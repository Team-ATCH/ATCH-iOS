//
//  ChattingData.swift
//  ATCH-iOS
//
//  Created by 변희주 on 9/7/24.
//

import UIKit

import MessageKit

struct Sender: SenderType {
    var senderId: String
    var displayName: String
}

struct ChattingData: MessageType {
    
    let id: String?
    var messageId: String {
        return id ?? UUID().uuidString
    }
    let content: String
    let sentDate: Date
    let sender: SenderType
    var kind: MessageKind {
        return .text(content)
    }
    
    init(content: String) {
        sender = Sender(senderId: "id(TODO...)", displayName: "displayName(TODO...)")
        self.content = content
        sentDate = Date()
        id = nil
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
