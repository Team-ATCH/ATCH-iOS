//
//  ProfileModalViewModel.swift
//  ATCH-iOS
//
//  Created by 변희주 on 11/9/24.
//

import Foundation

import RxRelay
import RxSwift

final class ProfileModalViewModel: NSObject {
    
    private let chatRepository: ChatRepository = ChatRepository()

    let chatRelay: PublishRelay<RoomResponseDTO> = PublishRelay<RoomResponseDTO>()
    
    override init() {
        super.init()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func postChattingRoom(userID: Int) {
        Task {
            do {
                let result = try await chatRepository.postChattingRoom(userId: userID)
                if let result = result {
                    chatRelay.accept(result)
                }
            }
        }
    }
}
