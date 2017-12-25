//
//  ExecutionTests.swift
//  AdventOfCodeTests
//
//  Created by Mark Vader on 12/24/17.
//  Copyright © 2017 Mark Vader. All rights reserved.
//

import XCTest

@testable import AdventOfCode

class ExecutionTests: XCTestCase {

    var list: [RealInstruction]?
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testReadSimpleData() {
        let theBundle = Bundle(for: ExecutionTests.self)
        guard let fileUrl = theBundle.url(forResource: "simpleFile", withExtension: "txt") else { fatalError() }
        let list = try? DeserializeRawData.processFrom(fileUrl: fileUrl)
        XCTAssertNotNil(list)
    }

    func testOneMultiply() {
        let theBundle = Bundle(for: ExecutionTests.self)
        guard let fileUrl = theBundle.url(forResource: "simpleFile", withExtension: "txt") else { fatalError() }
        let list = try! DeserializeRawData.processFrom(fileUrl: fileUrl)
        let allInstructions = ExecuteInstruction.requestInstructionExecutionOrder(startingAt: 0, withRegisterValues: [:], rollingInstructions: [], instructionList: list)
        let multiplyInstructions = allInstructions.filter { instruction -> Bool in
            return instruction.action == Action.multiplied
        }

        let countFound = multiplyInstructions.count
        XCTAssertEqual(allInstructions.count, 4)
        XCTAssertEqual(countFound, 1)
    }

    func testSubtraction() {
        let theBundle = Bundle(for: ExecutionTests.self)
        guard let fileUrl = theBundle.url(forResource: "subtractTest", withExtension: "txt") else { fatalError() }
        let list = try! DeserializeRawData.processFrom(fileUrl: fileUrl)
        let allInstructions = ExecuteInstruction.requestInstructionExecutionOrder(startingAt: 0, withRegisterValues: [:], rollingInstructions: [], instructionList: list)
        let multiplyInstructions = allInstructions.filter { instruction -> Bool in
            return instruction.action == Action.multiplied
        }
        let lastInstruction = allInstructions.last!
        let expectedRegisterXValue = lastInstruction
    }

    func testAddition() {
        let theBundle = Bundle(for: ExecutionTests.self)
        guard let fileUrl = theBundle.url(forResource: "addFile", withExtension: "txt") else { fatalError() }
        let list = try? DeserializeRawData.processFrom(fileUrl: fileUrl)
        if let theList = list {
            let allInstructions = ExecuteInstruction.requestInstructionExecutionOrder(startingAt: 0, withRegisterValues: [:], rollingInstructions: [], instructionList: theList)
            let multiplyInstructions = allInstructions.filter { instruction -> Bool in
                return instruction.action == Action.multiplied
            }
            let lastInstruction = allInstructions.last!
            let expectedRegisterXValue = lastInstruction
        }

    }

    func testJumpZero() {
        let theBundle = Bundle(for: ExecutionTests.self)
        guard let fileUrl = theBundle.url(forResource: "jumpZeroFile", withExtension: "txt") else { fatalError() }
        let list = try? DeserializeRawData.processFrom(fileUrl: fileUrl)
//        let allInstructions = ExecuteInstruction.requestInstructionExecutionOrder(startingAt: 0, withRegisterValues: [:], rollingInstructions: [], instructionList: list)
//        let multiplyInstructions = allInstructions.filter { instruction -> Bool in
//            return instruction.action == Action.multiplied
//        }
//        let lastInstruction = allInstructions.last!
//        let expectedRegisterXValue = lastInstruction
    }

}
