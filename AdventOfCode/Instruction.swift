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

enum Register: String, Codable {

    case a, b, c, d, e, f, g, h

}

typealias RegisterValues = [Register: Int]

protocol GivesValue {



}

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
            self = .math
        }
    }


}

protocol ThirdColumn {

    func getValueFrom(registerValues: RegisterValues) -> Int

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
            type = ActionType.math
        }
        action = try container.decode(Action.self, forKey: .action)
    }


}

extension Register: ThirdColumn {

    func getValueFrom(registerValues: RegisterValues) -> Int {
        return registerValues[self] ?? 0
    }

}

extension Int: ThirdColumn {

    func getValueFrom(registerValues: RegisterValues) -> Int {
        return self
    }

}

struct RealInstruction: Codable {

    let action: Action

    let xRegister: Register?
    let xValue: Int?
    let registerPointer: Register?
    let rawValue: Int?

    func requestThirdColumnValueFrom(registerValues: RegisterValues) -> Int {
        guard let valueFromRaw = rawValue else {
            return registerPointer?.getValueFrom(registerValues: registerValues) ?? 0
        }

        return valueFromRaw
    }

}

struct DeserializeRawData {

    static func process(string: String) -> [RealInstruction] {
        guard let fileUrl = Bundle.main.url(forResource: "file", withExtension: "txt") else { fatalError() }
        let rawLines = try! String(contentsOf: fileUrl, encoding: .utf8).components(separatedBy: "\n")
        let instructions = rawLines.map { rawLine -> RealInstruction in
            let lineArray = rawLine.components(separatedBy: .whitespaces)
            if let xValueFound = Int(lineArray[1]), lineArray[0] == "jnz" {
                let rawJSON = """
                    {
                    "action" = \(lineArray[0])",
                    "xValue" = \(xValueFound)",
                    }
                    """
            } else {

            }
            let rawJSON = """
            {
                "action" = \(lineArray[0])",
                "xRegister" = \(lineArray[1])",
            }
            """
            return RealInstruction(action: Action.jumped, xRegister: Register.a, xValue: 0, registerPointer: nil, rawValue: nil)
        }

        return [RealInstruction]()
    }


}


