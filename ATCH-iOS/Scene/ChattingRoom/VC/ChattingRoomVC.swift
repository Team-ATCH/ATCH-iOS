//
//  ChattingRoomVC.swift
//  ATCH-iOS
//
//  Created by 변희주 on 9/1/24.
//

import UIKit

import RxSwift
import SnapKit
import Then

final class ChattingRoomVC: UIViewController {
    
    var viewModel: ChattingRoomViewModel?
    
    private let disposeBag: DisposeBag = DisposeBag()

    private let chattingRoomNavigationView = NavigationView(backButtonHidden: false, backButtonTitle: "내 채팅")
    
    init(chattingRoomName: String) {
        self.chattingRoomNavigationView.changeTitle(title: chattingRoomName)
        
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
        self.view.backgroundColor = .atchGrey1
    }
    
    private func setupLayout() {
        self.view.addSubviews(chattingRoomNavigationView)
        chattingRoomNavigationView.snp.makeConstraints {
            $0.top.horizontalEdges.equalToSuperview()
            $0.height.equalTo((UIWindow.key?.safeAreaInsets.top ?? 0) + 51)
        }
    }
    
    private func setupAction() {
        chattingRoomNavigationView.navigationBackButton.rx.tapGesture().asObservable()
            .when(.recognized)
            .withUnretained(self)
            .subscribe(onNext: { vc, _ in
                vc.viewModel?.coordinator?.back()
            }).disposed(by: disposeBag)
    }
}

