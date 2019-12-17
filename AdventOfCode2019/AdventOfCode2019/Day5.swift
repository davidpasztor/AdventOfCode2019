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
    program1.execute()
    print("Output for \(memory1) is \(program1.output)")
    let memory2 = [1002,4,3,4,33]
    var program2 = IntcodeProgram(input: 1, memory: memory2)
    program2.execute()
    print("Output for \(memory2) is \(program2.output)")
}

func solvePuzzle5Pt1() -> Int? {
    let comma = CharacterSet(charactersIn: ",")
    guard let memory = try? parseInput(day: 5, separator: comma) else { return nil }
    var program = IntcodeProgram(input: 1, memory: memory)
    program.execute()
    return program.output
}

func puzzle5Pt2Examples() {
    print("Day 5 Pt2 examples")
    print("Comparison tests")
    let memory1 = [3,9,8,9,10,9,4,9,99,-1,8]
    var programCompTest1t = IntcodeProgram(input: 8, memory: memory1)
    programCompTest1t.execute()
    print("Input 8 produces output: \(programCompTest1t.output), expected: \(1)")
    let memory2 = [3,9,7,9,10,9,4,9,99,-1,8]
    var programCompTest1f = IntcodeProgram(input: 18, memory: memory2)
    programCompTest1f.execute()
    print("Input 18 produces output: \(programCompTest1f.output), expected: \(0)")
    let memory3 = [3,3,1108,-1,8,3,4,3,99]
    var programCompTest2t = IntcodeProgram(input: 8, memory: memory3)
    programCompTest2t.execute()
    print("Input 8 produces output: \(programCompTest2t.output), expected: \(1)")
    let memory4 = [3,3,1107,-1,8,3,4,3,99]
    var programCompTest2f = IntcodeProgram(input: 18, memory: memory4)
    programCompTest2f.execute()
    print("Input 18 produces output: \(programCompTest2f.output), expected: \(0)")
    let memory = [3,21,1008,21,8,20,1005,20,22,107,8,21,20,1006,20,31, 1106,0,36,98,0,0,1002,21,125,20,4,20,1105,1,46,104, 999,1105,1,46,1101,1000,1,20,4,20,1105,1,46,98,99]
    var program = IntcodeProgram(input: 7, memory: memory)
    program.execute()
    print("Jump tests")
    print("Input below 8 produces output: \(program.output), expected: 999")
    var program2 = IntcodeProgram(input: 8, memory: memory)
    program2.execute()
    print("Input 8 produces output: \(program2.output), expected: 1000")
    var program3 = IntcodeProgram(input: 9, memory: memory)
    program3.execute()
    print("Input above 8 produces output: \(program3.output), expected: 1001")
}

func solvePuzzle5Pt2() -> Int? {
    let comma = CharacterSet(charactersIn: ",")
    guard let memory = try? parseInput(day: 5, separator: comma) else { return nil }
    var program = IntcodeProgram(input: 5, memory: memory)
    program.execute()
    return program.output
}
