//
//  CarCellViewModel.swift
//  WunderAppTest
//
//  Created by Mark Labios on 10/29/19.
//  Copyright © 2019 Mark Labios. All rights reserved.
//

struct CarCellViewModel {
    let carItem: Car
    let name: String
    let address: String
    let engineType: String
    let exterior: String
    let fuel: Int
    let interior: String
    let vin: String
}

extension CarCellViewModel {
    init(car: Car) {
        self.carItem = car
        self.name = car.name
        self.address = car.address
        self.engineType = car.engineType
        self.exterior = car.exterior
        self.fuel = car.fuel
        self.interior = car.interior
        self.vin = car.vin
    }
}
