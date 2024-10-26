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

    private let disposeBag: DisposeBag = DisposeBag()
    
    private let locationManager = CLLocationManager()
    private var currentPoi: Poi? = nil

    private var mapChatList: [MapChatData] = [MapChatData(id: "", characterUrl: "https://i.namu.wiki/i/UfLKudDv6-jzO7_osc0VEqzb7_8HXfLXmIFzUBudsybDoiNHlFRzbFezzFyAkCoY4AIrqcpKTi5CRgcPIHv-ee0SQc-oOJEv1_wno8RjFt6G1aJrhQ9zBMUilCIjHOeTgZGNou2qteBqRPMXynaZ4w.webp", itemCount: 1, itemUrl: "", nickName: "과제의요정", tag: "#맛집 #카페 #홍대생 #빈티지 #아티스트"),
                                              MapChatData(id: "", characterUrl: "https://i.namu.wiki/i/UfLKudDv6-jzO7_osc0VEqzb7_8HXfLXmIFzUBudsybDoiNHlFRzbFezzFyAkCoY4AIrqcpKTi5CRgcPIHv-ee0SQc-oOJEv1_wno8RjFt6G1aJrhQ9zBMUilCIjHOeTgZGNou2qteBqRPMXynaZ4w.webp", itemCount: 1, itemUrl: "", nickName: "말리부", tag: "#맛집 #카페 #버스킹 #공연 #클럽 #힙스터"),
                                              MapChatData(id: "", characterUrl: "https://i.namu.wiki/i/UfLKudDv6-jzO7_osc0VEqzb7_8HXfLXmIFzUBudsybDoiNHlFRzbFezzFyAkCoY4AIrqcpKTi5CRgcPIHv-ee0SQc-oOJEv1_wno8RjFt6G1aJrhQ9zBMUilCIjHOeTgZGNou2qteBqRPMXynaZ4w.webp", itemCount: 1, itemUrl: "", nickName: "탕탕 후루후루", tag: "#맛집 #사장님 #버스킹 #주민"),
                                              MapChatData(id: "", characterUrl: "https://i.namu.wiki/i/UfLKudDv6-jzO7_osc0VEqzb7_8HXfLXmIFzUBudsybDoiNHlFRzbFezzFyAkCoY4AIrqcpKTi5CRgcPIHv-ee0SQc-oOJEv1_wno8RjFt6G1aJrhQ9zBMUilCIjHOeTgZGNou2qteBqRPMXynaZ4w.webp", itemCount: 1, itemUrl: "", nickName: "동그라미동동동쓰", tag: "#패션 #버스킹 #인플루언서 #힙스터")]
    
    private let alarmImageView = UIImageView().then {
        $0.image = .icAlarmYellow
        $0.contentMode = .scaleAspectFill
    }
    
    private let bottomSheetView = MapBottomSheetView()
    
    init(coordinator: MapCoordinator) {
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
        setupAction()
        setupLocationManager()
        setBottomSheetDefault()
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
                if vc.isCollectionViewScrolling() {
                    return
                }
                
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
        
        let mapPoint = MapPoint(longitude: currentLocation.coordinate.longitude, latitude: currentLocation.coordinate.latitude)
        guard let mapView = mapController?.getView("mapview") as? KakaoMap else { return }
        
        let manager = mapView.getLabelManager()
        if currentPoi == nil {
            // POI가 아직 추가되지 않았다면 새로 추가
            let layerOption = LabelLayerOptions(layerID: "PoiLayer", competitionType: .none, competitionUnit: .poi, orderType: .rank, zOrder: 10001)
            let _ = manager.addLabelLayer(option: layerOption)
            
            let iconStyle = PoiIconStyle(symbol: .kakaoMapIcon, anchorPoint: CGPoint(x: 0.0, y: 0.5))
            let perLevelStyle = PerLevelPoiStyle(iconStyle: iconStyle, level: 0)
            let poiStyle = PoiStyle(styleID: "customStyle1", styles: [perLevelStyle])
            manager.addPoiStyle(poiStyle)
            
            let layer = manager.getLabelLayer(layerID: "PoiLayer")
            let poiOption = PoiOptions(styleID: "customStyle1")
            poiOption.rank = 0
            poiOption.clickable = true
            
            // POI 추가 및 저장
            currentPoi = layer?.addPoi(option: poiOption, at: mapPoint, callback: { poi in
                print("POI added")
            })
            
            let _ = currentPoi?.addPoiTappedEventHandler(target: self, handler: MapVC.poiTappedHandler)
            currentPoi?.show()
        } else {
            // 이미 추가된 POI가 있다면 위치만 업데이트
            currentPoi?.moveAt(mapPoint, duration: 1)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Failed to find user's location: \(error.localizedDescription)")
    }
    
    func poiTappedHandler(_ param: PoiInteractionEventParam) {
        param.poiItem.hide()
    }
}

extension MapVC: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return mapChatList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MapChatCollectionViewCell.reuseIdentifier, for: indexPath) as? MapChatCollectionViewCell else {return UICollectionViewCell()}
        cell.bindCell(model: mapChatList[indexPath.item])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let opponent = Sender(senderId: mapChatList[indexPath.row].id, displayName: mapChatList[indexPath.row].nickName, profileImageUrl: mapChatList[indexPath.row].characterUrl)
        coordinator?.pushToChattingRoomView(opponent: opponent)
    }
}
