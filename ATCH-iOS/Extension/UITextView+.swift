//
//  UITextView+.swift
//  ATCH-iOS
//
//  Created by 변희주 on 9/7/24.
//

import UIKit

extension UITextView {
    func numberOfLine() -> Int {
        
        let size = CGSize(width: frame.width, height: .infinity)
        let estimatedSize = sizeThatFits(size)
        
        return Int(estimatedSize.height / (self.font!.lineHeight))
    }
}
