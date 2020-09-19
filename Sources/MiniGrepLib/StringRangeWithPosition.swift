/// Holds a range for a search query within a string but also with
/// that range expressed as the "position".
public struct StringRangeWithPosition {
    public var range: Range<String.Index>
    public var position: Range<Int>

    /// Initializer with range and query string.
    public init(_ range: Range<String.Index>, of query: String) {
        self.range = range
        let start: Int = range.lowerBound.utf16Offset(in: query) + Self.offset
        let end: Int = range.upperBound.utf16Offset(in: query) + Self.offset
        self.position = start..<end
    }

    /// Initializer with range and start end indices as ints.
    public init(_ range: Range<String.Index>, start: Int, end: Int) {
        self.range = range
        self.position = (start + Self.offset)..<(end + Self.offset)
    }

    private static let offset: Int = 0
}

extension StringRangeWithPosition: CustomStringConvertible {
    /// String representation
    public var description: String { "StringRangeWithPosition: \(position.lowerBound)..<\(position.upperBound)" }
}
