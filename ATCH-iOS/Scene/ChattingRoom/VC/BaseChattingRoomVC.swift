//
//  BaseChattingRoomVC.swift
//  ATCH-iOS
//
//  Created by 변희주 on 9/7/24.
//

import Combine
import UIKit

import InputBarAccessoryView
import Kingfisher
import MessageKit

class State {
    var panGesture: UIPanGestureRecognizer?
    var maintainPositionOnInputBarHeightChanged = false
    var scrollsToLastItemOnKeyboardBeginsEditing = false
    
    let inputContainerView: MessagesInputContainerView = .init()
    @Published var inputBarType: MessageInputBarKind = .messageInputBar
    let keyboardManager = KeyboardManager()
    var disposeBag: Set<AnyCancellable> = .init()
}

class BaseChattingRoomVC: MessagesViewController {
    
    var sender = Sender(senderId: "", displayName: "")
    var inputSender: SenderType = Sender(senderId: "", displayName: "")
        
    var messages = [ChattingData]()
    
    private let state: State = .init()
    private var disposeBag: Set<AnyCancellable> {
        get { state.disposeBag }
        set { state.disposeBag = newValue }
    }
    
    lazy var numberOfLines: Int = 0 {
        didSet {
            updateHeight(line: numberOfLines)
        }
    }
    
    let sendImageView: UIImageView = UIImageView().then {
        $0.image = .imgSendButtonBackground
        $0.contentMode = .scaleAspectFill
        $0.isUserInteractionEnabled = false
    }
    
    let sendLabel: UILabel = UILabel().then {
        $0.text = "보내기"
        $0.textColor = .atchBlack
        $0.font = .font(.smallButton)
    }
    
    private var automaticallyAddedBottomInset: CGFloat {
        messagesCollectionView.adjustedContentInset.bottom - messageCollectionViewBottomInset
    }
    
    private var messageCollectionViewBottomInset: CGFloat {
        messagesCollectionView.contentInset.bottom
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupStyle()
        setupMessageInputBar()
        setOutGoingMessageLayout()
        setIncomingMessageLayout()
        setupLayout()
        setupDelegate()
        setupAction()
        setupDismissKeyboardGesture()
        bindViewModel()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        removeKeyboardObservers()
    }
    
    func setupStyle() {         
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
    
    func setupMessageInputBar() { }
    
    private func setIncomingMessageLayout() {
        guard let layout = messagesCollectionView.collectionViewLayout as? MessagesCollectionViewFlowLayout else { return }
        layout.setMessageIncomingAvatarSize(.init(width: 40, height: 40))
        layout.setMessageIncomingAvatarPosition(.init(horizontal: .cellLeading, vertical: .cellTop))
        layout.setMessageIncomingAccessoryViewPadding(.init(left: 4, right: 0))
        layout.setMessageIncomingAccessoryViewSize(.init(width: 30, height: 30))
        layout.setMessageIncomingAccessoryViewPosition(.cellBottom)
    }
    
    private func setOutGoingMessageLayout() {
        guard let layout = messagesCollectionView.collectionViewLayout as? MessagesCollectionViewFlowLayout else { return }
        layout.textMessageSizeCalculator.outgoingAvatarSize = .zero
        layout.setMessageOutgoingAvatarSize(.zero)
        layout.setMessageOutgoingAccessoryViewPadding(.init(left: 0, right: 4))
        layout.setMessageOutgoingAccessoryViewSize(.init(width: 30, height: 30))
        layout.setMessageOutgoingAccessoryViewPosition(.cellBottom)
    }
    
    func insertNewMessage(_ message: ChattingData) { }
    
    func setupLayout() { }
    
    func setupDelegate() {
        messagesCollectionView.messagesDataSource = self
        messagesCollectionView.messagesLayoutDelegate = self
        messagesCollectionView.messagesDisplayDelegate = self
    }
    
    func setupAction() { }
    
    func addKeyboardObservers() {
        keyboardManager.bind(inputAccessoryView: inputContainerView)
        keyboardManager.bind(to: messagesCollectionView)
        
        /// 키보드가 나타날 때 마지막 메시지로 스크롤
        NotificationCenter.default
            .publisher(for: UITextView.keyboardDidShowNotification)
            .subscribe(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.messagesCollectionView.scrollToLastItem()
            }
            .store(in: &disposeBag)
        
        NotificationCenter.default
            .publisher(for: UITextView.textDidBeginEditingNotification)
            .subscribe(on: DispatchQueue.global())
            .delay(for: .milliseconds(200), scheduler: DispatchQueue.main)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] notification in
                self?.handleTextViewDidBeginEditing(notification)
            }
            .store(in: &disposeBag)
        
        NotificationCenter.default
            .publisher(for: UITextView.textDidChangeNotification)
            .subscribe(on: DispatchQueue.global())
            .receive(on: DispatchQueue.main)
            .compactMap { $0.object as? InputTextView }
            .filter { [weak self] textView in
                textView == self?.messageInputBar.inputTextView
            }
            .map(\.text)
            .removeDuplicates()
            .delay(for: .milliseconds(50), scheduler: DispatchQueue.main)
            .sink { [weak self] _ in
                guard let self = self else { return }

                self.updateMessageCollectionViewBottomInset()
                
                if !(self.maintainPositionOnInputBarHeightChanged) {
                    self.messagesCollectionView.scrollToLastItem()
                }
                
                self.numberOfLines = self.messageInputBar.inputTextView.numberOfLine()
            }
            .store(in: &disposeBag)
        
        inputContainerView.publisher(for: \.center)
            .receive(on: DispatchQueue.main)
            .removeDuplicates()
            .sink(receiveValue: { [weak self] _ in
                self?.updateMessageCollectionViewBottomInset()
            })
            .store(in: &disposeBag)
    }
    
    private func removeKeyboardObservers() {
        disposeBag.removeAll()
    }
    
    // 화면의 빈 공간 터치 시 키보드를 내리기 위한 제스처 설정
    private func setupDismissKeyboardGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tapGesture)
    }
    
    // 키보드 내리기 액션
    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }
    
    func updateMessageCollectionViewBottomInset() {
        let collectionViewHeight = messagesCollectionView.frame.maxY
        let newBottomInset = collectionViewHeight - (inputContainerView.frame.minY - additionalBottomInset) -
        automaticallyAddedBottomInset + 8
        let normalizedNewBottomInset = max(0, newBottomInset)
        let differenceOfBottomInset = newBottomInset - messageCollectionViewBottomInset
        
        UIView.performWithoutAnimation {
            guard differenceOfBottomInset != 0 else { return }
            messagesCollectionView.contentInset.bottom = normalizedNewBottomInset
            messagesCollectionView.verticalScrollIndicatorInsets.bottom = newBottomInset
        }
    }
    
    func handleTextViewDidBeginEditing(_ notification: Notification) {
        guard
            scrollsToLastItemOnKeyboardBeginsEditing,
            let inputTextView = notification.object as? InputTextView,
            inputTextView === messageInputBar.inputTextView
        else {
            return
        }
        messagesCollectionView.scrollToLastItem()
    }
    
    private func updateHeight(line: Int) {
        inputContainerView.snp.remakeConstraints {
            $0.horizontalEdges.equalToSuperview()
            $0.bottom.equalToSuperview().inset((UIWindow.key?.safeAreaInsets.bottom ?? 0) + 62)
            $0.height.equalTo(60 + 20 * (line - 1))
        }
        
        if line > 1 {
            messageInputBar.inputTextView.snp.remakeConstraints {
                $0.leading.equalToSuperview().inset(9)
                $0.centerY.equalToSuperview()
                $0.width.equalTo(280.adjustedW)
                $0.height.equalTo(39 + 20 * (line - 2))
            }
        }
        
        UIView.animate(withDuration: 0.2) { [weak self] in
            self?.view.layoutIfNeeded()
        }
    }
        
    func bindViewModel() { }
}

extension BaseChattingRoomVC: MessagesDataSource {
    var currentSender: SenderType {
        return self.inputSender
    }
    
    func numberOfSections(in messagesCollectionView: MessagesCollectionView) -> Int {
        return messages.count
    }
    
    func messageForItem(at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> MessageType {
        return messages[indexPath.section]
    }
    
    func messageTopLabelAttributedText(for message: MessageType, at indexPath: IndexPath) -> NSAttributedString? {
        let name = message.sender.displayName
        return NSAttributedString(string: name, attributes: [.font: UIFont.font(.body),
                                                             .foregroundColor: UIColor.atchGrey3])
    }    
}

extension BaseChattingRoomVC: MessagesLayoutDelegate {
    // 말풍선 위 이름 나오는 곳의 height
    func messageTopLabelHeight(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> CGFloat {
        return isFromCurrentSender(message: message) ? 0 : 20
    }
}

// 상대방이 보낸 메시지, 내가 보낸 메시지를 구분하여 색상과 모양 지정
extension BaseChattingRoomVC: MessagesDisplayDelegate {
    // 말풍선의 배경 색상
    func backgroundColor(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> UIColor {
        return isFromCurrentSender(message: message) ? .atchWhite : .atchGreen
    }
    
    func textColor(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> UIColor {
        return .atchShadowGrey
    }
    
    // 말풍선 커스텀화
    func messageStyle(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> MessageStyle {
        return .custom { [weak self] containerView in
            guard let self else { return }
            
            let isFromCurrentSender = self.isFromCurrentSender(message: message)
  
            containerView.layer.cornerRadius = 12
            containerView.layer.maskedCorners = isFromCurrentSender ? [.layerMinXMaxYCorner, .layerMinXMinYCorner, .layerMaxXMaxYCorner] : [.layerMinXMaxYCorner, .layerMaxXMinYCorner, .layerMaxXMaxYCorner]
            containerView.layer.borderWidth = 1
            containerView.layer.borderColor = UIColor.atchShadowGrey.cgColor
        }
    }
    
    func configureAvatarView(_ avatarView: AvatarView, for message: any MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) {
        if let chattingSender = message.sender as? Sender {
            if let url = URL(string: chattingSender.profileImageUrl) {
                avatarView.kf.setImage(with: url)
            }
        }
        
        avatarView.backgroundColor = .atchWhite
        avatarView.layer.borderColor = UIColor.atchShadowGrey.cgColor
        avatarView.layer.borderWidth = 1
    }
    
    func configureAccessoryView(_ accessoryView: UIView, for message: any MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) {
        accessoryView.removeAllSubViews()
        
        let timeStampLabel = UILabel().then {
            $0.text = message.sentDate.toTimeString()
            $0.textColor = .atchGrey3
            $0.font = .font(.caption)
        }
        
        accessoryView.addSubview(timeStampLabel)
        timeStampLabel.snp.makeConstraints {
            $0.leading.bottom.equalToSuperview()
        }
    }
}
