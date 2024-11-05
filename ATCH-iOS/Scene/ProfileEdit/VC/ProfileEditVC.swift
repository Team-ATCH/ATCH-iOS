//
//  ProfileEditVC.swift
//  ATCH-iOS
//
//  Created by 변희주 on 10/26/24.
//

import UIKit

import RxSwift
import SnapKit
import Then

final class ProfileEditVC: UIViewController {
    
    private let coordinator: ProfileEditCoordinator?
    private let disposeBag: DisposeBag = DisposeBag()
        
    private let profileEditNavigationView = NavigationView(title: "프로필 수정", backButtonHidden: false)
    private let profileEditView: ProfileEditView = ProfileEditView()
    
    init(coordinator: ProfileEditCoordinator) {
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
        self.view.backgroundColor = .atchGrey1
    }
    
    private func setupLayout() {
        self.view.addSubviews(profileEditNavigationView,
                              profileEditView)
        
        profileEditNavigationView.snp.makeConstraints {
            $0.top.horizontalEdges.equalToSuperview()
            $0.height.equalTo((UIWindow.key?.safeAreaInsets.top ?? 0) + 51)
        }
        
        profileEditView.snp.makeConstraints {
            $0.top.equalTo(profileEditNavigationView.snp.bottom)
            $0.horizontalEdges.bottom.equalToSuperview()
        }
    }
        
    private func setupAction() {
        profileEditNavigationView.navigationBackButton.rx.tapGesture()
            .when(.recognized)
            .withUnretained(self)
            .subscribe(onNext: { (vc, _) in
                vc.coordinator?.back()
            }).disposed(by: disposeBag)
        
        profileEditView.saveButton.rx.tapGesture()
            .when(.recognized)
            .withUnretained(self)
            .subscribe(onNext: { (vc, _) in
                // 수정사항 post
                vc.coordinator?.back()
                UserData.shared.hashTag = UserData.shared.hashTagRelay.value
            }).disposed(by: disposeBag)
    }
}
