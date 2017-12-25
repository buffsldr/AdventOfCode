//
//  DeserializeRawData.swift
//  AdventOfCode
//
//  Created by Mark Vader on 12/24/17.
//  Copyright © 2017 Mark Vader. All rights reserved.
//

import Foundation

final class DeserializeRawData {

    static func processFrom(fileUrl: URL) throws -> [RealInstruction] {
        let rawLines = try! String(contentsOf: fileUrl, encoding: .utf8).components(separatedBy: "\n").filter({ theStrings -> Bool in
            return theStrings.count > 0
        })

        let instructions = try rawLines.map { rawLine -> RealInstruction in
            do {
                let lineArray = rawLine.components(separatedBy: .whitespaces)

                if let yValueFound = Int(lineArray[2]), lineArray[0] == "jnz" {
                    if let xValueFound = Int(lineArray[1]) {
                        let rawJSONString = """
                            {
                            "action": "\(lineArray[0])",
                            "xValue": \(xValueFound),
                            "yValue": \(yValueFound)
                            }
                            """
                        let rawJSONData = rawJSONString.data(using: .utf8)!

                        return try JSONDecoder().decode(RealInstruction.self, from: rawJSONData)
                    } else {
                        // it is a register
                        let rawJSONString = """
                        {
                        "action": "\(lineArray[0])",
                        "xRegister": "\(lineArray[1])",
                        "yValue": \(yValueFound)
                        }
                        """

                        let rawJSONData = rawJSONString.data(using: .utf8)!
                        return try JSONDecoder().decode(RealInstruction.self, from: rawJSONData)
                    }

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
            } catch DecodingError.dataCorrupted(_) {
                throw ColumnReadError.yValueMissing
            } catch {
                throw ColumnReadError.yValueMissing
            }
        }

        return instructions
    }

}
