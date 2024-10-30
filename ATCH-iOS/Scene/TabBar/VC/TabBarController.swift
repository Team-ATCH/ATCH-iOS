//
//  TabBarController.swift
//  ATCH-iOS
//
//  Created by 변희주 on 8/18/24.
//

import UIKit

final class TabBarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let customTabBar = AtchTabBar()
        self.setValue(customTabBar, forKey: "tabBar")
        self.view.backgroundColor = .atchGrey1
        self.configureTabBarController()
    }
    
    private func configureTabBarController() {
        let borderLayer = CALayer()
        borderLayer.borderWidth = 1.0
        borderLayer.borderColor = UIColor.atchShadowGrey.cgColor
        self.tabBar.layer.addSublayer(borderLayer)
        borderLayer.frame = .init(origin: .zero, size: .init(width: UIScreen.main.bounds.width,
                                                             height: 1.0))
        
        let tabBarAppearance = UITabBarAppearance()
        tabBarAppearance.backgroundColor = .atchWhite
        tabBarAppearance.stackedLayoutAppearance.selected.titleTextAttributes = [
            .foregroundColor: UIColor.atchShadowGrey,
            .font: UIFont.font(.caption)
        ]
        tabBarAppearance.stackedLayoutAppearance.normal.titleTextAttributes = [
            .foregroundColor: UIColor.atchShadowGrey,
            .font: UIFont.font(.caption)
        ]
        tabBarAppearance.stackedItemWidth = 48.adjustedW
        tabBarAppearance.stackedLayoutAppearance.normal.titlePositionAdjustment = .init(horizontal: 0, vertical: -6)
        tabBarAppearance.stackedLayoutAppearance.selected.titlePositionAdjustment = .init(horizontal: 0, vertical: -6)
        tabBarAppearance.stackedItemSpacing = 42.adjustedW
        tabBarAppearance.stackedItemPositioning = .centered
        tabBarAppearance.backgroundEffect = nil
        
        self.tabBar.standardAppearance = tabBarAppearance
        self.tabBar.scrollEdgeAppearance = tabBarAppearance
    }
    
    func setViewControllersForTabs(_ viewControllers: [UIViewController]) {
        self.setViewControllers(viewControllers, animated: false)
        self.selectedIndex = TabBarItemType.map.toIndex()
    }
}
