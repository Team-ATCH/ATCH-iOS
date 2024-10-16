//
//  ProfileModalCoordinator.swift
//  ATCH-iOS
//
//  Created by 변희주 on 10/13/24.
//

import UIKit

final class ProfileModalCoordinator: Coordinator {
    var finishDelegate: (any CoordinatorFinishDelegate)?
    var navigationController: UINavigationController
    var childCoordinators: [any Coordinator] = []
    var type: CoordinatorType
    var profileModalVC: ProfileModalVC?
    
    required init(_ navigationController: UINavigationController) {
        self.navigationController = navigationController
        self.type = CoordinatorType.profileModal
    }
    
    func start() { }
    
    func start(userData: ProfileModalData) {
        self.profileModalVC = ProfileModalVC(coordinator: self)
        self.profileModalVC?.bindUserInfo(data: userData)
        
        if let vc = self.profileModalVC {
            vc.modalPresentationStyle = .overFullScreen
            self.navigationController.present(vc, animated: false)
        }
    }
        
    func pushToMyPage() {
        let myPageCoordinator = MyPageCoordinator(navigationController)
        myPageCoordinator.finishDelegate = self
        self.childCoordinators.append(myPageCoordinator)
        myPageCoordinator.start()
    }
    
    func back() {
        finish()
        self.navigationController.popViewController(animated: true)
    }
}

extension ProfileModalCoordinator: CoordinatorFinishDelegate {
    func coordinatorDidFinish(childCoordinator: Coordinator) {
        self.childCoordinators = self.childCoordinators
            .filter { $0.type != childCoordinator.type }
    }
}
