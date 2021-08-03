//
//  UITextFieldExxtension.swift
//  WSR-Asia
//
//  Created by ali on 8/3/21.
//

import UIKit
import SystemConfiguration

extension UITextField {
    func addCloseToolbar() {
        let bar = UIToolbar()
        let customFont = UIFont.systemFont(ofSize: 16, weight: .medium)
        let doneButton = UIBarButtonItem(title: "Close", style: .plain, target: self, action: #selector(hideKeyboard))
        doneButton.setTitleTextAttributes([ NSAttributedString.Key.font: customFont], for: UIControl.State.normal)
        let spacer = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        bar.items = [spacer, doneButton]
        bar.sizeToFit()
        self.inputAccessoryView = bar
    }
    
    @objc private func hideKeyboard() {
        self.resignFirstResponder()
    }
}


protocol Utilities {}
extension NSObject: Utilities {
    enum ReachabilityStatus {
        case notReachable
        case reachable
    }
    
    var currentReachabilityStatus: ReachabilityStatus {
        
        var zeroAddress = sockaddr_in()
        zeroAddress.sin_len = UInt8(MemoryLayout<sockaddr_in>.size)
        zeroAddress.sin_family = sa_family_t(AF_INET)
        guard let defaultRouteReachability = withUnsafePointer(to: &zeroAddress, {
            $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {
                SCNetworkReachabilityCreateWithAddress(nil, $0)
            }
        }) else {
            return .notReachable
        }
        
        var flags: SCNetworkReachabilityFlags = []
        if !SCNetworkReachabilityGetFlags(defaultRouteReachability, &flags) {
            return .notReachable
        }
        
        if flags.contains(.reachable) == false {
            return .notReachable
        }
        else if (flags.contains(.isWWAN) == true) || (flags.contains(.connectionRequired) == false) || ((flags.contains(.connectionOnDemand) == true || flags.contains(.connectionOnTraffic) == true) && flags.contains(.interventionRequired) == false) {
            return .reachable
        }
        else {
            return .notReachable
        }
    }
}
