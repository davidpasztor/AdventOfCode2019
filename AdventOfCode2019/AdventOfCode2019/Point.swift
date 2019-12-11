//
//  Point.swift
//  AdventOfCode2019
//
//  Created by David Pasztor on 10/12/2019.
//  Copyright © 2019 David Pasztor. All rights reserved.
//

import Foundation

struct Point: Hashable {
    let x: Int
    let y: Int
}

extension Point {
    /// Return the `Point` resulting in adding the vector (`diffX`, `diffY`) to `self`
    func moveByVector(diffX: Int, diffY: Int) -> Point {
        return Point(x: x + diffX, y: y + diffY)
    }
}

extension Point: CustomStringConvertible {
    var description: String {
        return "(x: \(x), y: \(y))"
    }
}
