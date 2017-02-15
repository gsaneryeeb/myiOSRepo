//
//  AppDelegate.swift
//  VirtualTourist
//
//  Created by JasonZ on 2017-2-9.
//  Copyright © 2017 saneryee. All rights reserved.
//

import UIKit
import CoreData

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        
    }

    // MARK: Core Data
    
    // MARK: Core Data Stack
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "VirtualTourist")
        container.loadPersistentStores(completionHandler: {(storeDescripton,error) in
            if let error = error as NSError? {
                self.showErrorMessage(title: "Could not load persistent Store", message: error.localizedDescription)
            }
        })
        
        container.viewContext.automaticallyMergesChangesFromParent = true
        container.viewContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        
        return container
    }()
    
    // MARK: Core Data Saving support
    func saveContext(_ context: NSManagedObjectContext? = nil){
        var contextToSave = persistentContainer.viewContext
        
        if let context = context {
            contextToSave = context
        }
        
        if contextToSave.hasChanges {
            do {
                try contextToSave.save()
            } catch {
                let nserror = error as NSError
                self.showErrorMessage(title: "Could not save data", message: nserror.localizedDescription)
            }
        }
        
        
    }
    
    // MARK: Show error message
        
    private var currentlyShowingError: Bool = false
    func showErrorMessage(title: String, message: String? = nil) {
        // Don't flood the user with error messages
        if currentlyShowingError {
            return
        }
            
        currentlyShowingError = true
        DispatchQueue.main.async {
            let alertController: UIAlertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler: {action in
                self.currentlyShowingError = false
            }))
            self.window?.rootViewController?.present(alertController, animated: true, completion: nil)
        }
    }

    
}

