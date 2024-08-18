//
//  TabBar.swift
//  ATCH-iOS
//
//  Created by 변희주 on 8/18/24.
//

import UIKit

enum TabBarItemType: String, CaseIterable {
    case map, myChat, allChat, myPage
    
    init?(index: Int) {
        switch index {
        case 0: self = .map
        case 1: self = .myChat
        case 2: self = .allChat
        case 3: self = .myPage
        default: return nil
        }
    }
    
    func toIndex() -> Int {
        switch self {
        case .map: return 0
        case .myChat: return 1
        case .allChat: return 2
        case .myPage: return 3
        }
    }
    
    func toTitle() -> String {
        switch self {
        case .map: return "지도"
        case .myChat: return "내 채팅"
        case .allChat: return "전체 채팅"
        case .myPage: return "마이페이지"
        }
    }
    
    func toIcon() -> UIImage {
        switch self {
        case .map: return .icMap.withRenderingMode(.alwaysOriginal)
        case .myChat: return .icChat.withRenderingMode(.alwaysOriginal)
        case .allChat: return .icAllChat.withRenderingMode(.alwaysOriginal)
        case .myPage: return .icMyPage.withRenderingMode(.alwaysOriginal)
        }
    }
}

class AtchTabBar: UITabBar {
    override func sizeThatFits(_ size: CGSize) -> CGSize {
        var sizeThatFits = super.sizeThatFits(size)
        sizeThatFits.height = 63 + (UIWindow.key?.safeAreaInsets.bottom ?? 0)
        return sizeThatFits
    }
}
