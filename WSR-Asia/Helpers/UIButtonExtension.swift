//
//  UIButtonExtension.swift
//  WSR-Asia
//
//  Created by ali on 8/3/21.
//

import UIKit

extension UIButton {
  func underline() {
    let attributedString = NSMutableAttributedString(string: (self.titleLabel?.text!)!)
    attributedString.addAttribute(NSAttributedString.Key.underlineStyle, value: NSUnderlineStyle.single.rawValue, range: NSRange(location: 0, length: (self.titleLabel?.text!.count)!))
    self.setAttributedTitle(attributedString, for: .normal)
  }
}
