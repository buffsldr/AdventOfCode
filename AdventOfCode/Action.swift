//
//  Action.swift
//  AdventOfCode
//
//  Created by Mark Vader on 12/24/17.
//  Copyright © 2017 Mark Vader. All rights reserved.
//

import Foundation

enum Action: String, Codable {

    case updated = "set"
    case subtracted =  "sub"
    case multiplied =  "mul"
    case jumped = "jnz"

}
