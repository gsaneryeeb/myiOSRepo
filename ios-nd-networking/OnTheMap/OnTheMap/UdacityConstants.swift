//
//  OTMConstants.swift
//  OnTheMap
//
//  Created by JasonZhang on 20/12/2016.
//  Copyright © 2016 Saneryee. All rights reserved.
//

// MARK: - Udacitylient (Constants)

extension UdacityClient {
    
    // MARK: Constants
    struct Constants {
        
        // MARK: URLs For Udacity
        //Sample URL: https://www.udacity.com/api/session
        
        static let ApiScheme = "https"
        static let ApiHost = "www.udacity.com"
        static let ApiPath = "/api"
        static let AuthorizationURL = "https://www.udacity.com/api/session"

    }
    
    // MARK: Methods
    struct Methods {
        
        
        // MARK: Session for Udacity
        static let SessionNew = "/session"
        
        // MARK: Users for Udacity
        static let Users = "/users"
        
    }
    
    // MARK: Parameter Keys
    struct ParameterKeys {
        
        static let Username = "username"
        static let Password = "password"
    }
    
    // MARK: JSON Response Keys
    struct JSONResponseKeys {
        
        // MARK: Users for Udacity
        static let Session = "session"
        static let SessionID = "session_id"
        
        // MARK: Account
        static let Account = "id"
        static let AccountKey = "key"
        
        // MARK: User
        static let User = "user"
        static let UserLastName = "last_name"
        static let UserFirstName = "first_name"
        static let UserKey = "key"
        
    }
    
}





