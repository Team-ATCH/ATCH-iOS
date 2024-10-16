//
//  MyPageVC.swift
//  ATCH-iOS
//
//  Created by 변희주 on 8/18/24.
//

import UIKit

import RxSwift
import SnapKit
import Then

final class MyPageVC: UIViewController {
    
    private let myChatNavigationView = NavigationView(title: "My")
    
    private let myPageView = MyPageView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupLayout()
    }
    
    private func setupLayout() {
        self.view.addSubviews(myChatNavigationView,
                              myPageView)
        
        myChatNavigationView.snp.makeConstraints {
            $0.top.horizontalEdges.equalToSuperview()
            $0.height.equalTo((UIWindow.key?.safeAreaInsets.top ?? 0) + 51)
        }
        
        myPageView.snp.makeConstraints {
            $0.top.equalTo(myChatNavigationView.snp.bottom)
            $0.horizontalEdges.bottom.equalToSuperview()
        }
    }
    
}

