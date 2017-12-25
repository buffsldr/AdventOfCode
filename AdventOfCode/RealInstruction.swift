//
//  RealInstruction.swift
//  AdventOfCode
//
//  Created by Mark Vader on 12/24/17.
//  Copyright © 2017 Mark Vader. All rights reserved.
//

import Foundation

class RealInstruction: Codable {

    //First Column
    let action: Action

    //Second Column
    let xRegister: Register?
    private let xValue: Int?

    //Third Column
    let yRegister: Register?
    private let yValue: Int?

    func requestXValueFrom(registerValues: [String: Int]) -> Int {
        guard let key = xRegister?.rawValue, let value = registerValues[key] else {

            return xValue ?? 0
        }

        return value
    }

    func requestYValueFrom(registerValues: [String: Int]) -> Int {
        guard let key = yRegister?.rawValue, let value = registerValues[key] else {

            return yValue ?? 0
        }

        return value
    }

}
