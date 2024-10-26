//
//  ProfileEditCoordinator.swift
//  ATCH-iOS
//
//  Created by 변희주 on 10/26/24.
//

import UIKit

final class ProfileEditCoordinator: Coordinator {
    var finishDelegate: (any CoordinatorFinishDelegate)?
    var navigationController: UINavigationController
    var childCoordinators: [any Coordinator] = []
    var type: CoordinatorType
    var profileEditVC: ProfileEditVC?

    required init(_ navigationController: UINavigationController) {
        self.navigationController = navigationController
        self.type = CoordinatorType.profileEdit
    }
    
    func start() {
        self.profileEditVC = ProfileEditVC(coordinator: self)
        
        if let vc = self.profileEditVC {
            vc.hidesBottomBarWhenPushed = false
            self.navigationController.pushViewController(vc, animated: true)
        }
    }
    
    func back() {
        finish()
        self.navigationController.popViewController(animated: true)
    }
}

extension ProfileEditCoordinator: CoordinatorFinishDelegate {
    func coordinatorDidFinish(childCoordinator: Coordinator) {
        self.childCoordinators = self.childCoordinators
            .filter { $0.type != childCoordinator.type }
    }
}
