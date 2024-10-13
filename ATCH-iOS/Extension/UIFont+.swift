//
//  UIFont+.swift
//  ATCH-iOS
//
//  Created by 변희주 on 8/15/24.
//

import UIKit

enum FontName {
    case caption
    case title, title2, title3, subtitle
    case headline
    case body
    case smallButton, bigButton
    case chat

    var fontName: String {
        switch self {
        case .caption:
            return "Pretendard-Regular"
        case .title:
            return "Pretendard-SemiBold"
        case .title2:
            return "Pretendard-Medium"
        case .title3:
            return "Pretendard-Medium"
        case .subtitle:
            return "Pretendard-Medium"
        case .headline:
            return "Pretendard-SemiBold"
        case .body:
            return "Pretendard-Regular"
        case .smallButton:
            return "Pretendard-Regular"
        case .bigButton:
            return "Pretendard-Regular"
        case .chat:
            return "Pretendard-Medium"
        }
    }

    var size: CGFloat {
        switch self {
        case .caption:
            return 11
        case .title:
            return 22
        case .title2:
            return 20
        case .title3:
            return 18
        case .subtitle:
            return 14
        case .headline:
            return 16
        case .body:
            return 12
        case .smallButton:
            return 14
        case .bigButton:
            return 17
        case .chat:
            return 16
        }
    }
}

extension UIFont {
    static func font(_ style: FontName) -> UIFont {
        return UIFont(name: style.fontName, size: style.size)!
    }
}
