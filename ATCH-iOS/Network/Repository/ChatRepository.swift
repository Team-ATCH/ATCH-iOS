//
//  ChatRepository.swift
//  ATCH-iOS
//
//  Created by 변희주 on 10/30/24.
//

import Foundation

final class ChatRepository {
    
    private let networkProvider: NetworkServiceType = NetworkService()
    
    func getAllChattingRoomList() async throws -> [AllChattingData] {
        do {
            let response: NetworkResult<GetRoomListDTO?> = try await networkProvider.request(
                type: .get,
                baseURL: Config.appBaseURL + "/rooms",
                accessToken: KeychainWrapper.loadToken(forKey: .accessToken),
                body: nil,
                pathVariables: nil
            )
            
            switch response {
            case .success(let data):
                return data?.mapToAllChatView() ?? []
            case .failure(let error):
                print("Error Code: \(error.code ?? "No code"), Message: \(error.message ?? "No message")")
                return []
            }
        } catch {
            return []
        }
    }
    
    func getMyChattingRoomList() async throws -> [MyChatData] {
        do {
            let response: NetworkResult<GetMyRoomListDTO?> = try await networkProvider.request(
                type: .get,
                baseURL: Config.appBaseURL + "/rooms/active",
                accessToken: KeychainWrapper.loadToken(forKey: .accessToken),
                body: nil,
                pathVariables: nil
            )
            
            switch response {
            case .success(let data):
                return data?.mapToMyChatView() ?? []
            case .failure(let error):
                print("Error Code: \(error.code ?? "No code"), Message: \(error.message ?? "No message")")
                return []
            }
        } catch {
            return []
        }
    }
    
    func postChattingRoom(userId: Int) async throws -> RoomResponseDTO? {
        let requestDTO = RoomRequestBody(userId: userId)
        do {
            let response: NetworkResult<RoomResponseDTO?> = try await networkProvider.request(
                type: .post,
                baseURL: Config.appBaseURL + "/rooms",
                accessToken: KeychainWrapper.loadToken(forKey: .accessToken),
                body: requestDTO,
                pathVariables: nil
            )
            
            switch response {
            case .success(let data):
                return data ?? nil
            case .failure(let error):
                print("Error Code: \(error.code ?? "No code"), Message: \(error.message ?? "No message")")
                return nil
            }
        } catch {
            return nil
        }
    }
    
    func getChattingList(roomId: Int) async throws -> [ChattingData] {
        do {
            let response: NetworkResult<GetChatListDTO?> = try await networkProvider.request(
                type: .get,
                baseURL: Config.appBaseURL + "/messages/\(roomId)",
                accessToken: KeychainWrapper.loadToken(forKey: .accessToken),
                body: nil,
                pathVariables: nil
            )
            
            switch response {
            case .success(let data):
                return data?.mapToChattingRoomView() ?? []
            case .failure(let error):
                print("Error Code: \(error.code ?? "No code"), Message: \(error.message ?? "No message")")
                return []
            }
        } catch {
            return []
        }
    }
}
