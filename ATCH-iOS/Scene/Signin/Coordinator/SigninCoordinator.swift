//
//  SigninCoordinator.swift
//  ATCH-iOS
//
//  Created by 변희주 on 10/11/24.
//

import UIKit

final class SigninCoordinator: Coordinator {
    var finishDelegate: (any CoordinatorFinishDelegate)?
    var navigationController: UINavigationController
    var childCoordinators: [any Coordinator] = []
    var type: CoordinatorType
    var signinVC: SigninVC?

    required init(_ navigationController: UINavigationController) {
        self.navigationController = navigationController
        self.type = CoordinatorType.signin
    }
    
    func start() {
        self.signinVC = SigninVC(coordinator: self)
        self.signinVC?.viewModel = SigninViewModel()
        
        if let vc = self.signinVC {
            vc.hidesBottomBarWhenPushed = false
            self.navigationController.pushViewController(vc, animated: false)
            self.navigationController.interactivePopGestureRecognizer?.isEnabled = false
        }
    }
    
    func pushToMainView() {
        let tabBarCoordinator = TabBarCoordinator(self.navigationController)
        tabBarCoordinator.finishDelegate = self
        childCoordinators.append(tabBarCoordinator)
        tabBarCoordinator.start(fromOnboarding: false)
    }
    
    func pushToCharacterSettingView() {
        let characterSettingCoordinator = CharacterSettingCoordinator(navigationController)
        characterSettingCoordinator.finishDelegate = self
        self.childCoordinators.append(characterSettingCoordinator)
        characterSettingCoordinator.start()
    }
}

extension SigninCoordinator: CoordinatorFinishDelegate {
    func coordinatorDidFinish(childCoordinator: Coordinator) {
        self.childCoordinators = self.childCoordinators
            .filter { $0.type != childCoordinator.type }
    }
}
