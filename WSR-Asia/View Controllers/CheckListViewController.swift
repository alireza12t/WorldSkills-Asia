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
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var confirmButton: UIButton!
    @IBOutlet weak var deleteButton: UIButton!
    
    @IBAction func backButtonDidTap(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func tryAgainButtonDidTap(_ sender: Any) {
        if currentReachabilityStatus == .notReachable {
            showAlertView()
        } else {
            getSymptoms()
        }
    }
    
    @IBAction func deleteButtonDidTap(_ sender: Any) {
        selectedImage = nil
        deleteButton.isHidden = true
        imageView.isHidden = true
        imageView.image = UIImage()
    }
    
    @IBAction func checkBoxButtonDidTap(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        let id = sender.tag
        if let index = selectedSymptoms.firstIndex(of: id) {
            selectedSymptoms.remove(at: index)
        } else {
            selectedSymptoms.append(sender.tag)
        }
    }
    
    @IBAction func confirmButtonDidTap(_ sender: Any) {
        uploadSymptoms()
        uploadPhoto()
    }
    
    @IBAction func plusButtonDidTap(_ sender: Any) {
        if UIImagePickerController.isSourceTypeAvailable(.savedPhotosAlbum){
            imagePicker.delegate = self
            imagePicker.sourceType = .savedPhotosAlbum
            imagePicker.allowsEditing = false
            present(imagePicker, animated: true, completion: nil)
        }
    }
    
    var symptoms: [SymptomItem] = []
    var selectedSymptoms: [Int] = []
    var selectedImage: UIImage!
    var imagePicker = UIImagePickerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        if currentReachabilityStatus == .notReachable {
            showAlertView()
        } else {
            getSymptoms()
        }
    }
    
    func setupView() {
        dateLabel.text = Date().toText(with: "MMM dd, yyyy")
        tryAgainButton.underline()
        errorView.layer.cornerRadius = 20
        confirmButton.layer.cornerRadius = 20
        plusButton.layer.borderWidth = 4
        plusButton.layer.borderColor = UIColor.white.cgColor
        notNowButton.underline()
        tableView.allowsSelection = false
    }
    
    func showAlertView(error: String = "You need to have access to internet") {
        checkListView.isHidden = true
        errorLabel.text = error
    }
    
    func uploadPhoto() {
        
    }
    
    func uploadSymptoms() {
        if let url = URL(string: "https://wsa2021.mad.hakta.pro/api/day_symptoms") {
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            request.httpBody = try! JSONSerialization.data(withJSONObject: selectedSymptoms)
                        
            AF.request(request).response { (response) in
                print(response.result)
                switch response.result {
                case .success(_):
                    DispatchQueue.main.async {
                        self.navigationController?.popViewController(animated: true)
                    }
                case .failure(_):
                    break
                }
            }
        }
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
        tableView.invalidateIntrinsicContentSize()
        tableView.layoutIfNeeded()
        tableView.reloadData()
        tableViewHeight.constant = CGFloat(symptoms.count * 60) + 20
        tableView.isScrollEnabled = false
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

extension CheckListViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        var newImage: UIImage
        
        if let possibleImage = info[.editedImage] as? UIImage {
            newImage = possibleImage
        } else if let possibleImage = info[.originalImage] as? UIImage {
            newImage = possibleImage
        } else {
            return
        }
        imageView.isHidden = false
        deleteButton.isHidden = false
        selectedImage = newImage
        imageView.image = newImage
        dismiss(animated: true)
    }
}
