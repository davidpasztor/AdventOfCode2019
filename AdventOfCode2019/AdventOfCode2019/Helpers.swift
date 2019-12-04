//
//  Helpers.swift
//  AdventOfCode2019
//
//  Created by David Pasztor on 04/12/2019.
//  Copyright © 2019 David Pasztor. All rights reserved.
//

import Foundation

public enum FileError: Error {
    case cannotFindJSON(named: String)
    case cannotFindFile(named: String, extension: String)
    case nonStringInput
}

/// Get the `URL` for a file named `filename` stored in the `Resources` bundle
public func fileURLInResources(filename: String, fileExtension: String) throws -> URL {
    let currentDirectoryURL = URL(fileURLWithPath: FileManager.default.currentDirectoryPath)
    let resourcesBundleURL = URL(fileURLWithPath: "InputResources.bundle", relativeTo: currentDirectoryURL)
    let resourcesBundle = Bundle(url: resourcesBundleURL)!
    guard let fileURL = resourcesBundle.url(forResource: filename, withExtension: fileExtension) else {
        throw FileError.cannotFindJSON(named: filename)
    }
    return fileURL
}

/// Parse the contents of a JSON file from the main Bundle
public func readInput<T: Decodable>(filename: String) throws -> T {
    let fileURL = try fileURLInResources(filename: filename, fileExtension: "json")
    let fileContent = try Data(contentsOf: fileURL)
    return try JSONDecoder().decode(T.self, from: fileContent)
}

/// Read the contents of a file stored in the main Bundle into a `Data`
public func readInput(filename: String, fileExtension: String = "txt") throws -> String {
    let fileURL = try fileURLInResources(filename: filename, fileExtension: fileExtension)
    let fileContent = try Data(contentsOf: fileURL)
    guard let inputString = String(data: fileContent, encoding: .utf8) else {
        throw FileError.nonStringInput
    }
    return inputString
}

/// Convert a `String` containing numeric values separated by a separator symbol into `[Int]`
public func parseInput(string: String, separator: CharacterSet) -> [Int] {
    return string.components(separatedBy: separator).compactMap { Int($0) }
}

/// Parses the input from a filename of the form `day\(day)input` into an `[Int]`
public func parseInput(day: Int, separator: CharacterSet) throws -> [Int] {
    let stringInput = try readInput(filename: "day\(day)input")
    return parseInput(string: stringInput, separator: separator)
}

func puzzleDay(n: Int) {
    print("-------------")
    print("Day\(n)")
}
