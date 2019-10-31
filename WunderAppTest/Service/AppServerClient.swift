//
//  AppServerClient.swift
//  WunderAppTest
//
//  Created by Mark Labios on 10/29/19.
//  Copyright © 2019 Mark Labios. All rights reserved.
//

import Alamofire
import RxSwift

// MARK: - AppServerClient
class AppServerClient {

    // MARK: - GetCars
    enum GetCarsFailureReason: Int, Error {
        case unAuthorized = 401
        case notFound = 404
    }

    typealias GetCarsResult = Result<[Car], GetCarsFailureReason>
    typealias GetCarsCompletion = (_ result: GetCarsResult) -> Void
    
    let EXPIRATION_MINS = 30

    func getCars() -> Observable<[Car]> {
        
        return Observable.create { observer -> Disposable in
            
            if let date = UserDefaults.standard.object(forKey: "creationTime") as? Date {
                  
                if let diff = Calendar.current.dateComponents([.minute], from: date, to: Date()).minute, diff < self.EXPIRATION_MINS {
                 
                    if let carData = UserDefaults.standard.data(forKey: "cars") {
                          
                            let carArray = try! JSONDecoder().decode([Car].self, from: carData)
                            observer.onNext(carArray)
                            return Disposables.create()
                        
                    }
                }
            }
            
            self.request(observer: observer)
            return Disposables.create()
        }
    }
    
    private func request(observer: AnyObserver<[Car]>) {
        Alamofire.request("https://s3-us-west-2.amazonaws.com/wunderbucket/locations.json")
            .validate()
            .responseJSON { response in
                switch response.result {
                case .success:
                        guard let data = response.data else {
                            observer.onError(response.error ?? GetCarsFailureReason.notFound)
                            return
                        }
                        
                        if let cars = self.parseJSON(data) {
                            observer.onNext(cars)
                            let carsData = try! JSONEncoder().encode(cars)
                            UserDefaults.standard.set(Date(), forKey:"creationTime")
                            UserDefaults.standard.set(carsData, forKey: "cars")
                        } else {
                            observer.onError(GetCarsFailureReason.notFound)
                        }
                        
                case .failure(let error):
                    if let statusCode = response.response?.statusCode,
                        let reason = GetCarsFailureReason(rawValue: statusCode) {
                        observer.onError(reason)
                    }
                    observer.onError(error)
                }
        }

    }
    
    private func parseJSON(_ carData: Data) -> [Car]? {
        let decoder = JSONDecoder()
        do {
            let decodedData = try decoder.decode(CarData.self, from: carData)
            let placemarks = decodedData.placemarks
            
            return placemarks
            
        } catch {
            print("error: \(error)")
            return nil
        }
    }


}

