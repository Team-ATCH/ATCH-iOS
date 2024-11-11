//
//  AlarmCoordinator.swift
//  ATCH-iOS
//
//  Created by 변희주 on 9/1/24.
//

import UIKit

final class AlarmCoordinator: Coordinator {
    var finishDelegate: (any CoordinatorFinishDelegate)?
    var navigationController: UINavigationController
    var childCoordinators: [any Coordinator] = []
    var type: CoordinatorType
    var alarmVC: AlarmVC?

    required init(_ navigationController: UINavigationController) {
        self.navigationController = navigationController
        self.type = CoordinatorType.alarm
    }
    
    func start() {
        self.alarmVC = AlarmVC(coordinator: self)
        self.alarmVC?.viewModel = AlarmViewModel()
        
        if let vc = self.alarmVC {
            vc.hidesBottomBarWhenPushed = false
            self.navigationController.pushViewController(vc, animated: true)
        }
    }
    
    func pushToMyPage() {
        navigationController.tabBarController?.selectedIndex = 3
    }
    
    func back() {
        finish()
        self.navigationController.popViewController(animated: true)
    }
}

extension AlarmCoordinator: CoordinatorFinishDelegate {
    func coordinatorDidFinish(childCoordinator: Coordinator) {
        self.childCoordinators = self.childCoordinators
            .filter { $0.type != childCoordinator.type }
    }
}
