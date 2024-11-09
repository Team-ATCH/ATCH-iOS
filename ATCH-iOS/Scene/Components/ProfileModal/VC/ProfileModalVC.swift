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
    var viewModel: ProfileModalViewModel?
    
    private let disposeBag: DisposeBag = DisposeBag()
    
    private var sender: Sender?
    private var buttonType: ProfileModalButtonType = .profileEdit
    private var opponentUserID: Int = 0
    
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
        
        bindViewModel()
        setupAction()
    }
    
    func bindUserInfo(data: ProfileModalData) {
        buttonType = data.buttonType
        sender = data.senderData
        if let userID = data.userID {
            opponentUserID = userID
        }
        
        profileModalView.bindViewData(data: data)
    }
    
    private func bindViewModel() {
        viewModel?.chatRelay
            .observe(on: MainScheduler.instance)
            .withUnretained(self)
            .subscribe(onNext: { vc, data in
                vc.dismiss(animated: false)
                if let sender = vc.sender {
                    self.coordinator?.pushToChattingRoomView(opponent: sender, roomID: data.roomID)
                }
            }).disposed(by: disposeBag)
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
                    vc.viewModel?.postChattingRoom(userID: vc.opponentUserID)
                }
            }).disposed(by: disposeBag)
    }
}
