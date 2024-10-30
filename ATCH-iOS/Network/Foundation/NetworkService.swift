//
//  NetworkService.swift
//  ATCH-iOS
//
//  Created by 변희주 on 10/27/24.
//

import UIKit

final class NetworkService: NetworkServiceType {
    private let tokenManager = TokenManager()
    
    func makeRequest(type: HttpMethod,
                     baseURL: String,
                     accessToken: String?,
                     body: Encodable,
                     pathVariables: [String: String]) -> URLRequest {
        var urlComponents = URLComponents(string: baseURL)
        
        // Path Variable 추가
        for (key, value) in pathVariables {
            let pathVariableItem = URLQueryItem(name: key, value: value)
            urlComponents?.queryItems = [pathVariableItem]
        }
        
        // 기존의 URL이 존재하지 않으면 fatalError
        guard let url = urlComponents?.url else {
            fatalError("Failed to create URL")
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = type.method
        
        var header: [String: String] = [:]

        if let accessToken = accessToken {
            header = ["Content-Type": "application/json",
                      "Authorization": "Bearer \(accessToken)"]
        } else {
            header = ["Content-Type": "application/json"]
        }
       
        header.forEach {
            request.addValue($0.value, forHTTPHeaderField: $0.key)
        }
        
        if type == .get {
            request.httpBody = nil
        } else {
            // 리퀘스트 바디 설정 (구조체)
            do {
                let jsonData = try JSONEncoder().encode(body)
                request.httpBody = jsonData
            } catch {
                print("Failed to encode request body: \(error)")
            }
        }
        
        return request
    }
    
    func request<T: Decodable>(type: HttpMethod,
                               baseURL: String,
                               accessToken: String?,
                               body: Encodable,
                               pathVariables: [String: String])  async throws -> T? {
        do {
            let request = self.makeRequest(type: type,
                                           baseURL: baseURL,
                                           accessToken: accessToken,
                                           body: body,
                                           pathVariables: pathVariables)
            
            let (data, response) = try await URLSession.shared.data(for: request)
            guard let httpResponse = response as? HTTPURLResponse else {
                print(NetworkError.responseError.description)
                throw NetworkError.responseError
            }
            
            switch httpResponse.statusCode {
            case 200..<400:
                let result = try JSONDecoder().decode(T.self, from: data)
                return result
            case 400:
                print(NetworkError.badRequestError.description)
                throw NetworkError.badRequestError
            case 404:
                print(NetworkError.notFoundError.description)
                throw NetworkError.notFoundError
            case 500:
                print(NetworkError.internalServerError.description)
                throw NetworkError.internalServerError
            default:
                print(NetworkError.unknownError.description)
                throw NetworkError.unknownError
            }
        } catch {
            throw error
        }
    }
}
