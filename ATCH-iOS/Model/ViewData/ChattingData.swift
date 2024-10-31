//
//  ChattingData.swift
//  ATCH-iOS
//
//  Created by 변희주 on 9/7/24.
//

import UIKit

import MessageKit

struct Sender: SenderType {
    let senderId: String
    let displayName: String
    var profileImageUrl: String = ""
}

struct ChattingData: MessageType {
    let id: String?
    var messageId: String {
        return id ?? UUID().uuidString
    }
    let sender: SenderType
    let content: String
    let sentDate: Date
    var kind: MessageKind {
        return .attributedText(NSAttributedString(string: content, attributes: [.font: UIFont.font(.chat),
                                                                                .foregroundColor: UIColor.atchShadowGrey]))
    }
    
    init(sender: Sender, content: String, sendDate: Date) {
        self.sender = sender
        self.content = content
        self.sentDate = sendDate
        self.id = UUID().uuidString
    }
}

extension ChattingData: Comparable {
  static func == (lhs: ChattingData, rhs: ChattingData) -> Bool {
    return lhs.id == rhs.id
  }

  static func < (lhs: ChattingData, rhs: ChattingData) -> Bool {
    return lhs.sentDate < rhs.sentDate
  }
}
