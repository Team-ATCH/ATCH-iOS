//
//  AlarmVC.swift
//  ATCH-iOS
//
//  Created by 변희주 on 9/1/24.
//

import UIKit

import RxSwift
import SnapKit
import Then

final class AlarmVC: UIViewController {
    
    var viewModel: AlarmViewModel?
    let coordinator: AlarmCoordinator?
    private let disposeBag: DisposeBag = DisposeBag()

    private let myChatNavigationView = NavigationView(title: "알림함", iconHidden: false, backButtonHidden: false, backButtonTitle: "지도")
    
    init(coordinator: AlarmCoordinator) {
        self.coordinator = coordinator
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupStyle()
        setupLayout()
        setupAction()
    }
    
    private func setupStyle() {
        self.view.backgroundColor = .atchYellow
    }
    
    private func setupLayout() {
        self.view.addSubviews(myChatNavigationView)
        myChatNavigationView.snp.makeConstraints {
            $0.top.horizontalEdges.equalToSuperview()
            $0.height.equalTo((UIWindow.key?.safeAreaInsets.top ?? 0) + 51)
        }
    }
    
    private func setupAction() {
        myChatNavigationView.navigationBackButton.rx.tapGesture().asObservable()
            .when(.recognized)
            .withUnretained(self)
            .subscribe(onNext: { vc, _ in
                vc.coordinator?.back()
            }).disposed(by: disposeBag)
    }
}

