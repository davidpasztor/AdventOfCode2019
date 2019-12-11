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
    var line = [Point]()
    var point = otherPoint
    let diffX = otherPoint.x - startingPoint.x
    let diffY = otherPoint.y - startingPoint.y
    while point.x < maxX && point.y < maxY {
        point = point.moveByVector(diffX: diffX, diffY: diffY)
        line.append(point)
    }
    return line
}

extension Array where Element == Point {
    func size() -> Point {
        let maxX = self.map { $0.x }.max() ?? 0
        let maxY = self.map { $0.y }.max() ?? 0
        return Point(x: maxX, y: maxY)
    }
}

func blockedAsteroids(from asteroid: Point, by otherAsteroid: Point, asteroidMap: [Point]) -> [Point] {
    let mapSize = asteroidMap.size()
    return pointsOnLine(from: asteroid, through: otherAsteroid, maxX: mapSize.x, maxY: mapSize.y)
}

func numberOfVisibleAsteroids(from asteroid: Point, on asteroidMap: [Point]) -> Int {
    let mapSize = asteroidMap.size()
    let blockedAsteroids = asteroidMap.reduce(into: Set<Point>(), { result, point in
        let blockedVisibility = pointsOnLine(from: asteroid, through: point, maxX: mapSize.x, maxY: mapSize.y)
        result.formUnion(blockedVisibility)
    })
    return asteroidMap.count - blockedAsteroids.count
}

func findBestLocationForMonitoringStation(on asteroidMap: [Point]) -> Point {
    let result = asteroidMap.map { point in (numberOfVisibleAsteroids(from: point, on: asteroidMap), point ) }
    return result.max(by: {$0.0 < $1.0})!.1
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

func puzzle10Examples() {
    let asteroidMap1 = parseAsteroidMap(exampleMap1)
    print(asteroidMap1)
    print("points on line from (0,0) to (3,1)")
    print(pointsOnLine(from: Point(x: 0, y: 0), through: Point(x: 3, y: 1), maxX: 9, maxY: 9))
    print("Blocked by point (3,1) from (0,0) on 9x9 map")
    print(blockedAsteroids(from: Point(x: 0, y: 0), by: Point(x: 3, y: 1), asteroidMap: parseAsteroidMap(exampleMap5)))
    print(numberOfVisibleAsteroids(from: Point(x: 1, y: 0), on: asteroidMap1))
    print(numberOfVisibleAsteroids(from: Point(x: 0, y: 2), on: asteroidMap1))
    print("Best location for example1: \(findBestLocationForMonitoringStation(on: asteroidMap1))")
    print(parseAsteroidMap(exampleMap2))
    let examplesMaps = [exampleMap1, exampleMap2, exampleMap3, exampleMap4, exampleMap5].map { parseAsteroidMap($0) }
    examplesMaps.enumerated().forEach { index, asteroidMap in
        print("Best location for example\(index+1): \(findBestLocationForMonitoringStation(on: asteroidMap))")
    }
}
