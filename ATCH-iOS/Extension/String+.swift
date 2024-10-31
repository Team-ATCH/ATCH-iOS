//
//  String+.swift
//  ATCH-iOS
//
//  Created by 변희주 on 10/31/24.
//

import Foundation

extension String {
    func convertToDate() -> Date? {
        let formatter = ISO8601DateFormatter()
        formatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        
        guard let date = formatter.date(from: self) else {
            return nil
        }
        
        let seoulTimeOffset = TimeZone(identifier: "Asia/Seoul")?.secondsFromGMT(for: date) ?? 0
        
        return date.addingTimeInterval(TimeInterval(seoulTimeOffset))
    }
}
