extension Range where Range.Bound == String.Index {

    /// Gets the `Range` as an integer in the given string content.
    public func getIndexRange<Content: StringProtocol>(
        in content: Content
    ) -> Range<Int> {
        let lower = self.lowerBound.getIndex(in: content)
        let upper = self.upperBound.getIndex(in: content)
        return lower..<upper
    }

    /// Returns a new `Range` with both low and high bounds shifted by the given offset for the given content.
    public func shift<Content: StringProtocol>(
        by index: String.IndexDistance,
        in content: Content
    ) -> Range<String.Index> {
        let lower = self.lowerBound.shift(by: index, in: content)
        let upper = self.upperBound.shift(by: index, in: content)
        return lower..<upper
    }
}
