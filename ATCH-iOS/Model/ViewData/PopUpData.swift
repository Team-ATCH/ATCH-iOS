//
//  PopUpData.swift
//  ATCH-iOS
//
//  Created by 변희주 on 10/16/24.
//

import Foundation

enum PopUpType {
    case oneButton
    case twoButton
}

struct PopUpData {
    let type: PopUpType
    let title: String
    let content: String
}
