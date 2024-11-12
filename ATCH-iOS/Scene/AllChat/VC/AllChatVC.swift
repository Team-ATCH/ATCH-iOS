//
//  AllChatVC.swift
//  ATCH-iOS
//
//  Created by 변희주 on 8/18/24.
//

import UIKit

import RxSwift
import SnapKit
import Then

final class AllChatVC: UIViewController {
    
    let coordinator: AllChatCoordinator?
    var viewModel: AllChatViewModel?
    private let disposeBag: DisposeBag = DisposeBag()
    
    private let allChatNavigationView = NavigationView(title: "전체 채팅")
    private let allChatView = AllChatView()

    init(coordinator: AllChatCoordinator) {
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
                vc.allChatView.chatCollectionView.reloadData()
            }).disposed(by: disposeBag)        
    }
    
    private func setupDelegate() {
        allChatView.chatCollectionView.delegate = self
        allChatView.chatCollectionView.dataSource = self
    }
    
    private func setupLayout() {
        self.view.addSubviews(allChatNavigationView, 
                              allChatView)
        
        allChatNavigationView.snp.makeConstraints {
            $0.top.horizontalEdges.equalToSuperview()
            $0.height.equalTo((UIWindow.key?.safeAreaInsets.top ?? 0) + 51)
        }
        
        allChatView.snp.makeConstraints {
            $0.top.equalTo(allChatNavigationView.snp.bottom)
            $0.horizontalEdges.equalToSuperview()
            $0.bottom.equalToSuperview().inset((UIWindow.key?.safeAreaInsets.bottom ?? 0) + 63)
        }
    }
}

extension AllChatVC: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel?.chatList.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: AllChatCollectionViewCell.reuseIdentifier, for: indexPath) as? AllChatCollectionViewCell else {return UICollectionViewCell()}
        if let chatList = viewModel?.chatList {
            cell.bindCell(model: chatList[indexPath.item])
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let chatList = viewModel?.chatList {
            let opponent = Sender(senderId: String(chatList[indexPath.row].firstFromID),
                                  displayName: String(chatList[indexPath.row].firstFromNickname),
                                  profileImageUrl: String(chatList[indexPath.row].firstProfileURL))
            coordinator?.pushToChattingRoomView(opponent: opponent, roomID: chatList[indexPath.row].roomID, allChatMode: true)
        }
    }
}



