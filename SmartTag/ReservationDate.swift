//
//  ReservationDate.swift
//  SmartTag
//
//  Created by Jackie Yang on 5/22/17.
//  Copyright © 2017 Jackie Yang. All rights reserved.
//

import UIKit
import CoreData

public class ReservationDate: NSManagedObject {
    static var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "MM/dd HH:mm"
        return formatter
    }
    
    var dateString: String? {
        get {
            if let currentDate = date {
                return ReservationDate.dateFormatter.string(from: currentDate)
            } else {
                return nil
            }
        }
    }
    
    static func getAllDatesSorted(context: NSManagedObjectContext) -> [ReservationDate] {
        let fetchRequest: NSFetchRequest<ReservationDate> = ReservationDate.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "date", ascending: true)]
        
        return try! context.fetch(fetchRequest)
    }
}

extension ReservationDate {
    
    @nonobjc public class func fetchRequest() -> NSFetchRequest<ReservationDate> {
        return NSFetchRequest<ReservationDate>(entityName: "ReservationDate")
    }
    
    @NSManaged public var date: Date?
    @NSManaged public var reservedInstances: Set<ReservationInstance>?
    
}

// MARK: Generated accessors for reservedInstances
extension ReservationDate {
    
    @objc(addReservedInstancesObject:)
    @NSManaged public func addToReservedInstances(_ value: ReservationInstance)
    
    @objc(removeReservedInstancesObject:)
    @NSManaged public func removeFromReservedInstances(_ value: ReservationInstance)
    
    @objc(addReservedInstances:)
    @NSManaged public func addToReservedInstances(_ values: Set<ReservationInstance>)
    
    @objc(removeReservedInstances:)
    @NSManaged public func removeFromReservedInstances(_ values: Set<ReservationInstance>)
    
}

