//
//  Day10.swift
//  AdventOfCode2019
//
//  Created by David Pasztor on 10/12/2019.
//  Copyright © 2019 David Pasztor. All rights reserved.
//

import Foundation

/// Parses a `String` representing an Asteroid map into an array of `Point`s, which represent the coordinates with asteroids on them
func parseAsteroidMap(_ map: String) -> [Point] {
    var asteroidCoordinates = [Point]()
    for (y, line) in map.components(separatedBy: .newlines).enumerated() {
        for (x, char) in line.enumerated() {
            if char == "#" {
                let asteroidCoordinate = Point(x: x, y: y)
                asteroidCoordinates.append(asteroidCoordinate)
            }
        }
    }
    return asteroidCoordinates
}

/// Returns an `[Point]` representing all points on the straight line drawn between `startingPoint` and `otherPoint` ending at the edge of the coordinate system (`maxX` and `maxY` for the x and y axis respectively)
func pointsOnLine(from startingPoint: Point, through otherPoint: Point, maxX: Int, maxY: Int) -> [Point] {
    // Avoid an infinite loop caused by `vectorBetweenPoints` being (0,0) if the two points are the same
    guard startingPoint != otherPoint else  { return [] }
    var line = [Point]()
    // Draw the vector between the two points, then reduce it to the minimal possible size with `Int` coordinates in the same direction as the original vector
    let vectorBetweenPoints = Vector(diffX: otherPoint.x - startingPoint.x, diffY: otherPoint.y - startingPoint.y).unitVector()
    var point = otherPoint.movedBy(vector: vectorBetweenPoints)
    while point.x <= maxX && point.y <= maxY && point.x >= 0 && point.y >= 0 {
        line.append(point)
        point = point.movedBy(vector: vectorBetweenPoints)
    }
    return line
}

extension Collection where Element == Point {
    /// Find the maximum element in both directions (x,y) in an [Point] and return a new `Point` with those (x,y) values
    func size() -> Point {
        let maxX = self.map { $0.x }.max() ?? 0
        let maxY = self.map { $0.y }.max() ?? 0
        return Point(x: maxX, y: maxY)
    }
}

func blockedAsteroids(from asteroid: Point, by otherAsteroid: Point, asteroidMap: Set<Point>) -> Set<Point> {
    let mapSize = asteroidMap.size()
    // Find all points in the finite coordinate system whose visibility is blocked from `asteroid` by `otherAsteroid`
    let pointsBlocked = pointsOnLine(from: asteroid, through: otherAsteroid, maxX: mapSize.x, maxY: mapSize.y)
    // Return the blocked points that contain asteroids
    return Set(asteroidMap).intersection(pointsBlocked)
}

func numberOfVisibleAsteroids(from asteroid: Point, on asteroidMap: [Point]) -> Int {
    let otherAsteroids = Set(asteroidMap).subtracting([asteroid])
    var visibleAsteroids = otherAsteroids
    for otherAsteroid in otherAsteroids {
        let blockedByAsteroid = blockedAsteroids(from: asteroid, by: otherAsteroid, asteroidMap: visibleAsteroids)
        visibleAsteroids.subtract(blockedByAsteroid)
        if visibleAsteroids.count == 0 { // if it's only the `asteroid` itself left, return early
            return 0
        }
    }
    return visibleAsteroids.count
}

func findBestLocationForMonitoringStation(on asteroidMap: [Point]) -> Point {
    let numberOfVisibleAsteroidsFromEachAsteroid = asteroidMap.map { numberOfVisibleAsteroids(from: $0, on: asteroidMap) }
    let bestIndex = numberOfVisibleAsteroidsFromEachAsteroid.enumerated().max(by: {$0.element < $1.element})!.offset
    return asteroidMap[bestIndex]
}

let exampleMap1 = """
.#..#
.....
#####
....#
...##
"""

let exampleMap2 = """
......#.#.
#..#.#....
..#######.
.#.#.###..
.#..#.....
..#....#.#
#..#....#.
.##.#..###
##...#..#.
.#....####
"""

let exampleMap3 = """
#.#...#.#.
.###....#.
.#....#...
##.#.#.#.#
....#.#.#.
.##..###.#
..#...##..
..##....##
......#...
.####.###.
"""

let exampleMap4 = """
.#..#..###
####.###.#
....###.#.
..###.##.#
##.##.#.#.
....###..#
..#.#..#.#
#..#.#.###
.##...##.#
.....#.#..
"""

let exampleMap5 = """
.#..##.###...#######
##.############..##.
.#.######.########.#
.###.#######.####.#.
#####.##.#.##.###.##
..#####..#.#########
####################
#.####....###.#.#.##
##.#################
#####.##.###..####..
..######..##.#######
####.##.####...##..#
.#####..#.######.###
##...#.##########...
#.##########.#######
.####.#.###.###.#.##
....##.##.###..#####
.#.#.###########.###
#.#.#.#####.####.###
###.##.####.##.#..##
"""

let lineOfSightExample = """
#.........
...#......
...#..#...
.####....#
..#.#.#...
.....#....
..###.#.##
.......#..
....#...#.
...#..#..#
"""

func puzzle10Examples() {
    let asteroidMap1 = parseAsteroidMap(exampleMap1)
    print("Example map 1\n", asteroidMap1)
    print("points on line from (0,0) to (3,1)")
    print(pointsOnLine(from: Point(x: 0, y: 0), through: Point(x: 3, y: 1), maxX: 9, maxY: 9))
    let asteroidMap2 = parseAsteroidMap(exampleMap2)
    print("Example map 2\n", asteroidMap2)
    let lineOfSightMap = parseAsteroidMap(lineOfSightExample)
    print("Blocked by point (3,3) from (0,0) on 10x10 map")
    print(blockedAsteroids(from: Point(x: 0, y: 0), by: Point(x: 3, y: 3), asteroidMap: Set(lineOfSightMap)))
    print("Blocked by point (2,3) from (0,0) on 10x10 map")
    print(blockedAsteroids(from: Point(x: 0, y: 0), by: Point(x: 2, y: 3), asteroidMap: Set(lineOfSightMap)))
    let point1 = Point(x: 4, y: 0)
    print("number of visible asteroids from \(point1) on Example1", numberOfVisibleAsteroids(from: point1, on: asteroidMap1))
    let point2 = Point(x: 3, y: 4)
    print("number of visible asteroids from \(point2) on Example1", numberOfVisibleAsteroids(from: point2, on: asteroidMap1))
    let examplesMaps = [exampleMap1, exampleMap2, exampleMap3, exampleMap4, exampleMap5].map { parseAsteroidMap($0) }
    examplesMaps.enumerated().forEach { index, asteroidMap in
        print("Best location for example\(index+1): \(findBestLocationForMonitoringStation(on: asteroidMap))")
    }
}
