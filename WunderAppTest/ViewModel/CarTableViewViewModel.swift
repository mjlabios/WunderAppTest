//
//  CarTableViewViewModel.swift
//  WunderAppTest
//
//  Created by Mark Labios on 10/29/19.
//  Copyright © 2019 Mark Labios. All rights reserved.
//

import RxSwift
import RxCocoa

enum CarTableViewCellType {
    case normal(cellViewModel: CarCellViewModel)
    case error(message: String)
    case empty
}


class CarTableViewViewModel {
    
    var carCells: Observable<[CarTableViewCellType]> {
        return cells.asObservable()
    }
    var carsObservable: Observable<[Car]> {
        return cars.asObservable()
    }
    
    var onShowLoadingHud: Observable<Bool> {
        return loadInProgress
            .asObservable()
            .distinctUntilChanged()
    }

    var onShowError: ((_ alert: SingleButtonAlert) -> Void)?
    let appServerClient: AppServerClient
    let disposeBag = DisposeBag()
    
    private let loadInProgress = BehaviorRelay(value: false)
    private let cells = BehaviorRelay<[CarTableViewCellType]>(value: [])
    private let cars = BehaviorRelay<[Car]>(value: [])
    
    init(appServerClient: AppServerClient = AppServerClient()) {
        self.appServerClient = appServerClient
    }
    
    
    func getCars() {
        loadInProgress.accept(true)
        appServerClient
            .getCars()
            .subscribe(
                onNext: { [weak self] cars in
                    self?.loadInProgress.accept(false)
                    guard cars.count > 0 else {
                        self?.cells.accept([.empty])
                        return
                    }
                    
                    self?.cells.accept(cars.compactMap { .normal(cellViewModel: CarCellViewModel(car: $0 )) })
                    self?.cars.accept(cars)
                   // self?.annotations.accept(cars.compactMap {Annotation(coordinate: CLLocationCoordinate2D(latitude: CLLocationDegrees(exactly: $0.coordinates[1])!, longitude: CLLocationDegrees(exactly: $0.coordinates[0])!))})
                },
                onError: { [weak self] error in
                    self?.loadInProgress.accept(false)
                    self?.cells.accept([
                        .error(
                            message: (error as? AppServerClient.GetCarsFailureReason)?.getErrorMessage() ?? "Loading failed, check network connection"
                        )
                    ])
                }
            )
        .disposed(by: disposeBag)
    }
    
}

// MARK: - AppServerClient.GetFriendsFailureReason
fileprivate extension AppServerClient.GetCarsFailureReason {
    func getErrorMessage() -> String? {
        switch self {
        case .unAuthorized:
            return "Please login to load your friends."
        case .notFound:
            return "Could not complete request, please try again."
        }
    }
}

