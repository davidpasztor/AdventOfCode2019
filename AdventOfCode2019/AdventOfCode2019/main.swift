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
print(solvePuzzle4Pt1())
print("Pt2")
print("112233 should be valid:", validatePasswordPt2("112233"))
print("123444 should be invalid:", validatePasswordPt2("123444"))
print("111122 should be valid:", validatePasswordPt2("111122"))
print(solvePuzzle4Pt2())
