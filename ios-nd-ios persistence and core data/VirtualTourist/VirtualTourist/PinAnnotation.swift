//
//  PinAnnotation.swift
//  VirtualTourist
//
//  Created by JasonZ on 2017-2-15.
//  Copyright © 2017 saneryee. All rights reserved.
//

import Foundation
import MapKit

public class PinAnnotation : MKPointAnnotation {
    
    init(coordinate: CLLocationCoordinate2D) {
        super.init()
        self.coordinate = coordinate
    }
    
    var pin: Pin?
    
}
