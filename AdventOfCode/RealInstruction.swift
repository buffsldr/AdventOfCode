//
//  RealInstruction.swift
//  AdventOfCode
//
//  Created by Mark Vader on 12/24/17.
//  Copyright © 2017 Mark Vader. All rights reserved.
//

import Foundation

struct RealInstruction: Codable {

    //First Column
    let action: Action

    //Second Column
    let xRegister: Register?
    private let xValue: Int?

    //Third Column
    let yRegister: Register?
    private let yValue: Int?

    func requestXValueFrom(registerValues: RegisterValues) -> Int {
        guard let valueFromDictionary = xRegister?.getValueFrom(registerValues: registerValues) else {
            return xValue ?? 0
        }

        return valueFromDictionary
    }

    func requestYValueFrom(registerValues: RegisterValues) -> Int {
        guard let valueFromDictionary = yRegister?.getValueFrom(registerValues: registerValues) else {
            return yValue ?? 0
        }

        return valueFromDictionary
    }

}
