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
        self.type = CoordinatorType.chattingRoom
    }
    
    func start() {
        self.signinVC = SigninVC(coordinator: self)
        self.signinVC?.viewModel = SigninViewModel()
        
        if let vc = self.signinVC {
            vc.hidesBottomBarWhenPushed = false
            self.navigationController.pushViewController(vc, animated: true)
        }
    }
    
    func back() {
        finish()
        self.navigationController.popViewController(animated: true)
    }
}

extension SigninCoordinator: CoordinatorFinishDelegate {
    func coordinatorDidFinish(childCoordinator: Coordinator) {
        self.childCoordinators = self.childCoordinators
            .filter { $0.type != childCoordinator.type }
    }
}
