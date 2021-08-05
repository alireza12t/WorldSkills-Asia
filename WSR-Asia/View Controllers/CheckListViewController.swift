//
//  CheckListViewController.swift
//  WSR-Asia
//
//  Created by ali on 8/5/21.
//

import UIKit
import Alamofire

class CheckListViewController: UIViewController, Storyboarded {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var errorView: UIView!
    @IBOutlet weak var checkListView: UIView!
    @IBOutlet weak var tryAgainButton: UIButton!
    @IBOutlet weak var plusButton: UIButton!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var notNowButton: UIButton!
    @IBOutlet weak var tableViewHeight: NSLayoutConstraint!
    
    @IBAction func backButtonDidTap(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func tryAgainButtonDidTap(_ sender: Any) {
        if currentReachabilityStatus == .notReachable {
            showAlertView()
        } else {
            self.checkListView.isHidden = true
            showAlertView(error: "Loading...")
            getSymptoms()
        }
    }
    
    @IBAction func confirmButtonDidTap(_ sender: Any) {
        
    }
    
    @IBAction func plusButtonDidTap(_ sender: Any) {
        
    }
    
    var symptoms: [SymptomItem] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        if currentReachabilityStatus == .notReachable {
            showAlertView()
        } else {
            checkListView.isHidden = false
        }
    }
    
    func setupView() {
        dateLabel.text = Date().toText(with: "MMM dd, yyyy")
        tryAgainButton.underline()
        errorView.layer.cornerRadius = 20
        plusButton.layer.borderWidth = 4
        plusButton.layer.borderColor = UIColor.white.cgColor
        notNowButton.underline()
    }
    
    func showAlertView(error: String = "You need to have access to internet") {
        checkListView.isHidden = true
        errorLabel.text = error
    }
    
    func uploadPhoto() {
        
    }
    
    func uploadSymptoms() {
        
    }
}

extension CheckListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        symptoms.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if symptoms.indices.contains(indexPath.row) {
            let cell = tableView.dequeueReusableCell(withIdentifier: "CheckListTableViewCell", for: indexPath) as! CheckListTableViewCell
            let cellData = symptoms[indexPath.row]
            cell.itemLabel.text = cellData.title
            cell.itemCheckBox.tag = cellData.id
            return cell
        } else {
            return UITableViewCell()
        }
    }
    
    func setupTableViewHeight() {
        tableView.layoutIfNeeded()
        tableViewHeight.constant = tableView.contentSize.height
        view.layoutSubviews()
    }
    
    func getSymptoms() {
        let url = "https://wsa2021.mad.hakta.pro/api/symptom_list"
        
        AF.request(url, method: .get).responseDecodable(of: SymptomList.self) { (response) in
            print(response.result)
            switch response.result {
            case .success(let model):
                DispatchQueue.main.async {
                    if model.success {
                        self.checkListView.isHidden = false
                        self.symptoms = model.data!
                        self.tableView.reloadData()
                        self.setupTableViewHeight()
                    } else {
                        self.showAlertView(error: model.message!)
                    }
                }
            case .failure(_):
                self.showAlertView(error: "Error in getting symptom items!")
            }
        }
    }
}
