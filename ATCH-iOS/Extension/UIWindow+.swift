//
//  UIWindow+.swift
//  ATCH-iOS
//
//  Created by 변희주 on 8/18/24.
//

import UIKit

extension UIWindow {
    static var key: UIWindow? {
        if #available(iOS 13, *) {
            return UIApplication.shared.windows.first { $0.isKeyWindow }
        } else {
            return UIApplication.shared.keyWindow
        }
    }
}
