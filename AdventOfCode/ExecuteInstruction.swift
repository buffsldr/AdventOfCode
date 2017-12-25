//
//  ExecuteInstruction.swift
//  AdventOfCode
//
//  Created by Mark Vader on 12/24/17.
//  Copyright © 2017 Mark Vader. All rights reserved.
//

import Foundation

struct ExecuteInstruction {

    static func requestInstructionExecutionOrder(startingAt index:Int, withRegisterValues: RegisterValues, rollingInstructions: [RealInstruction], instructionList: [RealInstruction]) -> [RealInstruction] {
        if index == 0 && rollingInstructions.count != 0 {
            return rollingInstructions
        }
        guard index < instructionList.count && index > -1 else {
            return rollingInstructions
        }
        let actualInstruction = instructionList[index]
        let localX = actualInstruction.requestXValueFrom(registerValues: withRegisterValues)
        let localY = actualInstruction.requestYValueFrom(registerValues: withRegisterValues)
        var mutableRegisterValues = withRegisterValues
        let updatedRollingInstructions = rollingInstructions + [actualInstruction]

        switch actualInstruction.action {
        case .jumped where localX != 0:
            let updatedIndex = index + localY
//            print("Mark says jump to \(updatedIndex)")
            let instructionListCopy = instructionList

            return  ExecuteInstruction.requestInstructionExecutionOrder(startingAt:updatedIndex,  withRegisterValues: withRegisterValues,  rollingInstructions: updatedRollingInstructions, instructionList: instructionListCopy)
        case .jumped:
            let updatedIndex = index + 1
            let instructionListCopy = instructionList
//            print("Mark says benign jump to  newXvalue to \(updatedIndex)")

            return ExecuteInstruction.requestInstructionExecutionOrder(startingAt:updatedIndex,  withRegisterValues: withRegisterValues,  rollingInstructions: updatedRollingInstructions, instructionList: instructionListCopy)
        case .multiplied:
            let newValueAtX = localX * localY
            let registerAtX = actualInstruction.xRegister!
            mutableRegisterValues[registerAtX] = newValueAtX
            let updatedIndex = index + 1
            let instructionListCopy = instructionList
//            print("Mark says multiply to  newXvalue of \(newValueAtX)")

            return ExecuteInstruction.requestInstructionExecutionOrder(startingAt:updatedIndex,  withRegisterValues: mutableRegisterValues,  rollingInstructions: updatedRollingInstructions, instructionList: instructionListCopy)
        case .subtracted:
            let newValueAtX = localX - localY
            let registerAtX = actualInstruction.xRegister!
            mutableRegisterValues[registerAtX] = newValueAtX
            let updatedIndex = index + 1
            let instructionListCopy = instructionList
//            print("Mark says subtract to get newXvalue of \(newValueAtX)")

            return ExecuteInstruction.requestInstructionExecutionOrder(startingAt:updatedIndex,  withRegisterValues: mutableRegisterValues,  rollingInstructions: updatedRollingInstructions, instructionList: instructionListCopy)
        case .updated:
            let newValueAtX = localY
            let registerAtX = actualInstruction.xRegister!
            mutableRegisterValues[registerAtX] = newValueAtX
            let updatedIndex = index + 1
            let instructionListCopy = instructionList
//            print("Mark says update to  newXvalue of \(newValueAtX)")

            return ExecuteInstruction.requestInstructionExecutionOrder(startingAt:updatedIndex,  withRegisterValues: mutableRegisterValues,  rollingInstructions: updatedRollingInstructions, instructionList: instructionListCopy)
        }
    }

}
