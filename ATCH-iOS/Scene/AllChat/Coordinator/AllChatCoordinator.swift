//
//  AllChatCoordinator.swift
//  ATCH-iOS
//
//  Created by 변희주 on 8/18/24.
//

import UIKit

final class AllChatCoordinator: Coordinator {
    var finishDelegate: (any CoordinatorFinishDelegate)?
    var navigationController: UINavigationController
    var childCoordinators: [any Coordinator] = []
    var type: CoordinatorType
    var allChatVC: AllChatVC?

    required init(_ navigationController: UINavigationController) {
        self.navigationController = navigationController
        self.type = CoordinatorType.allChat
    }
    
    func start() {
        self.allChatVC = AllChatVC()
        
        if let vc = self.allChatVC {
            vc.hidesBottomBarWhenPushed = false
            self.navigationController.pushViewController(vc, animated: true)
        }
    }
}

extension AllChatCoordinator: CoordinatorFinishDelegate {
    func coordinatorDidFinish(childCoordinator: Coordinator) {
        self.childCoordinators = self.childCoordinators
            .filter { $0.type != childCoordinator.type }
    }
}
