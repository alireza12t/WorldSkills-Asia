//
//  Coordinator.swift
//  WSR-Asia
//
//  Created by ali on 8/3/21.
//

import UIKit

protocol Storyboarded {
    static func instantiate(_ storyboard: String) -> Self
}

extension Storyboarded where Self: UIViewController {
    static func instantiate(_ storyboard: String) -> Self {
        let fullName = NSStringFromClass(self)
        let className = fullName.components(separatedBy: ".")[1]
        let storyboard = UIStoryboard(name: storyboard, bundle: Bundle.main)

        return storyboard.instantiateViewController(withIdentifier: className) as! Self
    }
}
