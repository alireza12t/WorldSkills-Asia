//
//  ViewController.swift
//  WSR-Asia
//
//  Created by ali on 8/3/21.
//

import UIKit
import RxKeyboard
import RxSwift
import Alamofire

class LoginViewController: UIViewController, Storyboarded {
    
    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var passworrdTextField: UITextField!
    @IBOutlet weak var loginTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet var alertView: UIView!
    @IBOutlet weak var loginTopConstraint: NSLayoutConstraint!
    
    var disposeBag = DisposeBag()
    
    @IBAction func signInButtonDidTap(_ sender: Any) {
        if currentReachabilityStatus == .reachable {
            if let errorText = ValidationHelper.validateEmail(for: loginTextField.text) {
                showAlertView(errorText)
            } else {
                if (passworrdTextField.text ?? "").isEmpty {
                    showAlertView("Passwordd is Empty")
                } else {
                    login()
                }
            }
        } else {
            showAlertView("No InterNet Connection")
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loginTopConstraint.constant = 50
        setupView()
        handleKeyboard()
    }
    
    func setupView() {
        loginTextField.layer.cornerRadius = 20
        passworrdTextField.layer.cornerRadius = 20
        loginButton.layer.cornerRadius = 20
    }
    
    func showAlertView(_ error: String) {
        view.endEditing(true)
        errorLabel.text = error
        loginTopConstraint.constant = 150
        view.layoutSubviews()
        alertView.frame = CGRect(origin: .zero, size: CGSize(width: 330, height: 60))
        self.scrollView.addSubview(alertView)
        alertView.layer.cornerRadius = 20
        self.alertView.center = passworrdTextField.center
        alertView.layer.position.y += 100
    }
    
    func removeAlert() {
        loginTopConstraint.constant = 50
        self.alertView.isHidden = true
    }
    
    func handleKeyboard(){
        RxKeyboard.instance.visibleHeight
            .drive(onNext: { [weak scrollView] keyboardVisibleHeight in
                scrollView?.contentInset.bottom = keyboardVisibleHeight
            })
            .disposed(by: disposeBag)
        loginTextField.addCloseToolbar()
        passworrdTextField.addCloseToolbar()
    }
    
    func login() {
        let url = "https://wsa2021.mad.hakta.pro/api/signin/"
        
        let parameters: [String: Any] = [
            "login": loginTextField.text ?? "",
            "password": passworrdTextField.text ?? ""
        ]
        
        AF.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default).responseDecodable(of: SignIn.self) { (response) in
            print(response.result)
            switch response.result {
            case .success(let model):
                if model.success {
                    DataManager.shared.token = model.data!.token
                    DataManager.shared.id = model.data!.id
                    DataManager.shared.name = model.data!.name
                    DataManager.shared.login = model.data!.login
                    DispatchQueue.main.async {
                        let vc = HomeViewController.instantiate("Main")
                        self.navigationController?.setViewControllers([vc], animated: true)
                    }
                } else {
                    self.showAlertView(model.message ?? "Error")
                }
                print(model)
            case .failure(_):
                break
            }
        }
        
    }
}

