//
//  MapViewController.swift
//  OnTheMap
//
//  Created by JasonZhang on 29/12/2016.
//  Copyright © 2016 Saneryee. All rights reserved.
//

import UIKit
import MapKit

// MARK: - MapViewController : UIViewController, MKMapViewDelegate

class MapViewController : UIViewController, MKMapViewDelegate {
    
    
    // MARK: - Outlets
    
    @IBOutlet weak var mapView: MKMapView!
    
    // MARK: Properties
    
    //var studentLocations = [ParseStudentLocation]()
    
    // MARK: Life Cycle
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        // Set delegate for map
        
        mapView.delegate = self
        
        print("----MapView viewDidLoad----")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        print("----MapView viewWillAppear----")
        
        super.viewWillAppear(animated)
        
        
        print("StudentLocations count:\(StudentLocations.sharedInstance.listOfStudents.count)")
        
        // When viewWillAppear is called (for example when we change tabs) annotations are always added, regardless if they were previously added:
        
        // Such as Pin have the heavy black shades. To avoid this, make sure that the map is always cleared of any previously added pins.
        
        self.mapView.removeAnnotations(self.mapView.annotations)
        
        if (StudentLocations.sharedInstance.listOfStudents.count > 0){
            
            self.showStudentLocations(studentLocations: StudentLocations.sharedInstance.listOfStudents)
            
        }
    }
    
    // MARK: Show Student Locations
    
    func showStudentLocations(studentLocations : [ParseStudentLocation]){
        
        // MARK: - Properties

        // We will create an MKPointAnnotation for each dictionary in "lcoations". 
        // The point annotations will be stored in this array and provided to the map view.
        var annotations = [MKPointAnnotation]()
        
        // The "locations" arary is loaded with the data below. 
        // We are using the dictionaries to create map annotations.
        // This would be more stylish if the dictionaties were being used to create custom structs.
        // Perhaps StudentLocation structs.
        for studentLocation in studentLocations {
            
            // Notice: the float values are being used to create CLLocationDegree values
            // This is a version of the Double type.
            
            if let lat = studentLocation.latitude, let lng = studentLocation.longitude {
                
                // The lat and lng are used to create a CLLocationCoordinates2D instance.
                let conordinate = CLLocationCoordinate2D(latitude: lat, longitude: lng)
                
                if let firstname = studentLocation.firstName, let lastname = studentLocation.lastName, let mediaURL = studentLocation.mediaURL{
                    
                    // We create the annotation and set its coordiate, title and subtitile properties
                    
                    let annotation = MKPointAnnotation()
                    annotation.coordinate = conordinate
                    annotation.title = "\(firstname) \(lastname)"
                    annotation.subtitle = mediaURL
                    
                    // Finally we place the annotation in an array of annotations.
                    annotations.append(annotation)
                    
                }
            }
        }
        
        // When the array is complete, we add the annotataions to the map.
        
        self.mapView.addAnnotations(annotations)
    
    }
    
    
    // MARK: - Delegate Methods
    
    // MKMapViewDelegate
    // Here we create a view with a "right callout accessory view". 
    // You might choose to look into other decoration alternatives. 
    // Notice the similarity between this method and the cellForRowAtIndexPath method in TableViewDataSource.
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        let reuseId = "pin"
        
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId) as? MKPinAnnotationView
        
        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            pinView!.canShowCallout = true
            pinView!.pinTintColor = .red
            pinView!.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
        }
        else {
            pinView!.annotation = annotation
        }
        
        return pinView
    }
    
    // This delegate method is implemented to respond to taps. 
    // It opens the system browser to the URL specified in the annotationViews subtitle property. 
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        
        if control == view.rightCalloutAccessoryView {
            let app = UIApplication.shared
            if let toOpen = view.annotation?.subtitle!{
                app.openURL(URL(string: toOpen)!)
            }
        }
    }
}
