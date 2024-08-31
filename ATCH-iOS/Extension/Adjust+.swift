//
//  adjust+.swift
//  ATCH-iOS
//
//  Created by 변희주 on 8/15/24.
//

import UIKit

extension CGFloat {
    var adjusted: CGFloat {
        let ratio: CGFloat = 0.46 * (UIScreen.main.bounds.height / UIScreen.main.bounds.width)
        return self * ratio
    }
}

extension Int {
    var adjusted: CGFloat {
        let ratio: CGFloat = 0.46 * (UIScreen.main.bounds.height / UIScreen.main.bounds.width)
        return CGFloat(self) * ratio
    }
}
