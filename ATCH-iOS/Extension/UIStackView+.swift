//
//  UIStackView+.swift
//  ATCH-iOS
//
//  Created by 변희주 on 8/31/24.
//

import UIKit

extension UIStackView {
    func addArrangedSubviews(_ views: UIView...) {
        views.forEach { self.addArrangedSubview($0) }
    }
}
