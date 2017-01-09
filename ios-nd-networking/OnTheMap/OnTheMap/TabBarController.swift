//
//  TabBarController.swift
//  OnTheMap
//
//  Created by JasonZhang on 29/12/2016.
//  Copyright © 2016 Saneryee. All rights reserved.
//

import UIKit

// MARK: - TabBarController:UITabBarController

class TabBarController: UITabBarController{
    
    // MARK: Properties
    
    // MARK: Outlets
    
    // MARK: Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("TabBarController----viewDidLoad")
        
        // Add Buttons on top
        // The first way would be to embed a navigation view controller and present the NavController instead
        // of the TabController. The NavController will automatically present the TabController.
        // NavController> TabController >
        // https://discussions.udacity.com/t/help-with-getting-navbar-items-on-tabbarcontroller-i-e-logout-dropapin-referesh-icons/162709/6
        
        // Pin Button
        let pinButton = UIBarButtonItem(image: UIImage(named: "Pin"), style: UIBarButtonItemStyle.plain, target: self, action: #selector(TabBarController.createNewStudentLocation))
        // Refesh Button
        let refreshButton = UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(TabBarController.refreshMapView))
        // Logout Button
        let logoutButton = UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector (TabBarController.logout))
        
        self.navigationItem.leftBarButtonItem = logoutButton
        navigationItem.rightBarButtonItems = [refreshButton,pinButton]
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        print("-- viewWillAppear --")
        loadStudentLocations()
    }
    
    // MARK: Actions
    
    
    // MARK: Create New Student Location
    
    func createNewStudentLocation(){
        
        let viewContoler = self.storyboard!.instantiateViewController(withIdentifier: "NewStudentLocationViewController") as! NewStudentLocationViewController
        
        self.present(viewContoler, animated: true, completion: nil)
    }
    
    // MARK: refresh MapView
    
    func refreshMapView(){
        print("-- refreshMapView --")
        loadStudentLocations()
    }
    
    // MARK: logout
    
    func logout(){
        print("-- logout --")
        
        UdacityClient.sharedInstance().logout(sessionId: ""){
            success, errorString in
            
            performUIUpdatesOnMain {
                
                
                if success{
                    print("success>")
                    self.showLoginView()
                }else{
                    print("error>")
                    self.showErrorAlert("Error in Logout")
                }
                
                
            }
        }

    }
    
    // MARK: Load Student Location
    
    func loadStudentLocations(){
    
        ParseStudentLocationClient.sharedInstance().getStudentLocations(){
            success, studentLocations,error in
            
            print("----Get Student Location Call Completed----")
            
            performUIUpdatesOnMain {
                
                if success {
                    
                    print("Success > students found: \(studentLocations?.count)")
                    
                    (UIApplication.shared.delegate as! AppDelegate).studentLocations.append(contentsOf: studentLocations!)
                    
                    let vc1 = self.viewControllers![0] as! MapViewController
                    
                    vc1.showStudentLocations(studentLocations: studentLocations!)
                    
                    let vc2 = self.viewControllers![1] as! TableViewController
                    
                    vc2.studentLocations = studentLocations!
                    
                    if let pinTable = vc2.pinsTableView {
                        
                        pinTable.reloadData()
                    }
                    
                }else{
                    
                    print("--error--")
                    self.showErrorAlert(error!)
                }
            }
        }
    }
    
    
    // MARK: Show Login View
    
    func showLoginView(){
        
        let vc1 = self.storyboard!.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
        
        self.present(vc1, animated: true,completion: nil)
        
    }
    
    // MARK: Show Error Alert
    
    func showErrorAlert(_ error : String){
        
        let alert = UIAlertController(title: "", message: error, preferredStyle: UIAlertControllerStyle.alert)
        
        alert.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.default, handler: nil))
        
        self.present(alert, animated: true, completion: nil)
        
    }

    
}
