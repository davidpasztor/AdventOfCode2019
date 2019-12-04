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

/// Checks whether `digits` has 6 elements
func sixDigitsLong(in digits: [Int]) -> Bool {
    return digits.count == 6
}

/// Checks whether there is at least one pair of adjacent digits that are the same, but aren't in a larger group of same digits
func groupOfOnlyTwoDigitsMatch(in digits: [Int]) -> Bool {
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

/// Checks whether `pw` satisfies all `rules`
func validatePassword(_ pw: String, rules: ([Int]) -> Bool...) -> Bool {
    let digits = pw.compactMap { Int(String($0)) }
    return rules.allSatisfy { validate in validate(digits) }
}

func solvePuzzle4Pt1() -> Int {
    let inputRange = 264360...746325
    let passwordsInRange = inputRange.map(String.init)
    let validPasswordsInRange = passwordsInRange.filter { validatePassword($0, rules: sixDigitsLong, digitsAreNotDecreasing, twoAdjacentDigitsMatch) }
    return validPasswordsInRange.count
}

func puzzle4Pt2Examples() {
    let testPasswordsAndValidities: [(pw:String, valid: Bool)] = [("112233",true), ("123444",false), ("111122",true), ("566678",false)]
    testPasswordsAndValidities.forEach {
        let isValid = validatePassword($0.pw, rules: sixDigitsLong, digitsAreNotDecreasing, groupOfOnlyTwoDigitsMatch)
        print("\($0.pw) should be: \($0.valid), result: \(isValid)")
    }
}

func solvePuzzle4Pt2() -> Int {
    let inputRange = 264360...746325
    let passwordsInRange = inputRange.map { $0.description }
    let validPasswordsInRange = passwordsInRange.filter { validatePassword($0, rules: sixDigitsLong, digitsAreNotDecreasing, groupOfOnlyTwoDigitsMatch) }
    return validPasswordsInRange.count
}
