extension Collection where Element == Range<String.Index> {

    /// Gets the `Range` as an integer in the given string content for each `Range` in a collection.
    public func getIndexList<Content: StringProtocol>(in content: Content) -> [Range<Int>] {
        return self.map { $0.getIndexRange(in: content) }
    }

    /// Returns a new `Range` with both low and high bounds shifted by the given offset for the given content for each `Range` in a collection.
    public func shifted<Content: StringProtocol>(
        by index: String.IndexDistance,
        in content: Content
    ) -> [Range<String.Index>] {
        return self.map { $0.shift(by: index, in: content) }
    }

    /// For a collection of `Range`s, gets all indices in the string that aren't part of those ranges for the
    /// given string content. It gets the opposite or "unselected" part of the range as new collection
    /// of `Ranges`.
    public func getInverseRanges<Content: StringProtocol>(in content: Content) -> [Range<String.Index>] {
        var inverseList = [Range<String.Index>]()
        var currentLow = content.startIndex
        var currentHigh = content.startIndex
        self.enumerated().forEach {(index, range) in
            currentHigh = range.lowerBound
            // This will stop the add if the first found range is at the start
            if range.lowerBound > content.startIndex {
                inverseList.append(currentLow..<currentHigh)
            }
            currentLow = range.upperBound
            // Adds any tail after the last found range
            if index == self.count - 1 && range.upperBound < content.endIndex {
                inverseList.append(currentLow..<content.endIndex)
            }
        }
        return inverseList
    }
}
