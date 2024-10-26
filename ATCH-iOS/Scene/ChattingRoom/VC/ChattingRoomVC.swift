//
//  ChattingRoomVC.swift
//  ATCH-iOS
//
//  Created by 변희주 on 9/1/24.
//

import UIKit

import InputBarAccessoryView
import MessageKit
import RxSwift
import SnapKit
import Then

final class ChattingRoomVC: BaseChattingRoomVC {
    
    var viewModel: ChattingRoomViewModel?
    let coordinator: ChattingRoomCoordinator?
    
    private let disposeBag: DisposeBag = DisposeBag()

    private let chattingRoomNavigationView = NavigationView(backButtonHidden: false, backButtonTitle: "내 채팅")

    init(coordinator: ChattingRoomCoordinator, opponent: Sender) {
        self.coordinator = coordinator
        self.chattingRoomNavigationView.changeTitle(title: opponent.displayName)
        
        super.init(nibName: nil, bundle: nil)
        
        self.sender = Sender(senderId: opponent.senderId, displayName: opponent.displayName, profileImageUrl: opponent.profileImageUrl)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setupStyle() {
        messagesCollectionView.backgroundColor = .atchGrey1
        messagesCollectionView.contentInset = .init(top: 10, left: 0, bottom: 10, right: 0)

        messageInputBar.backgroundView.backgroundColor = .atchGrey2
        
        messageInputBar.separatorLine.backgroundColor = .atchShadowGrey
        messageInputBar.separatorLine.height = 1

        messageInputBar.sendButton.removeFromSuperview()
        messageInputBar.inputTextView.removeFromSuperview()
                        
        messageInputBar.inputTextView.do {
            $0.backgroundColor = .atchWhite
            $0.layer.cornerRadius = 12
            $0.layer.borderColor = UIColor.atchShadowGrey.cgColor
            $0.layer.borderWidth = 1
            $0.layer.masksToBounds = true
            $0.tintColor = .atchShadowGrey
            $0.placeholder = ""
            $0.textContainerInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        }
    }
    
    override func setupLayout() {
        messagesCollectionView.removeFromSuperview()
        inputContainerView.removeFromSuperview()
        
        self.view.addSubviews(chattingRoomNavigationView,
                              messagesCollectionView,
                              inputContainerView)
        
        chattingRoomNavigationView.snp.makeConstraints {
            $0.top.horizontalEdges.equalToSuperview()
            $0.height.equalTo((UIWindow.key?.safeAreaInsets.top ?? 0) + 51)
        }
        
        messagesCollectionView.snp.makeConstraints {
            $0.top.equalTo(chattingRoomNavigationView.snp.bottom)
            $0.horizontalEdges.equalToSuperview()
            $0.bottom.equalToSuperview().inset((UIWindow.key?.safeAreaInsets.bottom ?? 0) + 62 + 60)
        }
        
        inputContainerView.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview()
            $0.bottom.equalToSuperview().inset((UIWindow.key?.safeAreaInsets.bottom ?? 0) + 62)
            $0.height.equalTo(60)
        }
        
        messageInputBar.addSubviews(messageInputBar.sendButton, messageInputBar.inputTextView)

        messageInputBar.sendButton.snp.makeConstraints {
            $0.trailing.equalToSuperview().inset(9)
            $0.centerY.equalToSuperview()
            $0.width.equalTo(67)
            $0.height.equalTo(39)
        }

        messageInputBar.inputTextView.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(9)
            $0.centerY.equalToSuperview()
            $0.width.equalTo(280)
            $0.height.equalTo(39)
        }
    
        messageInputBar.sendButton.addSubviews(sendImageView,
                                               sendLabel)
        sendImageView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        sendLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(8)
            $0.leading.equalToSuperview().inset(14)
        }
        
        addKeyboardObservers()
    }
    
    override func setupAction() {
        chattingRoomNavigationView.navigationBackButton.rx.tapGesture().asObservable()
            .when(.recognized)
            .withUnretained(self)
            .subscribe(onNext: { vc, _ in
                vc.coordinator?.back()
            }).disposed(by: disposeBag)
    }
    
    override func addDummyMessages() {
        let opponentMessage = ChattingData(sender: sender, content: "안녕하세여 저의 이름은", sendDate: Date())
        messages.append(opponentMessage)
                
        // 리로드 후 마지막 메시지로 스크롤
        messagesCollectionView.reloadData()
        messagesCollectionView.scrollToLastItem()
    }
}
