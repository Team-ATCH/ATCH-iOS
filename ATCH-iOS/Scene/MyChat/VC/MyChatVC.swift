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
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let chatList = viewModel?.chatList {
            let opponent = Sender(senderId: chatList[indexPath.row].id, displayName: chatList[indexPath.row].nickName, profileImageUrl: chatList[indexPath.row].characterUrl)
            coordinator?.pushToChattingRoomView(opponent: opponent, roomID: chatList[indexPath.row].roomID)
        }
    }
}

