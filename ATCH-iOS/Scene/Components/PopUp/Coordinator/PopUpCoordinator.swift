//
//  PopUpCoordinator.swift
//  ATCH-iOS
//
//  Created by 변희주 on 10/16/24.
//

import UIKit

final class PopUpCoordinator: Coordinator {
    var finishDelegate: (any CoordinatorFinishDelegate)?
    var navigationController: UINavigationController
    var childCoordinators: [any Coordinator] = []
    var type: CoordinatorType
    var popUpVC: PopUpVC?
    
    required init(_ navigationController: UINavigationController) {
        self.navigationController = navigationController
        self.type = CoordinatorType.popup
    }
    
    func start() { }
    
    func start(popUpData: PopUpData) {
        self.popUpVC = PopUpVC(coordinator: self)
        self.popUpVC?.viewModel = PopUpViewModel()
        self.popUpVC?.bindPopUpData(data: popUpData)
        
        if let vc = self.popUpVC {
            vc.modalPresentationStyle = .overFullScreen
            self.navigationController.present(vc, animated: false)
        }
    }
    
    func back() {
        finish()
        self.navigationController.popViewController(animated: true)
    }
}

extension PopUpCoordinator: CoordinatorFinishDelegate {
    func coordinatorDidFinish(childCoordinator: Coordinator) {
        self.childCoordinators = self.childCoordinators
            .filter { $0.type != childCoordinator.type }
    }
}
