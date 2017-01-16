//
//  NewStudentLocationViewController.swift
//  OnTheMap
//
//  Created by JasonZhang on 04/01/2017.
//  Copyright © 2017 Saneryee. All rights reserved.
//

import Foundation
import UIKit
import MapKit

// MARK: - NewStudentLocationViewController

class NewStudentLocationViewController: UIViewController,UITextFieldDelegate,UINavigationControllerDelegate {
    
    // MARK: Outlets
    
    @IBOutlet weak var viewLocation: UIView!
    @IBOutlet weak var viewLink: UIView!
    
    @IBOutlet weak var locationTextField: UITextField!
    @IBOutlet weak var linkTextField: UITextField!
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    
    // MARK: Properties
    
    let inputLocationText = "Enter your location here"
    let inputLinkText = "Enter a link to share here"
    
    let segueIdentifierForNextView = "onTheMapDetail"
    
    var studentLocations = [ParseStudentLocation]()
    
    var parseStudentLocation: ParseStudentLocation?
    
    var selectedPlaceMark: CLPlacemark?
    
    
    // MARK: Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("----NewStudentLocationViewController : viewDidLoad----")
        
        activityIndicator.alpha = 0.0
        
        prepareTextField(textField: locationTextField, defaultText: inputLocationText)
        
        prepareTextField(textField: linkTextField, defaultText: inputLinkText)
        
        self.subscribeToKeyboardNotifications()
        
        showLocationView()
        
    }
    
    
    // MARK: showLocationInMap
    
    func showLocationInMap(){
        
        let address = locationTextField.text
        
        
        DispatchQueue.main.async {
            self.activityIndicator.alpha = 1.0
            self.activityIndicator.startAnimating()
        }
        
        
        let geocoder = CLGeocoder()
        
        geocoder.geocodeAddressString(address!){
            placemarks, error in
            
            func displayError(_ error: String){
                
                print(error)
                self.showErrorAlert("Location not found")
                
            }
            
            if error != nil {
                
                // Stopping and hiding the activity indicator
                DispatchQueue.main.async {
                    self.activityIndicator.isHidden = true
                }
                
                displayError(":::CLGeocoder sent an error")
                return
            }
            
            guard let placemark = placemarks?[0] else {
                
                displayError(":::CLGeocoder cannot find placemark")
                return
            }
            
            self.selectedPlaceMark = placemark
            
            self.mapView.addAnnotation(MKPlacemark(placemark: placemark))
            
            //zoom the map to the selected location
            let latDelta:CLLocationDegrees = 0.3
            let lonDelta:CLLocationDegrees = 0.3
            let span = MKCoordinateSpanMake(latDelta, lonDelta)
            let location = CLLocationCoordinate2DMake(placemark.location!.coordinate.latitude, placemark.location!.coordinate.longitude)
            let region = MKCoordinateRegionMake(location, span)
            self.mapView.setRegion(region, animated: false)
            //end zooming to the location
            
            self.showLinkView()
            
            DispatchQueue.main.async {
                
                self.activityIndicator.isHidden = true
            }

        }
    }
    
    // MARK: showLocationView
    
    func showLocationView(){
        
        viewLocation.isHidden = false
        viewLink.isHidden = true
    
    }
    
    // MARK: showLinkView
    
    func showLinkView(){
    
        viewLocation.isHidden = true
        viewLink.isHidden = false
        
    }
    
    // MARK: Create Student Location In View
    
    func createStudentLocationInView(){
        
        
        let udacityStudent = UdacityClient.sharedInstance().udacityStudent
        
        var parseStudentDictionary = [String : AnyObject]()
        
        parseStudentDictionary[ParseStudentLocationClient.JSONResponseKeys.FirstName] = udacityStudent?.firstName as AnyObject?
        
        parseStudentDictionary[ParseStudentLocationClient.JSONResponseKeys.LastName] = udacityStudent?.lastName as AnyObject?
        
        parseStudentDictionary[ParseStudentLocationClient.JSONResponseKeys.UniqueKey] = udacityStudent?.key as AnyObject?
        
        parseStudentDictionary[ParseStudentLocationClient.JSONResponseKeys.Latitude] = self.selectedPlaceMark?.location?.coordinate.latitude as AnyObject?
        
        parseStudentDictionary[ParseStudentLocationClient.JSONResponseKeys.Longitude] = self.selectedPlaceMark?.location?.coordinate.longitude as AnyObject?
        
        parseStudentDictionary[ParseStudentLocationClient.JSONResponseKeys.MapString] = locationTextField.text as AnyObject?
        
        parseStudentDictionary[ParseStudentLocationClient.JSONResponseKeys.MediaURL] = linkTextField.text as AnyObject?

        parseStudentLocation = ParseStudentLocation(dictionary: parseStudentDictionary)
        
    }
    
    
    // MARK: cancelAction
    func cancelAction(){
        
        dismiss(animated: true, completion: nil)
        
    }
    
    
    // MARK: Actions
    
    @IBAction func findOnMap(_ sender : Any){
        
        print("---NewSLVC--findOnMap--")
 
        showLinkView()
        showLocationInMap()
        
    }
    
    
    @IBAction func submitAction(_ sender : Any){
        
        print("---NewSLVC--submitAction--")
        
        createStudentLocationInView()
        
        ParseStudentLocationClient.sharedInstance().saveParseStudentLocation(parseStudentLocation:
        parseStudentLocation!){ success, error in
    
            print("save ParseStudent Location call completed>")
            
            performUIUpdatesOnMain {
                if success{
                    print("Success saveParseStudentLocation: ")
                    
                    self.cancelAction()
                }else{
                    
                    print("Error In saveParseStudentLocation")
                    self.showErrorAlert(error!)
                }
            }
            
        }
    }
    
    
    @IBAction func performCancelAction(_ sender: Any){
        
        cancelAction()
        
    }
    
    
    
    // MARK: Delegate Methods

    //TextField Control
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        textField.resignFirstResponder()
        
        return true;
    }
  
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        print("---NewSLVC-- textFieldDidBeginEditing--")
        
        if (textField.text == inputLocationText || textField.text == inputLinkText) {
            
            textField.text = ""
        
        }
    }
    
    
    
    // MARK: Helper
    
    // MARK: prepareTextField
    func prepareTextField(textField: UITextField, defaultText: String){
        
        let myTextAttributes  = [ NSForegroundColorAttributeName : UIColor.white,
            NSFontAttributeName : UIFont(name: "HelveticaNeue-CondensedBlack", size: 20)!
            ] as [String : Any]
        
        textField.defaultTextAttributes = myTextAttributes
        textField.textAlignment = .center
        textField.delegate = self
        textField.text = defaultText
    }
    
    // MARK: showErrorAlert
    
    func showErrorAlert(_ error : String){
        
        let alert = UIAlertController(title: "", message: error, preferredStyle: UIAlertControllerStyle.alert
        )
        
        alert.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.default, handler: nil))
        
        self.present(alert, animated: true, completion: nil)
        
    }
    
    
    
    // MARK: KeyBoard Contorl
    
    // MARK: subscibeTokeyboardNotifications
    
    func subscribeToKeyboardNotifications(){
        
        print("--NewSLVC:subscribeToKeyboardNotifications--")
        
        NotificationCenter.default.addObserver(self, selector: #selector(NewStudentLocationViewController.keyboardWillShow(notification:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(NewStudentLocationViewController.keyboardWillHide(notification:))   , name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    
    
    // MARK: keyboardWillShow
    
    var keyboardHeight : CGFloat = 0.0
    
    func keyboardWillShow(notification: NSNotification) {
        
        print("---NewSLVC--->keyboardWillShow")
        
        
        if(viewLocation.isHidden == true){
            
            return
        }
        
        
        keyboardHeight=getKeyboardHeight(notification: notification)
        
        view.frame.origin.y =  getKeyboardHeight(notification: notification) * -1
        
        
    }
    
    func keyboardWillHide(notification: NSNotification) {
        
        print("IN-->keyboardWillHide origin: \(self.view.frame.origin.y)")
        
        if(self.view.frame.origin.y == 0){
            return
        }
        
        self.view.frame.origin.y += keyboardHeight
        
    }
    
    func getKeyboardHeight(notification: NSNotification) -> CGFloat {
        
        //print("IN-->getKeyboardHeight")
        
        let userInfo = notification.userInfo!
        let keyboardSize = userInfo[UIKeyboardFrameEndUserInfoKey] as! NSValue // of CGRect
        
        //print("IN-->getKeyboardHeight2: \( keyboardSize.cgRectValue.height)")
        return keyboardSize.cgRectValue.height
    }
    
}
