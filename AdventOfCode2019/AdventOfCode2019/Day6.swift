//
//  Day6.swift
//  AdventOfCode2019
//
//  Created by David Pasztor on 06/12/2019.
//  Copyright © 2019 David Pasztor. All rights reserved.
//

import Foundation

indirect enum BinaryTree<Element> {
    case leaf
    case node(BinaryTree<Element>, Element, BinaryTree<Element>)

    init() {
        self = .leaf
    }

    init(value: Element) {
        self = .node(.leaf, value, .leaf)
    }
}

class Tree<Element> {
    let value: Element
    var children = [Tree<Element>]()

    init(value: Element) {
        self.value = value
    }
}

typealias OrbitMap = Tree<String>

extension OrbitMap {
    static func parse(orbitRelationships: [OrbitRelationship], topNodeValue: String) -> OrbitMap {
        let allOrbitsAreAroundTopNode = orbitRelationships.allSatisfy({ $0.orbitedObject == topNodeValue })
        if allOrbitsAreAroundTopNode {
            let topNode = OrbitMap(value: topNodeValue)
            topNode.children = orbitRelationships.map { OrbitMap(value: $0.orbitingObject) }
            return topNode
        } else {
            let unparsedRelationships = orbitRelationships.filter { $0.orbitingObject != topNodeValue }
            //return parse(orbitRelationships: <#T##[OrbitRelationship]#>, topNodeValue: <#T##String#>)
            return OrbitMap(value: topNodeValue) // TODO: replace this with the above line
        }
    }

    convenience init(orbitRelationships: [OrbitRelationship]) {
        // Center of Mass (COM) is the only object not orbiting any other object
        let com = "COM"
        self.init(value: com)
        self.children = orbitRelationships.filter { $0.orbitedObject == com }.map { OrbitMap(value: $0.orbitingObject) }
    }
}

func orbitCount(for map: String) -> Int {
    return 0
}

struct OrbitRelationship {
    let orbitedObject: String
    let orbitingObject: String
}

func parseOrbitInput(_ input: String) -> OrbitMap {
    let rawRelationships = input.components(separatedBy: .newlines)
    let relationships = rawRelationships.map { raw -> OrbitRelationship in
        let orbits = raw.components(separatedBy: ")")
        return OrbitRelationship(orbitedObject: orbits[0], orbitingObject: orbits[1])
    }
    return OrbitMap.parse(orbitRelationships: relationships, topNodeValue: "COM")
}
