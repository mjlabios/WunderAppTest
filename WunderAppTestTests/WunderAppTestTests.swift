//
//  WunderAppTestTests.swift
//  WunderAppTestTests
//
//  Created by Mark Labios on 10/29/19.
//  Copyright © 2019 Mark Labios. All rights reserved.
//

import XCTest
@testable import WunderAppTest

class WunderAppTestTests: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
       
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func assertNotNil() {
        let viewModel: CarTableViewViewModel = CarTableViewViewModel()
        viewModel.getCars()
        
        // Assert car array is not Nil
        XCTAssertNotNil(viewModel.carCells)
        XCTAssertNotNil(viewModel.carsObservable)
       
    }



}
