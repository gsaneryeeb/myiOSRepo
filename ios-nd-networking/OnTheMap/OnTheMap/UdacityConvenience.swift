//
//  OTMConvenience.swift
//  OnTheMap
//
//  Created by JasonZhang on 21/12/2016.
//  Copyright © 2016 Saneryee. All rights reserved.
//

import UIKit
import Foundation

// MARK: - UdacityClient (Convenient Resource Methods)

extension UdacityClient {
    
    
    // MARK: Authentication (GET) via the API
    /*
     Steps for Authentication...
     
     Step 1: Create a request token
     Step 2: Ask the user for permission via the API ("login")
     Step 3: Create a session ID
     
     Extra Steps...
     Step 4: Get the user id ;)
     Step 5: Go to the next view!
     */
    
    func authenticateWithAPI (_ username: String?,_ password:String?,completionHandlerForAuth: @escaping (_ success: Bool, _ errorString: String?) -> Void) {
        
        // chain completion handlers for each request so that they run one after the other
        
        
        self.loginWithToken(username,password) { (success,errorString) in
                    
            if success {
                
                //Get Udacity User Info with userKey
                self.getUdacityUser(userKey: self.userKey!){ (success, udacityStudent, errorString ) in
                    
                    if success {
                        
                        self.udacityStudent = udacityStudent
                        
                        completionHandlerForAuth(success,errorString)
                        
                    } else {
                        
                        completionHandlerForAuth(success,errorString)
                        
                    }
                }
                        
            }else{
                completionHandlerForAuth(success, errorString as! String?)
            }
        }
        

    }
    

    // MARK: Login with Username and Password
    private func loginWithToken(_ username: String?, _ password: String?,completionHandlerForLogin: @escaping (_ success: Bool, _ errorString: Error?) -> Void) {
        
        /* 1. Specify parameters, method (if has {key}), and HTTP body (if POST) */
        
        let jsonBody = "{\"udacity\":{\"\(UdacityClient.ParameterKeys.Username)\":\"\(username)\",\"\(UdacityClient.ParameterKeys.Password)\":\"\(password)\"}}"
        
        /* 2. Make the request */
        let _ = taskForPOSTMethod(UdacityClient.Methods.SessionNew,parameters:[String:AnyObject](),jsonBody: jsonBody) { (results, error) in
            
            /* 3. Send the desired value(s) to completion handler */
            
            func displayError(_ error:String){
                print(error)
                let userInfo = [NSLocalizedDescriptionKey : error]
                
                completionHandlerForLogin(false, NSError(domain: "loginWithToken", code: 1, userInfo: userInfo))
            }
            
            if error != nil {
                
                // 403 Error
                if(error!.localizedDescription.contains("403")){
                    displayError("Invalid Email or Password")
                }else{
                    displayError(error!.localizedDescription)
                }
            }
            
            /* GUARD: Was there a results */
            guard let results = results else {
                displayError("Cannot find 'results' in Response")
                return
            }
            
            /* GUARD: Was there a sessionID return */
            guard let session = results[UdacityClient.JSONResponseKeys.Session] as? [String:AnyObject], let sessionID = session[UdacityClient.JSONResponseKeys.SessionID] as! String? else {
                
                displayError("Cannot find key 'sessionID")
                return
            }
            
            self.sessionID = sessionID
            
            /* GUARD: Was there a userKey */
            
            guard let account = results[UdacityClient.JSONResponseKeys.Account] as? [String:AnyObject], let key = account[UdacityClient.JSONResponseKeys.AccountKey] as! String? else{
                
                displayError("Cannot find key 'key' in \(UdacityClient.JSONResponseKeys.Account)")
                return
            }
        
            print("key found \(key)")
            self.userKey = key;
            
            completionHandlerForLogin(true, nil)
        }
    }
    
    // MARK: - Get Udacity User with UserKey
    private func getUdacityUser(userKey : String, completionHandlerForUser: @escaping (_ success: Bool, _ udacityStudent: UdacityStudent?, _ errorString: String?) -> Void){
        
        /* 1. Specify parameters, method (if has {key}), and HTTP body (if POST) */
        
        let method = UdacityClient.Methods.Users.appending("/").appending(userKey)
        
        /* 2. Make the request */
        let _ = taskForGETMethod(method, parameters: [String : AnyObject]()){ (results, error) in
            /* 3. Send the desired value(s) to completion handler */
            
            func displayError(_ error: String){
                
                print(error)
                completionHandlerForUser(false, nil, "Udacity User Not Found")
            }
            
            /* GUARD: Was there a user */
            guard let user = results?[UdacityClient.JSONResponseKeys.User] as? [String:AnyObject], let _ = user[UdacityClient.JSONResponseKeys.UserFirstName] as! String?, let _ = user[UdacityClient.JSONResponseKeys.UserLastName] as! String? else{
                
                displayError("Cannot find mandatory key from 'user'")
                return
            }
            
            let udacityStudent : UdacityStudent = UdacityStudent(dictionary: results as! [String : AnyObject])
            
            
            completionHandlerForUser(true, udacityStudent, nil)

            
        }
        
    }
    
}



