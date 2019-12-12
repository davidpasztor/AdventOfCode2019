//
//  Point.swift
//  AdventOfCode2019
//
//  Created by David Pasztor on 10/12/2019.
//  Copyright © 2019 David Pasztor. All rights reserved.
//

import Foundation

/// Point in a 2D coordinate system
struct Point: Hashable {
    let x: Int
    let y: Int
}

/// Represents a movement in a 2D coordinate system
struct Vector {
    let diffX: Int
    let diffY: Int

    /// Reduce the size of the `Vector` by `scale` - divide both its components by that
    func reduced(by scale: Int) -> Vector {
        return Vector(diffX: diffX / scale, diffY: diffY / scale)
    }

    /// Reduce `self` to be the smallest `Vector` with `Int` movements in the same direction as the original vector
    func unitVector() -> Vector {
        if diffX == 0 {
            if diffY == 0 {
                return self // 0.isMultiple(of: num) returns `true`, but then `scale` would become `0`, by which we cannot reduce the vector
            } else {
                return reduced(by: diffY) // If only one of the components are 0, we can reduce the other component to 1
            }
        } else if diffY == 0 {
            return reduced(by: diffX) // If only one of the components are 0, we can reduce the other component to 1
        } else if diffY.isMultiple(of: diffX) {
            return reduced(by: diffX)
        } else if diffX.isMultiple(of: diffY) {
            return reduced(by: diffY)
        } else {
            return self
        }
    }
}

extension Point {
    /// Return the `Point` resulting in adding the `vector` to `self`
    func movedBy(vector: Vector) -> Point {
        return Point(x: x + vector.diffX, y: y + vector.diffY)
    }
}

extension Point: CustomStringConvertible {
    var description: String {
        return "(x: \(x), y: \(y))"
    }
}
