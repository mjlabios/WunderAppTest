//
//  MapViewController.swift
//  WunderAppTest
//
//  Created by Mark Labios on 10/29/19.
//  Copyright © 2019 Mark Labios. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import MapKit

class MapViewController: UIViewController {

    @IBOutlet weak var mapView: MKMapView!
       
    var car: Car?
    
    let disposeBag = DisposeBag()
    var annotationDict: [String: MKAnnotation] = [:]
    
     let viewModel: CarTableViewViewModel = CarTableViewViewModel()
    
     override func viewDidLoad() {
           super.viewDidLoad()
      
       }
    
    func pinCars(cars: Observable<[Car]>) {
         cars.subscribe(
                       onNext: { [weak self] cars in
                           guard cars.count > 0 else {
                               return
                           }
                        for car in cars {
                            let latitude = car.coordinates[1]
                            let longitude = car.coordinates[0]
                            let annotation = MKPointAnnotation()
                                annotation.title = car.name
                                annotation.subtitle = car.vin
                                annotation.coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
                            self?.annotationDict[car.name] = annotation
                            self?.mapView.addAnnotation(annotation)
                        }
                           
                       }
                   )
               .disposed(by: disposeBag)
        
    }
    
    
    func onCellTapped() {
        let latitude = car?.coordinates[1] ?? 0
        let longitude = car?.coordinates[0] ?? 0
        var viewRegion =
            MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: latitude, longitude: longitude), span: MKCoordinateSpan(latitudeDelta: CLLocationDegrees(exactly: 0.5)!, longitudeDelta: CLLocationDegrees(exactly: 0.5)!))
                
        mapView.setRegion(viewRegion, animated: true)
       viewRegion =
            MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: latitude, longitude: longitude), span: MKCoordinateSpan(latitudeDelta: CLLocationDegrees(exactly: 0.05)!, longitudeDelta: CLLocationDegrees(exactly: 0.05)!))
        
        zoomInCamera(viewRegion)
       
        
    }
    
    func zoomInCamera(_ region: MKCoordinateRegion) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.mapView.setRegion(region, animated: true)
            self.mapView.selectAnnotation(self.annotationDict[self.car!.name]!, animated: true)
        }
    }

}

