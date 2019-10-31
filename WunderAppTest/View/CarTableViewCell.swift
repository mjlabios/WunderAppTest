//
//  CarTableViewCell.swift
//  WunderAppTest
//
//  Created by Mark Labios on 10/29/19.
//  Copyright © 2019 Mark Labios. All rights reserved.
//

import UIKit

class CarTableViewCell: UITableViewCell {

    @IBOutlet weak var labelName: UILabel!
    @IBOutlet weak var labelFuel: UILabel!
    @IBOutlet weak var labelEngine: UILabel!
    @IBOutlet weak var labelAddress: UILabel!
    @IBOutlet weak var labelVin: UILabel!
    @IBOutlet weak var labelExterior: UILabel!
    @IBOutlet weak var labelInterior: UILabel!
    
    var viewModel: CarCellViewModel? {
        didSet {
            bindViewModel()
        }
    }

    private func bindViewModel() {
        if let viewModel = viewModel {
            labelName?.text = viewModel.name
            labelFuel?.text = "\(viewModel.fuel)%"
            labelEngine?.text = viewModel.engineType
            labelAddress?.text = viewModel.address
            labelExterior?.text = viewModel.exterior
            labelInterior?.text = viewModel.interior
            labelVin?.text = viewModel.vin
        }
    }
}

