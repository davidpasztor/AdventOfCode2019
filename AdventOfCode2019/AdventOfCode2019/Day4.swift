//
//  Day4.swift
//  AdventOfCode2019
//
//  Created by David Pasztor on 04/12/2019.
//  Copyright © 2019 David Pasztor. All rights reserved.
//

import Foundation

//: Day 4 - https://adventofcode.com/2019/day/4

func validatePassword(_ pw: String) -> Bool {
    let digits = pw.compactMap { Int(String($0)) }
    guard digits.count == 6 else { return false }
    let twoAdjacentDigitsMatch = digits.indices.dropFirst().contains { digits[$0] == digits[$0 - 1] }
    guard twoAdjacentDigitsMatch else { return false }
    return digits.indices.dropFirst().allSatisfy { digits[$0] >= digits[$0 - 1] }
}

func solvePuzzle4Pt1() -> Int {
    let inputRange = 264360...746325
    let passwordsInRange = inputRange.map(String.init)
    let validPasswordsInRange = passwordsInRange.filter { validatePassword($0) }
    return validPasswordsInRange.count
}

func validatePasswordPt2(_ pw: String) -> Bool {
    let digits = pw.compactMap { Int(String($0)) }
    guard digits.count == 6 else { return false }
    let digitsAreNotDecreasing = digits.indices.dropFirst().allSatisfy { digits[$0] >= digits[$0 - 1] }
    guard digitsAreNotDecreasing else { return false }
    var valid: Bool? = nil
    for index in digits.indices.dropFirst() {
        if digits[index] == digits[index - 1] {
            if index == digits.indices.last {
                return valid ?? true
            } else if digits[index] == digits[index + 1] {
                valid = false
            } else {
                return true
            }
        }
    }
    return valid ?? false
}

func solvePuzzle4Pt2() -> Int {
    let inputRange = 264360...746325
    let passwordsInRange = inputRange.map { $0.description }
    let validPasswordsInRange = passwordsInRange.filter { validatePasswordPt2($0) }
    return validPasswordsInRange.count
}
