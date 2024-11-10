//
//  CharacterEditViewModel.swift
//  ATCH-iOS
//
//  Created by 변희주 on 11/10/24.
//

import Foundation

import RxRelay
import RxSwift

final class CharacterEditViewModel: NSObject {
    
    private let userRepository: UserRepository = UserRepository()

    let itemSuccessRelay: PublishRelay<([Int?], ItemData)> = PublishRelay<([Int?], ItemData)>()
    let characterSuccessRelay: PublishRelay<[CharacterData]> = PublishRelay<[CharacterData]>()
    let backgroundSuccessRelay: PublishRelay<(Int, [BackgroundData])> = PublishRelay<(Int, [BackgroundData])>()

    var characterID: Int = 0
    
    override init() {
        super.init()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func getCharacterItems() {
        Task {
            do {
                let result = try await userRepository.getUserCharacterItems()
                if let result {
                    itemSuccessRelay.accept((result.inUseIDs, result.mapToItemSelectView()))
                }
            }
        }
    }
    
    func getCharacters() {
        Task {
            do {
                let result = try await userRepository.getUserCharacterList()
                characterSuccessRelay.accept(result)
            }
        }
    }
    
    func getBackgrounds() {
        Task {
            do {
                let result = try await userRepository.getUserBackgroundList()
                if let result {
                    backgroundSuccessRelay.accept((result.inUseId ?? -1, result.mapToBackgroundSelectView()))
                }
            }
        }
    }
    
    func updateItems(items: [Int]) {
        Task {
            do {
                let itemId1 = items.indices.contains(0) ? items[0] : nil
                let itemId2 = items.indices.contains(1) ? items[1] : nil
                let itemId3 = items.indices.contains(2) ? items[2] : nil

                let request = ItemRequestBody(itemId1: itemId1,
                                              itemId2: itemId2,
                                              itemId3: itemId3)
                
                let result = try await userRepository.patchUserItem(item: request)
                print(result)
            }
        }
    }
    
    func updateCharacter(characterID: Int) {
        Task {
            do {
                let result = try await userRepository.patchUserCharacter(characterID: characterID)
                print(result)
            }
        }
    }
    
    func updateBackground(backgroundID: Int) {
        Task {
            do {
                let result = try await userRepository.patchUserBackground(backgroundID: backgroundID)
                print(result)
            }
        }
    }
}
