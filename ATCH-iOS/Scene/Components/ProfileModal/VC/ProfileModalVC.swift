//
//  ProfileModalVC.swift
//  ATCH-iOS
//
//  Created by 변희주 on 10/13/24.
//

import UIKit

import Lottie
import RxSwift
import SnapKit
import Then

final class ProfileModalVC: UIViewController {
    
    let coordinator: ProfileModalCoordinator?
    
    private let disposeBag: DisposeBag = DisposeBag()
    
    private var sender: Sender?
    private var buttonType: ProfileModalButtonType = .profileEdit
    
    private let profileModalView = ProfileModalView()
    
    init(coordinator: ProfileModalCoordinator) {
        self.coordinator = coordinator
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        super.loadView()
        
        self.view = profileModalView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupAction()
    }
    
    func bindUserInfo(data: ProfileModalData) {
        buttonType = data.buttonType
        sender = data.senderData
        profileModalView.bindViewData(data: data)
    }
    
    private func setupAction() {
        profileModalView.closeButton.rx.tap.asObservable()
            .withUnretained(self)
            .subscribe(onNext: { vc, _ in
                vc.dismiss(animated: false)
            }).disposed(by: disposeBag)
        
        profileModalView.bottomButton.rx.tapGesture().asObservable()
            .when(.recognized)
            .withUnretained(self)
            .subscribe(onNext: { vc, _ in
                switch vc.buttonType {
                case .profileEdit:
                    vc.dismiss(animated: false)
                    vc.coordinator?.pushToMyPage()
                case .chatting:
                    vc.dismiss(animated: false)
                    if let sender = vc.sender {
                        vc.coordinator?.pushToChattingRoomView(opponent: sender)
                    }
                }
            }).disposed(by: disposeBag)
    }
}
