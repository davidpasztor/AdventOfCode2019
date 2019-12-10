//
//  Day2.swift
//  AdventOfCode2019
//
//  Created by David Pasztor on 04/12/2019.
//  Copyright © 2019 David Pasztor. All rights reserved.
//

import Foundation

// Day 2 - https://adventofcode.com/2019/day/2
/// Operation code for an Intcode program
private enum OpCode: Int {
    /// Adds together numbers read from two positions and stores the result in a third position. The three integers immediately after the opcode tell you these three positions - the first two indicate the positions from which you should read the input values, and the third indicates the position at which the output should be stored
    /// - For example, if your `Intcode` computer encounters `1,10,20,30`, it should read the values at positions 10 and 20, add those values, and then overwrite the value at position 30 with their sum.
    case add = 1
    // Opcode 2 works exactly like opcode 1, except it multiplies the two inputs instead of adding them. Again, the three integers after the opcode indicate where the inputs and outputs are, not their values.
    case multiply = 2
    /// The program is finished and should immediately halt
    case finished = 99

    func performOperation(lhs: Int, rhs: Int) -> Int? {
        switch self {
        case .add:
            return lhs + rhs
        case .multiply:
            return lhs * rhs
        case .finished:
            return nil
        }
    }
}

func restoreIntcodeComputer(from faultyProgram: [Int]) -> [Int] {
    var finishedProgram = faultyProgram
    for opCodeIndex in stride(from: finishedProgram.indices.lowerBound, through: finishedProgram.indices.upperBound, by: 4) {
        let opCode = OpCode(rawValue: finishedProgram[opCodeIndex])!
        switch opCode {
        case .add, .multiply:
            let lhsIndex = finishedProgram[opCodeIndex + 1]
            let rhsIndex = finishedProgram[opCodeIndex + 2]
            if let result = opCode.performOperation(lhs: finishedProgram[lhsIndex], rhs: finishedProgram[rhsIndex]) {
                let resultIndex = finishedProgram[opCodeIndex + 3]
                finishedProgram[resultIndex] = result
            }
        case .finished:
            return finishedProgram
        }
    }
    return finishedProgram
}

func runDay2Examples() {
    print(restoreIntcodeComputer(from: [1,0,0,0,99])) // expected 2,0,0,0,99
    print(restoreIntcodeComputer(from: [2,3,0,3,99])) // expected 2,3,0,6,99
    print(restoreIntcodeComputer(from: [2,4,4,5,99,0])) // expected 2,4,4,5,99,9801
    print(restoreIntcodeComputer(from: [1,1,1,4,99,5,6,0,99])) // expected 30,1,1,4,2,5,6,0,99

}

func solvePuzzle2Pt1() -> Int? {
    do {
        let comma = CharacterSet(charactersIn: ",")
        let faultyProgram = try parseInput(day: 2, separator: comma)
        // Restore program state
        var restoredProgram = faultyProgram
        restoredProgram[1] = 12
        restoredProgram[2] = 2
        let finishedProgram = restoreIntcodeComputer(from: restoredProgram)
        return finishedProgram[0]
    } catch {
        print(error)
        return nil
    }
}

struct Pair<Element> {
    let left: Element
    let right: Element
}

extension Pair: Equatable where Element: Equatable {}
extension Pair: Hashable where Element: Hashable {}

func solvePuzzle2Pt2() -> Int? {
    do {
        let comma = CharacterSet(charactersIn: ",")
        let faultyProgram = try parseInput(day: 2, separator: comma)
        let inputRange = 0...99
        var nounsAndVerbs = Set<Pair<Int>>()
        for noun in inputRange {
            for verb in inputRange {
                nounsAndVerbs.insert(.init(left: noun, right: verb))
            }
        }
        for current in nounsAndVerbs {
            var restoredProgram = faultyProgram
            restoredProgram[1] = current.left
            restoredProgram[2] = current.right
            let finishedProgram = restoreIntcodeComputer(from: restoredProgram)
            let output = finishedProgram[0]
            if output == 19690720 {
                return 100 * current.left + current.right
            }
        }
        return nil
    } catch {
        print(error)
        return nil
    }
}
