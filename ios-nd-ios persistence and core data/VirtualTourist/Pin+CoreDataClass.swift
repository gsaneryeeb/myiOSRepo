//
//  Pin+CoreDataClass.swift
//  VirtualTourist
//
//  Created by JasonZ on 2017-2-15.
//  Copyright © 2017 saneryee. All rights reserved.
//

import Foundation
import CoreData
import MapKit

@objc(Pin)
public class Pin: NSManagedObject {
    
    // MARK: Properties
    
    var coordinate: CLLocationCoordinate2D {
        get {
            return CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        }
    }
    
    var appDelegate: AppDelegate {
        get {
            return UIApplication.shared.delegate as! AppDelegate
        }
    }
    
    // MARK: Initialization
    
    convenience init(coordinate: CLLocationCoordinate2D, context: NSManagedObjectContext) {
        guard let entity = NSEntityDescription.entity(forEntityName: "Pin", in: context) else {
            fatalError("Unable to find Entity name!")
        }
        
        self.init(entity: entity, insertInto: context)
        
        latitude = coordinate.latitude
        longitude = coordinate.longitude
        loadedPhotos = false
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.saveContext(context)
        
        loadNewPhotos(context: context)
    }
    
    public func loadNewPhotos(context: NSManagedObjectContext) {
        // Just load new photos if photo album is empty
        if photos!.count > 0 {
            deleteAllPhotos(context: context)
        }
        loadedPhotos = false
        
        FlickrClient.getImageURLsForLocation(coordinate: coordinate) { urls, error in
            self.appDelegate.persistentContainer.performBackgroundTask() { block in
                func saveBlock() {
                    do {
                        try block.save()
                    } catch {
                        let nsError = error as NSError
                        self.appDelegate.showErrorMessage(title: "Could not save Pin!", message: nsError.localizedDescription)
                    }
                }
                
                guard let urls = urls, error == nil else {
                    self.loadedPhotos = true
                    saveBlock()
                    self.appDelegate.showErrorMessage(title: "Could not fetch Photos for new Pin!", message: error!.localizedDescription)
                    return
                }
                
                block.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
                
                // Copy pin to background context
                let pin = block.object(with: self.objectID) as! Pin
                
                // Initialize photos
                var photos = [Photo]()
                for url in urls {
                    let photo = Photo(pin: pin, url: url, context: block)
                    photos.append(photo)
                }
                
                pin.loadedPhotos = true
                saveBlock()
                
                // load photos
                for photo in photos {
                    photo.loadImage()
                }
            }
        }
    }
    
    public func deleteAllPhotos(context: NSManagedObjectContext) {
        let _ = photos?.allObjects.map() { context.delete($0 as! NSManagedObject) }
        appDelegate.saveContext(context)
    }
    
}
