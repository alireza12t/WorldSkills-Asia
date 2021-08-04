//
//  QRCodeViewController.swift
//  WSR-Asia
//
//  Created by ali on 8/4/21.
//

import UIKit
import Kingfisher
import Alamofire

class QRCodeViewController: UIViewController, Storyboarded {
    
    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var qrImageView: UIImageView!
    @IBOutlet weak var errorView: UIView!
    @IBOutlet weak var qrCodeView: UIView!
    @IBOutlet weak var tryAgainButton: UIButton!
    
    @IBAction func backButtonDidTap(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func tryAgainButtonDidTap(_ sender: Any) {
        if currentReachabilityStatus == .notReachable {
            showAlertView()
        } else {
            getQR()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        if currentReachabilityStatus == .notReachable {
            showAlertView()
        } else {
            getQR()
        }
    }
    
    func setupView() {
        tryAgainButton.underline()
        errorView.layer.cornerRadius = 20
    }
    
    func getQR() {
        let url = "https://wsa2021.mad.hakta.pro/api/user_qr?white"
        let headders = HTTPHeaders([HTTPHeader(name: "Token", value: DataManager.shared.token)])
        
        AF.request(url, method: .get, headers: headders).responseDecodable(of: QR.self) { (response) in
            print(response.result)
            switch response.result {
            case .success(let model):
                DispatchQueue.main.async {
                    if model.success {
                        if let url = URL(string: model.data!) {
                            self.qrImageView.kf.setImage(with: url)
                            self.qrCodeView.isHidden = false
                        } else {
                            self.showAlertView(error: "Invalid QRCode")
                        }
                    } else {
                        self.showAlertView(error: model.message!)
                    }
                }
            case .failure(_):
                self.showAlertView(error: "Error in getting QR Code!")
            }
        }
    }
    
    func showAlertView(error: String = "You need to have access to internet") {
        qrCodeView.isHidden = true
        errorLabel.text = error
    }
}
