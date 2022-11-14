//
//  UserInfo+CoreDataProperties.swift
//  UserInfo+CoreData+MVP
//
//  Created by Артем Галай on 14.11.22.
//
//

import Foundation
import CoreData


extension UserInfo {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<UserInfo> {
        return NSFetchRequest<UserInfo>(entityName: "UserInfo")
    }

    @NSManaged public var fullName: String?
    @NSManaged public var dateOfBirth: Date?
    @NSManaged public var gender: String?
    @NSManaged public var photo: Data?

}

extension UserInfo : Identifiable {

}
