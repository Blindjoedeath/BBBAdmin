//
//  Settings+CoreDataProperties.swift
//  BBBAdmin
//
//  Created by Blind Joe Death on 13.09.2018.
//  Copyright © 2018 Codezavod. All rights reserved.
//
//

import Foundation
import CoreData


extension Settings {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Settings> {
        return NSFetchRequest<Settings>(entityName: "Settings")
    }

    @NSManaged public var bassLevel: Float
    @NSManaged public var boostLevel: Float

}
