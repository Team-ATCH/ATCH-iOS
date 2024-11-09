//
//  MapCoordinator.swift
//  ATCH-iOS
//
//  Created by 변희주 on 8/18/24.
//

import UIKit

final class MapCoordinator: Coordinator {
    var finishDelegate: (any CoordinatorFinishDelegate)?
    var navigationController: UINavigationController
    var childCoordinators: [any Coordinator] = []
    var type: CoordinatorType
    var mapVC: MapVC?

    required init(_ navigationController: UINavigationController) {
        self.navigationController = navigationController
        self.type = CoordinatorType.map
    }
    
    func start() {
        
    }
    
    func start(fromOnboarding: Bool) {
        self.mapVC = MapVC(coordinator: self, fromOnboarding: fromOnboarding)
        self.mapVC?.viewModel = MapViewModel()
        
        if let vc = self.mapVC {
            vc.hidesBottomBarWhenPushed = false
            self.navigationController.pushViewController(vc, animated: true)
        }
    }
    
    func pushToAlarmView() {
        let alarmCoordinator = AlarmCoordinator(navigationController)
        alarmCoordinator.finishDelegate = self
        self.childCoordinators.append(alarmCoordinator)
        alarmCoordinator.start()
    }
    
    func pushToChattingRoomView(opponent: Sender, roomID: Int) {
        let chattingRoomCoordinator = ChattingRoomCoordinator(navigationController)
        chattingRoomCoordinator.finishDelegate = self
        self.childCoordinators.append(chattingRoomCoordinator)
        chattingRoomCoordinator.start(opponent: opponent, roomID: roomID)
    }
    
    func presentProfileModal(userData: ProfileModalData) {
        let profileModalCoordinator = ProfileModalCoordinator(navigationController)
        profileModalCoordinator.finishDelegate = self
        self.childCoordinators.append(profileModalCoordinator)
        profileModalCoordinator.start(userData: userData)
    }
}

extension MapCoordinator: CoordinatorFinishDelegate {
    func coordinatorDidFinish(childCoordinator: Coordinator) {
        self.childCoordinators = self.childCoordinators
            .filter { $0.type != childCoordinator.type }
    }
}
