//
//  HomeViewController.swift
//  WSR-Asia
//
//  Created by ali on 8/3/21.
//

import UIKit
import Alamofire

class HomeViewController: UIViewController, Storyboarded {
    
    @IBOutlet weak var noReportView: UIView!
    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet var alertView: UIView!
    @IBOutlet weak var uncheckedView: UIView!
    @IBOutlet weak var checkView: UIView!
    @IBOutlet weak var checkButton: UIButton!
    @IBOutlet weak var caseNumbersLabel: UILabel!
    @IBOutlet weak var casesView: UIView!
    @IBOutlet weak var currentDateLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var reportView: UIView!
    @IBOutlet weak var checkInButton: UIButton!
    @IBOutlet weak var repportTopView: UIView!
    @IBOutlet weak var reportStatusLabel: UILabel!
    @IBOutlet weak var detailLabel: UILabel!
    @IBOutlet weak var reportNameLabel: UILabel!
    @IBOutlet weak var reportDateLabel: UILabel!
    @IBOutlet weak var reportTimeLabel: UILabel!
    @IBOutlet weak var reportBottomView: UIView!
    
    //MARK: - Session 2
    @IBOutlet weak var bluLineWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var weekStackView: UIStackView!
    @IBOutlet weak var weekReportContainerView: UIView!
    @IBOutlet weak var statsContainerView: UIView!
    @IBOutlet weak var pagerControll: UIPageControl!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var fakeView: UIView!
    
    @IBAction func shareButtonDidTap(_ sender: Any) {
        doShareAction()
    }
    
    @IBAction func qrCodeButtonDidTap(_ sender: Any) {
        let vc = QRCodeViewController.instantiate("Main")
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func checkInNowButtonDidTap(_ sender: Any) {
        let vc = CheckListViewController.instantiate("Main")
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    var syptomData: [SymptomsHistoryData]!
    var statsData: CoivdStatsData = CoivdStats.exampleData()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        fillUI()
    }
    
    func setupUI() {
        casesView.layer.cornerRadius = 20
        noReportView.layer.cornerRadius = 20
        reportView.layer.cornerRadius = 20
        checkInButton.layer.cornerRadius = 20
        statsContainerView.layer.cornerRadius = 20
        weekReportContainerView.layer.cornerRadius = 16
        fakeView.layer.cornerRadius = 20
        setupCasesView(cases: 0)
        checkButton.underline()
        setupHasCheckedView(nil)
        reportBottomView.roundUpSpecificCorners(20, corners: [.bottomRight, .bottomRight])
        repportTopView.roundUpSpecificCorners(20, corners: [.topLeft, .topRight])
        pagerControll.transform = CGAffineTransform(rotationAngle: .pi/2)
        view.layoutSubviews()
    }
    
    func fillUI() {
        reportNameLabel.text = DataManager.shared.name
        currentDateLabel.text = Date().toText(with: "MMM dd, yyyy")
        nameLabel.text = DataManager.shared.name
        if currentReachabilityStatus == .reachable {
            getCases()
            getSymptomsHistory()
            getCoivdStats()
        } else {
            showAlertView("No InterNet Connection")
            setupCasesView(cases: 0)
            setupHasCheckedView(nil)
            statsContainerView.isHidden = true
        }
    }
    
    func showAlertView(_ error: String) {
        alertView.isHidden = false
        view.endEditing(true)
        errorLabel.text = error
        view.layoutSubviews()
        alertView.frame = CGRect(origin: .zero, size: CGSize(width: 330, height: 60))
        self.view.addSubview(alertView)
        alertView.layer.cornerRadius = 20
        self.alertView.center = view.center
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.alertView.isHidden = true
        }
    }
    
    func getCases(isZero: Bool = false) {
        var url = ""
        if isZero {
            url = "https://wsa2021.mad.hakta.pro/api/cases?zero"
        } else {
            url = "https://wsa2021.mad.hakta.pro/api/cases"
        }
        
        AF.request(url, method: .get).responseDecodable(of: Cases.self) { (response) in
            print(response.result)
            switch response.result {
            case .success(let model):
                DispatchQueue.main.async {
                    if model.success {
                        self.setupCasesView(cases: model.data!)
                    } else {
                        self.showAlertView(model.message!)
                    }
                }
            case .failure(_):
                break
            }
        }
    }
    
    func getSymptomsHistory() {
        let url = "https://wsa2021.mad.hakta.pro/api/symptoms_history?user_id=\(DataManager.shared.id)"
        
        
        AF.request(url, method: .get).responseDecodable(of: SymptomsHistory.self) { (response) in
            print(response.result)
            switch response.result {
            case .success(let model):
                if model.success {
                    var data: SymptomsHistoryData?
                    var list = [Bool?]()
                    var todayIndex = -1
                    for i in 0 ..< model.data!.count {
                        let date = model.data![i].date.toDate().toText(with: "yyyy-MM-dd")
                        let today = Date().toText(with: "yyyy-MM-dd")
                        if date == today {
                            data = model.data![i]
                            todayIndex = i
                        }
                        list.append(model.data![i].probability_infection >= 60)
                    }
                    if todayIndex == -1 {
                        list.append(nil)
                    }
                    DispatchQueue.main.async {
                        self.setupWeeklyReport(list: list)
                        self.syptomData = model.data
                        self.setupHasCheckedView(data)
                    }
                } else {
                    DispatchQueue.main.async {
                        self.showAlertView(model.message!)
                    }
                }
                print(model)
            case .failure(_):
                break
            }
        }
    }
    
    func setupHasCheckedView(_ data: SymptomsHistoryData?) {
        if let symptomData = data {
            setupReportView(data: symptomData)
            checkView.isHidden = false
            uncheckedView.isHidden = true
            checkButton.setTitle("Re-check in", for: .normal)
            noReportView.isHidden = true
            reportView.isHidden = false
        } else {
            checkView.isHidden = true
            uncheckedView.isHidden = false
            checkButton.setTitle("Why do this?", for: .normal)
            noReportView.isHidden = false
            reportView.isHidden = true
        }
        view.layoutSubviews()
    }
    
    func setupReportView(data: SymptomsHistoryData) {
        if data.probability_infection >= 60 {
            repportTopView.backgroundColor = .brandRed
            reportStatusLabel.text = "CALL TO DOCTOR"
            detailLabel.text = "You may be infected with a virus"
        } else {
            repportTopView.backgroundColor = .brandGreen
            reportStatusLabel.text = "CLEAR"
            detailLabel.text = "* Wear mask.  Keep 2m distance.  Wash hands."
        }
        reportDateLabel.text = data.date.toDate().toText(with: "dd/MM")
        reportTimeLabel.text = data.date.toDate().toText(with: "/yyyy hh:mm a")
    }
    
    func setupCasesView(cases: Int) {
        if cases == 0 {
            caseNumbersLabel.text = "No case "
            casesView.backgroundColor = .darkBrandBlue
        } else {
            caseNumbersLabel.text = "\(cases) cases "
            casesView.backgroundColor = .brandPink
        }
    }
    
    func doShareAction() {
        var shareText = ""
        guard let symptoms = syptomData else {
            return
        }
        for i in symptoms {
            let date = i.date.toDate().toText(with: "yyyy-MM-dd")
            let today = Date().toText(with: "yyyy-MM-dd")
            if date == today {
                if i.probability_infection >= 60 {
                    shareText = "As of \(Date().toText(with: "dd/MM/yyyy")), there is a possibility that I have a covid"
                } else {
                    shareText = "As of \(Date().toText(with: "dd/MM/yyyy")), it is likely that I am healthy (but this is not certain)"
                }
            }
        }
        
        let shareAlert = UIActivityViewController(activityItems: [shareText], applicationActivities: nil)
        present(shareAlert, animated: true)
    }
}

//MARK: - Session 2
extension HomeViewController {
    func setupWeeklyReport(list: [Bool?]) {
        
        for i in 0 ..< list.count {
            let imageView = UIImageView()
            if i < list.count - 1 {
                if list[i]! {
                    imageView.image = UIImage(named: "smallRed")!
                } else {
                    imageView.image = UIImage(named: "smallBlue")!
                }
            } else {
                if let status = list[i] {
                    if status {
                        imageView.image = UIImage(named: "bigRed")!
                    } else {
                        imageView.image = UIImage(named: "bigBlue")!
                    }
                } else {
                    imageView.image = UIImage(named: "emptyBlue")!
                }
            }
            weekStackView.addArrangedSubview(imageView)
        }
        for _ in 0 ..< (7-list.count) {
            let imageView = UIImageView()
            imageView.image = UIImage(named: "emptyGray")!
            weekStackView.addArrangedSubview(imageView)
        }
        if list.last == nil {
            bluLineWidthConstraint.constant = 221 * CGFloat(CGFloat(list.count-1)/CGFloat(7))
        } else {
            bluLineWidthConstraint.constant = 221 * CGFloat(CGFloat(list.count)/CGFloat(7))
        }
        self.view.layoutSubviews()
    }
    
    func getCoivdStats() {
        let url = "https://wsa2021.mad.hakta.pro/api/covid_stats"
        
        
        AF.request(url, method: .get).responseDecodable(of: CoivdStats.self) { (response) in
            print(response.result)
            switch response.result {
            case .success(let model):
                DispatchQueue.main.async {
                    if model.success {
                        self.statsData = model.data!
                        self.setupStatsView(data: model.data!)
                    } else {
                        self.statsContainerView.isHidden = true
                        self.showAlertView(model.message!)
                    }
                }
            case .failure(_):
                break
            }
        }
    }
    
    func setupStatsView(data: CoivdStatsData) {
        self.collectionView.reloadData()
        self.statsContainerView.isHidden = false
    }
}

extension HomeViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let count = 4
        pagerControll.numberOfPages = count
        return count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DataCollectionViewCell", for: indexPath) as! DataCollectionViewCell
        
        switch indexPath.row {
        case 0:
            cell.titleLabel.text = "Infection cases"
            cell.numberLabel.text = "\(statsData.world.infected)"
            cell.topDetailLabel.font = cell.topDetailLabel.font.withSize(20)
            cell.topDetailLabel.text = "Over all world"
            cell.bottomDetailLabel.text = "\(statsData.current_city.infected) cases in your city"
        case 1:
            cell.titleLabel.text = "Deaths"
            cell.numberLabel.text = "\(statsData.world.death)"
            cell.topDetailLabel.font = cell.topDetailLabel.font.withSize(20)
            cell.topDetailLabel.text = "Over all world"
            cell.bottomDetailLabel.font = cell.bottomDetailLabel.font.withSize(16)
            cell.bottomDetailLabel.text = "\(statsData.current_city.death) death in your city"
        case 2:
            cell.titleLabel.text = "Recovered"
            cell.numberLabel.text = "\(statsData.world.recovered)"
            cell.bottomDetailLabel.font = cell.bottomDetailLabel.font.withSize(20)
            cell.bottomDetailLabel.font = cell.bottomDetailLabel.font.withSize(16)
            cell.topDetailLabel.font = cell.topDetailLabel.font.withSize(20)
            var adults = Double(statsData.current_city.recovered_adults)/Double(statsData.world.recovered_adults)
            var young = Double(statsData.current_city.recovered_young)/Double(statsData.world.recovered_young)
            adults = Double(round(100*adults)/100)
            young = Double(round(100*young)/100)
            cell.topDetailLabel.text = "\(round(adults))% - adults"
            cell.bottomDetailLabel.text = "\(round(young))% - young"
        case 3:
            cell.titleLabel.text = "In your city"
            var vaccinated = Double(statsData.current_city.vaccinated)/Double(statsData.world.vaccinated)
            vaccinated = Double(round(100*vaccinated)/100)
            if vaccinated > 50 {
                cell.bottomDetailLabel.text = "Keep it going and ask friends to get vaccine"
            } else {
                cell.bottomDetailLabel.text = "It’s very bad result for making world safe"
            }
            cell.topDetailLabel.font = cell.topDetailLabel.font.withSize(16)
            cell.topDetailLabel.text = "People vaccinated"
            cell.numberLabel.text = "\(vaccinated)%"
        default:
            break
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        pagerControll.currentPage = indexPath.row
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let size = collectionView.bounds.size
        return CGSize(width: size.width, height: size.height - 8)
    }
}
