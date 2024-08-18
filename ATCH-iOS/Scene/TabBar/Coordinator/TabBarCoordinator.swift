//
//  TabBarCoordinator.swift
//  ATCH-iOS
//
//  Created by 변희주 on 8/17/24.
//

import UIKit

final class TabBarCoordinator: Coordinator {
    
    var finishDelegate: CoordinatorFinishDelegate?
    var tabBarController: UITabBarController
    var navigationController: UINavigationController
    var childCoordinators: [Coordinator] = []
    var type: CoordinatorType
    
    required init(_ navigationController: UINavigationController) {
        self.navigationController = navigationController
        self.type = CoordinatorType.tab

        // AtchTabBarController를 생성
        self.tabBarController = TabBarController()
    }
    
    func start() {
        // 1. 탭바 아이템 리스트 생성
        let pages: [TabBarItemType] = TabBarItemType.allCases
        // 2. 탭바 아이템 생성
        let tabBarItems: [UITabBarItem] = pages.map { self.createTabBarItem(of: $0) }
        // 3. 탭바별 navigation controller 생성
        let controllers: [UINavigationController] = tabBarItems.map {
            self.createTabNavigationController(tabBarItem: $0)
        }
        // 4. 탭바별로 코디네이터 생성하기
        let _ = controllers.map { self.startTabCoordinator(tabNavigationController: $0) }
        
        // 5. 탭바 설정 및 화면에 추가
        if let tabBarVC = self.tabBarController as? TabBarController {
            tabBarVC.setViewControllersForTabs(controllers)
        }
        self.addTabBarController()
    }
    
    private func addTabBarController() {
        self.navigationController.pushViewController(self.tabBarController, animated: true)
    }
    
    private func createTabBarItem(of page: TabBarItemType) -> UITabBarItem {
        return UITabBarItem(
            title: page.toTitle(),
            image: page.toIcon(),
            tag: page.toIndex()
        )
    }
    
    private func createTabNavigationController(tabBarItem: UITabBarItem) -> UINavigationController {
        let tabNavigationController = UINavigationController()
        tabNavigationController.setNavigationBarHidden(true, animated: true)
        tabNavigationController.tabBarItem = tabBarItem
        return tabNavigationController
    }
    
    private func startTabCoordinator(tabNavigationController: UINavigationController) {
        let tabBarItemTag: Int = tabNavigationController.tabBarItem.tag
        guard let tabBarItemType: TabBarItemType = TabBarItemType(index: tabBarItemTag) else { return }
        
        switch tabBarItemType {
        case .map:
            let mapCoordinator = MapCoordinator(tabNavigationController)
            mapCoordinator.finishDelegate = self
            self.childCoordinators.append(mapCoordinator)
            mapCoordinator.start()
        case .myChat:
            let myChatCoordinator = MyChatCoordinator(tabNavigationController)
            myChatCoordinator.finishDelegate = self
            self.childCoordinators.append(myChatCoordinator)
            myChatCoordinator.start()
        case .allChat:
            let allChatCoordinator = AllChatCoordinator(tabNavigationController)
            allChatCoordinator.finishDelegate = self
            self.childCoordinators.append(allChatCoordinator)
            allChatCoordinator.start()
        case .myPage:
            let myPageCoordinator = MyPageCoordinator(tabNavigationController)
            myPageCoordinator.finishDelegate = self
            self.childCoordinators.append(myPageCoordinator)
            myPageCoordinator.start()
        }
    }
}

extension TabBarCoordinator: CoordinatorFinishDelegate {
    func coordinatorDidFinish(childCoordinator: Coordinator) {
        self.childCoordinators.removeAll()
        self.navigationController.viewControllers.removeAll()
        self.finishDelegate?.coordinatorDidFinish(childCoordinator: self)
    }
}
