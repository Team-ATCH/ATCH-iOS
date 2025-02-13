//
//  HttpMethod.swift
//  ATCH-iOS
//
//  Created by 변희주 on 10/27/24.
//

import Foundation

enum HttpMethod {
    case get
    case post
    case delete
    case patch
    
    var method: String {
        switch self {
        case .get:
            "GET"
        case .post:
            "POST"
        case .delete:
            "DELETE"
        case .patch:
            "PATCH"
        }
    }
}
