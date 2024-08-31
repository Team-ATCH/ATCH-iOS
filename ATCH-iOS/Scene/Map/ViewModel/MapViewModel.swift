//
//  MapViewModel.swift
//  ATCH-iOS
//
//  Created by 변희주 on 9/1/24.
//

import ObjectiveC
import RxRelay
import RxSwift

final class MapViewModel: NSObject {
    
    let coordinator: MapCoordinator?

    init(coordinator: MapCoordinator) { // 나중에 유즈케이스도
        self.coordinator = coordinator
    }
    
}
