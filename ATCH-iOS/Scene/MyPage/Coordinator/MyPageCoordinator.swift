//
//  MyPageCoordinator.swift
//  ATCH-iOS
//
//  Created by 변희주 on 8/18/24.
//

import UIKit

final class MyPageCoordinator: Coordinator {
    var finishDelegate: (any CoordinatorFinishDelegate)?
    var navigationController: UINavigationController
    var childCoordinators: [any Coordinator] = []
    var type: CoordinatorType
    var myPageVC: MyPageVC?

    required init(_ navigationController: UINavigationController) {
        self.navigationController = navigationController
        self.type = CoordinatorType.myPage
    }
    
    func start() {
        self.myPageVC = MyPageVC()
        
        if let vc = self.myPageVC {
            vc.hidesBottomBarWhenPushed = false
            self.navigationController.pushViewController(vc, animated: true)
        }
    }
}

extension MyPageCoordinator: CoordinatorFinishDelegate {
    func coordinatorDidFinish(childCoordinator: Coordinator) {
        self.childCoordinators = self.childCoordinators
            .filter { $0.type != childCoordinator.type }
    }
}
