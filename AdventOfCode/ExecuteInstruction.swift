//
//  ExecuteInstruction.swift
//  AdventOfCode
//
//  Created by Mark Vader on 12/24/17.
//  Copyright © 2017 Mark Vader. All rights reserved.
//

import Foundation

final class ExecuteInstruction {

    private var simpleDictionary = [String: Int]()
    let instructionList: [RealInstruction]
     var multiplyCount = 0
    var index = 0

    init(instructionList: [RealInstruction]){
        self.instructionList = instructionList
    }

    enum Result {
        case ok
        case done
    }

    func step() -> Result {

        guard index < instructionList.count else {

            print("index at catch is \(index)")
            return .done
        }
        //        print("Mark at \(index)")
        let actualInstruction = instructionList[index]
        let localX = actualInstruction.requestXValueFrom(registerValues: simpleDictionary)
        let localY = actualInstruction.requestYValueFrom(registerValues: simpleDictionary)

        switch actualInstruction.action {
        case .jumped where localX != 0:
            index += localY
            //            print("Mark says jump to \(updatedIndex)")

        case .jumped:
            index += 1
            //            print("Mark says benign jump to  newXvalue to \(updatedIndex)")

        case .multiplied:
            let newValueAtX = localX * localY
            let registerAtX = actualInstruction.xRegister!
            simpleDictionary[registerAtX.rawValue] = newValueAtX
            index += 1
            //            print("Mark says multiply to  newXvalue of \(newValueAtX)")
            multiplyCount+=1

        case .subtracted:
            let newValueAtX = localX - localY
            let registerAtX = actualInstruction.xRegister!
            simpleDictionary[registerAtX.rawValue] = newValueAtX
            index += 1
            //            print("Mark says subtract to get newXvalue of \(newValueAtX)")

        case .updated:
            let newValueAtX = localY
            let registerAtX = actualInstruction.xRegister!
            simpleDictionary[registerAtX.rawValue] = newValueAtX
            index += 1
            //            print("Mark says update to  newXvalue of \(newValueAtX)")

        }

        return .ok
    }

}
