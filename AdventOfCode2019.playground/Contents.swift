import Foundation

// Day 1 - https://adventofcode.com/2019/day/1

func fuelRequirements(for mass: Int) -> Int {
    return mass / 3 - 2
}

fuelRequirements(for: 12)
fuelRequirements(for: 14)
fuelRequirements(for: 1969)
fuelRequirements(for: 100756)

func solvePuzzle1() -> Int? {
    do {
        let inputNumbers = try parseInput(day: 1, separator: .newlines)
        let totalFuelRequirements = inputNumbers.reduce(0, { currentResult, input in
            return currentResult + fuelRequirements(for: input)
        })
        return totalFuelRequirements
    } catch {
        error
        return nil
    }
}

solvePuzzle1()

/* Day 1 Part 2 */

func complexFuelRequirements(for mass: Int) -> Int {
    let fuel = fuelRequirements(for: mass)
    if fuel <= 0 {
        return 0
    } else {
        return fuel + complexFuelRequirements(for: fuel)
    }
}

complexFuelRequirements(for: 14)
complexFuelRequirements(for: 1969)
complexFuelRequirements(for: 100756)

func solvePuzzle1Pt2() -> Int? {
    do {
        let inputNumbers = try parseInput(day: 1, separator: .newlines)
        let totalFuelRequirements = inputNumbers.reduce(0, { currentResult, input in
            return currentResult + complexFuelRequirements(for: input)
        })
        return totalFuelRequirements
    } catch {
        error
        return nil
    }
}

solvePuzzle1Pt2()

// Day 2 - https://adventofcode.com/2019/day/2
/// Operation code for an Intcode program
enum OpCode: Int {
    /// Adds together numbers read from two positions and stores the result in a third position. The three integers immediately after the opcode tell you these three positions - the first two indicate the positions from which you should read the input values, and the third indicates the position at which the output should be stored
    /// - For example, if your `Intcode` computer encounters `1,10,20,30`, it should read the values at positions 10 and 20, add those values, and then overwrite the value at position 30 with their sum.
    case add = 1
    // Opcode 2 works exactly like opcode 1, except it multiplies the two inputs instead of adding them. Again, the three integers after the opcode indicate where the inputs and outputs are, not their values.
    case multiply = 2
    /// The program is finished and should immediately halt
    case finished = 99
}

func restoreIntcodeComputer(from faultyProgram: [Int]) -> [Int] {
    var finishedProgram = faultyProgram
    for opCodeIndex in stride(from: finishedProgram.indices.lowerBound, through: finishedProgram.indices.upperBound, by: 4) {
        let opCode = OpCode(rawValue: finishedProgram[opCodeIndex])!
        switch opCode {
        case .add:
            let resultIndex = finishedProgram[opCodeIndex + 3]
            let lhsIndex = finishedProgram[opCodeIndex + 1]
            let rhsIndex = finishedProgram[opCodeIndex + 2]
            finishedProgram[resultIndex] = finishedProgram[lhsIndex] + finishedProgram[rhsIndex]
        case .multiply:
            let resultIndex = finishedProgram[opCodeIndex + 3]
            let lhsIndex = finishedProgram[opCodeIndex + 1]
            let rhsIndex = finishedProgram[opCodeIndex + 2]
            finishedProgram[resultIndex] = finishedProgram[lhsIndex] * finishedProgram[rhsIndex]
        case .finished:
            return finishedProgram
        }
    }
    return finishedProgram
}

restoreIntcodeComputer(from: [1,0,0,0,99]) // expected 2,0,0,0,99
restoreIntcodeComputer(from: [2,3,0,3,99]) // expected 2,3,0,6,99
restoreIntcodeComputer(from: [2,4,4,5,99,0]) // expected 2,4,4,5,99,9801
restoreIntcodeComputer(from: [1,1,1,4,99,5,6,0,99]) // expected 30,1,1,4,2,5,6,0,99

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
        error
        return nil
    }
}

solvePuzzle2Pt1()
