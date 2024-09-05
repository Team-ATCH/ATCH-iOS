//
//  AlarmData.swift
//  ATCH-iOS
//
//  Created by 변희주 on 9/5/24.
//

import Foundation

enum AlarmType {
    case item
    case notice
}

struct AlarmData {
    let type: AlarmType
    let title: String
    let content: String
}
