//
//  RobotDelegate.swift
//  Rapiro
//
//  Created by Sunny Cheung on 5/12/14.
//  Copyright (c) 2014 khl. All rights reserved.
//

import Foundation

protocol RobotDelegate {
    func cancelConnection()
    func connectPeripheral(robot:CBPeripheral)
}
