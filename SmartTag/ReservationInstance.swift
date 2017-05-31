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
    case Available
    case Reserved
    case Occupied
    case Blocked
    
    static let allValues = [Available, Reserved, Occupied, Blocked]
    
    var description: String {
        switch self {
        case .Available:
            return "Available"
        case .Reserved:
            return "Reserved"
        case .Occupied:
            return "Occupied"
        case .Blocked:
            return "Blocked"
        }
    }
}

public class ReservationInstance: NSManagedObject {
}

extension ReservationInstance {
    
    @nonobjc public class func fetchRequest() -> NSFetchRequest<ReservationInstance> {
        return NSFetchRequest<ReservationInstance>(entityName: "ReservationInstance")
    }
    
    @NSManaged public var type: ReservationType
    @NSManaged public var x: Int16
    @NSManaged public var y: Int16
    @NSManaged public var date: ReservationDate?
    @NSManaged public var priorityCode: Int16
    @NSManaged public var information: String
    @NSManaged public var request: String
}
