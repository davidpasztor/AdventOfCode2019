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
        error
        return nil
    }
}
// Takes a long time to run, so commented out
//solvePuzzle2Pt2()

// Day 3 - https://adventofcode.com/2019/day/3
struct Point: Hashable {
    let x: Int
    let y: Int
}

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
func pointsOnAWire(_ wire: [Move], startingPoint: Point) -> Set<Point> {
    let emptyResult = (Set<Point>(),startingPoint)
    return wire.reduce(emptyResult, { result, move in
        let (pointsTouched, currentPoint) = result
        let newPoints = move.createPointsForMove(from: currentPoint)
        return (pointsTouched.union(newPoints), newPoints.last!)
    }).0
}

func findClosestIntersection(to centralPort: Point, wire1: Set<Point>, wire2: Set<Point>) -> Int? {
    let intersections = wire1.intersection(wire2)
    let intersectionDistancesFromCentralPort = intersections.map { manhattanDistance(of: $0, to: centralPort) }
    return intersectionDistancesFromCentralPort.min()
}

let centralPortLocation = Point(x: 0, y: 0)
let example1 = """
R8,U5,L5,D3
U7,R6,D4,L4
"""
let wires = parseWireInput(example1)
wires.left
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

func solvePuzzle3Pt1() -> Int? {
    guard let stringInput = try? readInput(filename: "day3input") else { return nil }
    let wires = parseWireInput(stringInput)
    let centralPortLocation = Point(x: 0, y: 0)
    let firstWirePoints = pointsOnAWire(wires.left, startingPoint: centralPortLocation)
    let secondWirePoints = pointsOnAWire(wires.right, startingPoint: centralPortLocation)
    return findClosestIntersection(to: centralPortLocation, wire1: firstWirePoints, wire2: secondWirePoints)
}

solvePuzzle3Pt1()
