//
//  CharacterEditCoordinator.swift
//  ATCH-iOS
//
//  Created by 변희주 on 10/26/24.
//

import UIKit

final class CharacterEditCoordinator: Coordinator {
    var finishDelegate: (any CoordinatorFinishDelegate)?
    var navigationController: UINavigationController
    var childCoordinators: [any Coordinator] = []
    var type: CoordinatorType
    var characterEditVC: CharacterEditVC?

    required init(_ navigationController: UINavigationController) {
        self.navigationController = navigationController
        self.type = CoordinatorType.adornCharacter
    }
    
    func start() {
        self.characterEditVC = CharacterEditVC(coordinator: self)
        self.characterEditVC?.viewModel = CharacterEditViewModel()
        
        if let vc = self.characterEditVC {
            vc.hidesBottomBarWhenPushed = false
            self.navigationController.pushViewController(vc, animated: true)
        }
    }
    
    func back() {
        finish()
        self.navigationController.popViewController(animated: true)
    }
}

extension CharacterEditCoordinator: CoordinatorFinishDelegate {
    func coordinatorDidFinish(childCoordinator: Coordinator) {
        self.childCoordinators = self.childCoordinators
            .filter { $0.type != childCoordinator.type }
    }
}
