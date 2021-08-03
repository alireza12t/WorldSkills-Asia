//
//  HomeViewController.swift
//  WSR-Asia
//
//  Created by ali on 8/3/21.
//

import UIKit
import Alamofire

class HomeViewController: UIViewController, Storyboarded {
    
    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet var alertView: UIView!
    @IBOutlet weak var uncheckedView: UIView!
    @IBOutlet weak var checkView: UIView!
    @IBOutlet weak var checkButton: UIButton!
    @IBOutlet weak var caseNumbersLabel: UILabel!
    @IBOutlet weak var casesView: UIView!
    @IBOutlet weak var currentDateLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    
    var syptomData: [SymptomsHistoryData]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        fillUI()
    }
    
    func setupUI() {
        casesView.layer.cornerRadius = 20
        setupCasesView(cases: 0)
        checkButton.underline()
        setupHasCheckedView(hasChecked: false)
    }
    
    func fillUI() {
        currentDateLabel.text = Date().toText(with: "MMM dd, yyyy")
        nameLabel.text = DataManager.shared.name
        if currentReachabilityStatus == .reachable {
            getCases(isZero: true)
            getSymptomsHistory()
        } else {
            showAlertView("No InterNet Connection")
            setupCasesView(cases: 0)
            setupHasCheckedView(hasChecked: false)
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
                    var hasChecked = false
                    for i in model.data! {
                        let date = i.date.toDate().toText(with: "yyyy-MM-dd")
                        let today = Date().toText(with: "yyyy-MM-dd")
                        if date == today {
                            hasChecked = true
                        }
                    }
                    self.syptomData = model.data
                    self.setupHasCheckedView(hasChecked: hasChecked)
                } else {
                    self.showAlertView(model.message!)
                }
                print(model)
            case .failure(_):
                break
            }
        }
    }
    
    func setupHasCheckedView(hasChecked: Bool) {
        if hasChecked {
            checkView.isHidden = false
            uncheckedView.isHidden = true
            checkButton.setTitle("Re-check in", for: .normal)
        } else {
            checkView.isHidden = true
            uncheckedView.isHidden = false
            checkButton.setTitle("Why do this?", for: .normal)
        }
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
    
    func shareAction() {
        var shareText = ""
        
        for i in self.syptomData {
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
