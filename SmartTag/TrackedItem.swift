//
//  TrackedItem.swift
//  SmartTag
//
//  Created by Jackie Yang on 5/30/17.
//  Copyright © 2017 Jackie Yang. All rights reserved.
//

import Foundation
import CoreData

@objc(TrackedItem)
public class TrackedItem: NSManagedObject {
    static let maxLatitude = 1024.0
    static let maxLongtitude = 1024.0
}
