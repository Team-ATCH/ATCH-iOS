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

    private let allChatMode: Bool?
    
    private let chattingRoomNavigationView = NavigationView(backButtonHidden: false, backButtonTitle: "내 채팅")

    init(coordinator: ChattingRoomCoordinator, opponent: Sender, allChatMode: Bool = false) {
        self.coordinator = coordinator
        self.chattingRoomNavigationView.changeTitle(title: opponent.displayName)
        self.allChatMode = allChatMode
        
        super.init(nibName: nil, bundle: nil)
        
        self.sender = Sender(senderId: opponent.senderId, 
                             displayName: opponent.displayName,
                             profileImageUrl: opponent.profileImageUrl)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
        
    override func bindViewModel() {
        // 여기서 senderID에 myID 넣어야함
        inputSender = Sender(senderId: "17", displayName: "heejoo")

        viewModel?.previousMessagesRelay
            .observe(on: MainScheduler.instance)
            .withUnretained(self)
            .subscribe(onNext: { vc, messages in
                vc.messages = messages
                vc.messages.sort()
                vc.messagesCollectionView.reloadData()
                vc.messagesCollectionView.scrollToLastItem()
            }).disposed(by: disposeBag)
        
        if allChatMode == true {
            viewModel?.getAllChattingMessages()
        } else {
            viewModel?.getPreviousChattingMessages()
        }

        viewModel?.messageRelay
            .observe(on: MainScheduler.instance)
            .withUnretained(self)
            .subscribe(onNext: { vc, message in
                vc.messages.append(message)
                vc.messages.sort()
                vc.messagesCollectionView.reloadData()
                vc.messagesCollectionView.scrollToLastItem()
            }).disposed(by: disposeBag)
    }
    
    override func setupStyle() {
        super.setupStyle()
        
        overrideUserInterfaceStyle = .light
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
        
        if allChatMode == true {
            messagesCollectionView.snp.makeConstraints {
                $0.top.equalTo(chattingRoomNavigationView.snp.bottom)
                $0.horizontalEdges.equalToSuperview()
                $0.bottom.equalToSuperview().inset((UIWindow.key?.safeAreaInsets.bottom ?? 0) + 62)
            }
        } else {
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
                $0.width.equalTo(280.adjustedW)
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
    }
    
    override func setupDelegate() {
        super.setupDelegate()
        
        messageInputBar.delegate = self
    }
    
    override func insertNewMessage(_ message: ChattingData) {
        viewModel?.sendMessage(message: message)
        messages.append(message)
        messages.sort()
        
        messagesCollectionView.reloadData()
    }
    
    override func setupAction() {
        chattingRoomNavigationView.navigationBackButton.rx.tapGesture().asObservable()
            .when(.recognized)
            .withUnretained(self)
            .subscribe(onNext: { vc, _ in
                vc.viewModel?.disconnect()
                vc.coordinator?.back()
            }).disposed(by: disposeBag)
    }
}

extension ChattingRoomVC: InputBarAccessoryViewDelegate {
    func inputBar(_ inputBar: InputBarAccessoryView, didPressSendButtonWith text: String) {
        let message = ChattingData(sender: Sender(senderId: inputSender.senderId,
                                                  displayName: inputSender.displayName),
                                   content: text,
                                   sendDate: Date())
                
        insertNewMessage(message)
        inputBar.inputTextView.text.removeAll()

        messageInputBar.inputTextView.snp.remakeConstraints {
            $0.leading.equalToSuperview().inset(9)
            $0.centerY.equalToSuperview()
            $0.width.equalTo(280.adjustedW)
            $0.height.equalTo(39)
        }
    }
}
