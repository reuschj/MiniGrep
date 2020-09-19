/// Holds information about a line of text with 
public struct Line {
    public var text: String
    public var originalIndex: Int
    var foundQuery: [String]?
    var locations: [Range<String.Index>]?
    var highlightColor: TerminalColor? = .yellow

    public init(
        _ text: String,
        at index: Int,
        found: [String]?,
        locations: [Range<String.Index>?]? = nil,
        highlightColor: TerminalColor? = .yellow
    ) {
        self.text = text
        self.originalIndex = index
        self.foundQuery = found
        self.locations = locations?.compactMap { $0 }
        self.highlightColor = highlightColor
    }

    /// Flag for if line contains query.
    public var hasQuery: Bool { foundQuery.map { $0.count > 0 } ?? false }

    /// Gets text tagged with the index locations of the search result (if it exists).
    public var taggedText: String {
        guard let locations = locations else { return text }
        let rangeStrings: [String] = locations.map {
            let start = $0.lowerBound.getIndex(in: text)
            let end = $0.upperBound.getIndex(in: text)
            let length = end - start
            return length > 1 ? "\(start)-\(end)" : "\(start)"
        }
        return "Found at \(rangeStrings.joined(separator: ", ")): \(text)"
    }

    /// Gets the the final string output.
    public func getOutput(tagged: Bool = true) -> String {
        tagged ? taggedText : text
    }
}
