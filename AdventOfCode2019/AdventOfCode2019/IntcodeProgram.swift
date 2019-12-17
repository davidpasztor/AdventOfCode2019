//
//  IntcodeProgram.swift
//  AdventOfCode2019
//
//  Created by David Pasztor on 05/12/2019.
//  Copyright © 2019 David Pasztor. All rights reserved.
//

import Foundation



struct IntcodeProgram {
    let input: Int
    var memory: [Int]
    var output: Int

    init(input: Int, memory: [Int]) {
        self.input = input
        self.memory = memory
        self.output = input
    }

    mutating func execute() -> [Int] {
        // Instruction pointer of the program
        var ip = memory.indices.lowerBound
        while ip < memory.indices.upperBound - 1 {
            let instruction = Instruction(rawInput: memory[ip])
            switch instruction.operation {
            case .add, .multiply:
                let lhsOperand: Int
                switch instruction.parameterMode[0] {
                case .immediate:
                    lhsOperand = memory[ip + 1]
                case .position:
                    lhsOperand = memory[memory[ip + 1]]
                }
                let rhsOperand: Int
                switch instruction.parameterMode[1] {
                case .immediate:
                    rhsOperand = memory[ip + 2]
                case .position:
                    rhsOperand = memory[memory[ip + 2]]
                }
                if let result = instruction.operation.performOperation(lhs: lhsOperand, rhs: rhsOperand) {
                    let resultIndex = memory[ip + 3]
                    memory[resultIndex] = result
                }
                ip += 4
            case .save:
                let address = memory[ip + 1]
                memory[address] = input
                ip += 2
            case .output:
                let address: Int
                switch instruction.parameterMode[0] {
                case .immediate:
                    address = ip + 1
                case .position:
                    address = memory[ip + 1]
                }
                output = memory[address]
                ip += 2
                print(output)
            case .finished:
                return memory
            }
        }
        return memory
    }
}

private struct Instruction {
    let operation: OpCode
    let parameterMode: [OpCode.ParameterMode]
    let instructionPointerOffset: Int

    init(rawInput: Int) {
        let digits = String(rawInput).map { Int(String($0))! }
        let rawParameterModes: [Int]
        if digits.count == 1 {
            let rawOpCode = digits[0]
            guard let opCode = OpCode(rawValue: rawOpCode) else {
                fatalError("Incorrect 1-digit OpCode encountered: \(rawOpCode)")
            }
            rawParameterModes = [0,0,0]
            self.operation = opCode
        } else {
            // Need to take last 2 elements, not first 2!
            let opCodeDigits = Array(digits.reversed().prefix(2))
            let rawOpCode = 10 * opCodeDigits[1] + opCodeDigits[0]
            guard let opCode = OpCode(rawValue: rawOpCode) else {
                fatalError("Incorrect 2-digit OpCode encountered: \(rawOpCode)")
            }
            rawParameterModes = Array((digits.dropLast(2).reversed() + [0,0,0]).prefix(3))
            self.operation = opCode
        }
        switch self.operation {
        case .add, .multiply:
            self.parameterMode = rawParameterModes.map { OpCode.ParameterMode(rawValue: $0)! }
            self.instructionPointerOffset = 4
        case .output:
            let rawParameterMode: Int
            if digits.count == 1 {
                rawParameterMode = 0
            } else {
                rawParameterMode = digits[0]
            }
            self.parameterMode = [OpCode.ParameterMode(rawValue: rawParameterMode)!]
            self.instructionPointerOffset = 2
        case .save:
            self.parameterMode = [.position]
            self.instructionPointerOffset = 2
        case .finished:
            self.parameterMode = []
            self.instructionPointerOffset = 1
        }
    }
}

/// Operation code for an Intcode program
private enum OpCode: Int {
    /// Adds together numbers read from two positions and stores the result in a third position. The three integers immediately after the opcode tell you these three positions - the first two indicate the positions from which you should read the input values, and the third indicates the position at which the output should be stored
    /// - For example, if your `Intcode` computer encounters `1,10,20,30`, it should read the values at positions 10 and 20, add those values, and then overwrite the value at position 30 with their sum.
    case add = 1
    /// Opcode 2 works exactly like opcode 1, except it multiplies the two inputs instead of adding them. Again, the three integers after the opcode indicate where the inputs and outputs are, not their values.
    case multiply = 2
    /// Takes a single integer input and saves it to the address given by its parameter
    case save = 3
    /// Outputs the value at the address given by its parameter
    case output = 4
    /// The program is finished and should immediately halt
    case finished = 99

    func performOperation(lhs: Int, rhs: Int) -> Int? {
        switch self {
        case .add:
            return lhs + rhs
        case .multiply:
            return lhs * rhs
        case .finished, .output, .save:
            return nil
        }
    }
}

extension OpCode {
    /// Determines the way the parameter of an `OpCode` is interpreted
    enum ParameterMode: Int {
        /// Interpret the parameter as a position
        case position = 0
        /// Interpret the parameter as a value
        /// - if the parameter is 50, its value is simply 50
        case immediate = 1
    }
}
