//
//  Day5.swift
//  AdventOfCode2019
//
//  Created by David Pasztor on 05/12/2019.
//  Copyright © 2019 David Pasztor. All rights reserved.
//

import Foundation

func puzzle5Examples() {
    let memory1 = [3,0,4,0,99]
    var program1 = IntcodeProgram(input: 1, memory: memory1)
    print("Output for \(memory1) is \(program1.execute())")
    let memory2 = [1002,4,3,4,33]
    var program2 = IntcodeProgram(input: 1, memory: memory2)
    print("Output for \(memory2) is \(program2.execute())")
}

func solvePuzzle5Pt1() -> Int? {
    let comma = CharacterSet(charactersIn: ",")
    guard let memory = try? parseInput(day: 5, separator: comma) else { return nil }
    var program = IntcodeProgram(input: 1, memory: memory)
    return program.execute()
}

func runDiagnostics() -> Int {
    return 0
}
