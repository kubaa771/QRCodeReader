//
//  ScannedCode.swift
//  QRCodeReader
//
//  Created by Jakub Iwaszek on 25/04/2019.
//  Copyright © 2019 Jakub Iwaszek. All rights reserved.
//

import Foundation
import RealmSwift

class ScannedCode: Object {
    @objc dynamic var metadata: String = ""
    @objc dynamic var date: Date = Date()
    @objc dynamic var uuid = UUID().uuidString
    
    convenience init(metadata: String, date: Date) {
        self.init()
        self.metadata = metadata
        self.date = date
    }
    
    override static func primaryKey() -> String? {
        return "uuid"
    }
}
