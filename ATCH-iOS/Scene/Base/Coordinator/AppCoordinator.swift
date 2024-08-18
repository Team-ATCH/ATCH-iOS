//
//  AppCoordinator.swift
//  ATCH-iOS
//
//  Created by 변희주 on 8/18/24.
//

import UIKit

final class AppCoordinator: Coordinator {
    var finishDelegate: (any CoordinatorFinishDelegate)?
    var navigationController: UINavigationController
    var childCoordinators: [any Coordinator] = []
    var type: CoordinatorType
    
    var isLoggedIn = true
    
    required init(_ navigationController: UINavigationController) {
        self.navigationController = navigationController
        self.type = CoordinatorType.app
    }
    
    func start() {
        if isLoggedIn {
            showMainFlow()
        } else {
            showLoginFlow()
        }
    }
    
    private func showMainFlow() {
        let tabBarCoordinator = TabBarCoordinator(self.navigationController)
        tabBarCoordinator.finishDelegate = self
        childCoordinators.append(tabBarCoordinator)
        tabBarCoordinator.start()
    }
    
    private func showLoginFlow() {
        // 회원가입 및 로그인
    }
}

extension AppCoordinator: CoordinatorFinishDelegate {
    func coordinatorDidFinish(childCoordinator: Coordinator) {
        self.childCoordinators.removeAll()
        self.navigationController.viewControllers.removeAll()
        self.finishDelegate?.coordinatorDidFinish(childCoordinator: self)
    }
}
