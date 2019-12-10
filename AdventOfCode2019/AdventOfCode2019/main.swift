//
//  main.swift
//  AdventOfCode2019
//
//  Created by David Pasztor on 04/12/2019.
//  Copyright © 2019 David Pasztor. All rights reserved.
//

import Foundation

print("Welcome to Advent of Code 2019!")
puzzleDay(n: 1)
print("Pt1")
print(solvePuzzle1Pt1()?.description ?? "Failed")
print("Pt2")
print(solvePuzzle1Pt2()?.description ?? "Failed")
puzzleDay(n: 2)
print("Pt1")
print(solvePuzzle2Pt1()?.description ?? "Failed")
print("Pt2")
print(solvePuzzle2Pt2()?.description ?? "Failed")
puzzleDay(n: 3)
print("Pt1")
print(solvePuzzle3Pt1()?.description ?? "Failed")
print("Pt2")
print(solvePuzzle3Pt2()?.description ?? "Failed")
puzzleDay(n: 4)
print("Pt1")
let puzzle4Pt1Expected = 945
print("Expected: \(puzzle4Pt1Expected)")
print("Actual: \(solvePuzzle4Pt1())")
print("Pt2")
puzzle4Pt2Examples()
let puzzle4Pt2Expected = 617
print("Expected: \(puzzle4Pt2Expected)")
print("Actual: \(solvePuzzle4Pt2())")
puzzleDay(n: 5)
puzzle5Examples()
