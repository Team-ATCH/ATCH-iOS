//
//  ProfileModalData.swift
//  ATCH-iOS
//
//  Created by 변희주 on 10/16/24.
//

import Foundation

enum ProfileModalButtonType {
    case profileEdit
    case chatting
}

struct ProfileModalData {
    let userID: Int?
    let nickname: String
    let hashTag: String
    let profileURL: String?
    let backgroundURL: String?
    let buttonType: ProfileModalButtonType
    let senderData: Sender?
    let items: [UserItem]?
    
    var buttonString: String {
        switch buttonType {
        case .profileEdit:
            return "프로필 수정"
        case .chatting:
            return "채팅하기"
        }
    }
    
}
