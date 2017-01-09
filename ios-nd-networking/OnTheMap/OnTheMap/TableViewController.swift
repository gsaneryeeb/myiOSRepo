//
//  TableViewController.swift
//  OnTheMap
//
//  Created by JasonZhang on 29/12/2016.
//  Copyright © 2016 Saneryee. All rights reserved.
//

import UIKit

// MARK: - TableViewController : UITableViewController

class TableViewController : UITableViewController {
    
    // MARK: Outlets
    
    @IBOutlet var pinsTableView: UITableView!
    
    // MARK: Properties
    
    var studentLocations = [ParseStudentLocation]()
    
    // MARK: Life Cycle
    
    override func viewDidLoad() {
        print("--TableViewController: viewDidLoad--")
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        print("--TableViewController: viewWillAppear--")
    }
    // MARK: Delegate Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return studentLocations.count
        
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "PinTableCell")!
        
        let studentLocation = studentLocations[indexPath.row]
        
        // Set the studentLocation and image
        
        if let firstName = studentLocation.firstName, let lastName = studentLocation.lastName {
            
            cell.textLabel?.text = "\(firstName) \(lastName)"
            cell.imageView?.image = UIImage(named: "Pin")
            
        }
        
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let studentLocation = studentLocations[indexPath.row]
        
        if let url = URL(string: studentLocation.mediaURL!){
            
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
            
        }
        
    }
    
}
