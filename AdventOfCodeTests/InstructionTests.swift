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
            "action": "set"
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
            "yRegister": "g"
        }
    """.data(using: .utf8)!

    let realInstructionDataWithRawValueNoRegisters = """
        {
            "action": "set",
            "xRegister": "a"

        }
    """.data(using: .utf8)!

    let realInstructionDataWithRegisterPointer = """
        {
            "action": "set",
            "xRegister": "a",
            "yRegister": "h"
        }
    """.data(using: .utf8)!

    let realInstructionFromJumperData = """
        {
            "action": "jnz",
            "xValue": 55,
            "yValue": 33
        }
    """.data(using: .utf8)!

    let noFailData = """
        {
            "action": "set",
            "xRegister": "b",
            "yValue": 65
        }
    """.data(using: .utf8)!

    let jumpRegisterStyleData = """
        {
            "action": "jnz",
            "xRegister": "b",
            "yValue": 1
        }
    """.data(using: .utf8)!

    func testBuildJumpRegisterStyle() {
        do {
            let realInstruction = try JSONDecoder().decode(RealInstruction.self, from: jumpRegisterStyleData)
            let xRegister = realInstruction.xRegister!
            let yRegister = realInstruction.yRegister
            XCTAssertEqual(xRegister, Register.b)
            XCTAssertNil(yRegister)
            XCTAssertNotNil(realInstruction)
        } catch DecodingError.dataCorrupted(_) {
            XCTFail()
        } catch {
            XCTFail()
        }
    }

    func testNoFail() {
        do {
            let realInstruction = try JSONDecoder().decode(RealInstruction.self, from: noFailData)
            XCTAssertNotNil(realInstruction)
        } catch DecodingError.dataCorrupted(_) {
            XCTFail()
        } catch {
            XCTFail()
        }
    }

    func testJumperData() {
        let sampleData: RegisterValues = [Register.h: 42]
        do {
            let realInstruction = try JSONDecoder().decode(RealInstruction.self, from: realInstructionFromJumperData)
            XCTAssertNotNil(realInstruction)
            let localX = realInstruction.requestXValueFrom(registerValues: sampleData)
            let localY = realInstruction.requestYValueFrom(registerValues: sampleData)
            XCTAssertEqual(localX, 55)
            XCTAssertEqual(realInstruction.action, Action.jumped)
            XCTAssertEqual(localY, 33)


        } catch DecodingError.dataCorrupted(_) {
            XCTFail()
        } catch {
            XCTFail()
        }
    }

    func testRealInstructionGettingPointerValueFromRegisterPointer() {
        let sampleData: RegisterValues = [Register.h: 42]
        do {
            let realInstruction = try JSONDecoder().decode(RealInstruction.self, from: realInstructionDataWithRegisterPointer)
            let theValueFromFunction = realInstruction.requestYValueFrom(registerValues: sampleData)
            XCTAssertEqual(42, theValueFromFunction)
        } catch DecodingError.dataCorrupted(_) {
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
            XCTAssertEqual(realInstruction.yRegister, Register.h)
        } catch DecodingError.dataCorrupted(_) {
            XCTFail()
        } catch {
            XCTFail()
        }
    }

    func testRealInstructionMakeMath() {
        let sampleData: RegisterValues = [Register.a: 123, Register.g: 41]

        do {
            let realInstruction = try JSONDecoder().decode(RealInstruction.self, from: realInstructionDataWithRawValue)
            XCTAssertNotNil(realInstruction)
            XCTAssertEqual(realInstruction.action, Action.updated)
            XCTAssertEqual(realInstruction.xRegister, Register.a)
            let localX = realInstruction.requestXValueFrom(registerValues: sampleData)
            let localY = realInstruction.requestYValueFrom(registerValues:  sampleData)
            XCTAssertEqual(localY, 41)
            XCTAssertEqual(localX, 123)

        } catch DecodingError.dataCorrupted(_) {
            XCTFail()
        } catch {
            XCTFail()
        }
    }

    func testRequestYValuesFromGuardFailsCase() {
        let sampleData: RegisterValues = [Register.a: 123, Register.g: 41]

        do {
            let realInstruction = try JSONDecoder().decode(RealInstruction.self, from: realInstructionDataWithRawValueNoRegisters)
            XCTAssertNotNil(realInstruction)
            XCTAssertEqual(realInstruction.action, Action.updated)
            XCTAssertEqual(realInstruction.xRegister, Register.a)
            let localY = realInstruction.requestYValueFrom(registerValues:  sampleData)
            XCTAssertEqual(localY, 0)

        } catch DecodingError.dataCorrupted(_) {
            XCTFail()
        } catch {
            XCTFail()
        }
    }

    func testRunIt() {
        do {
            let theBundle = Bundle(for: ExecutionTests.self)
            guard let fileUrl = theBundle.url(forResource: "file", withExtension: "txt") else { fatalError() }
            let realInstructions = try DeserializeRawData.processFrom(fileUrl: fileUrl)
            XCTAssertNotNil(realInstructions)
        } catch DecodingError.dataCorrupted(_) {
            XCTFail()
        } catch {
            XCTFail()
        }
    }

    func testRun14() {
        let theBundle = Bundle(for: ExecutionTests.self)
        guard let fileUrl = theBundle.url(forResource: "file", withExtension: "txt") else { fatalError() }
        let realInstructions = try? DeserializeRawData.processFrom(fileUrl: fileUrl)
        let item14 = realInstructions?[13]
        XCTAssertEqual(item14?.action, Action.subtracted)
        XCTAssertEqual(item14?.xRegister, Register.g)
        XCTAssertEqual(item14?.yRegister, Register.b)
    }

}
