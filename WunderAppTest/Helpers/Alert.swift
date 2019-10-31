//
//  Alert.swift
//  WunderAppTest
//
//  Created by Mark Labios on 10/29/19.
//  Copyright © 2019 Mark Labios. All rights reserved.
//

import UIKit

struct AlertAction {
    let buttonTitle: String
    let handler: (() -> Void)?
}

struct SingleButtonAlert {
    let title: String
    let message: String?
    let action: AlertAction
}
