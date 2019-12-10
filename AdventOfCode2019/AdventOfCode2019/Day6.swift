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

func orbitCount(for map: String) -> Int {
    return 0
}
