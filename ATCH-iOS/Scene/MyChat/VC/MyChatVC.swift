//
//  MyChatVC.swift
//  ATCH-iOS
//
//  Created by 변희주 on 8/18/24.
//

import UIKit

import RxSwift
import SnapKit
import Then

final class MyChatVC: UIViewController {
    
    let coordinator: MyChatCoordinator?
    var viewModel: MyChatViewModel?
    private let disposeBag: DisposeBag = DisposeBag()

    private let myChatNavigationView = NavigationView(title: "내 채팅")
    private let myChatView = MyChatView()
   
    init(coordinator: MyChatCoordinator) {
        self.coordinator = coordinator
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bindViewModel()
        setupDelegate()
        setupLayout()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        viewModel?.getChatList()
    }
    
    private func bindViewModel() {
        viewModel?.chatListRelay
            .observe(on: MainScheduler.instance)
            .withUnretained(self)
            .subscribe(onNext: { vc, _ in
                vc.myChatView.chatCollectionView.reloadData()
            }).disposed(by: disposeBag)
    }
    
    private func setupDelegate() {
        myChatView.chatCollectionView.delegate = self
        myChatView.chatCollectionView.dataSource = self
    }
    
    private func setupLayout() {
        self.view.addSubviews(myChatNavigationView,
                              myChatView)
        
        myChatNavigationView.snp.makeConstraints {
            $0.top.horizontalEdges.equalToSuperview()
            $0.height.equalTo((UIWindow.key?.safeAreaInsets.top ?? 0) + 51)
        }
        
        myChatView.snp.makeConstraints {
            $0.top.equalTo(myChatNavigationView.snp.bottom)
            $0.horizontalEdges.equalToSuperview()
            $0.bottom.equalToSuperview().inset((UIWindow.key?.safeAreaInsets.bottom ?? 0) + 63)
        }
    }
}

extension MyChatVC: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel?.chatList.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MyChatCollectionViewCell.reuseIdentifier, for: indexPath) as? MyChatCollectionViewCell else {return UICollectionViewCell()}
        if let chatList = viewModel?.chatList {
            cell.bindCell(model: chatList[indexPath.item])
            cell.delegate = self
        }
        return cell
    }
}

extension MyChatVC: CellButtonActionDelegate {
    func profileImageTapped(userID: String) {
        if let chatList = viewModel?.chatList,
           let index = chatList.firstIndex(where: { ($0.id == userID) }) {
            coordinator?.presentProfileModal(userData: ProfileModalData.init(userID: Int(chatList[index].id),
                                                                             nickname: chatList[index].nickName,
                                                                             hashTag: chatList[index].tag,
                                                                             profileURL: chatList[index].characterUrl,
                                                                             backgroundURL: nil,
                                                                             buttonType: .otherProfile,
                                                                             senderData: nil,
                                                                             items: nil),
                                             delegate: self)
        }
    }
    
    func chattingButtonTapped(userID: String) {
        if let chatList = viewModel?.chatList,
           let index = chatList.firstIndex(where: { ($0.id == userID) }) {
            let opponent = Sender(senderId: chatList[index].id,
                                  displayName: chatList[index].nickName,
                                  profileImageUrl: chatList[index].characterUrl)
            coordinator?.pushToChattingRoomView(opponent: opponent, roomID: chatList[index].roomID)
        }
    }
}


extension MyChatVC: BlockUserDelegate {
    func blockUser() {
        self.presentedViewController?.dismiss(animated: false)
        myChatView.chatCollectionView.reloadData()
        UIWindow.key?.showToastMessage(message: "해당 유저를 차단했습니다.")
    }
}
