extension String {

    /// Wraps the string with escapes to produce the given terminal color
    public func terminalColor(_ color: TerminalColor) -> Self { color.wrap(self) }

    /// Gets ranges of the given search query within the string (or inverted ranges)
    public func getRanges<Query: StringProtocol>(of query: Query, inverted: Bool = false) -> [Range<String.Index>]? {
        var rangeIterator = QueryRangeIterator(String(query), in: self, inverted: inverted)
        let ranges = rangeIterator.collect()
        return ranges.isEmpty ? nil : ranges
    }
    
    /// Maps ranges of the given search query within the string (or inverted ranges)
    public func mapRanges<Query: StringProtocol, R>(of query: Query, inverted: Bool = false, _ transform: (Range<String.Index>) -> R) -> [R]? {
        var rangeIterator = QueryRangeIterator(String(query), in: self, inverted: inverted)
        let ranges = rangeIterator.map(transform)
        return ranges.isEmpty ? nil : ranges
    }
}

extension String.Index {
    /// Gets the index as an integer in the given string content.
    public func getIndex<Content: StringProtocol>(in content: Content) -> Int {
        return self.utf16Offset(in: content)
    }

    /// Returns a new index shifted by the given offset for the given content.
    public func shift<Content: StringProtocol>(by index: String.IndexDistance, in content: Content) -> Self {
        return content.index(self, offsetBy: index)
    }
}
