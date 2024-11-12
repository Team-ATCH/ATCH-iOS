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
    var viewModel: ProfileEditViewModel?
    
    private let disposeBag: DisposeBag = DisposeBag()
        
    private let profileEditNavigationView = NavigationView(title: "프로필 수정", backButtonHidden: false)
    private let profileEditView: ProfileEditView = ProfileEditView()
    
    private let previousNickname: String = UserData.shared.nickname
    private let previousHashTag: [HashTag] = UserData.shared.hashTag
    
    private var newNickname: String = ""
    private var newHashTag: [HashTag] = []
    
    init(coordinator: ProfileEditCoordinator) {
        self.coordinator = coordinator
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bindViewModel()
        setupStyle()
        setupLayout()
        setupAction()
    }
    
    private func bindViewModel() {
        viewModel?.nicknameSuccessRelay
            .withUnretained(self)
            .subscribe(onNext: { vc, _ in
                UserData.shared.nickname = vc.newNickname
                vc.viewModel?.updateHashTag(hashTag: vc.newHashTag.map { $0.hashTagTitle })
            }).disposed(by: disposeBag)
        
        viewModel?.hashTagSuccessRelay
            .withUnretained(self)
            .subscribe(onNext: { vc, _ in
                UserData.shared.hashTag = vc.newHashTag
            }).disposed(by: disposeBag)
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
                if let text = vc.profileEditView.nicknameTextFiled.text {
                    vc.newNickname = text
                }
                vc.newHashTag = UserData.shared.hashTagRelay.value
                
                // 닉네임, 해시태그가 각각 달라졌으면 서버에 post
                if vc.previousNickname != vc.newNickname {
                    vc.viewModel?.updateNickname(nickname: vc.newNickname)
                } else {
                    if vc.previousHashTag != vc.newHashTag {
                        vc.viewModel?.updateHashTag(hashTag: vc.newHashTag.map { $0.hashTagTitle })
                    }
                }
                
            }).disposed(by: disposeBag)
    }
}
