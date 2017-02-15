//
//  Photo+CoreDataClass.swift
//  VirtualTourist
//
//  Created by JasonZ on 2017-2-15.
//  Copyright © 2017 saneryee. All rights reserved.
//

import Foundation
import CoreData
import MapKit

@objc(Photo)
public class Photo: NSManagedObject {

    // MARK: Properties
    
    var isLoading : Bool {
        get {
            return image == nil && downloadingImage
        }
    }
    
    var errorWhileLoading : Bool {
        get {
            return image == nil && !downloadingImage
        }
    }
    
    // MARK: Initialization
    
    convenience init(pin: Pin, url: URL, context: NSManagedObjectContext) {
        guard let entity = NSEntityDescription.entity(forEntityName: "Photo", in: context) else {
            fatalError("Unable to find Entity name!")
        }
        
        self.init(entity: entity, insertInto: context)
        
        self.pin = pin
        path = url.absoluteString
        downloadingImage = true
    }
    
    func loadImage() {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.persistentContainer.performBackgroundTask() { block in
            
            // Copy photo to background context
            let photo = block.object(with: self.objectID) as! Photo
            
            photo.downloadingImage = true
            appDelegate.saveContext(block)
            
            FlickrClient.getImageDataForPath(path: URL(string: photo.path!)!) { imageData, error in
                block.perform {
                    block.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
                    
                    if let imageData = imageData, error == nil {
                        photo.image = imageData as NSData
                    }
                    
                    photo.downloadingImage = false
                    appDelegate.saveContext(block)
                }
            }
        }
    }
    
    
}

