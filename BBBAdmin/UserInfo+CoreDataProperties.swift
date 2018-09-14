//
//  UserInfo+CoreDataProperties.swift
//  BBBAdmin
//
//  Created by Blind Joe Death on 13.09.2018.
//  Copyright © 2018 Codezavod. All rights reserved.
//
//

import Foundation
import CoreData


extension UserInfo {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<UserInfo> {
        return NSFetchRequest<UserInfo>(entityName: "UserInfo")
    }

    @NSManaged public var userId: String
    @NSManaged public var firstName: String
    @NSManaged public var lastName: String
    @NSManaged public var nickName: String
    @NSManaged public var videoMessageCount: Int64
    @NSManaged public var videoCount: Int64
    @NSManaged public var audioMessageCount: Int64
    @NSManaged public var audioCount: Int64
    @NSManaged public var settings: Settings

}
