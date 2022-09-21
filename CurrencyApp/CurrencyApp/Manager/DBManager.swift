//
//  DBManager.swift
//  CurrencyApp
//
//  Created by Phyo Kyaw Swar on 21/09/2022.
//

import Foundation
import RealmSwift
import RxSwift
import RxRelay
import RxRealm

enum  ROname : String {
    case preCartRo
}

class DBManager {
    private var   database:Realm
    static let   sharedInstance = DBManager()
    
    private init() {
        database = try! Realm()
        print("Realm >> ", Realm.Configuration.defaultConfiguration.fileURL!)
    }
}

extension DBManager {
    //MARK: - General CRUD
   
    public func retrieveData<T>(value: T.Type) -> Observable<T> where T: Object {
        guard let data = database.objects(T.self).first else {
            return Observable.empty()
        }
        return Observable.from(object: data)
    }
    
    
    
    public func saveData<T>(data: T, value: T.Type, failure: @escaping (String) -> Void) where T : Object {
        do{
            database.refresh()
            try database.write{
                database.add(data)
            }
            
        }catch let exception {
            print("Failed to save")
            failure(exception.localizedDescription)
        }
    }
    
  
   
    func deleteRealmData(success: @escaping(() -> Void), failure: @escaping(String) -> Void) {
        do{
            try database.write{
                database.deleteAll()
            }
            success()
            
        }catch let exception {
            failure(exception.localizedDescription)
        }
    }
    
    public func retrieveDataByKey<T>(value: T.Type, key: String, filterValue: String) -> Observable<T> where T: Object {
        guard let data = database.objects(T.self).filter("\(key) CONTAINS %@", filterValue).first else{
            return Observable.empty()
        }
        return Observable.from(object: data)
    }
    
    public func retrieveCurrencyByKey<T>(value: T.Type, key: String, filterValue: String) -> Observable<[T]> where T: Object {
        let data = database.objects(T.self).filter("\(key) CONTAINS %@", filterValue)
        return Observable.array(from: data)
    }
    
}
