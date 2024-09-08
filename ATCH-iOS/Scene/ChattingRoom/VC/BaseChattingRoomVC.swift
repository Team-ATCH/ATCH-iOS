//
//  BaseChattingRoomVC.swift
//  ATCH-iOS
//
//  Created by 변희주 on 9/7/24.
//

import Combine
import UIKit

import InputBarAccessoryView
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
    var messages = [ChattingData]()
    
    private let state: State = .init()
    private var keyboardManager: KeyboardManager { state.keyboardManager }
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
        removeOutgoingMessageAvatars()
        setupLayout()
        setupDelegate()
        setupAction()
        setupDismissKeyboardGesture()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        removeKeyboardObservers()
    }
    
    func setupStyle() {
    
    }
    
    func setupMessageInputBar() {
        
    }
    
    private func removeOutgoingMessageAvatars() {
        guard let layout = messagesCollectionView.collectionViewLayout as? MessagesCollectionViewFlowLayout else { return }
        layout.textMessageSizeCalculator.outgoingAvatarSize = .zero
        layout.setMessageOutgoingAvatarSize(.zero)
        let outgoingLabelAlignment = LabelAlignment(textAlignment: .right, textInsets: UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 15))
        layout.setMessageOutgoingMessageTopLabelAlignment(outgoingLabelAlignment)
    }
    
    private func insertNewMessage(_ message: ChattingData) {
        messages.append(message)
        messages.sort()
        
        messagesCollectionView.reloadData()
    }
    
    func setupLayout() {
        
    }
    
    private func setupDelegate() {
        messagesCollectionView.messagesDataSource = self
        messagesCollectionView.messagesLayoutDelegate = self
        messagesCollectionView.messagesDisplayDelegate = self
        
        messageInputBar.delegate = self
    }
    
    func setupAction() {
        
    }
    
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
                self?.updateMessageCollectionViewBottomInset()
                
                if !(self?.maintainPositionOnInputBarHeightChanged ?? false) {
                    self?.messagesCollectionView.scrollToLastItem()
                }
                
                self?.numberOfLines = self?.messageInputBar.inputTextView.numberOfLine() ?? 0
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
                $0.trailing.equalTo(messageInputBar.sendButton.snp.leading).offset(-10)
                $0.centerY.equalToSuperview()
                $0.height.equalTo(39 + 20 * (line - 2))
            }
        }
        
        UIView.animate(withDuration: 0.2) { [weak self] in
            self?.view.layoutIfNeeded()
        }
    }
}

extension BaseChattingRoomVC: MessagesDataSource {
    var currentSender: any MessageKit.SenderType {
        return sender
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
    
    func messageTimestampLabelAttributedText(for message: any MessageType, at indexPath: IndexPath) -> NSAttributedString? {
        let date = message.sentDate.toTimeString()
        return NSAttributedString(string: date, attributes: [.font: UIFont.font(.caption),
                                                             .foregroundColor: UIColor.atchGrey3])
    }
}

extension BaseChattingRoomVC: MessagesLayoutDelegate {
    // 아래 여백
    func footerViewSize(for section: Int, in messagesCollectionView: MessagesCollectionView) -> CGSize {
        return CGSize(width: 0, height: 8)
    }
    
    // 말풍선 위 이름 나오는 곳의 height
    func messageTopLabelHeight(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> CGFloat {
//        return isFromCurrentSender(message: message) ? 20 : 0
        return 20
    }
}


// 상대방이 보낸 메시지, 내가 보낸 메시지를 구분하여 색상과 모양 지정
extension BaseChattingRoomVC: MessagesDisplayDelegate {
    // 말풍선의 배경 색상
    func backgroundColor(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> UIColor {
        return isFromCurrentSender(message: message) ? .atchGreen : .atchWhite
    }
    
    func textColor(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> UIColor {
        return .atchShadowGrey
    }
    
    // 말풍선의 꼬리 모양 방향
    func messageStyle(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> MessageStyle {
        let cornerDirection: MessageStyle.TailCorner = isFromCurrentSender(message: message) ? .bottomRight : .bottomLeft
        
        return .bubbleTail(cornerDirection, .curved)
    }
}

extension BaseChattingRoomVC: InputBarAccessoryViewDelegate {
    func inputBar(_ inputBar: InputBarAccessoryView, didPressSendButtonWith text: String) {
        let message = ChattingData(content: text)
        
        print(message)
        
        insertNewMessage(message)
        inputBar.inputTextView.text.removeAll()
        disposeBag.removeAll()

        messageInputBar.inputTextView.snp.remakeConstraints {
            $0.leading.equalToSuperview().inset(9)
            $0.trailing.equalTo(messageInputBar.sendButton.snp.leading).offset(-10)
            $0.centerY.equalToSuperview()
            $0.height.equalTo(39)
        }
    }
}
