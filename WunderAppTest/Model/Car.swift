//
//  Car.swift
//  WunderAppTest
//
//  Created by Mark Labios on 10/29/19.
//  Copyright © 2019 Mark Labios. All rights reserved.
//

struct CarData: Codable {
    let placemarks: [Car]
}


struct Car: Codable {
    let name: String
    let address: String
    let engineType: String
    let exterior: String
    let fuel: Int
    let interior: String
    let vin: String
    let coordinates: [Double]
}

