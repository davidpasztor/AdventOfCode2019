//
//  Day1.swift
//  AdventOfCode2019
//
//  Created by David Pasztor on 04/12/2019.
//  Copyright © 2019 David Pasztor. All rights reserved.
//

import Foundation

// Day 1 - https://adventofcode.com/2019/day/1

func fuelRequirements(for mass: Int) -> Int {
    return mass / 3 - 2
}

func solvePuzzle1Pt1() -> Int? {
    do {
        let inputNumbers = try parseInput(day: 1, separator: .newlines)
        let totalFuelRequirements = inputNumbers.reduce(0, { currentResult, input in
            return currentResult + fuelRequirements(for: input)
        })
        return totalFuelRequirements
    } catch {
        print(error)
        return nil
    }
}

/* Day 1 Part 2 */

func complexFuelRequirements(for mass: Int) -> Int {
    let fuel = fuelRequirements(for: mass)
    if fuel <= 0 {
        return 0
    } else {
        return fuel + complexFuelRequirements(for: fuel)
    }
}


func runDay1Examples() {
    let examples = [12, 14, 1969, 100756]
    examples.forEach {
        print("fuelRequirement for \($0) is \(fuelRequirements(for: $0))")
        print("complexFuelRequirement for \($0) is \(complexFuelRequirements(for: $0))")
    }
}

func solvePuzzle1Pt2() -> Int? {
    do {
        let inputNumbers = try parseInput(day: 1, separator: .newlines)
        let totalFuelRequirements = inputNumbers.reduce(0, { currentResult, input in
            return currentResult + complexFuelRequirements(for: input)
        })
        return totalFuelRequirements
    } catch {
        print(error)
        return nil
    }
}
