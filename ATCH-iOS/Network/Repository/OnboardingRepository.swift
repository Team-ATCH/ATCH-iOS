//
//  OnboardingRepository.swift
//  ATCH-iOS
//
//  Created by 변희주 on 10/30/24.
//

import Foundation

final class OnboardingRepository {
    
    private let networkProvider: NetworkServiceType = NetworkService()
    
    func postNickname(nickname: String) async throws -> Bool {
        let requestDTO = NicknameRequestBody(nickname: nickname)
        do {
            let response: NetworkResult<EmptyResponse?> = try await networkProvider.request(
                type: .post,
                baseURL: Config.appBaseURL + "/onboarding/nickname",
                accessToken: KeychainWrapper.loadToken(forKey: .accessToken),
                body: requestDTO,
                pathVariables: nil
            )
    
            switch response {
            case .success:
                return true
            case .failure(let error):
                print("Error Code: \(error.code ?? "No code"), Message: \(error.message ?? "No message")")
                return false
            }
        } catch {
            return false
        }
    }
    
    func postHashTag(hashTag: [String]) async throws -> Bool {
        let requestDTO = HashTagRequestBody(hashTag: hashTag)
        do {
            let response: NetworkResult<EmptyResponse?> = try await networkProvider.request(
                type: .post,
                baseURL: Config.appBaseURL + "/onboarding/hash-tag",
                accessToken: KeychainWrapper.loadToken(forKey: .accessToken),
                body: requestDTO,
                pathVariables: nil
            )
    
            switch response {
            case .success:
                return true
            case .failure(let error):
                print("Error Code: \(error.code ?? "No code"), Message: \(error.message ?? "No message")")
                return false
            }
        } catch {
            return false
        }
    }
    
    func postCharacter(characterID: Int) async throws -> Bool {
        let requestDTO = CharacterRequestBody(characterId: characterID)
        do {
            let response: NetworkResult<EmptyResponse?> = try await networkProvider.request(
                type: .post,
                baseURL: Config.appBaseURL + "/onboarding/character",
                accessToken: KeychainWrapper.loadToken(forKey: .accessToken),
                body: requestDTO,
                pathVariables: nil
            )
    
            switch response {
            case .success:
                return true
            case .failure(let error):
                print("Error Code: \(error.code ?? "No code"), Message: \(error.message ?? "No message")")
                return false
            }
        } catch {
            return false
        }
    }
    
    func getCharacterList() async throws -> [CharacterData] {
        do {
            let response: NetworkResult<GetCharacterListDTO?> = try await networkProvider.request(
                type: .get,
                baseURL: Config.appBaseURL + "/onboarding/character",
                accessToken: KeychainWrapper.loadToken(forKey: .accessToken),
                body: nil,
                pathVariables: nil
            )
    
            switch response {
            case .success(let data):
                return data?.mapToCharacterSelectView() ?? []
            case .failure(let error):
                print("Error Code: \(error.code ?? "No code"), Message: \(error.message ?? "No message")")
                return []
            }
        } catch {
            return []
        }
    }
    
}
