//
//  NicknameSettingCoordinator.swift
//  ATCH-iOS
//
//  Created by 변희주 on 10/12/24.
//

import UIKit

final class NicknameSettingCoordinator: Coordinator {
    var finishDelegate: (any CoordinatorFinishDelegate)?
    var navigationController: UINavigationController
    var childCoordinators: [any Coordinator] = []
    var type: CoordinatorType
    var nicknameSettingVC: NicknameSettingVC?

    required init(_ navigationController: UINavigationController) {
        self.navigationController = navigationController
        self.type = CoordinatorType.profileSetting
    }
    
    func start() {
        self.nicknameSettingVC = NicknameSettingVC(coordinator: self)
        self.nicknameSettingVC?.viewModel = ProfileSettingViewModel()
        
        if let vc = self.nicknameSettingVC {
            vc.hidesBottomBarWhenPushed = false
            self.navigationController.pushViewController(vc, animated: true)
        }
    }
    
    func back() {
        finish()
        self.navigationController.popViewController(animated: true)
    }
    
    func pushToHashTagSettingView() {
        let hashTagSettingCoordinator = HashTagSettingCoordinator(navigationController)
        hashTagSettingCoordinator.finishDelegate = self
        self.childCoordinators.append(hashTagSettingCoordinator)
        hashTagSettingCoordinator.start()
    }
}

extension NicknameSettingCoordinator: CoordinatorFinishDelegate {
    func coordinatorDidFinish(childCoordinator: Coordinator) {
        self.childCoordinators = self.childCoordinators
            .filter { $0.type != childCoordinator.type }
    }
}
