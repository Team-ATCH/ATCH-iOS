//
//  CharacterSettingCoordinator.swift
//  ATCH-iOS
//
//  Created by 변희주 on 10/12/24.
//

import UIKit

final class CharacterSettingCoordinator: Coordinator {
    var finishDelegate: (any CoordinatorFinishDelegate)?
    var navigationController: UINavigationController
    var childCoordinators: [any Coordinator] = []
    var type: CoordinatorType
    var characterSettingVC: CharacterSettingVC?

    required init(_ navigationController: UINavigationController) {
        self.navigationController = navigationController
        self.type = CoordinatorType.profileSetting
    }
    
    func start() {
        self.characterSettingVC = CharacterSettingVC(coordinator: self)
        self.characterSettingVC?.viewModel = ProfileSettingViewModel()
        
        if let vc = self.characterSettingVC {
            vc.hidesBottomBarWhenPushed = false
            self.navigationController.pushViewController(vc, animated: true)
        }
    }
    
    func back() {
        finish()
        self.navigationController.popViewController(animated: true)
    }
    
    func pushToNicknameSettingView() {
        let nicknameSettingCoordinator = NicknameSettingCoordinator(navigationController)
        nicknameSettingCoordinator.finishDelegate = self
        self.childCoordinators.append(nicknameSettingCoordinator)
        nicknameSettingCoordinator.start()
    }
}

extension CharacterSettingCoordinator: CoordinatorFinishDelegate {
    func coordinatorDidFinish(childCoordinator: Coordinator) {
        self.childCoordinators = self.childCoordinators
            .filter { $0.type != childCoordinator.type }
    }
}
