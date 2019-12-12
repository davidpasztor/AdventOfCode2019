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

func simulateMotionOfMoons(currentPositions: [MoonPosition]) -> [MoonPosition] {
    // 1. Update the velocity of every moon by applying gravity
    let velocities = currentPositions.map { $0.calculateTotalGravity(from: currentPositions) }
    // 2. After the velocity of all moons have been updated, update the position of every moon by applying velocity
    let updatedPositions = zip(currentPositions, velocities).map { $0.0.applyVelocity($0.1)}
    return updatedPositions
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
    var currentMoonPositions = example1StartingPositions
    for i in 1...10 {
        currentMoonPositions = simulateMotionOfMoons(currentPositions: currentMoonPositions)
        print("Position after \(i) steps:")
        print(currentMoonPositions)
    }
}
