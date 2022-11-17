//
//  UserInfo+CoreDataClass.swift
//  UserInfo+CoreData+MVP
//
//  Created by Артем Галай on 14.11.22.
//
//

import Foundation
import CoreData

@objc(UserInfo)
public class UserInfo: NSManagedObject {
    convenience init() {
        self.init(entity: CoreDataManager.instance.entityForName(entityName: "UserInfo"), insertInto: CoreDataManager.instance.context)
    }
}
