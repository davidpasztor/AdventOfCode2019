//
//  Day3.swift
//  AdventOfCode2019
//
//  Created by David Pasztor on 04/12/2019.
//  Copyright © 2019 David Pasztor. All rights reserved.
//

import Foundation

// Day 3 - https://adventofcode.com/2019/day/3

// Manhattan distance equation https://en.wikipedia.org/wiki/Taxicab_geometry
func manhattanDistance(of point1: Point, to point2: Point) -> Int {
    return abs(point1.x - point2.x) + abs(point1.y - point2.y)
}

/// Straight move in a taxicab geometry
enum Move: RawRepresentable {
    case down(Int)
    case left(Int)
    case right(Int)
    case up(Int)

    var rawValue: String {
        switch self {
        case let .down(num):
            return "D\(num)"
        case let .left(num):
            return "L\(num)"
        case let .right(num):
            return "R\(num)"
        case let .up(num):
            return "U\(num)"
        }
    }

    init?(rawValue: String) {
        guard let direction = rawValue.first, let distance = Int(rawValue.dropFirst()) else { return nil }
        switch direction {
        case "D":
            self = .down(distance)
        case "L":
            self = .left(distance)
        case "R":
            self = .right(distance)
        case "U":
            self = .up(distance)
        default:
            return nil
        }
    }

    /// Returns all points that a specific move from `startingPoint` touches
    func createPointsForMove(from startingPoint: Point) -> [Point] {
        switch self {
        case let .down(num):
            return (1...num).map { Point(x: startingPoint.x, y: startingPoint.y - $0) }
        case let .left(num):
            return (1...num).map { Point(x: startingPoint.x - $0, y: startingPoint.y) }
        case let .right(num):
            return (1...num).map { Point(x: startingPoint.x + $0, y: startingPoint.y) }
        case let .up(num):
            return (1...num).map { Point(x: startingPoint.x, y: startingPoint.y + $0) }
        }
    }
}

/// Given a `String` representation of a pair of wires, parse it into a pair of each move making up that wire
func parseWireInput(_ string: String) -> Pair<[Move]> {
    let wires = string.components(separatedBy: .newlines)
    let instructions = wires.map { $0.components(separatedBy: CharacterSet(charactersIn: ",")).compactMap { Move(rawValue: $0) }}
    return .init(left: instructions[0], right: instructions[1])
}

/// Get the set of points making up a wire
func pointsOnAWire(_ wire: [Move], startingPoint: Point) -> [Point] {
    let emptyResult = ([Point](),startingPoint)
    return wire.reduce(emptyResult, { result, move in
        let (pointsTouched, currentPoint) = result
        let newPoints = move.createPointsForMove(from: currentPoint)
        return (pointsTouched + newPoints, newPoints.last!)
    }).0
}

/// Find the intersection of `wire1` and `wire2` closest to `centralPort` based on Manhattan distances
func findClosestIntersection(to centralPort: Point, wire1: [Point], wire2: [Point]) -> Int? {
    let intersections = Set(wire1).intersection(wire2)
    let intersectionDistancesFromCentralPort = intersections.map { manhattanDistance(of: $0, to: centralPort) }
    return intersectionDistancesFromCentralPort.min()
}

/// The number of coordinates touched (steps) by a wire until it reaches `destination`
/// - precondition: `destination` is an element of `wire`
func stepsToReach(_ destination: Point, on wire: [Point]) -> Int {
    precondition(wire.contains(destination), "`destination` should be an element of `wire`")
    let wirePathsUntilDestination = wire.prefix(while: { $0 != destination })
    return wirePathsUntilDestination.enumerated().reduce(0, { steps, current in
        return steps + manhattanDistance(of: current.element, to: wire[current.offset + 1])
    }) + 1 // need to add an extra step, because we aren't iterating over the last point
}

/// Find the intersection of `wire1` and `wire2` where the number of steps the wires take to reach the intersection from `centralPort` is the smallest
func findShortestPathIntersection(from centralPort: Point, wire1: [Point], wire2: [Point]) -> Int {
    let intersections = Set(wire1).intersection(wire2)
    let intersectionDistancesFromCentralPort = intersections.map { stepsToReach($0, on: wire1) + stepsToReach($0, on: wire2) }
    return intersectionDistancesFromCentralPort.min()!
}

func runDay3Examples() {
    let centralPortLocation = Point(x: 0, y: 0)
    let example1 = """
    R8,U5,L5,D3
    U7,R6,D4,L4
    """
    let wires = parseWireInput(example1)
    let firstWirePoints = pointsOnAWire(wires.left, startingPoint: centralPortLocation)
    let secondWirePoints = pointsOnAWire(wires.right, startingPoint: centralPortLocation)
    let smallestDistance = findClosestIntersection(to: centralPortLocation, wire1: firstWirePoints, wire2: secondWirePoints)
    print("Example1 smallest distance: \(smallestDistance?.description ?? "Failed")")

    let ex2 = """
    R75,D30,R83,U83,L12,D49,R71,U7,L72
    U62,R66,U55,R34,D71,R55,D58,R83
    """
    let wires2 = parseWireInput(ex2)
    let smallestDistance2 = findClosestIntersection(to: centralPortLocation, wire1: pointsOnAWire(wires2.left, startingPoint: centralPortLocation), wire2: pointsOnAWire(wires2.right, startingPoint: centralPortLocation))
    print("Example2 smallest distance: \(smallestDistance2?.description ?? "Failed")")

    let ex3 = """
    R98,U47,R26,D63,R33,U87,L62,D20,R33,U53,R51
    U98,R91,D20,R16,D67,R40,U7,R15,U6,R7
    """
    let wires3 = parseWireInput(ex3)
    let smallestDistance3 = findClosestIntersection(to: centralPortLocation, wire1: pointsOnAWire(wires3.left, startingPoint: centralPortLocation), wire2: pointsOnAWire(wires3.right, startingPoint: centralPortLocation))
    print("Example3 smallest distance: \(smallestDistance3?.description ?? "Failed")")

    [example1, ex2, ex3].forEach { wireSpecInput in
        let wires = parseWireInput(wireSpecInput)
        let firstWirePoints = pointsOnAWire(wires.left, startingPoint: centralPortLocation)
        let secondWirePoints = pointsOnAWire(wires.right, startingPoint: centralPortLocation)
        print(findShortestPathIntersection(from: Point(x: 0, y: 0), wire1: firstWirePoints, wire2: secondWirePoints))
    }

}

func solvePuzzle3Pt1() -> Int? {
    let stringInput = try! readInput(filename: "day3input")
    let wires = parseWireInput(stringInput)
    let centralPortLocation = Point(x: 0, y: 0)
    let firstWirePoints = pointsOnAWire(wires.left, startingPoint: centralPortLocation)
    let secondWirePoints = pointsOnAWire(wires.right, startingPoint: centralPortLocation)
    return findClosestIntersection(to: centralPortLocation, wire1: firstWirePoints, wire2: secondWirePoints)
}

func solvePuzzle3Pt2() -> Int? {
    guard let stringInput = try? readInput(filename: "day3input") else { return nil }
    let wires = parseWireInput(stringInput)
    let centralPortLocation = Point(x: 0, y: 0)
    let firstWirePoints = pointsOnAWire(wires.left, startingPoint: centralPortLocation)
    let secondWirePoints = pointsOnAWire(wires.right, startingPoint: centralPortLocation)
    return findShortestPathIntersection(from: centralPortLocation, wire1: firstWirePoints, wire2: secondWirePoints)
}
