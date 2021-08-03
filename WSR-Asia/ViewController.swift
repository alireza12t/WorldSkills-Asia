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

class ViewController: UIViewController {

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
//        AF.request(<#T##convertible: URLConvertible##URLConvertible#>)
    }
}

