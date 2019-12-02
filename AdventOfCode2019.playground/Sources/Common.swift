import Foundation

public enum FileError: Error {
    case cannotFindJSON(named: String)
    case cannotFindFile(named: String, extension: String)
    case nonStringInput
}

/// Parse the contents of a JSON file from the main Bundle
public func readInput<T: Decodable>(filename: String) throws -> T {
    guard let fileURL = Bundle.main.url(forResource: filename, withExtension: "json") else {
        throw FileError.cannotFindJSON(named: filename)
    }
    let fileContent = try Data(contentsOf: fileURL)
    return try JSONDecoder().decode(T.self, from: fileContent)
}

/// Read the contents of a file stored in the main Bundle into a `Data`
public func readInput(filename: String, fileExtension: String = "txt") throws -> String {
    guard let fileURL = Bundle.main.url(forResource: filename, withExtension: fileExtension) else {
        throw FileError.cannotFindFile(named: filename, extension: fileExtension)
    }
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
