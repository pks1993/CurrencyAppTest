//
//  APIClient.swift
//  CurrencyApp
//
//  Created by Phyo Kyaw Swar on 20/09/2022.
//

import Foundation
import Alamofire
import RxRelay
import RxSwift
import RxCocoa
import SwiftyJSON
import SystemConfiguration
import Reachability

enum ErrorType: Error {
    case NoInterntError
    case NoDataError
    case KnownError(_ errorMessage: String)
    case UnKnownError
    case TokenExpireError(_ errorMessage : String)
}

class ApiClient {
    //MARK:- NETWORK CALLS
    static let shared = ApiClient()
    
    private let APIManager: Session = {
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = 30
        configuration.urlCache = nil
        configuration.requestCachePolicy = .reloadIgnoringCacheData
        let delegate = Session.default.delegate
        let manager = Session.init(configuration: configuration,
                                   delegate: delegate)
        return manager
    }()
    
    public func request(url : String,
                        method : HTTPMethod = .get,
                        parameters : Parameters = [:],
                        headers : HTTPHeaders = [:] ,
                        isOpenAPI : Bool = false) -> Observable<Any>{
        
        if !ApiClient.checkReachable() {
            return Observable.create { observer in
                observer.onError(ErrorType.NoInterntError)
                return Disposables.create()
            }
        }
        
        let encoding : ParameterEncoding = (method == .get ? URLEncoding.default : JSONEncoding.default)
        
        return Observable.create { observer in
            self.APIManager.request(url).responseData { response in
                switch response.result {
                case .success:
                    if let data = response.data, let responseJSON = data.decode(modelType: CurrencyResponseVO.self){
                        observer.onNext(data)
                        observer.onCompleted()
                    }
                case .failure:
                    let error = ErrorType.UnKnownError
                    observer.onError(error)
                }
            }
            return Disposables.create()
        }
    }
    
    
}

//MARK:- CHECK NETWORK
extension ApiClient {
    
    static func isOnline(callback: @escaping (Bool) -> Void){
        //declare this property where it won't go out of scope relative to your listener
        
        let reachability = try! Reachability()
        
        reachability.whenReachable = { reachability in
            if reachability.connection == .wifi {
                print("Reachable via WiFi")
                callback(true)
            } else {
                print("Reachable via Cellular")
                callback(true)
            }
        }
        
        reachability.whenUnreachable = { _ in
            print("Not reachable")
            callback(false)
        }
        
        do {
            try reachability.startNotifier()
        } catch {
            print("Unable to start notifier")
            callback(false)
        }
    }
    
    static func checkReachable() -> Bool{
        let reachability = SCNetworkReachabilityCreateWithName(nil, "www.raywenderlich.com")
        
        var flags = SCNetworkReachabilityFlags()
        SCNetworkReachabilityGetFlags(reachability!, &flags)
        
        if (isNetworkReachable(with: flags))
        {
            if flags.contains(.isWWAN) {
                return true
            }
            
            return true
        }
        else if (!isNetworkReachable(with: flags)) {
            return false
        }
        
        return false
    }
    
    static func checkReachable(success : @escaping () -> Void,
                               failure : @escaping () -> Void){
        
        if checkReachable() {
            success()
        }else{
            failure()
        }
        
    }
    
    static func isNetworkReachable(with flags: SCNetworkReachabilityFlags) -> Bool {
        let isReachable = flags.contains(.reachable)
        let needsConnection = flags.contains(.connectionRequired)
        let canConnectAutomatically = flags.contains(.connectionOnDemand) || flags.contains(.connectionOnTraffic)
        let canConnectWithoutUserInteraction = canConnectAutomatically && !flags.contains(.interventionRequired)
        return isReachable && (!needsConnection || canConnectWithoutUserInteraction)
    }
    
}
