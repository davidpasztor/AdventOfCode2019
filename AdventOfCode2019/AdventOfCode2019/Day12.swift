//
//  Day12.swift
//  AdventOfCode2019
//
//  Created by David Pasztor on 12/12/2019.
//  Copyright © 2019 David Pasztor. All rights reserved.
//

import Foundation

/// Position of a moon in space
struct MoonPosition: Hashable {
    let x: Int
    let y: Int
    let z: Int

    /// Calculates the gravitational velocity exerted by `otherMoon`
    func calculateGravity(from otherMoon: MoonPosition) -> MoonVelocity {
        func calculateVelocity(position: Int, otherPosition: Int) -> Int {
            if position > otherPosition {
                return -1
            } else if position == otherPosition {
                return 0
            } else {
                return 1
            }
        }
        let xVelocity = calculateVelocity(position: x, otherPosition: otherMoon.x)
        let yVelocity = calculateVelocity(position: y, otherPosition: otherMoon.y)
        let zVelocity = calculateVelocity(position: z, otherPosition: otherMoon.z)
        return MoonVelocity(dx: xVelocity, dy: yVelocity, dz: zVelocity)
    }

    /// Apply `velocity` to `position`
    func applyVelocity(_ velocity: MoonVelocity) -> MoonPosition {
        return MoonPosition(x: x + velocity.dx, y: y + velocity.dy, z: z + velocity.dz)
    }
}

extension MoonPosition: CustomStringConvertible {
    var description: String {
        return "(x: \(x), y: \(y), z: \(z))"
    }
}

/// Velocity of a moon in space
struct MoonVelocity: Hashable {
    let dx: Int
    let dy: Int
    let dz: Int

    /// Initialize a `MoonVelocity` for which all components are `0`
    static var zero: MoonVelocity {
        return MoonVelocity(dx: 0, dy: 0, dz: 0)
    }

    /// Add together two moon velocities
    static func + (lhs: MoonVelocity, rhs: MoonVelocity) -> MoonVelocity {
        return MoonVelocity(dx: lhs.dx + rhs.dx, dy: lhs.dy + rhs.dy, dz: lhs.dz + rhs.dz)
    }

    /// Add together two moon velocities and assign them to the `lhs` operand
    static func += (lhs: inout MoonVelocity, rhs: MoonVelocity) {
        lhs = lhs + rhs
    }
}

extension MoonVelocity: CustomStringConvertible {
    var description: String {
        return "(x: \(dx), y: \(dy), z: \(dz))"
    }
}

/// Represents a `Moon`
class Moon {
    /// Current position of the moon
    var position: MoonPosition
    /// Current velocity of the moon
    var velocity: MoonVelocity

    /// Initialise with a position and velocity
    /// - parameter position: initial position of the Moon
    /// - parameter velocity: initial velocity, default value is `.zero`
    init(position: MoonPosition, velocity: MoonVelocity = .zero) {
        self.position = position
        self.velocity = velocity
    }

    /// Calculates the total gravitational velocity exerted on this moon by all other moons
    /// - parameter otherMoons: all other moons in the system exerting gravity on this moon
    func calculateTotalGravity(from otherMoons: [Moon]) -> MoonVelocity {
        return otherMoons.reduce(into: MoonVelocity.zero, { $0 += position.calculateGravity(from: $1.position) })
    }

    /// Update the `position` of the moon by applying its current `velocity` to it
    func applyVelocity() {
        position = position.applyVelocity(velocity)
    }

    var potentialEnergy: Int {
        return abs(position.x) + abs(position.y) + abs(position.z)
    }

    var kineticEnergy: Int {
        return abs(velocity.dx) + abs(velocity.dy) + abs(velocity.dz)
    }

    var totalEnergy: Int {
        return potentialEnergy * kineticEnergy
    }
}

extension Moon: Equatable {
    static func == (lhs: Moon, rhs: Moon) -> Bool {
        return lhs.position == rhs.position && lhs.velocity == rhs.velocity
    }
}

extension Moon: Hashable {
    func hash(into hasher: inout Hasher) {
        hasher.combine(position)
        hasher.combine(velocity)
    }
}

extension Moon: CustomStringConvertible {
    var description: String {
        return "pos=\(position), vel=\(velocity)"
    }
}

/// Parse an array of `MoonPosition`s from a multiline input where each line is in the form "<x=-1, y=0, z=2>"
func parseMoonPositions(from input: String) -> [MoonPosition] {
    let rawMoonPositions = input.components(separatedBy: .newlines)
    let digitPattern = #"-?\d+"#
    let coordinateSeparatorPattern = #"\D+="#
    let coordinateRegex = try! NSRegularExpression(pattern: "(?<x>\(digitPattern))\(coordinateSeparatorPattern)(?<y>\(digitPattern))\(coordinateSeparatorPattern)(?<z>\(digitPattern))")
    let moonPositions = rawMoonPositions.map { rawInput -> MoonPosition in
        // TODO: create extensions for a better regex API and improve error handling
        let inputRange = NSRange(rawInput.startIndex..<rawInput.endIndex, in: rawInput)
        let match = coordinateRegex.firstMatch(in: rawInput, options: [], range: inputRange)!
        let coordinates = ["x","y","z"].map { matchingGroupName -> Int in
            let stringCoordinate = rawInput[Range(match.range(withName: matchingGroupName),in: rawInput)!]
            return Int(stringCoordinate)!
        }
        return MoonPosition(x: coordinates[0], y: coordinates[1], z: coordinates[2])
    }
    return moonPositions
}

func simulateMotionOfMoons(currentMoonState: [Moon]) {
    // 1. Calculate the gravity applied to each moon by all other moons
    let totalGravities = currentMoonState.map { $0.calculateTotalGravity(from: currentMoonState)}
    // 2. Update the velocity of every moon by applying gravity
    currentMoonState.enumerated().forEach { $0.element.velocity += totalGravities[$0.offset] }
    // 3. After the velocity of all moons have been updated, update the position of every moon by applying velocity
    currentMoonState.forEach { $0.applyVelocity() }
}

func simulateSteps(n: Int, startingMoonState: [Moon]) {
    for _ in 1...n {
        simulateMotionOfMoons(currentMoonState: startingMoonState)
    }
}

func totalEnergyOfSystem(_ moons: [Moon]) -> Int {
    return moons.reduce(0, { $0 + $1.totalEnergy })
}

private let example1Input = """
    <x=-1, y=0, z=2>
    <x=2, y=-10, z=-7>
    <x=4, y=-8, z=8>
    <x=3, y=5, z=-1>
"""

private let example1StartingPositions = parseMoonPositions(from: example1Input)

private let example2Input = """
<x=-8, y=-10, z=0>
<x=5, y=5, z=10>
<x=2, y=-7, z=3>
<x=9, y=-8, z=-3>
"""
private let example2StartingPositions = parseMoonPositions(from: example2Input)

func puzzle12Examples() {
    print(example1StartingPositions)
    let example1MoonStates = example1StartingPositions.map { Moon(position: $0) }
    for i in 1...10 {
        simulateMotionOfMoons(currentMoonState: example1MoonStates)
        print("Position after \(i) steps:")
        print(example1MoonStates)
    }
    let totalEnergyOfEx1 = totalEnergyOfSystem(example1MoonStates)
    print("Total energy of the system after 10 steps: \(totalEnergyOfEx1)")

    let startingMoonState2 = example2StartingPositions.map { Moon(position: $0) }
    simulateSteps(n: 100, startingMoonState: startingMoonState2)
    print("Example 2 after 100 steps:")
    print(startingMoonState2)
    let totalEnergyOfEx2 = totalEnergyOfSystem(startingMoonState2)
    print("Total energy of the system after 100 steps: \(totalEnergyOfEx2)")
}

func parsePuzzle12Input() -> [Moon] {
    let input = """
    <x=13, y=9, z=5>
    <x=8, y=14, z=-2>
    <x=-5, y=4, z=11>
    <x=2, y=-6, z=1>
    """
    let startingMoonPositions = parseMoonPositions(from: input)
    let moonState = startingMoonPositions.map { Moon(position: $0) }
    return moonState
}

func solvePuzzle12Pt1() -> Int {
    let moonState = parsePuzzle12Input()
    simulateSteps(n: 1000, startingMoonState: moonState)
    return totalEnergyOfSystem(moonState)
}

/// Given the starting state of a system of `Moon`s, find the number of steps it takes for the system to get back to a state in which it previously was
func findTimeLoop(startingState: [Moon]) -> Int {
    var matchingPreviousState = false
    var previousStates = Set<Int>()
    let saveSystemState: ([Moon]) -> Void = { system in
        var hasher = Hasher()
        hasher.combine(startingState)
        let systemState = previousStates.insert(hasher.finalize())
        matchingPreviousState = systemState.inserted == false
    }
    while !matchingPreviousState {
        simulateMotionOfMoons(currentMoonState: startingState)
        saveSystemState(startingState)
    }
    return previousStates.count
}

func puzzle12Pt2Examples() {
    let example1MoonStates = example1StartingPositions.map { Moon(position: $0) }
    let daysToRepeatEx1 = findTimeLoop(startingState: example1MoonStates)
    print("It takes example1 \(daysToRepeatEx1) days to repeat its state")
    let example2MoonStates = example2StartingPositions.map { Moon(position: $0) }
    let daysToRepeatEx2 = findTimeLoop(startingState: example2MoonStates)
    print("It takes example2 \(daysToRepeatEx2) days to repeat its state")
}

func solvePuzzle12Pt2() -> Int {
    let moonState = parsePuzzle12Input()
    return findTimeLoop(startingState: moonState)
}
