import Foundation

/// Reads a file at the given path and out
public func readFile(at filename: String) -> String? {
    let possibleFile: FileHandle? = FileHandle(forReadingAtPath: filename)
    guard let file = possibleFile else { return nil }
    let data = file.readDataToEndOfFile()
    file.closeFile()
    return String(data: data, encoding: .utf8)
}
