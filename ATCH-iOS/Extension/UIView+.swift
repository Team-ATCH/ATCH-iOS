//
//  UIView+.swift
//  ATCH-iOS
//
//  Created by 변희주 on 8/29/24.
//

import UIKit

extension UIView {
    func addSubviews(_ views: UIView...) {
        views.forEach { self.addSubview($0) }
    }
    
    func removeAllSubViews() {
        self.subviews.forEach { $0.removeFromSuperview() }
    }
    
    func addLeftBorder(borderColor: UIColor, borderWidth: CGFloat) {
        let leftBorder = CALayer()
        leftBorder.backgroundColor = borderColor.cgColor
        leftBorder.frame = CGRect(x: 0, y: 0, width: borderWidth, height: frame.height)
        layer.addSublayer(leftBorder)
    }
    
    func addRightBorder(borderColor: UIColor, borderWidth: CGFloat) {
        let rightBorder = CALayer()
        rightBorder.backgroundColor = borderColor.cgColor
        rightBorder.frame = CGRect(x: frame.width - borderWidth, y: 0, width: borderWidth, height: frame.height)
        layer.addSublayer(rightBorder)
    }
}
