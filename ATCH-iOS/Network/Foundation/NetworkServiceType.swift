//
//  NetworkServiceType.swift
//  ATCH-iOS
//
//  Created by 변희주 on 10/27/24.
//

import Foundation

enum NetworkResult<T> {
    case success(T)
    case failure(NetworkError)
}

protocol NetworkServiceType {
    func makeRequest(type: HttpMethod,
                     baseURL: String,
                     accessToken: String?,
                     body: Encodable?,
                     pathVariables: [String: String]?) -> URLRequest
    
    func request<T: Decodable>(type: HttpMethod,
                               baseURL: String,
                               accessToken: String?,
                               body: Encodable?,
                               pathVariables: [String: String]?) async throws -> NetworkResult<T>
}
