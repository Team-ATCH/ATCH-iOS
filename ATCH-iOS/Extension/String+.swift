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
    
    func toSeoulDateString() -> String? {
        // ISO 8601 날짜 포맷터 설정
        let isoFormatter = ISO8601DateFormatter()
        isoFormatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        
        // 문자열을 Date 타입으로 변환
        guard let utcDate = isoFormatter.date(from: self) else {
            return nil
        }
        
        // 서울 시간대로 변환할 DateFormatter 설정
        let seoulFormatter = DateFormatter()
        seoulFormatter.dateFormat = "yyyy/MM/dd HH:mm"
        seoulFormatter.timeZone = TimeZone(identifier: "Asia/Seoul")
        
        // 서울 시간대에 맞춘 문자열 반환
        return seoulFormatter.string(from: utcDate)
    }
}
