//
//  MapVC.swift
//  ATCH-iOS
//
//  Created by 변희주 on 8/18/24.
//

import CoreLocation
import UIKit

import KakaoMapsSDK
import SnapKit
import Then

final class MapVC: BaseMapVC {
    
    private var isFirst: Bool = false
    private let locationManager = CLLocationManager()
    
    private let alarmImageView = UIImageView().then {
        $0.image = .icAlarmYellow
        $0.contentMode = .scaleAspectFill
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupLayout()
        setupLocationManager()
    }
    
    override func addViews() {
        // 기본 위치 및 레벨 설정
        let defaultPosition = MapPoint(longitude: 126.92390068909582, latitude: 37.55697173535178)
        let mapviewInfo = MapviewInfo(viewName: "mapview", viewInfoName: "map", defaultPosition: defaultPosition, defaultLevel: 8)
        
        // 지도 추가
        mapController?.addView(mapviewInfo)
    }
    
    override func addViewSucceeded(_ viewName: String, viewInfoName: String) {
        super.addViewSucceeded(viewName, viewInfoName: viewInfoName)
        
        // 지도 뷰를 탭바 위에 맞게 조정
        adjustMapViewFrame()
    }
    
    private func adjustMapViewFrame() {
        if let mapView = mapController?.getView("mapview") as? KakaoMap {
            
            let tabBarHeight: CGFloat = 63 + (UIWindow.key?.safeAreaInsets.bottom ?? 0)
            
            // 탭바 위에 맞게 프레임을 설정합니다.
            let frame = CGRect(
                x: 0,
                y: 0,
                width: view.bounds.width,
                height: view.bounds.height - tabBarHeight
            )
            
            mapView.viewRect = frame
        }
    }
    
    private func setupLayout() {
        self.view.addSubview(alarmImageView)
        alarmImageView.snp.makeConstraints {
            $0.top.equalToSuperview().inset((UIWindow.key?.safeAreaInsets.top ?? 0))
            $0.trailing.equalToSuperview().inset(16)
            $0.size.equalTo(42)
        }
    }
    
    private func setupLocationManager() {
        isFirst = true
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
}

extension MapVC: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let currentLocation = locations.last else { return }

//        // 내 위치로 옮기기
//        if isFirst {
//            let mapPoint = MapPoint(longitude: currentLocation.coordinate.longitude, latitude: currentLocation.coordinate.latitude)
//            guard let mapView = mapController?.getView("mapview") as? KakaoMap else { return }
//            let cameraUpdate = CameraUpdate.make(target: mapPoint, mapView: mapView)
//            mapView.moveCamera(cameraUpdate)
//            isFirst = false
//        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Failed to find user's location: \(error.localizedDescription)")
    }
}
