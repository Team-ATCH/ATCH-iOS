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
        
        return formatter.date(from: self)
    }
}
