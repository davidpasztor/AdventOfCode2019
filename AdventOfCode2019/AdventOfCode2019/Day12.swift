//
//  Day12.swift
//  AdventOfCode2019
//
//  Created by David Pasztor on 12/12/2019.
//  Copyright © 2019 David Pasztor. All rights reserved.
//

import Foundation

/// Position of a moon in space
struct MoonPosition {
    let x: Int
    let y: Int
    let z: Int

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

    func calculateTotalGravity(from otherMoons: [MoonPosition]) -> MoonVelocity {
        return otherMoons.reduce(into: MoonVelocity.zero, { $0 += calculateGravity(from: $1) })
    }

    /// Calculate the position of a moon after applying the gravitational force exerted by `otherMoon`
    func applyGravity(from otherMoons: [MoonPosition]) -> MoonPosition {
        let totalGravity = calculateTotalGravity(from: otherMoons)
        return applyVelocity(totalGravity)
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
struct MoonVelocity {
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

//// Represents a `Moon`
class Moon {
    /// Current position of the moon
    var position: MoonPosition
    /// Current velocity of the moon
    var velocity: MoonVelocity

    /// Initialise with a position and velocity
    /// - parameter velocity: default value is `.zero`
    init(position: MoonPosition, velocity: MoonVelocity = .zero) {
        self.position = position
        self.velocity = velocity
    }

    /// Update the position of a moon after applying the gravitational force exerted by `otherMoon`
    func applyGravity(from otherMoons: [Moon]) {
        let totalGravity = position.calculateTotalGravity(from: otherMoons.map { $0.position })
        velocity += totalGravity
        position = position.applyVelocity(velocity)
    }

    /// Update the `position` of the moon by applying its current `velocity` to it
    func applyVelocity() {
        position = position.applyVelocity(velocity)
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
    let currentMoonPositions = currentMoonState.map { $0.position }
    // 1. Calculate the gravity applied to each moon by all other moons
    let totalGravities = currentMoonState.map { $0.position.calculateTotalGravity(from: currentMoonPositions)}
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

func puzzle12Examples() {
    let example1Input = """
        <x=-1, y=0, z=2>
        <x=2, y=-10, z=-7>
        <x=4, y=-8, z=8>
        <x=3, y=5, z=-1>
    """
    let example1StartingPositions = parseMoonPositions(from: example1Input)
    print(example1StartingPositions)
    let currentMoonStates = example1StartingPositions.map { Moon(position: $0) }
    for i in 1...10 {
        simulateMotionOfMoons(currentMoonState: currentMoonStates)
        print("Position after \(i) steps:")
        print(currentMoonStates)
    }

    let example2Input = """
    <x=-8, y=-10, z=0>
    <x=5, y=5, z=10>
    <x=2, y=-7, z=3>
    <x=9, y=-8, z=-3>
    """
    let startingMoonState2 = parseMoonPositions(from: example2Input).map { Moon(position: $0) }
    simulateSteps(n: 100, startingMoonState: startingMoonState2)
    print("Example 2 after 100 steps:")
    print(startingMoonState2)
}
