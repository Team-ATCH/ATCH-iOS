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
    
    let coordinator: MyPageCoordinator?
    private let disposeBag: DisposeBag = DisposeBag()

    private let myPageNavigationView = NavigationView(title: "My")
    private let myPageView = MyPageView()
    
    init(coordinator: MyPageCoordinator) {
        self.coordinator = coordinator
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupLayout()
        setupAction()
    }
    
    private func setupLayout() {
        self.view.addSubviews(myPageNavigationView,
                              myPageView)
        
        myPageNavigationView.snp.makeConstraints {
            $0.top.horizontalEdges.equalToSuperview()
            $0.height.equalTo((UIWindow.key?.safeAreaInsets.top ?? 0) + 51)
        }
        
        myPageView.snp.makeConstraints {
            $0.top.equalTo(myPageNavigationView.snp.bottom)
            $0.horizontalEdges.bottom.equalToSuperview()
        }
    }
    
    private func setupAction() {
        myPageView.profileEditView.nextButton.rx.tap
            .withUnretained(self)
            .subscribe(onNext: { (vc, _) in
                vc.coordinator?.pushToProfileEditView()
            }).disposed(by: disposeBag)
        
        myPageView.withdrawView.rx.tapGesture().asObservable()
            .when(.recognized)
            .withUnretained(self)
            .subscribe(onNext: { vc, _ in
                vc.coordinator?.pushToPopupView(data: PopUpData(type: .withdraw,
                                                                buttonType: .oneButton,
                                                                content: "회원 탈퇴되었습니다.\n안녕히 가세요.",
                                                                leftButtonText: "",
                                                                rightButtonText: "",
                                                                oneButtonText: "처음으로"))
            }).disposed(by: disposeBag)
    }
    
}

