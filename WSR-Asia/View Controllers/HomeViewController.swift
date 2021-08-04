//
//  HomeViewController.swift
//  WSR-Asia
//
//  Created by ali on 8/3/21.
//

import UIKit
import Alamofire

class HomeViewController: UIViewController, Storyboarded {
    
    @IBOutlet weak var noReportContainerView: UIView!
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
    
    @IBAction func shareButtonDidTap(_ sender: Any) {
        doShareAction()
    }
    
    var syptomData: [SymptomsHistoryData]!
    
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
        setupCasesView(cases: 0)
        checkButton.underline()
        setupHasCheckedView(nil)
        reportBottomView.roundUpSpecificCorners(20, corners: [.bottomRight, .bottomRight])
        repportTopView.roundUpSpecificCorners(20, corners: [.topLeft, .topRight])
    }
    
    func fillUI() {
        reportNameLabel.text = DataManager.shared.name
        currentDateLabel.text = Date().toText(with: "MMM dd, yyyy")
        nameLabel.text = DataManager.shared.name
        if currentReachabilityStatus == .reachable {
            getCases()
            getSymptomsHistory()
        } else {
            showAlertView("No InterNet Connection")
            setupCasesView(cases: 0)
            setupHasCheckedView(nil)
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
                if model.success {
                    self.setupCasesView(cases: model.data!)
                } else {
                    self.showAlertView(model.message!)
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
                    for i in model.data! {
                        let date = i.date.toDate().toText(with: "yyyy-MM-dd")
                        let today = Date().toText(with: "yyyy-MM-dd")
                        if date == today {
                            data = i
                        }
                    }
                    self.syptomData = model.data
                    self.setupHasCheckedView(data)
                } else {
                    self.showAlertView(model.message!)
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
            noReportContainerView.isHidden = true
            reportView.isHidden = false
        } else {
            checkView.isHidden = true
            uncheckedView.isHidden = false
            checkButton.setTitle("Why do this?", for: .normal)
            noReportContainerView.isHidden = false
            reportView.isHidden = true
        }
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
