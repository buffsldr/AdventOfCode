//
//  Register.swift
//  AdventOfCode
//
//  Created by Mark Vader on 12/24/17.
//  Copyright © 2017 Mark Vader. All rights reserved.
//

import Foundation

typealias RegisterValues = [Register: Int]

enum Register: String, Codable {

    case a, b, c, d, e, f, g, h

    func getValueFrom(registerValues: RegisterValues) -> Int? {
        return registerValues[self]
    }

}
