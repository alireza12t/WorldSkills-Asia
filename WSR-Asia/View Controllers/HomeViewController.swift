//
//  HomeViewController.swift
//  WSR-Asia
//
//  Created by ali on 8/3/21.
//

import UIKit
import Alamofire

class HomeViewController: UIViewController, Storyboarded {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getCases()
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
                self.setupCasesView(cases: model.data)
                print(model)
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
                break
                print(model)
            case .failure(_):
                break
            }
        }
    }
    
    func setupCasesView(cases: Int) {
        if cases == 0 {
            
        } else {
            
        }
    }
}
