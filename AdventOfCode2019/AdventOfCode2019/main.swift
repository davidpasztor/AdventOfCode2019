//
//  main.swift
//  AdventOfCode2019
//
//  Created by David Pasztor on 04/12/2019.
//  Copyright © 2019 David Pasztor. All rights reserved.
//

import Foundation

print("Welcome to Advent of Code 2019!")
/*
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
 */
puzzleDay(n: 5)
puzzle5Examples()
let puzzle5Pt1Result = solvePuzzle5Pt1()
print("Pt1 result is \(puzzle5Pt1Result?.description ?? "failed"), expected \(7566643)")
puzzle5Pt2Examples()
let puzzle5Pt2Result = solvePuzzle5Pt2()
print("Pt2 result is \(puzzle5Pt2Result?.description ?? "failed"), expected \("")")
puzzleDay(n: 10)
//puzzle10Examples()
puzzleDay(n: 12)
puzzle12Examples()
let puzzle12Pt1Result = solvePuzzle12Pt1()
print("Total energy in the system after 1000 steps: \(puzzle12Pt1Result)")
print("Equals expected answer, 6490:", puzzle12Pt1Result == 6490)
//puzzle12Pt2Examples()
puzzleDay(n: 14)
//solvePuzzle14Pt1Examples()
