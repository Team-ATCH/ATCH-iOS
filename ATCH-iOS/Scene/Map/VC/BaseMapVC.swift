//
//  BaseMapVC.swift
//  ATCH-iOS
//
//  Created by 변희주 on 8/29/24.
//

import UIKit

import KakaoMapsSDK

class BaseMapVC: UIViewController, MapControllerDelegate {
    
    var mapContainer: KMViewContainer?
    var mapController: KMController?
    var _observerAdded: Bool = false
    var _auth: Bool = false
    var _appear: Bool = false
    
    deinit {
        mapController?.pauseEngine()
        mapController?.resetEngine()
        
        print("deinit")
    }
    
    override func loadView() {
        super.loadView()
        // Initialize the view as KMViewContainer
        self.view = KMViewContainer()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        guard let container = self.view as? KMViewContainer else {
            print("Failed to cast view as KMViewContainer")
            return
        }
        
        mapContainer = container
        
        // KMController 생성.
        mapController = KMController(viewContainer: mapContainer!)
        mapController!.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        _appear = true
        if mapController?.isEnginePrepared == false {
            mapController?.prepareEngine()
        }
        
        if mapController?.isEngineActive == false {
            mapController?.activateEngine()
        }
    }
    
    func authenticationSucceeded() {
        if !_auth {
            _auth = true
        }
        
        if _appear && mapController?.isEngineActive == false {
            mapController?.activateEngine()
        }
    }
    
    func authenticationFailed(_ errorCode: Int, desc: String) {
        print("error code: \(errorCode)")
        print("desc: \(desc)")
        _auth = false
        switch errorCode {
        case 400:
            showToast(self.view, message: "지도 종료(API인증 파라미터 오류)")
        case 401:
            showToast(self.view, message: "지도 종료(API인증 키 오류)")
        case 403:
            showToast(self.view, message: "지도 종료(API인증 권한 오류)")
        case 429:
            showToast(self.view, message: "지도 종료(API 사용쿼터 초과)")
        case 499:
            showToast(self.view, message: "지도 종료(네트워크 오류) 5초 후 재시도..")
            DispatchQueue.main.asyncAfter(deadline: .now() + 5.0) {
                print("retry auth...")
                self.mapController?.prepareEngine()
            }
        default:
            break
        }
    }
    
    func addViews() {
        let defaultPosition: MapPoint = MapPoint(longitude: 127.108678, latitude: 37.402001)
        let mapviewInfo: MapviewInfo = MapviewInfo(viewName: "mapview", viewInfoName: "map", defaultPosition: defaultPosition, defaultLevel: 7)
        
        mapController?.addView(mapviewInfo)
    }
    
    func viewInit(viewName: String) {
        print("OK")
    }
    
    func addViewSucceeded(_ viewName: String, viewInfoName: String) {
        let view = mapController?.getView("mapview") as! KakaoMap
        view.viewRect = mapContainer!.bounds
        viewInit(viewName: viewName)
    }
    
    func addViewFailed(_ viewName: String, viewInfoName: String) {
        print("Failed")
    }
    
    func containerDidResized(_ size: CGSize) {
        let mapView: KakaoMap? = mapController?.getView("mapview") as? KakaoMap
        mapView?.viewRect = CGRect(origin: CGPoint(x: 0.0, y: 0.0), size: size)
    }
        
    func showToast(_ view: UIView, message: String, duration: TimeInterval = 2.0) {
        let toastLabel = UILabel(frame: CGRect(x: view.frame.size.width/2 - 150, y: view.frame.size.height-100, width: 300, height: 35))
        toastLabel.backgroundColor = UIColor.black
        toastLabel.textColor = UIColor.white
        toastLabel.textAlignment = NSTextAlignment.center
        view.addSubview(toastLabel)
        toastLabel.text = message
        toastLabel.alpha = 1.0
        toastLabel.layer.cornerRadius = 10
        toastLabel.clipsToBounds = true
        
        UIView.animate(withDuration: 0.4, delay: duration - 0.4, options: .curveEaseOut, animations: {
            toastLabel.alpha = 0.0
        }, completion: { finished in
            toastLabel.removeFromSuperview()
        })
    }
}
