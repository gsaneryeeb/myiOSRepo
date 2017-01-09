//
//  ParseStudentLocationConvenience.swift
//  OnTheMap
//
//  Created by JasonZhang on 04/01/2017.
//  Copyright © 2017 Saneryee. All rights reserved.
//


import UIKit
import Foundation

// (Convenient Resource Methods)

extension ParseStudentLocationClient {
    
    // MARK: Get Student Location
    
    func getStudentLocations(completionHandlerForStudent: @escaping (_ success : Bool, _ studentLocations : [ParseStudentLocation]?, _ errorString:  String? ) -> Void){
        
        
        getParseStudentLocationsFromUdacity(){
            success, studentLocations, error in
            
            
            if success {
                
                completionHandlerForStudent(true, studentLocations, nil)
                
            }else{
                
                completionHandlerForStudent(false, nil, "Student Locations Not Found")
            }
            
        }
        
    }
    
    // MARK: Save Parse Student Location
    
    func saveParseStudentLocation( parseStudentLocation : ParseStudentLocation, completionHandlerForStudentLocation: @escaping (_ succes : Bool, _ errorString: String?) -> Void ) {
        
        
        saveParseStudentLocationService(parseStudentLocation: parseStudentLocation){
            success,  error in
            
            
            if success {
                
                completionHandlerForStudentLocation(true, nil)
                
            }else{
                
                completionHandlerForStudentLocation(false,  "Error while saving Student Location")
            }
        }
        
        
    }
    
    
    
    
}
