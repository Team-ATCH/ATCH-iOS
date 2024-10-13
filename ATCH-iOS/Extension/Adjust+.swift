//
//  adjust+.swift
//  ATCH-iOS
//
//  Created by 변희주 on 8/15/24.
//

import UIKit

extension CGFloat {
    var adjustedW: CGFloat {
        let ratio: CGFloat = UIScreen.main.bounds.width / 375
        return self * ratio
    }
    
    var adjustedH: CGFloat {
        let ratio: CGFloat = UIScreen.main.bounds.height / 812
        return self * ratio
    }
}

extension Int {
    var adjustedW: CGFloat {
        let ratio: CGFloat = UIScreen.main.bounds.width / 375
        return CGFloat(self) * ratio
    }
    
    var adjustedH: CGFloat {
        let ratio: CGFloat = UIScreen.main.bounds.height / 812
        return CGFloat(self) * ratio
    }
}
