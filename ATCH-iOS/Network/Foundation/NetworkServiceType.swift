//
//  NetworkServiceType.swift
//  ATCH-iOS
//
//  Created by 변희주 on 10/27/24.
//

import Foundation

protocol NetworkServiceType {
    func makeRequest(type: HttpMethod,
                     baseURL: String,
                     accessToken: String?,
                     body: Encodable,
                     pathVariables: [String: String]) -> URLRequest
    
    func network<T: Decodable>(type: HttpMethod,
                               baseURL: String,
                               accessToken: String?,
                               body: Encodable,
                               pathVariables: [String: String]) async throws -> T?
}

