//
//  Date+.swift
//  ATCH-iOS
//
//  Created by 변희주 on 9/8/24.
//

import Foundation

extension Date {
    func toTimeString() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone(identifier: "Asia/Seoul") // 한국 시간대로 설정
        dateFormatter.dateFormat = "HH:mm"
        return dateFormatter.string(from: self)
    }
}
