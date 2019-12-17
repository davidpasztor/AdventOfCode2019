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

    /// Returns the address in `memory` for an operand of an `Instruction`, based on teh current `instructionPointer` and the index of the parameter
    private func addressForOperand(parameterMode: OpCode.ParameterMode, instructionPointer: Int, parameterIndex: Int) -> Int {
        let index = instructionPointer + parameterIndex
        switch parameterMode {
        case .immediate:
            return index
        case .position:
            return memory[index]
        }
    }

    /// Returns the addresses in `memory` for all operands of `instruction` based on the current state of the `instructionPointer`
    private func addressForOperands(of instruction: Instruction, instructionPointer ip: Int) -> [Int] {
        switch instruction.operation.parameterCount {
        case 3:
            let lhsOperandAddress = addressForOperand(parameterMode: instruction.parameterMode[0], instructionPointer: ip, parameterIndex: 1)
            let rhsOperandAddress = addressForOperand(parameterMode: instruction.parameterMode[1], instructionPointer: ip, parameterIndex: 2)
            let resultAddress = addressForOperand(parameterMode: instruction.parameterMode[2], instructionPointer: ip, parameterIndex: 3)
            return [lhsOperandAddress, rhsOperandAddress, resultAddress]
        case 2:
            let lhsOperandAddress = addressForOperand(parameterMode: instruction.parameterMode[0], instructionPointer: ip, parameterIndex: 1)
            let rhsOperandAddress = addressForOperand(parameterMode: instruction.parameterMode[1], instructionPointer: ip, parameterIndex: 2)
            return [lhsOperandAddress, rhsOperandAddress]
        case 1:
            let address = addressForOperand(parameterMode: instruction.parameterMode[0], instructionPointer: ip, parameterIndex: 1)
            return [address]
        default:
            return []
        }
    }

    mutating func execute() {
        /// Instruction pointer of the program
        var ip = memory.indices.lowerBound
        while ip < memory.indices.upperBound - 1 {
            let instruction = Instruction(rawInput: memory[ip])
            let operandAddresses = addressForOperands(of: instruction, instructionPointer: ip)
            switch instruction.operation {
            case .add, .equals, .lessThan, .multiply:
                let lhsOperand = memory[operandAddresses[0]]
                let rhsOperand = memory[operandAddresses[1]]
                let resultAddress = operandAddresses[2]
                if let result = instruction.operation.performOperation(lhs: lhsOperand, rhs: rhsOperand) {
                    memory[resultAddress] = result
                }
            case .jumpIfFalse:
                let firstOperand = memory[operandAddresses[0]]
                let secondOperand = memory[operandAddresses[1]]
                if firstOperand == 0 {
                    // Will be increased by instruction.instructionPointerOffset, so to achieve a jump to `secondOperand`, we need to counteract the later increase
                    ip = secondOperand - instruction.instructionPointerOffset
                }
            case .jumpIfTrue:
                let firstOperand = memory[operandAddresses[0]]
                let secondOperand = memory[operandAddresses[1]]
                if firstOperand != 0 {
                    // Will be increased by instruction.instructionPointerOffset, so to achieve a jump to `secondOperand`, we need to counteract the later increase
                    ip = secondOperand - instruction.instructionPointerOffset
                }
            case .save:
                let saveAddress = operandAddresses[0]
                memory[saveAddress] = input
            case .output:
                let outputAddress = operandAddresses[0]
                output = memory[outputAddress]
            case .finished:
                return
            }
            ip += instruction.instructionPointerOffset
        }
    }
}

/// Instruction for an Intcode program
private struct Instruction {
    let operation: OpCode
    /// The parameter mode for each parameter of the operation (the number of elements of `parameterMode` equals the number of parameters of the operation)
    let parameterMode: [OpCode.ParameterMode]
    /// Determines by how much the instruction pointer needs to be offset after `Instruction` was executed, depending on the number of parameters the `operation` takes
    let instructionPointerOffset: Int

    /**
     Initialise an `Instruction` from a single `Int`, which can have 1-5 digits. The last two digits represents the `OpCode`.
     The first 3 digits represent the parameter modes for each parameter of the operation. If a parameter mode digit is missing, its default value is 0 and leading 0s are omitted.
        - parameter rawInput: the 1-5 digit raw representation of the `Instruction`
     */
    init(rawInput: Int) {
        // TODO: use `OpCode.parameterCount` to init `parameterMode`
        let defaultParameterModes = [0,0,0]
        let digits = String(rawInput).map { Int(String($0))! }
        let rawParameterModes: [Int]
        if digits.count == 1 {
            let rawOpCode = digits[0]
            guard let opCode = OpCode(rawValue: rawOpCode) else {
                fatalError("Incorrect 1-digit OpCode encountered: \(rawOpCode)")
            }
            rawParameterModes = defaultParameterModes
            self.operation = opCode
        } else {
            // Need to take last 2 elements, not first 2!
            let opCodeDigits = Array(digits.reversed().prefix(2))
            let rawOpCode = 10 * opCodeDigits[1] + opCodeDigits[0]
            guard let opCode = OpCode(rawValue: rawOpCode) else {
                fatalError("Incorrect 2-digit OpCode encountered: \(rawOpCode)")
            }
            // An instruction can have up to 3 parameters and hence parameter modes. The parameter modes are in reverse order, but we store them in the correct order. We also need to make sure omitted parameter modes are initialised with the correct default value
            rawParameterModes = Array((digits.dropLast(2).reversed() + defaultParameterModes).prefix(3))
            self.operation = opCode
        }
        switch self.operation {
        case .add, .equals, .lessThan, .multiply:
            self.parameterMode = rawParameterModes.map { OpCode.ParameterMode(rawValue: $0)! }
            self.instructionPointerOffset = 4
        case .jumpIfTrue, .jumpIfFalse:
            self.parameterMode = rawParameterModes.map { OpCode.ParameterMode(rawValue: $0)! }
            self.instructionPointerOffset = 3
        case .output:
            let rawParameterMode: Int
            if digits.count == 1 {
                rawParameterMode = defaultParameterModes[0]
            } else { // An output instruction has only 1 input parameter, so it can only have 1 input parameter opcode
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
    /// If the first parameter is non-zero, set the instruction pointer to the value from the second parameter. Otherwise does nothing
    case jumpIfTrue = 5
    /// If the first parameter is zero, set the instruction pointer to the value from the second parameter. Otherwise does nothing
    case jumpIfFalse = 6
    /// If the first parameter is less than the second parameter, it stores 1 in the position given by the third parameter. Otherwise, it stores 0.
    case lessThan = 7
    /// If the first parameter is equal to the second parameter, it stores 1 in the position given by the third parameter. Otherwise, it stores 0.
    case equals = 8
    /// The program is finished and should immediately halt
    case finished = 99

    func performOperation(lhs: Int, rhs: Int) -> Int? {
        switch self {
        case .add:
            return lhs + rhs
        case .equals:
            return lhs == rhs ? 1 : 0
        case .lessThan:
            return lhs < rhs ? 1 : 0
        case .multiply:
            return lhs * rhs
        case .finished, .output, .save, .jumpIfTrue, .jumpIfFalse:
            return nil
        }
    }

    /// Determines how many parameters the operation takes
    var parameterCount: Int {
        switch self {
        case .add, .multiply, .lessThan, .equals:
            return 3
        case .jumpIfFalse, .jumpIfTrue:
            return 2
        case .save, .output:
            return 1
        case .finished:
            return 0
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
