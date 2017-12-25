
//
//  Day23.swift
//  test
//
//  Created by Dave DeLong on 12/22/17.
//  Copyright © 2017 Dave DeLong. All rights reserved.
//

import Foundation

protocol Day {
    init()
    func run() -> (String, String)

    func part1() -> String
    func part2() -> String

}

extension Day {

    static func rawInput(_ callingFrom: StaticString = #file) -> String {
        var components = ("\(callingFrom)" as NSString).pathComponents
        _ = components.removeLast()
        components.append("file.txt")
        let path = NSString.path(withComponents: components)
        return try! String(contentsOf: URL(fileURLWithPath: path))
    }

    static func trimmedInput(_ callingFrom: StaticString = #file) -> String {
        return rawInput(callingFrom).trimmingCharacters(in: .whitespacesAndNewlines)
    }

    static func inputLines(trimming: Bool = true, _ callingFrom: StaticString = #file) -> Array<String> {
        let i = trimming ? trimmedInput(callingFrom) : rawInput(callingFrom)
        let g = i.components(separatedBy: .newlines)

        return g
    }

    static func inputCharacters(trimming: Bool = true, _ callingFrom: StaticString = #file) -> Array<Array<Character>> {
        return inputLines(trimming: trimming, callingFrom).map { Array($0) }
    }

    func run() -> (String, String) {
        return (part1(), part2())
    }
    func part1() -> String { return "implement me!" }
    func part2() -> String { return "implement me!" }

}


class Day23: Day {

    typealias Registers = Dictionary<String, Int>

    enum Instruction {
        enum Arg {
            case register(String)
            case value(Int)

            init(_ string: String) {
                if let i = Int(string) {
                    self = .value(i)
                } else {
                    self = .register(string)
                }
            }

            func eval(with registers: Registers) -> Int {
                switch self {
                case .register(let r):
                    let theAnswer = registers[r] ?? 0
                    if r == "b" && theAnswer == 1 {


                        print("Bingo")
                    }
                    return theAnswer
                case .value(let i):
                    return i
                }
            }
        }

        case set(String, Arg)
        case sub(String, Arg)
        case mul(String, Arg)
        case jump(Arg, Arg)

        init(_ s: String) {
            self.init(args: s.components(separatedBy: .whitespaces))
        }

        init(args: Array<String>) {
            switch args[0] {
            case "set": self = .set(args[1], Arg(args[2]))
            case "sub": self = .sub(args[1], Arg(args[2]))
            case "mul": self = .mul(args[1], Arg(args[2]))
            case "jnz": self = .jump(Arg(args[1]), Arg(args[2]))
            default: fatalError()
            }
        }

    }
    class Program {
        private var reg = Registers()
        private let instructions: Array<Instruction>
        private var index = 0 {
            didSet {
                if index == 19 {

//                    print("heading to 19")
                }
            }
        }

        var mulCount = 0

        enum Result {
            case ok
            case done
        }

        init(instructions: Array<Instruction>) {
            self.instructions = instructions
        }

        func step() -> Result {
            // return .waiting if we rcv but don't have a value
//            print("Dave at \(index)")

            guard index < instructions.count else {

              print("index at catch is \(index)")
                print("Dave Found count to be \(mulCount)")

                return .done
            }
            let inst = instructions[index]
            switch inst {
            case .set(let r, let arg):
                index += 1
                let newValueAtX = arg.eval(with: reg)
//                print("Dave says set to  newXvalue of \(newValueAtX)")

                reg[r] = arg.eval(with: reg)
            case .sub(let r, let arg):
                index += 1
                let newValueAtX = reg[r, default: 0] - arg.eval(with: reg)

                reg[r, default: 0] -= arg.eval(with: reg)
            case .mul(let r, let arg):
                index += 1
                mulCount += 1
                let newValueAtX = reg[r, default: 0] * arg.eval(with: reg)

//                print("Dave says multiply to  newXvalue of \(newValueAtX)")

                reg[r, default: 0] *= arg.eval(with: reg)
            case .jump(let r, let arg):
                let val = r.eval(with: reg)
                if val != 0 {
                    index += arg.eval(with: reg)
//                    print("Dave says jump to \(index)")
                } else {
                    let updatedIndex = index + 1
//                    print("Dave says benign jump to  newXvalue to \(updatedIndex)")

                    index += 1
                }
            }
            return .ok
        }
    }

    required init() { }

    func part1() -> String {
        let instructions = Day23.inputLines().map { Instruction($0) }
        let p = Program(instructions: instructions)
        while p.step() == .ok { }
        return "\(p.mulCount)"
    }

    func part2() -> String {
        func isComposite(_ i: Int) -> Bool {
            for d in 2 ... Int(sqrt(Double(i))) {
                if i % d == 0 { return true }
            }
            return false
        }

        let count = stride(from: 109900, through: 126900, by: 17).filter(isComposite).count
        return "\(count)"
    }

}

extension Day {
    fileprivate func execute() -> TimeInterval {
        print("============ \(type(of: self)) ============")

        let (duration, results) = autoreleasepool { () -> (TimeInterval, (String, String)) in
            let start = Date()
            let results = self.run()
            return (Date().timeIntervalSince(start), results)
        }


        print("part 1: \(results.0)")
        print("part 2: \(results.1)")
//        print("time: \(durationFormatter.string(from: duration as NSNumber) ?? "0.0")s")
        print("\n")
        return duration
    }
}
