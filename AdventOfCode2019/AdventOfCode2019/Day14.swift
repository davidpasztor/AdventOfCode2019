//
//  Day14.swift
//  AdventOfCode2019
//
//  Created by David Pasztor on 16/12/2019.
//  Copyright © 2019 David Pasztor. All rights reserved.
//

import Foundation

struct ChemicalIngredient {
    let name: String
    let quantity: Int

    init(name: String, quantity: Int) {
        self.name = name
        self.quantity = quantity
    }

    /// Create a `ChemicalIngredient` from a `String` in the form of "X NAME" where `X` is the quantity of the ingredient
    init?(rawInput: String) {
        let nameAndQuantity = rawInput.trimmingCharacters(in: .whitespaces).components(separatedBy: .whitespaces)
        guard nameAndQuantity.count == 2, let quantity = Int(nameAndQuantity[0]) else {
            assertionFailure("Incorrect input for ChemicalIngredient(rawInput:). The input should be in the form of \"10 NAME\"")
            return nil
        }
        self.name = nameAndQuantity[1]
        self.quantity = quantity
    }
}

extension ChemicalIngredient: CustomStringConvertible {
    var description: String {
        return "\(quantity) \(name)"
    }
}

extension Array where Element == ChemicalIngredient {
    init(rawInput: String) {
        self = rawInput.components(separatedBy: ",").compactMap { ChemicalIngredient(rawInput: $0)}
    }
}

struct ChemicalReaction {
    var inputs: [ChemicalIngredient]
    let output: ChemicalIngredient

    init?(rawInput: String) {
        let inputAndOutput = rawInput.components(separatedBy: " => ")
        guard inputAndOutput.count == 2, let output = ChemicalIngredient(rawInput: inputAndOutput[1]) else {
            assertionFailure("Incorrect input for ChemicalReaction(rawInput:). The input should be in the form of \"10 INPUT => 11 OUTPUT\"")
            return nil
        }
        self.inputs = [ChemicalIngredient](rawInput: inputAndOutput[0])
        self.output = output
    }

    /// `inputs` might include several quantities of the same ingredient - consolidate them into a single `ChemicalIngredient` by summing the `quantity` of all `inputs` with the same `name`
    mutating func reduceInputs() {
        let inputsDict = Dictionary<String, Int>(inputs.map {($0.name, $0.quantity)}, uniquingKeysWith: { thisQuant, thatQuant in
            return thisQuant + thatQuant
        })
        inputs = inputsDict.map { ChemicalIngredient(name: $0.key, quantity: $0.value) }
    }
}

extension ChemicalReaction: CustomStringConvertible {
    var description: String {
        let inputDescription = inputs.map { $0.description }.joined(separator: ", ")
        return "\(inputDescription) => \(output)"
    }
}

func parseChemicalReactions(_ rawInput: String) -> [ChemicalReaction] {
    let rawReactions = rawInput.components(separatedBy: .newlines)
    return rawReactions.compactMap { ChemicalReaction(rawInput: $0) }
}

/// Solves the list of chemical reactions to calculate how many ores are required to produce 1 fuel
func solveFuelEquations(_ reactions: [ChemicalReaction]) -> Int {
    var unsolvedReactions = reactions
    let ore = "ORE"
    while unsolvedReactions.count > 1 {
        for (oreReactionIndex, oreReaction) in unsolvedReactions.enumerated() where oreReaction.inputs.count == 1 && oreReaction.inputs.first?.name == ore {
            for (reactionSubstitutionIndex, reactionToSubstitute) in unsolvedReactions.enumerated() where reactionToSubstitute.inputs.contains(where: { $0.name == oreReaction.output.name && $0.quantity.isMultiple(of: oreReaction.output.quantity) }) {
                let ingredientName = oreReaction.output.name
                guard let inputSubstitutionIndex = reactionToSubstitute.inputs.firstIndex(where: { $0.name == ingredientName && $0.quantity.isMultiple(of: oreReaction.output.quantity) }) else { continue }
                let quantity = reactionToSubstitute.inputs[inputSubstitutionIndex].quantity / oreReaction.output.quantity
                unsolvedReactions[reactionSubstitutionIndex].inputs[inputSubstitutionIndex] = ChemicalIngredient(name: ingredientName, quantity: quantity)
            }
            unsolvedReactions.remove(at: oreReactionIndex)
        }
    }

    return unsolvedReactions[0].inputs[0].quantity
}

private let ex1Input = """
10 ORE => 10 A
1 ORE => 1 B
7 A, 1 B => 1 C
7 A, 1 C => 1 D
7 A, 1 D => 1 E
7 A, 1 E => 1 FUEL
"""

func solvePuzzle14Pt1Examples() {
    let reactions1 = parseChemicalReactions(ex1Input)
    print(reactions1)
    print(solveFuelEquations(reactions1))
}
