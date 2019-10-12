//
//  MapViewExtension.swift
//  Booking
//
//  Created by mac on 10/8/19.
//  Copyright © 2019 OwnProjects. All rights reserved.
//

import Foundation
import MapKit

extension MKMapView {

    /// this function is just wrapper for ordinary register of AnnotaionView
    /// it is made for easily registering by using Generics and using identifier as the AnnonaionClassName
    /// - Parameter annotationViewClass: any annotaionView of type AnnoTaionView
    func register<AnnotationView:MKAnnotationView>(_ annotationViewClass: AnnotationView.Type)
    {
        register(annotationViewClass, forAnnotationViewWithReuseIdentifier: String(describing: AnnotationView.self))
    }

    /// this function is just wrapper for ordinary dequeReusable of AnnotaionView
    /// it is made for easily dequeing by using Generics
    /// - Parameter annotation: is the Annotaion that related to AnnotaionView
    /// - Returns: return annotaion from Type Annotaion Parameter Passed
    func dequeueReusableAnnotationView<AnnotationView: MKAnnotationView>(for annotation: MKAnnotation) -> AnnotationView {
        let identifier = String(describing: AnnotationView.self)
        guard let annotationView = self.dequeueReusableAnnotationView(withIdentifier: identifier, for: annotation) as? AnnotationView else {
            fatalError("Unable to dequeue annotation view with identifier \(identifier) of type \(AnnotationView.self)")
        }
        return annotationView
    }

    /// this function is responsible for adjusting all annotaions in the view by this calculation actually this calculation
    /// from this link https://stackoverflow.com/a/53025716/10871790
    /// - Parameter animated: to set Annimation with true or false
    func adjustMapZoomToAnnotaionsLocations(animated: Bool) {
        var zoomRect = MKMapRect.null
        for annotation in annotations {
            let annotationPoint = MKMapPoint(annotation.coordinate)
            let pointRect = MKMapRect(x: annotationPoint.x, y: annotationPoint.y, width: 0.01, height: 0.01)
            zoomRect = zoomRect.union(pointRect)
        }
        setVisibleMapRect(zoomRect, edgePadding: UIEdgeInsets(top: 50, left: 50, bottom: 50, right: 50), animated: animated)
    }

}
