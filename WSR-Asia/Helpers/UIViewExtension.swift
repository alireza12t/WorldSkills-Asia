//
//  UIViewExtension.swift
//  WSR-Asia
//
//  Created by ali on 8/4/21.
//

import UIKit

extension UIView {
    func roundUpSpecificCorners(_ value: CGFloat, corners: UIRectCorner) {
        DispatchQueue.main.async { [weak self] in
            let path = UIBezierPath(roundedRect: (self?.bounds ?? .zero), byRoundingCorners: corners, cornerRadii: CGSize(width: value, height: value))
            let mask = CAShapeLayer()
            mask.path = path.cgPath
            self?.layer.mask = mask
        }
    }
}
