//
//  NetworkService.swift
//  ATCH-iOS
//
//  Created by 변희주 on 10/27/24.
//

import UIKit

final class NetworkService: NetworkServiceType {
    
    func makeRequest(type: HttpMethod,
                     baseURL: String,
                     accessToken: String?,
                     body: Encodable?,
                     pathVariables: [String: String]?) -> URLRequest {
        var urlComponents = URLComponents(string: baseURL)
        
        // Path Variable 추가
        if let pathVariables = pathVariables {
            for (key, value) in pathVariables {
                let pathVariableItem = URLQueryItem(name: key, value: value)
                urlComponents?.queryItems = [pathVariableItem]
            }
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
        
        if let body = body {
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
                               body: Encodable?,
                               pathVariables: [String: String]?) async throws -> NetworkResult<T> {
        do {
            let request = self.makeRequest(
                type: type,
                baseURL: baseURL,
                accessToken: accessToken,
                body: body,
                pathVariables: pathVariables
            )
            
            dump(request)
            
            let (data, response) = try await URLSession.shared.data(for: request)
            guard let httpResponse = response as? HTTPURLResponse else {
                throw NetworkError.responseError
            }
            
            dump(response)
            
            if 200..<300 ~= httpResponse.statusCode {
                if data.isEmpty {
                    return .success(nil)
                } else {
                    let result = try JSONDecoder().decode(T.self, from: data)
                    dump(result)
                    return .success(result)
                }
            } else {
                // 실패 응답 처리
                let errorResponse = try JSONDecoder().decode(ErrorResponse.self, from: data)
                return .failure(.serverError(errorResponse))
            }
            
        } catch {
            throw error
        }
    }
}
