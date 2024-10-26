//
//  SplashCoordinator.swift
//  ATCH-iOS
//
//  Created by 변희주 on 10/12/24.
//

import UIKit

final class SplashCoordinator: Coordinator {
    var finishDelegate: (any CoordinatorFinishDelegate)?
    var navigationController: UINavigationController
    var childCoordinators: [any Coordinator] = []
    var type: CoordinatorType
    var splashVC: SplashVC?

    required init(_ navigationController: UINavigationController) {
        self.navigationController = navigationController
        self.type = CoordinatorType.splash
    }
    
    func start() {
        self.splashVC = SplashVC(coordinator: self)
        self.splashVC?.viewModel = SplashViewModel()
        
        if let vc = self.splashVC {
            vc.hidesBottomBarWhenPushed = false
            self.navigationController.pushViewController(vc, animated: true)
        }
    }
    
    func pushToMainView() {
        let tabBarCoordinator = TabBarCoordinator(self.navigationController)
        tabBarCoordinator.finishDelegate = self
        childCoordinators.append(tabBarCoordinator)
        tabBarCoordinator.start(fromOnboarding: false)
    }
    
    func pushToSignView() {
        let signinCoordinator = SigninCoordinator(self.navigationController)
        signinCoordinator.finishDelegate = self
        childCoordinators.append(signinCoordinator)
        signinCoordinator.start()
    }
}

extension SplashCoordinator: CoordinatorFinishDelegate {
    func coordinatorDidFinish(childCoordinator: Coordinator) {
        self.childCoordinators = self.childCoordinators
            .filter { $0.type != childCoordinator.type }
    }
}
