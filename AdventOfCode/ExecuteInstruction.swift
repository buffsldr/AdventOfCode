//
//  ExecuteInstruction.swift
//  AdventOfCode
//
//  Created by Mark Vader on 12/24/17.
//  Copyright © 2017 Mark Vader. All rights reserved.
//

import Foundation

struct ExecuteInstruction {

    let instructionList: [RealInstruction]

    init(instructionList: [RealInstruction]) {
        self.instructionList = instructionList
        instructionListHistory = [instructionList]
    }

    var instructionListHistory = [[RealInstruction]]()

    func requestInstructionExecutionOrder(startingAt index:Int, withRegisterValues: RegisterValues, rollingInstructions: [RealInstruction]) -> [RealInstruction] {
        guard index < instructionList.count && index > -1 else {
            return rollingInstructions
        }
        let actualInstruction = instructionList[index]
        let localX = actualInstruction.requestXValueFrom(registerValues: withRegisterValues)
        let localY = actualInstruction.requestYValueFrom(registerValues: withRegisterValues)
        var mutableRegisterValues = withRegisterValues
        let updatedRollingInstructions = rollingInstructions + [actualInstruction]

        switch actualInstruction.action {
        case .jumped where localX != 0 :
            let updatedIndex = index + localY

            return  requestInstructionExecutionOrder(startingAt:updatedIndex,  withRegisterValues: withRegisterValues,  rollingInstructions: updatedRollingInstructions)
        case .multiplied:
            let newValueAtX = localX * localY
            let registerAtX = actualInstruction.xRegister!
            mutableRegisterValues.updateValue(newValueAtX, forKey: registerAtX)
            let updatedIndex = index + 1

            return requestInstructionExecutionOrder(startingAt:updatedIndex,  withRegisterValues: mutableRegisterValues,  rollingInstructions: updatedRollingInstructions)
        case .subtracted:
            let newValueAtX = localX - localY
            let registerAtX = actualInstruction.xRegister!
            mutableRegisterValues.updateValue(newValueAtX, forKey: registerAtX)
            let updatedIndex = index + 1

            return requestInstructionExecutionOrder(startingAt:updatedIndex,  withRegisterValues: mutableRegisterValues,  rollingInstructions: updatedRollingInstructions)
        case .updated:
            let newValueAtX = localY
            let registerAtX = actualInstruction.xRegister!
            mutableRegisterValues.updateValue(newValueAtX, forKey: registerAtX)
            let updatedIndex = index + 1

            return requestInstructionExecutionOrder(startingAt:updatedIndex,  withRegisterValues: mutableRegisterValues,  rollingInstructions: updatedRollingInstructions)
        case .jumped:
            let updatedIndex = index + 1

            return requestInstructionExecutionOrder(startingAt:updatedIndex,  withRegisterValues: withRegisterValues,  rollingInstructions: updatedRollingInstructions)
        }
    }

}