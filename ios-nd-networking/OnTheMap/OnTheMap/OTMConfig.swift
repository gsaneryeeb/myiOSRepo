//
//  OTMConfig.swift
//  OnTheMap
//
//  Created by JasonZhang on 20/12/2016.
//  Copyright © 2016 Saneryee. All rights reserved.
//
//  The Config class persists information that is used to build image
//  URL's for TheMovieDB. The constant values below were taken from
//  the site on 1/23/15. Invoking the updateConfig convenience method
//  will download the latest using the initializer below to
//  parse the dictionary.
//
//  We will talk more about persistance in a later course.
//

import Foundation

// MARK: - File Support

private let _documentsDirectoryURL: URL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first! as URL
private let _fileURL: URL = _documentsDirectoryURL.appendingPathComponent("OnTheMap-Context")

// MARK: - OTMConfig: NSObject, NSCoding

class OTMConfig: NSObject, NSCoding {
    
    // MARK: Properties
    
    // default values from 1/12/15
    var baseImageURLString = "http://image.tmdb.org/t/p/"
    var secureBaseImageURLString =  "https://image.tmdb.org/t/p/"
    var posterSizes = ["w92", "w154", "w185", "w342", "w500", "w780", "original"]
    var profileSizes = ["w45", "w185", "h632", "original"]
    var dateUpdated: Date? = nil
    
    // returns the number days since the config was last updated
    var daysSinceLastUpdate: Int? {
        if let lastUpdate = dateUpdated {
            return Int(Date().timeIntervalSince(lastUpdate)) / 60*60*24
        } else {
            return nil
        }
    }
    
    // MARK: Initialization
    
    override init() {}
    
    convenience init?(dictionary: [String:AnyObject]) {
        
        self.init()
        
        if let imageDictionary = dictionary[OTMClient.JSONResponseKeys.ConfigImages] as? [String:AnyObject],
            let urlString = imageDictionary[OTMClient.JSONResponseKeys.ConfigBaseImageURL] as? String,
            let secureURLString = imageDictionary[OTMClient.JSONResponseKeys.ConfigSecureBaseImageURL] as? String,
            let posterSizesArray = imageDictionary[OTMClient.JSONResponseKeys.ConfigPosterSizes] as? [String],
            let profileSizesArray = imageDictionary[OTMClient.JSONResponseKeys.ConfigProfileSizes] as? [String] {
            baseImageURLString = urlString
            secureBaseImageURLString = secureURLString
            posterSizes = posterSizesArray
            profileSizes = profileSizesArray
            dateUpdated = Date()
        } else {
            return nil
        }
    }
    
    // MARK: Update
    
    func updateIfDaysSinceUpdateExceeds(_ days: Int) {
        
        // if the config is up to date then return
        if let daysSinceLastUpdate = daysSinceLastUpdate, daysSinceLastUpdate <= days {
            return
        } else {
            updateConfiguration()
        }
    }
    
    private func updateConfiguration() {
        
        OTMClient.sharedInstance().getConfig() { (didSucceed, error) in
            if let error = error {
                print("Error updating config: \(error.localizedDescription)")
            } else {
                print("Updated Config: \(didSucceed)")
                self.save()
            }
        }
    }
    
    // MARK: NSCoding
    
    let BaseImageURLStringKey = "config.base_image_url_string_key"
    let SecureBaseImageURLStringKey =  "config.secure_base_image_url_key"
    let PosterSizesKey = "config.poster_size_key"
    let ProfileSizesKey = "config.profile_size_key"
    let DateUpdatedKey = "config.date_update_key"
    
    required init(coder aDecoder: NSCoder) {
        baseImageURLString = aDecoder.decodeObject(forKey: BaseImageURLStringKey) as! String
        secureBaseImageURLString = aDecoder.decodeObject(forKey: SecureBaseImageURLStringKey) as! String
        posterSizes = aDecoder.decodeObject(forKey: PosterSizesKey) as! [String]
        profileSizes = aDecoder.decodeObject(forKey: ProfileSizesKey) as! [String]
        dateUpdated = aDecoder.decodeObject(forKey: DateUpdatedKey) as? Date
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(baseImageURLString, forKey: BaseImageURLStringKey)
        aCoder.encode(secureBaseImageURLString, forKey: SecureBaseImageURLStringKey)
        aCoder.encode(posterSizes, forKey: PosterSizesKey)
        aCoder.encode(profileSizes, forKey: ProfileSizesKey)
        aCoder.encode(dateUpdated, forKey: DateUpdatedKey)
    }
    
    private func save() {
        NSKeyedArchiver.archiveRootObject(self, toFile: _fileURL.path)
    }
    
    class func unarchivedInstance() -> OTMConfig? {
        
        if FileManager.default.fileExists(atPath: _fileURL.path) {
            return NSKeyedUnarchiver.unarchiveObject(withFile: _fileURL.path) as? OTMConfig
        } else {
            return nil
        }
    }
}
