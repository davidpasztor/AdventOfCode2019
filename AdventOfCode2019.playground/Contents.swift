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

func solvePuzzle2Pt1() -> Int? {
    do {
        let comma = CharacterSet(charactersIn: "-")
        let input = try parseInput(day: 2, separator: comma)
        
        return input[0]
    } catch {
        error
        return nil
    }
}
