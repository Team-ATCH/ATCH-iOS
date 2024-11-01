//
//  GetNoticeListDTO.swift
//  ATCH-iOS
//
//  Created by 변희주 on 10/30/24.
//

import Foundation

struct GetNoticeListDTO: Decodable {
    let data: [NoticeList]
}

struct NoticeList: Decodable {
    let title: String
    let content: String
    let isItem: Bool
}


extension GetNoticeListDTO {
    func mapToAlarmView() -> [AlarmData] {
        let alarmDataList: [AlarmData] = self.data.map { data in
            let alarmData: AlarmData = .init(type: data.isItem ? .item : .notice,
                                             title: data.title,
                                             content: data.content)
            return alarmData
        }
        return alarmDataList
    }
}
