//
//  ViewController.swift
//  AdventOfCode
//
//  Created by Mark Vader on 12/23/17.
//  Copyright © 2017 Mark Vader. All rights reserved.
//
// test
import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var multiplyCountLabel: UILabel?

    @IBAction func runItTapped(_ sender: UIButton) {
//        let g12214 = Day23().run()


        guard let fileUrl = Bundle.main.url(forResource: "file", withExtension: "txt") else { fatalError() }
        let list = try! DeserializeRawData.processFrom(fileUrl: fileUrl)
        let startingRegisterValues: RegisterValues = [ Register.a: 0,
                                                       Register.b: 0,
                                                       Register.c: 0,
                                                       Register.d: 0,
                                                       Register.e: 0,
                                                       Register.f: 0,
                                                       Register.g: 0,
                                                       Register.h: 0
        ]

        let allInstructions = ExecuteInstruction.requestInstructionExecutionOrder(startingAt: 0, withRegisterValues: startingRegisterValues, rollingInstructions: [], instructionList: list)
        let multiplyInstructions = allInstructions.filter { instruction -> Bool in
            return instruction.action == Action.multiplied
        }

        let countFound = multiplyInstructions.count

        let countString = String(countFound)

        multiplyCountLabel?.text = countString
    }

}
