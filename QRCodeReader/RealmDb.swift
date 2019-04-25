//
//  RealmDb.swift
//  QRCodeReader
//
//  Created by Jakub Iwaszek on 25/04/2019.
//  Copyright © 2019 Jakub Iwaszek. All rights reserved.
//

import Foundation
import RealmSwift

class RealmDb {
    static let shared = RealmDb()
    var realm: Realm!
    
    init() {
        var config = Realm.Configuration()
        config.fileURL = config.fileURL?.deletingLastPathComponent().appendingPathComponent("RealmDb")
        Realm.Configuration.defaultConfiguration = config
        Realm.Configuration.defaultConfiguration.deleteRealmIfMigrationNeeded = true
        self.realm = try! Realm()
        
        /*try! realm.write {
         realm.deleteAll()
         }
         
         //uncomment to delete whole database
         
         self.realm = nil*/
        
    }
    
    func addNewScannedCode(newScannedCode: ScannedCode) {
        let allScannedCodes = realm.objects(ScannedCode.self)
        print(allScannedCodes)
        let lastScannedCode = allScannedCodes.last
        
        if lastScannedCode?.metadata == newScannedCode.metadata {
            print("this code was already added")
        } else {
            print("add code")
            try! realm.write {
                realm.add(newScannedCode)
            }
        }
    }
    
    func getScannedCodes() -> Results<ScannedCode> {
        let allScannedCodes = realm.objects(ScannedCode.self).sorted(byKeyPath: "date", ascending: false)
        return allScannedCodes
    }
    
}
