//
//  Day4.swift
//  AdventOfCode2019
//
//  Created by David Pasztor on 04/12/2019.
//  Copyright © 2019 David Pasztor. All rights reserved.
//

import Foundation

//: Day 4 - https://adventofcode.com/2019/day/4

/// Checks whether the array contains any adjacent digits that are the same
func twoAdjacentDigitsMatch(in digits: [Int]) -> Bool {
    digits.indices.dropFirst().contains { digits[$0] == digits[$0 - 1] }
}

/// Checks whether all elements of the array are bigger than or equal to the previous element
func digitsAreNotDecreasing(in digits: [Int]) -> Bool {
    digits.indices.dropFirst().allSatisfy { digits[$0] >= digits[$0 - 1] }
}

func validatePassword(_ pw: String) -> Bool {
    let digits = pw.compactMap { Int(String($0)) }
    guard digits.count == 6 else { return false }
    guard twoAdjacentDigitsMatch(in: digits) else { return false }
    return digitsAreNotDecreasing(in: digits)
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
    guard digitsAreNotDecreasing(in: digits) else { return false }
    var index = digits.indices.lowerBound
    while index < digits.indices.upperBound {
        let digitsFromIndex = digits[index...]
        let matchingDigits = digitsFromIndex.prefix(while: { $0 == digits[index] })
        if matchingDigits.count == 2 {
            return true
        } else if matchingDigits.count == digitsFromIndex.count {
            return false
        }
        index += matchingDigits.count
    }
    return false
}

func puzzle4Pt2Examples() {
    let testPasswordsAndValidities: [(pw:String, valid: Bool)] = [("112233",true), ("123444",false), ("111122",true), ("566678",false)]
    testPasswordsAndValidities.forEach {
        print("\($0.pw) should be: \($0.valid), result: \(validatePasswordPt2($0.pw))")
    }
}

func solvePuzzle4Pt2() -> Int {
    let inputRange = 264360...746325
    let passwordsInRange = inputRange.map { $0.description }
    let validPasswordsInRange = passwordsInRange.filter { validatePasswordPt2($0) }
    return validPasswordsInRange.count
}
