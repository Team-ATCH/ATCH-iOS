//
//  MyChatCoordinator.swift
//  ATCH-iOS
//
//  Created by 변희주 on 8/18/24.
//

import UIKit

final class MyChatCoordinator: Coordinator {
    var finishDelegate: (any CoordinatorFinishDelegate)?
    var navigationController: UINavigationController
    var childCoordinators: [any Coordinator] = []
    var type: CoordinatorType
    var myChatVC: MyChatVC?

    required init(_ navigationController: UINavigationController) {
        self.navigationController = navigationController
        self.type = CoordinatorType.myChat
    }
    
    func start() {
        self.myChatVC = MyChatVC(coordinator: self)
        
        if let vc = self.myChatVC {
            vc.hidesBottomBarWhenPushed = false
            self.navigationController.pushViewController(vc, animated: true)
        }
    }
    
    func pushToChattingRoomView(chattingRoomName: String) {
        let chattingRoomCoordinator = ChattingRoomCoordinator(navigationController)
        chattingRoomCoordinator.finishDelegate = self
        self.childCoordinators.append(chattingRoomCoordinator)
        chattingRoomCoordinator.start(chattingRoomName: chattingRoomName)
    }
}

extension MyChatCoordinator: CoordinatorFinishDelegate {
    func coordinatorDidFinish(childCoordinator: Coordinator) {
        self.childCoordinators = self.childCoordinators
            .filter { $0.type != childCoordinator.type }
    }
}

