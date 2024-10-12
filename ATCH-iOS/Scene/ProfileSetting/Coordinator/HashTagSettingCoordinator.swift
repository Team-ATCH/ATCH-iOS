//
//  HashTagSettingCoordinator.swift
//  ATCH-iOS
//
//  Created by 변희주 on 10/12/24.
//

import UIKit

final class HashTagSettingCoordinator: Coordinator {
    var finishDelegate: (any CoordinatorFinishDelegate)?
    var navigationController: UINavigationController
    var childCoordinators: [any Coordinator] = []
    var type: CoordinatorType
    var hashTagSettingVC: HashTagSettingVC?

    required init(_ navigationController: UINavigationController) {
        self.navigationController = navigationController
        self.type = CoordinatorType.profileSetting
    }
    
    func start() {
        self.hashTagSettingVC = HashTagSettingVC(coordinator: self)
        self.hashTagSettingVC?.viewModel = ProfileSettingViewModel()
        
        if let vc = self.hashTagSettingVC {
            vc.hidesBottomBarWhenPushed = false
            self.navigationController.pushViewController(vc, animated: true)
        }
    }
    
    func back() {
        finish()
        self.navigationController.popViewController(animated: true)
    }
}

extension HashTagSettingCoordinator: CoordinatorFinishDelegate {
    func coordinatorDidFinish(childCoordinator: Coordinator) {
        self.childCoordinators = self.childCoordinators
            .filter { $0.type != childCoordinator.type }
    }
}
