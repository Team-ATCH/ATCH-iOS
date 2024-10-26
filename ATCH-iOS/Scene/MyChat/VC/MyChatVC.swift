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
    
    private let myChatNavigationView = NavigationView(title: "내 채팅")
    private let myChatView = MyChatView()
    private var chatList: [MyChatData] = [MyChatData(characterUrl: "https://i.namu.wiki/i/UfLKudDv6-jzO7_osc0VEqzb7_8HXfLXmIFzUBudsybDoiNHlFRzbFezzFyAkCoY4AIrqcpKTi5CRgcPIHv-ee0SQc-oOJEv1_wno8RjFt6G1aJrhQ9zBMUilCIjHOeTgZGNou2qteBqRPMXynaZ4w.webp", id: "", nickName: "탕탕 후루후루", content: "마침 하나 남았는데 오실거면...", tag: "#맛집 #사장 #버스킹 #주민"),
                                          MyChatData(characterUrl: "https://i.namu.wiki/i/UfLKudDv6-jzO7_osc0VEqzb7_8HXfLXmIFzUBudsybDoiNHlFRzbFezzFyAkCoY4AIrqcpKTi5CRgcPIHv-ee0SQc-oOJEv1_wno8RjFt6G1aJrhQ9zBMUilCIjHOeTgZGNou2qteBqRPMXynaZ4w.webp", id: "", nickName: "맛집헌터", content: "카미야 너무 유명해졌어요", tag: "#맛집 #홍대생"),
                                          MyChatData(characterUrl: "https://i.namu.wiki/i/UfLKudDv6-jzO7_osc0VEqzb7_8HXfLXmIFzUBudsybDoiNHlFRzbFezzFyAkCoY4AIrqcpKTi5CRgcPIHv-ee0SQc-oOJEv1_wno8RjFt6G1aJrhQ9zBMUilCIjHOeTgZGNou2qteBqRPMXynaZ4w.webp", id: "", nickName: "호롤롤로", content: "근데 좀 심심해요ㅋ", tag: "#홍대생 #클럽"),
                                          MyChatData(characterUrl: "https://i.namu.wiki/i/UfLKudDv6-jzO7_osc0VEqzb7_8HXfLXmIFzUBudsybDoiNHlFRzbFezzFyAkCoY4AIrqcpKTi5CRgcPIHv-ee0SQc-oOJEv1_wno8RjFt6G1aJrhQ9zBMUilCIjHOeTgZGNou2qteBqRPMXynaZ4w.webp", id: "", nickName: "안돼요교수님", content: "제발요ㅠㅠ", tag: "#카페 #덕질 #홍대생 #버스킹"),
                                          MyChatData(characterUrl: "https://i.namu.wiki/i/UfLKudDv6-jzO7_osc0VEqzb7_8HXfLXmIFzUBudsybDoiNHlFRzbFezzFyAkCoY4AIrqcpKTi5CRgcPIHv-ee0SQc-oOJEv1_wno8RjFt6G1aJrhQ9zBMUilCIjHOeTgZGNou2qteBqRPMXynaZ4w.webp", id: "", nickName: "홍대피플", content: "에이ㅋㅋ", tag: "#오타쿠 #공연 #빈티지 #패션"),
                                          MyChatData(characterUrl: "https://i.namu.wiki/i/UfLKudDv6-jzO7_osc0VEqzb7_8HXfLXmIFzUBudsybDoiNHlFRzbFezzFyAkCoY4AIrqcpKTi5CRgcPIHv-ee0SQc-oOJEv1_wno8RjFt6G1aJrhQ9zBMUilCIjHOeTgZGNou2qteBqRPMXynaZ4w.webp", id: "", nickName: "닉네임은 최대 10글자", content: "최근 메시지 최대 20자까지 넣기...", tag: "#패션 #맛집 #홍대생 #오타쿠 #인디씬"),
                                          MyChatData(characterUrl: "https://i.namu.wiki/i/UfLKudDv6-jzO7_osc0VEqzb7_8HXfLXmIFzUBudsybDoiNHlFRzbFezzFyAkCoY4AIrqcpKTi5CRgcPIHv-ee0SQc-oOJEv1_wno8RjFt6G1aJrhQ9zBMUilCIjHOeTgZGNou2qteBqRPMXynaZ4w.webp", id: "", nickName: "닉네임은 최대 10글자", content: "최근 메시지 최대 20자까지 넣기...", tag: "#패션 #맛집 #홍대생 #오타쿠 #인디씬"),
                                          MyChatData(characterUrl: "https://i.namu.wiki/i/UfLKudDv6-jzO7_osc0VEqzb7_8HXfLXmIFzUBudsybDoiNHlFRzbFezzFyAkCoY4AIrqcpKTi5CRgcPIHv-ee0SQc-oOJEv1_wno8RjFt6G1aJrhQ9zBMUilCIjHOeTgZGNou2qteBqRPMXynaZ4w.webp", id: "", nickName: "닉네임은 최대 10글자", content: "최근 메시지 최대 20자까지 넣기...", tag: "#패션 #맛집 #덕질 #인디씬 #홍대생 #주민")]
    
    init(coordinator: MyChatCoordinator) {
        self.coordinator = coordinator
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupDelegate()
        setupLayout()
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
        return chatList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MyChatCollectionViewCell.reuseIdentifier, for: indexPath) as? MyChatCollectionViewCell else {return UICollectionViewCell()}
        cell.bindCell(model: chatList[indexPath.item])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let opponent = Sender(senderId: chatList[indexPath.row].id, displayName: chatList[indexPath.row].nickName, profileImageUrl: chatList[indexPath.row].characterUrl)
        coordinator?.pushToChattingRoomView(opponent: opponent)
    }
}

