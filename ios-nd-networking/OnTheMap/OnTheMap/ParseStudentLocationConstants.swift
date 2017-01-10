//
//  ParseStudentLocationConstants.swift
//  OnTheMap
//
//  Created by JasonZhang on 04/01/2017.
//  Copyright © 2017 Saneryee. All rights reserved.
//

// MARK: - ParseStudentLocationClient (Constants)

extension ParseStudentLocationClient {
    
    // MARK: Constants
    
    struct Constants {
        
        // MARK: URLs
        //Sample URL: https://parse.udacity.com/parse/classes/StudentLocation
        
        static let ApiScheme = "https"
        static let ApiHost = "parse.udacity.com"
        static let ApiPath = "/parse/classes"
        
    }
    
    // MARK: Methods
    struct Methods {
        
        static let StudentLocation = "/StudentLocation"
        
        static let User = "/users"
    }
    
    
    // MARK: ParametersKeys
    
    struct ParametersKeys {
        
        static let Username = "username"
        static let Password = "password"
        
        // MARK: Config
        static let Limit = "limit"
        static let Order = "order"
    }
    
    // MARK: ParametersValues
    struct ParametersValues {
        
        static let Limit = "100"
        static let Order = "-updatedAt"
        
    }
    
    // MARK: JSON Response Keys
    struct JSONResponseKeys {
        
        
        // MARK: Results
        static let Results = "results"
        
        
        // MARK: StudentLocation
        static let CreateAt = "createdAt"
        static let FirstName = "firstName"
        static let LastName = "lastName"
        static let Latitude = "latitude"
        static let Longitude = "longitude"
        static let MapString = "mapString"
        static let MediaURL = "mediaURL"
        static let ObjectId = "objectId"
        static let UniqueKey = "uniqueKey"
        static let UpdateAd = "updatedAt"
    }
    
    // MARK: Request Key
    struct RequestKey {
        
        static let ApplicationId = "X-Parse-Application-Id"
        static let ApiKey = "X-Parse-REST-API-Key"
        
    }
    
    // MARK: Request Value
    struct RequestValue {
        
        static let ApplicationId = "QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr"
        static let ApiKey = "QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY"
    }
    
    // MARK: JSON Body Keys
    struct JSONBodyKeys {
        static let UniqueKey = "uniqueKey"
        static let FirstName = "firstName"
        static let Lastname = "lastName"
        static let MapString = "mapString"
        static let MediaURL = "mediaURL"
        static let Latitude = "latitude"
        static let Longitude = "longitude"
    }
    
    
    
}


