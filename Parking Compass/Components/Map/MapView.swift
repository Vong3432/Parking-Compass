//
//  MapView.swift
//  Parking Compass
//
//  Created by Vong Nyuksoon on 18/02/2022.
//

import Foundation
import SwiftUI
import MapKit

struct MapView: UIViewRepresentable {
    typealias UIViewType = MKMapView
    
    let userLocation: CLLocation
    let parkingLocation: CLLocation
    
    func makeCoordinator() -> MapViewCoordinator {
        return MapViewCoordinator()
    }
    
    func makeUIView(context: Context) -> MKMapView {
        let mapView = MKMapView()
        mapView.delegate = context.coordinator
        
        let region = MKCoordinateRegion(
            center: CLLocationCoordinate2D(latitude: userLocation.coordinate.latitude, longitude: userLocation.coordinate.longitude),
            span: MKCoordinateSpan(latitudeDelta: 100, longitudeDelta: 100))
        mapView.setRegion(region, animated: true)
        mapView.userTrackingMode = .follow
        mapView.isZoomEnabled = true
        mapView.isPitchEnabled = true
        mapView.isUserInteractionEnabled = true
        mapView.showsTraffic = false
        
        draw(mapView)
        
        return mapView
    }
    
    func updateUIView(_ uiView: UIViewType, context: Context) {
        draw(uiView)
    }
    
    func draw(_ mapView: UIViewType) {
        // drawing
        let userPlacemark = MKPlacemark(coordinate: CLLocationCoordinate2D(latitude: userLocation.coordinate.latitude, longitude: userLocation.coordinate.longitude))
        
        /// Uncomment for testing
        //  let dummyPlacemark = MKPlacemark(coordinate: CLLocationCoordinate2D(latitude: 1.492290, longitude: 103.584049))
        
        let parkingPlacemark = MKPlacemark(coordinate: CLLocationCoordinate2D(latitude: parkingLocation.coordinate.latitude, longitude: parkingLocation.coordinate.longitude))
        
        let request = MKDirections.Request()
        request.source = MKMapItem(placemark: userPlacemark)
        request.destination = MKMapItem(placemark: parkingPlacemark)
        request.transportType = .walking
        
        // annotations
        let userAnnotation = MKPointAnnotation()
        userAnnotation.coordinate = userPlacemark.coordinate
        userAnnotation.title = "You're here"
        
        let parkingAnnotation = MKPointAnnotation()
        parkingAnnotation.coordinate = parkingPlacemark.coordinate
        parkingAnnotation.title = "Your vehicle is here"
        
        
        let directions = MKDirections(request: request)
        directions.calculate { response, error in
            guard let route = response?.routes.first else { return }
            
            // clear
            mapView.removeAnnotations(mapView.annotations)
            
            mapView.addAnnotations([userAnnotation, parkingAnnotation])
            mapView.addOverlay(route.polyline)
            mapView.setVisibleMapRect(
                route.polyline.boundingMapRect,
                edgePadding: UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20),
                animated: true)
        }
    }
    
    class MapViewCoordinator: NSObject, MKMapViewDelegate {
        func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
            let renderer = MKPolylineRenderer(overlay: overlay)
            renderer.strokeColor = .systemBlue
            renderer.lineWidth = 5
            return renderer
        }
    }
}
