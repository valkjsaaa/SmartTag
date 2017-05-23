//
//  ReservationInstance.swift
//  SmartTag
//
//  Created by Jackie Yang on 5/22/17.
//  Copyright © 2017 Jackie Yang. All rights reserved.
//

import UIKit
import CoreData

@objc public enum ReservationType: Int16 {
    case Reserved
    case Occupied
    case Blocked
}

public class ReservationInstance: NSManagedObject {
}

extension ReservationInstance {
    
    @nonobjc public class func fetchRequest() -> NSFetchRequest<ReservationInstance> {
        return NSFetchRequest<ReservationInstance>(entityName: "ReservationInstance")
    }
    
    @NSManaged public var type: ReservationType
    @NSManaged public var date: ReservationDate?
    
}
