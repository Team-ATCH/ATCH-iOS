//
//  AlarmViewModel.swift
//  ATCH-iOS
//
//  Created by 변희주 on 9/1/24.
//

import Foundation

import RxRelay
import RxSwift

final class AlarmViewModel: NSObject {
    
    private let homeRepository: HomeRepository = HomeRepository()
    
    var alarmList: [AlarmData] = []
    let alarmListRelay: PublishRelay<Bool> = PublishRelay<Bool>()
    
    override init() {
        super.init()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func getNoticeList() {
        Task {
            do {
                let result = try await homeRepository.getNoticeList()
                alarmList.append(contentsOf: result)
                alarmListRelay.accept(!alarmList.isEmpty)
            }
        }
    }
}
