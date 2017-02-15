//
//  Photo+CoreDataProperties.swift
//  VirtualTourist
//
//  Created by JasonZ on 2017-2-15.
//  Copyright © 2017 saneryee. All rights reserved.
//

import Foundation
import CoreData


extension Photo {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Photo> {
        return NSFetchRequest<Photo>(entityName: "Photo");
    }

    @NSManaged public var downloadingImage: Bool
    @NSManaged public var image: NSData?
    @NSManaged public var path: String?
    @NSManaged public var pin: Pin?

}
