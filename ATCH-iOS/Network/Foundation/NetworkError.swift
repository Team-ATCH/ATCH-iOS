//
//  NetworkError.swift
//  ATCH-iOS
//
//  Created by 변희주 on 10/27/24.
//

import Foundation

enum NetworkError: Error, CustomStringConvertible {
    case responseError
    case serverError(ErrorResponse)
    case unknownError
    
    var description: String {
        switch self {
        case .responseError:
            return "RESPONSE_ERROR"
        case .serverError(let errorResponse):
            return "SERVER_ERROR: Code - \(errorResponse.code), Message - \(errorResponse.message)"
        case .unknownError:
            return "UNKNOWN_ERROR"
        }
    }
    
    var code: String? {
        switch self {
        case .serverError(let errorResponse):
            return errorResponse.code
        default:
            return nil
        }
    }
    
    var message: String? {
        switch self {
        case .serverError(let errorResponse):
            return errorResponse.message
        default:
            return nil
        }
    }
}
