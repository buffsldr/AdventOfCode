//
//  Instruction.swift
//  AdventOfCode
//
//  Created by Mark Vader on 12/23/17.
//  Copyright © 2017 Mark Vader. All rights reserved.
//

import Foundation


enum Action: String, Codable {

    case updated = "set"
    case subtracted =  "sub"
    case multiplied =  "mul"
    case jumped = "jnz"

}

enum Register: String, Codable, ThirdColumn {

    case a, b, c, d, e, f, g, h

}

typealias RegisterValues = [Register: Int]

struct ValuedRegister: Codable {

    let register: Register
    let value: Int

}


func ==(lhs: ActionType, rhs: ActionType) -> Bool {
    switch (lhs, rhs) {
    case (.math, .math):
        return true
    case (.instructionLocation(_), .math):
        return false
    case (.math, .instructionLocation(_)):
        return false
    case (.instructionLocation(let a), .instructionLocation(let b)):
        return a == b
    }
}

enum ActionType: Decodable, Equatable {

    case math
    case instructionLocation(Register)

    private enum CodingKeys: String, CodingKey {
        case math
        case instructionLocation

    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        do {
            let register = try values.decode(Register.self, forKey: .instructionLocation)
            self = .instructionLocation(register)
        } catch {
            throw ColumnReadError.yValueMissing
        }
    }


}

protocol ThirdColumn {

    func getValueFrom(registerValues: RegisterValues) -> Int?

}

struct Instruction: Decodable {

    let action: Action
    let type: ActionType

    private enum CodingKeys: String, CodingKey {

        case action
        case type

    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        do {
            type = try container.decode(ActionType.self, forKey: .type)
        } catch {
            throw ColumnReadError.yValueMissing
        }
        action = try container.decode(Action.self, forKey: .action)
    }

}

extension Register {

    func getValueFrom(registerValues: RegisterValues) -> Int? {
        return registerValues[self]
    }

}

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

enum ColumnReadError: Error {

    case yValueMissing

}

struct DeserializeRawData {

    static func processFrom(fileUrl: URL) throws -> [RealInstruction] {
        let rawLines = try! String(contentsOf: fileUrl, encoding: .utf8).components(separatedBy: "\n").filter({ theStrings -> Bool in
            return theStrings.count > 0
        })

        let instructions = try rawLines.map { rawLine -> RealInstruction in
            do {
                let lineArray = rawLine.components(separatedBy: .whitespaces)

                if let xValueFound = Int(lineArray[1]), let yValueFound = Int(lineArray[2]), lineArray[0] == "jnz" {
                    let rawJSON = """
                        {
                            "action": "\(lineArray[0])",
                            "xValue": \(xValueFound),
                            "yValue": \(yValueFound)
                        }
                        """.data(using: .utf8)!

                    return try JSONDecoder().decode(RealInstruction.self, from: rawJSON)
                } else if let yValueFound = Int(lineArray[2])  {
                    // In this case we are not a jumper
                    let rawJSONString = """
                        {
                            "action": "\(lineArray[0])",
                            "xRegister": "\(lineArray[1])",
                            "yValue": \(yValueFound)
                        }
                        """

                        let rawJSON = rawJSONString.data(using: .utf8)!

                    return try JSONDecoder().decode(RealInstruction.self, from: rawJSON)
                } else {
                    // In this case we are not a jumper and we have a pointer at Y not a raw value at Y
                    let rawJSON = """
                        {
                            "action": "\(lineArray[0])",
                            "xRegister": "\(lineArray[1])",
                            "yRegister": "\(lineArray[2])"
                        }
                        """.data(using: .utf8)!

                    return try JSONDecoder().decode(RealInstruction.self, from: rawJSON)
                }
            } catch DecodingError.dataCorrupted(let context) {
                throw ColumnReadError.yValueMissing
            } catch {
                throw ColumnReadError.yValueMissing
            }

            throw ColumnReadError.yValueMissing
        }

        return instructions
    }

}


