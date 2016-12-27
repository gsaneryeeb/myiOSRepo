//
//  OTMConvenience.swift
//  OnTheMap
//
//  Created by JasonZhang on 21/12/2016.
//  Copyright © 2016 Saneryee. All rights reserved.
//

import UIKit
import Foundation

// MARK: - OTMClient (Convenient Resource Methods)

extension OTMClient {
    
    
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
    
    func authenticateWithAPI (_ parameters:[String:AnyObject],completionHandlerForAuth: @escaping (_ success: Bool, _ errorString: String?) -> Void) {
        
        // chain completion handlers for each request so that they run one after the other
        getRequestToken() { (success, requestToken, errorString) in
            
            if success {
                
                // success! we have the requestToken!
                print(requestToken)
                self.requestToken = requestToken
                
                self.loginWithToken(requestToken,parameters: parameters) { (success,requestToken,errorString) in
                    
                    if success {
                        self.getSessionID(requestToken) { (success, sessionID, errorString) in
                            
                            if success {
                                
                                // success! we have the sessionID!
                                self.sessionID = sessionID
                                
                                self.getUserID() { (success, userID, errorString) in
                                    
                                    if success {
                                        
                                        if let userID = userID {
                                            
                                            // and the userID 😄!
                                            self.userID = userID
                                        }
                                    }
                                    
                                    completionHandlerForAuth(success, errorString)
                                }
                            } else {
                                completionHandlerForAuth(success, errorString)
                            }
                        }
                    } else {
                        completionHandlerForAuth(success, errorString)
                    }
                }
            } else {
                completionHandlerForAuth(success, errorString)
            }
        }

    }
    
    private func getRequestToken(_ completionHandlerForToken: @escaping (_ success: Bool, _ requestToken: String?, _ errorString: String?) -> Void) {
        
        /* 1. Specify parameters, method (if has {key}), and HTTP body (if POST) */
        let parameters = [String:AnyObject]()
        
        /* 2. Make the request */
        let _ = taskForGETMethod(Methods.AuthenticationTokenNew, parameters: parameters) { (results, error) in
            
            /* 3. Send the desired value(s) to completion handler */
            if let error = error {
                print(error)
                completionHandlerForToken(false, nil, "Login Failed (Request Token).")
            } else {
                if let requestToken = results?[OTMClient.JSONResponseKeys.RequestToken] as? String {
                    completionHandlerForToken(true, requestToken, nil)
                } else {
                    print("Could not find \(OTMClient.JSONResponseKeys.RequestToken) in \(results)")
                    completionHandlerForToken(false, nil, "Login Failed (Request Token).")
                }
            }
        }
    }
    
    // MARK: Login with Username and Password
    private func loginWithToken(_ requestToken: String?, parameters: [String:AnyObject],completionHandlerForLogin: @escaping (_ success: Bool, _ requestToken: String?, _ errorString: String?) -> Void) {
        
        /* 1. Specify parameters, method (if has {key}), and HTTP body (if POST) */
        let parameters = [
            OTMClient.ParameterKeys.RequestToken: requestToken!,
            OTMClient.ParameterKeys.Username: parameters[OTMClient.ParameterKeys.Username],
            OTMClient.ParameterKeys.Password: parameters[OTMClient.ParameterKeys.Password]
        ] as [String : Any]
        
        /* 2. Make the request */
        let _ = taskForGETMethod(Methods.AuthenticationTokenNew, parameters: parameters as [String : AnyObject]) { (results, error) in
            
            /* 3. Send the desired value(s) to completion handler */
            if let error = error {
                print(error)
                completionHandlerForLogin(false, nil, "Login Failed (Request Token).")
            } else {
                if let requestToken = results?[OTMClient.JSONResponseKeys.RequestToken] as? String {
                    completionHandlerForLogin(true, requestToken, nil)
                } else {
                    print("Could not find \(OTMClient.JSONResponseKeys.RequestToken) in \(results)")
                    completionHandlerForLogin(false, nil, "Login Failed (Request Token).")
                }
            }
        }
    }
    
    private func getSessionID(_ requestToken: String?, completionHandlerForSession: @escaping (_ success: Bool, _ sessionID: String?, _ errorString: String?) -> Void) {
        
        /* 1. Specify parameters, method (if has {key}), and HTTP body (if POST) */
        let parameters = [OTMClient.ParameterKeys.RequestToken: requestToken!]
        
        /* 2. Make the request */
        let _ = taskForGETMethod(Methods.AuthenticationSessionNew, parameters: parameters as [String:AnyObject]) { (results, error) in
            
            /* 3. Send the desired value(s) to completion handler */
            if let error = error {
                print(error)
                completionHandlerForSession(false, nil, "Login Failed (Session ID).")
            } else {
                if let sessionID = results?[OTMClient.JSONResponseKeys.SessionID] as? String {
                    completionHandlerForSession(true, sessionID, nil)
                } else {
                    print("Could not find \(OTMClient.JSONResponseKeys.SessionID) in \(results)")
                    completionHandlerForSession(false, nil, "Login Failed (Session ID).")
                }
            }
        }
    }
    
    private func getUserID(_ completionHandlerForUserID: @escaping (_ success: Bool, _ userID: Int?, _ errorString: String?) -> Void) {
        
        /* 1. Specify parameters, method (if has {key}), and HTTP body (if POST) */
        let parameters = [OTMClient.ParameterKeys.SessionID: OTMClient.sharedInstance().sessionID!]
        
        /* 2. Make the request */
        let _ = taskForGETMethod(Methods.Account, parameters: parameters as [String:AnyObject]) { (results, error) in
            
            /* 3. Send the desired value(s) to completion handler */
            if let error = error {
                print(error)
                completionHandlerForUserID(false, nil, "Login Failed (User ID).")
            } else {
                if let userID = results?[OTMClient.JSONResponseKeys.UserID] as? Int {
                    completionHandlerForUserID(true, userID, nil)
                } else {
                    print("Could not find \(OTMClient.JSONResponseKeys.UserID) in \(results)")
                    completionHandlerForUserID(false, nil, "Login Failed (User ID).")
                }
            }
        }
    }

    func getConfig(_ completionHandlerForConfig: @escaping (_ didSucceed: Bool, _ error: NSError?) -> Void) {
        
        /* 1. Specify parameters, method (if has {key}), and HTTP body (if POST) */
        let parameters = [String:AnyObject]()
        
        /* 2. Make the request */
        let _ = taskForGETMethod(Methods.Config, parameters: parameters as [String:AnyObject]) { (results, error) in
            
            /* 3. Send the desired value(s) to completion handler */
            if let error = error {
                completionHandlerForConfig(false, error)
            } else if let newConfig = OTMConfig(dictionary: results as! [String:AnyObject]) {
                self.config = newConfig
                completionHandlerForConfig(true, nil)
            } else {
                completionHandlerForConfig(false, NSError(domain: "getConfig parsing", code: 0, userInfo: [NSLocalizedDescriptionKey: "Could not parse getConfig"]))
            }
        }
    }
    
}
