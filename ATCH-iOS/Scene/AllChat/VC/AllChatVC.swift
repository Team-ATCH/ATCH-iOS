//
//  AllChatVC.swift
//  ATCH-iOS
//
//  Created by 변희주 on 8/18/24.
//

import UIKit

import RxSwift
import SnapKit
import Then

final class AllChatVC: UIViewController {
    
    private let myChatNavigationView = NavigationView(title: "전체 채팅")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupLayout()
    }
    
    private func setupLayout() {
        self.view.addSubviews(myChatNavigationView)
        myChatNavigationView.snp.makeConstraints {
            $0.top.horizontalEdges.equalToSuperview()
            $0.height.equalTo((UIWindow.key?.safeAreaInsets.top ?? 0) + 51)
        }
    }
    
}

