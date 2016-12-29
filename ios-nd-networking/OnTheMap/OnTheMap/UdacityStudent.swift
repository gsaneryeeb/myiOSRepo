//
//  UdacityStudent.swift
//  OnTheMap
//
//  Created by JasonZhang on 30/12/2016.
//  Copyright © 2016 Saneryee. All rights reserved.
//

// MARK: - UdacityStudent

struct UdacityStudent {
    
    let firstName : String
    let lastName : String
    let key : String
    
    // construct a UdacityStudent from a dictionary
    init(dictionary: [String : AnyObject]) {
        
        let user = dictionary[UdacityClient.JSONResponseKeys.User] as! [String : AnyObject]
        
        firstName = user [UdacityClient.JSONResponseKeys.UserFirstName] as! String
        
        lastName = user [UdacityClient.JSONResponseKeys.UserLastName] as! String
        
        key = user [UdacityClient.JSONResponseKeys.UserKey] as! String
        
    }
    
}
