//
//  BaseResponse.swift
//  ATCH-iOS
//
//  Created by 변희주 on 10/27/24.
//

import Foundation

struct ErrorResponse: Decodable {
    let code: String
    let message: String
}

struct EmptyResponse: Decodable {
    
}
