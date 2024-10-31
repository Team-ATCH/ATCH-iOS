//
//  GetNoticeListDTO.swift
//  ATCH-iOS
//
//  Created by 변희주 on 10/30/24.
//

import Foundation

struct NoticeList: Decodable {
    let title: String
    let content: String
    let isItem: Bool
}

typealias GetNoticeListDTO = [NoticeList]
