//
//  InstructionTests.swift
//  AdventOfCodeTests
//
//  Created by Mark Vader on 12/23/17.
//  Copyright © 2017 Mark Vader. All rights reserved.
//

import XCTest
@testable import AdventOfCode

class InstructionTests: XCTestCase {


    let instructionData = """
        {
            "action": "set",
            "type":  {
            "instructionLocation": "a"
        }
        }
    """.data(using: .utf8)!

    let instructionMathData = """
        {
            "action": "set",

        }
    """.data(using: .utf8)!

    let actionTypeData = """
        {
            "instructionLocation": "a"
        }
    """.data(using: .utf8)!

    let valuedRegisterData = """
        {
            "register": "a",
            "value": 12
        }
    """.data(using: .utf8)!

    let realInstructionDataWithRawValue = """
        {
            "action": "set",
            "xRegister": "a",
            "rawValue": 12
        }
    """.data(using: .utf8)!

    let realInstructionDataWithRegisterPointer = """
        {
            "action": "set",
            "xRegister": "a",
            "registerPointer": "h"
        }
    """.data(using: .utf8)!

    let realInstructionFromJumperData = """
        {
            "action": "jnz",
            "xValue": 55,
            "rawValue": 33
        }
    """.data(using: .utf8)!

    func testJumperData() {
        var sampleData: RegisterValues = [Register.h: 42]
        do {
            let realInstruction = try JSONDecoder().decode(RealInstruction.self, from: realInstructionFromJumperData)
            XCTAssertNotNil(realInstruction)
            XCTAssertEqual(realInstruction.xValue, 55)
            XCTAssertEqual(realInstruction.action, Action.jumped)
            XCTAssertEqual(realInstruction.rawValue, 33)


        } catch DecodingError.dataCorrupted(let context) {
            XCTFail()
        } catch {
            XCTFail()
        }
    }

    func testRealInstructionGettingPointerValueFromRegisterPointer() {
        var sampleData: RegisterValues = [Register.h: 42]
        do {
            let realInstruction = try JSONDecoder().decode(RealInstruction.self, from: realInstructionDataWithRegisterPointer)
            let theValueFromFunction = realInstruction.requestThirdColumnValueFrom(registerValues: sampleData)
            XCTAssertEqual(42, theValueFromFunction)
        } catch DecodingError.dataCorrupted(let context) {
            XCTFail()
        } catch {
            XCTFail()
        }
    }

    func testRealInstruction() {
        do {
            let realInstruction = try JSONDecoder().decode(RealInstruction.self, from: realInstructionDataWithRegisterPointer)
            XCTAssertNotNil(realInstruction)
            XCTAssertEqual(realInstruction.action, Action.updated)
            XCTAssertEqual(realInstruction.xRegister, Register.a)
            XCTAssertEqual(realInstruction.registerPointer, Register.h)
        } catch DecodingError.dataCorrupted(let context) {
            XCTFail()
        } catch {
            XCTFail()
        }
    }

    func testRealInstructionMakeMath() {
        do {
            let realInstruction = try JSONDecoder().decode(RealInstruction.self, from: realInstructionDataWithRawValue)
            XCTAssertNotNil(realInstruction)
            XCTAssertEqual(realInstruction.action, Action.updated)
            XCTAssertEqual(realInstruction.xRegister, Register.a)
            XCTAssertEqual(realInstruction.rawValue, 12)
        } catch DecodingError.dataCorrupted(let context) {
            XCTFail()
        } catch {
            XCTFail()
        }
    }

    func testValueRegisterExists() {
        let valuedRegister = try? JSONDecoder().decode(ValuedRegister.self, from: valuedRegisterData)

        XCTAssertNotNil(valuedRegister)
    }

    func testActionTypeCreation() {
        let actionType = try? JSONDecoder().decode(ActionType.self, from: actionTypeData)
        XCTAssertNotEqual(actionType!, ActionType.math)
        XCTAssertEqual(actionType!, ActionType.instructionLocation(Register.a))

        XCTAssertNotNil(actionType)
    }

    func testInstructionMake() {
        do {
            let instruction = try JSONDecoder().decode(Instruction.self, from: instructionData)
            XCTAssertNotNil(instruction)
            XCTAssertEqual(instruction.type, ActionType.instructionLocation(Register.a))
        } catch DecodingError.dataCorrupted(let context) {
            XCTFail()
        } catch {
            XCTFail()
        }
    }

    func testInstructionMakeMath() {
        do {
            let instruction = try JSONDecoder().decode(Instruction.self, from: instructionMathData)
            XCTAssertNotNil(instruction)
            XCTAssertEqual(instruction.type, ActionType.math)
        } catch DecodingError.dataCorrupted(let context) {
            XCTFail()
        } catch {
            XCTFail()
        }
    }

}
