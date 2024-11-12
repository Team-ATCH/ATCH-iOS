//
//  MapVC.swift
//  ATCH-iOS
//
//  Created by 변희주 on 8/18/24.
//

import CoreLocation
import UIKit

import KakaoMapsSDK
import RxGesture
import RxSwift
import SnapKit
import Then

final class MapVC: BaseMapVC {
    
    var viewModel: MapViewModel?
    let coordinator: MapCoordinator?
    
    let isFromOnboarding: Bool?
    
    private let disposeBag: DisposeBag = DisposeBag()
    
    private let locationManager = CLLocationManager()
    private var currentPoi: Poi? = nil
    private var otherPois: [Poi] = []
    private let layerOption = LabelLayerOptions(layerID: "PoiLayer", competitionType: .none, competitionUnit: .poi, orderType: .rank, zOrder: 10001)

    private let alarmImageView = UIImageView().then {
        $0.image = .icAlarmYellow
        $0.contentMode = .scaleAspectFill
    }
    
    private let bottomSheetView = MapBottomSheetView()
    
    private let profileModalView = ProfileModalView()
    
    init(coordinator: MapCoordinator, fromOnboarding: Bool) {
        self.coordinator = coordinator
        self.isFromOnboarding = fromOnboarding
        
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
        setupAction()
        setupLocationManager()
        setBottomSheetDefault()
    }
    
    private func bindViewModel() {
        // bindMapChatList
        viewModel?.mapChatListRelay
            .observe(on: MainScheduler.instance)
            .withUnretained(self)
            .subscribe(onNext: { vc, _ in
                vc.bottomSheetView.chatCollectionView.reloadData()
            }).disposed(by: disposeBag)
        
        viewModel?.locationListRelay
            .observe(on: MainScheduler.instance)
            .withUnretained(self)
            .subscribe(onNext: { vc, _ in
                vc.updateMapView()
            }).disposed(by: disposeBag)
        
        viewModel?.chatRelay
            .observe(on: MainScheduler.instance)
            .withUnretained(self)
            .subscribe(onNext: { vc, data in
                if let index = vc.viewModel?.mapChatList.firstIndex(where: { $0.userID == String(data.toID) }),
                   let mapChatList = vc.viewModel?.mapChatList {
                    let opponent = Sender(senderId: mapChatList[index].userID,
                                          displayName: mapChatList[index].nickName,
                                          profileImageUrl: mapChatList[index].characterUrl)
                    vc.coordinator?.pushToChattingRoomView(opponent: opponent, roomID: data.roomID)
                }
            }).disposed(by: disposeBag)
    }
    
    func updateMapView() {
        guard let mapView = mapController?.getView("mapview") as? KakaoMap else { return }
        let manager = mapView.getLabelManager()
        let _ = manager.addLabelLayer(option: layerOption)
        
        let iconStyle = PoiIconStyle(symbol: .icOnMap.resized(to: CGSize(width: 18, height: 20)), anchorPoint: CGPoint(x: 0.0, y: 0.5))
        let perLevelStyle = PerLevelPoiStyle(iconStyle: iconStyle, level: 0)
        let poiStyle = PoiStyle(styleID: "customStyle2", styles: [perLevelStyle])
        manager.addPoiStyle(poiStyle)
        
        let layer = manager.getLabelLayer(layerID: "PoiLayer")
        let poiOption = PoiOptions(styleID: "customStyle2")
        poiOption.clickable = true
        
        viewModel?.locationList.forEach { [weak self] location in
            guard let self else { return }
            
            let mapPoint = MapPoint(longitude: location.longitude, latitude: location.latitude)
            if let poi = layer?.addPoi(option: poiOption, at: mapPoint) {
                let _ = poi.addPoiTappedEventHandler(target: self, handler: MapVC.poiTappedHandler)
                otherPois.append(poi)
            }
        }
        
        layer?.showAllPois()
    }
    
    override func addViews() {
        let defaultPosition = MapPoint(longitude: 126.92390068909582, latitude: 37.55697173535178)
        let mapviewInfo = MapviewInfo(viewName: "mapview", viewInfoName: "map", defaultPosition: defaultPosition, defaultLevel: 8)
        
        mapController?.addView(mapviewInfo)
    }
    
    override func addViewSucceeded(_ viewName: String, viewInfoName: String) {
        super.addViewSucceeded(viewName, viewInfoName: viewInfoName)
        
        adjustMapViewFrame()
    }
    
    private func adjustMapViewFrame() {
        if let mapView = mapController?.getView("mapview") as? KakaoMap {
            
            let tabBarHeight: CGFloat = 63 + (UIWindow.key?.safeAreaInsets.bottom ?? 0)
            
            // 탭바 위에 맞게 프레임을 설정
            let frame = CGRect(x: 0, y: 0, width: view.bounds.width, height: view.bounds.height - tabBarHeight)
            
            mapView.viewRect = frame
        }
    }

    private func setupDelegate() {
        bottomSheetView.chatCollectionView.delegate = self
        bottomSheetView.chatCollectionView.dataSource = self
    }
    
    private func setupLayout() {
        self.view.addSubviews(alarmImageView,
                              bottomSheetView)
        
        alarmImageView.snp.makeConstraints {
            $0.top.equalToSuperview().inset((UIWindow.key?.safeAreaInsets.top ?? 0))
            $0.trailing.equalToSuperview().inset(16)
            $0.size.equalTo(42)
        }
        
        bottomSheetView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(UIScreen.main.bounds.height)
            $0.horizontalEdges.equalToSuperview()
            $0.height.equalTo(289)
        }
    }
    
    private func setupAction() {
        if isFromOnboarding == true {
            // 내 프로필 모달
            self.coordinator?.presentProfileModal(userData: ProfileModalData.init(userID: nil,
                                                                                  nickname: UserData.shared.nickname,
                                                                                  hashTag: "#" + UserData.shared.hashTagRelay.value.map { $0.hashTagTitle }.joined(separator: " #"),
                                                                                  profileURL: UserData.shared.characterImageUrl,
                                                                                  backgroundURL: nil,
                                                                                  buttonType: .profileEdit,
                                                                                  senderData: nil, 
                                                                                  items: nil))
        }
        
        alarmImageView.rx.tapGesture().asObservable()
            .when(.recognized)
            .withUnretained(self)
            .subscribe(onNext: { vc, _ in
                vc.coordinator?.pushToAlarmView()
            }).disposed(by: disposeBag)
        
        bottomSheetView.rx.panGesture().asObservable()
            .when(.recognized)
            .withUnretained(self)
            .subscribe(onNext: {(vc, gesture) in
                if vc.isCollectionViewScrolling() { return }
                
                let translation = gesture.translation(in: vc.bottomSheetView).y
                if translation > 30 {
                    vc.setBottomSheetDefault()
                } else if translation < -30 {
                    vc.setBottomSheetUp()
                }
             })
            .disposed(by: disposeBag)
    }
    
    private func setupLocationManager() {
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
    
    private func isCollectionViewScrolling() -> Bool {
        // chatCollectionView가 스크롤 중인지 확인
        return bottomSheetView.chatCollectionView.isDragging || bottomSheetView.chatCollectionView.isDecelerating
    }
    
    private func setBottomSheetDefault() {
        UIView.animate(withDuration: 0.3) {
            self.bottomSheetView.transform = CGAffineTransform(translationX: 0, y: -(62 + 105 + (UIWindow.key?.safeAreaInsets.bottom ?? 0)))
        }
    }
    
    private func setBottomSheetUp() {
        UIView.animate(withDuration: 0.3) {
            self.bottomSheetView.transform = CGAffineTransform(translationX: 0, y: -(62 + 289 + (UIWindow.key?.safeAreaInsets.bottom ?? 0)))
        }
    }
}

extension MapVC: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let currentLocation = locations.last else { return }
        let currentLongitude = currentLocation.coordinate.longitude
        let currentLatitude = currentLocation.coordinate.latitude
        
        let mapPoint = MapPoint(longitude: currentLongitude, latitude: currentLatitude)
        guard let mapView = mapController?.getView("mapview") as? KakaoMap else { return }
        let manager = mapView.getLabelManager()
        
        if currentPoi == nil { // POI가 아직 추가되지 않았다면 새로 추가
            let _ = manager.addLabelLayer(option: layerOption)
            
            let iconStyle = PoiIconStyle(symbol: .kakaoMapIcon, anchorPoint: CGPoint(x: 0.0, y: 0.5))
            let perLevelStyle = PerLevelPoiStyle(iconStyle: iconStyle, level: 0)
            let poiStyle = PoiStyle(styleID: "customStyle1", styles: [perLevelStyle])
            manager.addPoiStyle(poiStyle)
            
            let layer = manager.getLabelLayer(layerID: "PoiLayer")
            let poiOption = PoiOptions(styleID: "customStyle1")
            
            // POI 추가 및 서버에 현재 위치 전달
            currentPoi = layer?.addPoi(option: poiOption, at: mapPoint, callback: { [weak self] poi in
                guard let self else { return }
                self.viewModel?.updateMyLoaction(longitude: currentLongitude, latitude: currentLatitude)
                print("Current POI added")
            })
        } else {
            // 이미 추가된 POI가 있다면 위치만 업데이트
            currentPoi?.moveAt(mapPoint, duration: 1)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Failed to find user's location: \(error.localizedDescription)")
        viewModel?.getUserList()
    }
    
    func poiTappedHandler(_ param: PoiInteractionEventParam) {
        let poi = param.poiItem
        if let index = otherPois.firstIndex(where: { $0.itemID == poi.itemID }),
           let mapChatData = viewModel?.mapChatList[index] {
            let opponent = Sender(senderId: mapChatData.userID, displayName: mapChatData.nickName, profileImageUrl: mapChatData.characterUrl)
            
            let profileModalData = ProfileModalData(userID: Int(mapChatData.userID),
                                                    nickname: mapChatData.nickName,
                                                    hashTag: mapChatData.tag,
                                                    profileURL: mapChatData.characterUrl,
                                                    backgroundURL: mapChatData.backgroundUrl,
                                                    buttonType: .chatting,
                                                    senderData: opponent,
                                                    items: mapChatData.items)
            
            self.coordinator?.presentProfileModal(userData: profileModalData)
        }
    }
}

extension MapVC: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel?.mapChatList.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MapChatCollectionViewCell.reuseIdentifier, for: indexPath) as? MapChatCollectionViewCell else {return UICollectionViewCell()}
        if let mapChatList = viewModel?.mapChatList {
            cell.bindCell(model: mapChatList[indexPath.item])
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let mapChatList = viewModel?.mapChatList,
           let userID = Int(mapChatList[indexPath.row].userID) {
            viewModel?.postChattingRoom(userID: userID)
        }
    }
}
