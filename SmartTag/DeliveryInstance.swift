//
//  DeliveryInstance.swift
//  SmartTag
//
//  Created by Jackie Yang on 5/25/17.
//  Copyright © 2017 Jackie Yang. All rights reserved.
//

import Foundation
import CoreData

@objc(ReservationDelivery)
public class ReservationDelivery: NSManagedObject {
    
}

extension ReservationDelivery {
    
    @nonobjc public class func fetchRequest() -> NSFetchRequest<ReservationDelivery> {
        return NSFetchRequest<ReservationDelivery>(entityName: "ReservationDelivery")
    }
    
    @NSManaged public var type: ReservationType
    @NSManaged public var which: Int16
    @NSManaged public var date: ReservationDate?
    
}
