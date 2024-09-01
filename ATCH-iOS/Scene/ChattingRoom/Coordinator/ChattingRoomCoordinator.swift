//
//  ChattingRoomCoordinator.swift
//  ATCH-iOS
//
//  Created by 변희주 on 9/1/24.
//

import UIKit

final class ChattingRoomCoordinator: Coordinator {
    var finishDelegate: (any CoordinatorFinishDelegate)?
    var navigationController: UINavigationController
    var childCoordinators: [any Coordinator] = []
    var type: CoordinatorType
    var chattingRoomVC: ChattingRoomVC?

    required init(_ navigationController: UINavigationController) {
        self.navigationController = navigationController
        self.type = CoordinatorType.chattingRoom
    }
    
    func start() { }
    
    func start(chattingRoomName: String) {
        self.chattingRoomVC = ChattingRoomVC(coordinator: self, chattingRoomName: chattingRoomName)
        self.chattingRoomVC?.viewModel = ChattingRoomViewModel()
        
        if let vc = self.chattingRoomVC {
            vc.hidesBottomBarWhenPushed = false
            self.navigationController.pushViewController(vc, animated: true)
        }
    }
    
    func back() {
        finish()
        self.navigationController.popViewController(animated: true)
    }
}

extension ChattingRoomCoordinator: CoordinatorFinishDelegate {
    func coordinatorDidFinish(childCoordinator: Coordinator) {
        self.childCoordinators = self.childCoordinators
            .filter { $0.type != childCoordinator.type }
    }
}
