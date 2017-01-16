//
//  StudentLocations.swift
//  OnTheMap
//
//  Created by JasonZhang on 12/01/2017.
//  Copyright © 2017 Saneryee. All rights reserved.
//

import Foundation

class StudentLocations {
    
    //MARK: Shared Instance
    
    static let sharedInstance : StudentLocations = {
        let instance = StudentLocations(array: [])
        return instance
    }()
    
    //MARK: Local Variable
    
    var listOfStudents : [ParseStudentLocation]
    
    //MARK: Init
    
    init( array : [ParseStudentLocation]) {
        listOfStudents = array
    }
    
}
