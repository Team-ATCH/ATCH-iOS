//
//  PopUpData.swift
//  ATCH-iOS
//
//  Created by 변희주 on 10/16/24.
//

import Foundation

enum PopUpType {
    case logout
    case withdraw
    case back
}

enum PopUpButtonType {
    case oneButton
    case twoButton
}

struct PopUpData {
    let type: PopUpType
    let buttonType: PopUpButtonType
    let content: String
    let leftButtonText: String
    let rightButtonText: String
    let oneButtonText: String
}
