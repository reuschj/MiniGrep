extension String {

    /// Wraps the string with escapes to produce the given terminal color
    public func terminalColor(_ color: TerminalColor) -> Self { color.wrap(self) }

    public func getRanges<Query: StringProtocol>(of query: Query) -> [Range<String.Index>]? {
        let queryLength = query.count
        var ranges: [Range<String.Index>] = []
        // This will be updated to keep track of where we are in the overall content
        var currentPosition: Int = 0
        // These will be updated to reflect the indices within the overall content vs. current substring
        var start: Self.Index = self.startIndex
        var end: Self.Index = start
        /// Recursively runs until range is nil (cannot find in remaining substring)
        func getNextRange(from input: Self) {
            guard let range = input.range(of: query) else { return } // When this returns, we're done looking
            // Gets the offset of new range within original content
            let startOffset = range.lowerBound.getIndex(in: self)
            // Updates current position to match this offset
            currentPosition += startOffset
            // End index will be calculated based on the query length
            let endIndex = currentPosition + queryLength
            // Now we'll update the start and end before adding range to array
            start = self.index(start, offsetBy: startOffset )
            end = self.index(start, offsetBy: queryLength)
            ranges.append(start..<end)
            // Advance the current position and start
            currentPosition = endIndex
            start = end
            // Make the next substring from remaining characters and call the function recursively
            let nextString = input[range.upperBound..<input.endIndex]
            getNextRange(from: Self(nextString))
        }
        getNextRange(from: self)
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
