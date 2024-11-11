//
//  UserRepository.swift
//  ATCH-iOS
//
//  Created by 변희주 on 10/30/24.
//

import Foundation

final class UserRepository {
    
    private let networkProvider: NetworkServiceType = NetworkService()

    func postUserBlock(userID: Int) async throws -> Bool {
        let requestDTO = BlockRequestBody(userId: userID)
        do {
            let response: NetworkResult<EmptyResponse?> = try await networkProvider.request(
                type: .post,
                baseURL: Config.appBaseURL + "/users/block",
                accessToken: KeychainWrapper.loadToken(forKey: UserData.shared.getAccessTokenType()),
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
    
    func patchUserNickname(nickname: String) async throws -> Bool {
        let requestDTO = NicknameRequestBody(nickname: nickname)
        do {
            let response: NetworkResult<EmptyResponse?> = try await networkProvider.request(
                type: .patch,
                baseURL: Config.appBaseURL + "/users/nickname",
                accessToken: KeychainWrapper.loadToken(forKey: UserData.shared.getAccessTokenType()),
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
    
    func getUserCharacterItems() async throws -> GetItemListDTO? {
        do {
            let response: NetworkResult<GetItemListDTO?> = try await networkProvider.request(
                type: .get,
                baseURL: Config.appBaseURL + "/users/item",
                accessToken: KeychainWrapper.loadToken(forKey: UserData.shared.getAccessTokenType()),
                body: nil,
                pathVariables: nil
            )
            
            switch response {
            case .success(let data):
                return data
            case .failure(let error):
                print("Error Code: \(error.code ?? "No code"), Message: \(error.message ?? "No message")")
                return nil
            }
        } catch {
            return nil
        }
    }
    
    func patchUserItem(item: ItemRequestBody) async throws -> Bool {
        let requestDTO = item
        do {
            let response: NetworkResult<EmptyResponse?> = try await networkProvider.request(
                type: .patch,
                baseURL: Config.appBaseURL + "/users/item",
                accessToken: KeychainWrapper.loadToken(forKey: UserData.shared.getAccessTokenType()),
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
    
    func patchUserHashTag(hashTag: [String]) async throws -> Bool {
        let requestDTO = HashTagRequestBody(hashTag: hashTag)
        do {
            let response: NetworkResult<EmptyResponse?> = try await networkProvider.request(
                type: .patch,
                baseURL: Config.appBaseURL + "/users/hash-tag",
                accessToken: KeychainWrapper.loadToken(forKey: UserData.shared.getAccessTokenType()),
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
    
    func getUserCharacterList() async throws -> [CharacterData] {
        do {
            let response: NetworkResult<GetCharacterListDTO?> = try await networkProvider.request(
                type: .get,
                baseURL: Config.appBaseURL + "/users/character",
                accessToken: KeychainWrapper.loadToken(forKey: UserData.shared.getAccessTokenType()),
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
    
    func patchUserCharacter(characterID: Int) async throws -> Bool {
        let requestDTO = CharacterRequestBody(characterId: characterID)
        do {
            let response: NetworkResult<EmptyResponse?> = try await networkProvider.request(
                type: .patch,
                baseURL: Config.appBaseURL + "/users/character",
                accessToken: KeychainWrapper.loadToken(forKey: UserData.shared.getAccessTokenType()),
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
    
    func getUserBackgroundList() async throws -> GetBackgroundListDTO? {
        do {
            let response: NetworkResult<GetBackgroundListDTO?> = try await networkProvider.request(
                type: .get,
                baseURL: Config.appBaseURL + "/users/background",
                accessToken: KeychainWrapper.loadToken(forKey: UserData.shared.getAccessTokenType()),
                body: nil,
                pathVariables: nil
            )
            
            switch response {
            case .success(let data):
                return data
            case .failure(let error):
                print("Error Code: \(error.code ?? "No code"), Message: \(error.message ?? "No message")")
                return nil
            }
        } catch {
            return nil
        }
    }
    
    func getUserCharacterSlotList() async throws -> [CharacterSlot]? {
        do {
            let response: NetworkResult<GetCharacterSlotDTO?> = try await networkProvider.request(
                type: .get,
                baseURL: Config.appBaseURL + "/users/slots",
                accessToken: KeychainWrapper.loadToken(forKey: UserData.shared.getAccessTokenType()),
                body: nil,
                pathVariables: nil
            )
            
            switch response {
            case .success(let data):
                return data?.data
            case .failure(let error):
                print("Error Code: \(error.code ?? "No code"), Message: \(error.message ?? "No message")")
                return nil
            }
        } catch {
            return nil
        }
    }
    
    func patchUserBackground(backgroundID: Int) async throws -> Bool {
        let requestDTO = BackgroundRequestBody(backgroundId: backgroundID)
        do {
            let response: NetworkResult<EmptyResponse?> = try await networkProvider.request(
                type: .patch,
                baseURL: Config.appBaseURL + "/users/background",
                accessToken: KeychainWrapper.loadToken(forKey: UserData.shared.getAccessTokenType()),
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
    
    func deleteUser() async throws -> Bool {
        do {
            let response: NetworkResult<EmptyResponse?> = try await networkProvider.request(
                type: .delete,
                baseURL: Config.appBaseURL + "/users",
                accessToken: KeychainWrapper.loadToken(forKey: UserData.shared.getAccessTokenType()),
                body: nil,
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

}
