//
//  TokenManager.swift
//  ATCH-iOS
//
//  Created by 변희주 on 10/27/24.
//

import UIKit

final class TokenManager {
    
    func checkToken(accessToken: String) -> URLRequest {
        
        let urlString = Config.appBaseURL + "/auth/token"
        
        // URL 생성
        guard let url = URL(string: urlString) else {
            fatalError("Failed to create URL")
        }
        print(url)

        // URLRequest 생성
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        // 헤더 추가
        let header = ["Content-Type": "application/json",
                      "Authorization" : "Bearer \(accessToken)"]
        header.forEach {
            request.addValue($0.value, forHTTPHeaderField: $0.key)
        }
        
        return request
    }
    
    func getTokenAPI(accessToken: String) async throws -> BaseResponse<TokenReissueResponseDTO> {
        do {
            let request = self.checkToken(accessToken: accessToken)
            let (data, response) = try await URLSession.shared.data(for: request)
            dump(request)
            guard let httpResponse = response as? HTTPURLResponse else {
                throw NetworkError.responseError
            }
            
            switch httpResponse.statusCode {
            case 200..<401:
                let result = try JSONDecoder().decode(BaseResponse<TokenReissueResponseDTO>.self, from: data)
                return result
            case 404:
                throw NetworkError.notFoundError
            case 500:
                throw NetworkError.internalServerError
            default:
                throw NetworkError.unknownError
            }
        } catch {
            throw error
        }
    }
}

struct TokenReissueResponseDTO: Decodable {
    let accessToken: String
}