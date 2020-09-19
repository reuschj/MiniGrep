/// Error type for `Search`.
public enum SearchError: Error, CustomStringConvertible {
    case fileNotFound(filename: String)
    case queryNotFound(query: String, filename: String)

    public var description: String {
        switch self {
        case .fileNotFound(let filename):
            return "The file \"\(filename)\" was not found."
        case .queryNotFound(let query, let filename):
            return "The query \"\(query)\" was not found in \(filename)."
        }
    }
}

/// Holds a single search for a given query in a given file.
public struct Search: SearchProtocol {
    // Search ---------------------------------- /
    /// The string of text the user is looking for.
    public var query: String
    /// The path to the file the user wants to search through.
    public var filename: String

    // Options ---------------------------------- /

    /// Highlights the found query in this color. Pass `nil` to disable highlighting.
    public var highlightColor: TerminalColor?
    /// If enabled, search results will ignore case. Case-sensitivity is default.
    public var caseInsensitive: Bool
    /// If enabled, all lines will print. By default, only lines with found query will print.
    public var allLines: Bool
    public var tagged: Bool

    public init(
        for query: String,
        in filename: String,
        highlightColor: TerminalColor? = .yellow,
        caseInsensitive: Bool = false,
        showAllLines: Bool = false,
        tagLines: Bool = false
    ) {
        self.query = query
        self.filename = filename
        self.highlightColor = highlightColor
        self.caseInsensitive = caseInsensitive
        self.allLines = showAllLines
        self.tagged = tagLines
    }

    /// Runs the search and generates output.
    public func getResults() throws -> [String] {
        guard let displayLines = displayLines else {
            // File not found
            throw SearchError.fileNotFound(filename: filename)
        }
        guard displayLines.count > 0 else {
            // No results
            throw SearchError.queryNotFound(query: query, filename: filename)
        }
        return displayLines.map { $0.getOutput(tagged: tagged) }
    }

    /// Gets the full file text for current filename.
    public var fileContent: String? { readFile(at: filename) }

    /// Gets all lines in the specified file
    private var lines: [Substring]? {
        guard let content = fileContent else { return nil }
        return content.split(separator: "\n")
    }

    /// Return an array with all lines from the file
    private var displayLines: [Line]? {
        guard let lines = lines else { return nil }
        return lines.enumerated().compactMap { (index, lineText) in
            getLine(for: String(lineText), at: index)
        }
    }

    /// Highlights the given query for the given content.
    private func highlight(_ content: String) -> String {
        guard let selects = getRanges(for: content) else { return content }
        let rest = selects.getInverseRanges(in: content)
        let selectedSubs: [(String, String.Index)] = selects.map {
            (addHighlight(to: String(content[$0])), $0.lowerBound)
        }
        let unselectedSubs: [(String, String.Index)] = rest.map {
            (String(content[$0]), $0.lowerBound)
        }
        let merged: [String] = (selectedSubs + unselectedSubs).sorted { $0.1 < $1.1 }.map { $0.0 }
        return merged.joined()
    }

    private func addHighlight(to text: String) -> String {
        guard let highlightColor = highlightColor else { return text }
        return text.terminalColor(highlightColor)
    }

    /// Builds a `Line` structure. Returns no `Line` if line content has no query
    /// and `allLines` setting is off.
    private func getLine(for content: String, at index: Int) -> Line? {
        let ranges = getRanges(for: content)
        guard allLines || ranges != nil else { return nil }
        let foundQuery = ranges?.map { String(content[$0]) }
        let lineText = getLineText(for: content)
        return Line(
            lineText,
            at: index,
            found: foundQuery,
            locations: ranges,
            highlightColor: highlightColor
        )
    }

    /// Gets ranges of given query within given content.
    private func getRanges(for content: String) -> [Range<String.Index>]? {
        let searchQuery = getSearchContent(for: query)
        let searchContent = getSearchContent(for: content)
        return searchContent.getRanges(of: searchQuery)
    }

    /// Gets search content (depends on if case-sensitive or not).
    private func getSearchContent(for content: String) -> String {
        guard caseInsensitive else { return content }
        return content.lowercased()
    }

    /// Gets line text (depends on if highlighted or not).
    private func getLineText(for content: String) -> String {
        guard highlightColor != nil else { return content }
        return highlight(content)
    }

    /// Prints the given string with (optional)
    /// new line before (on by default) and
    /// new line after (off by default)
    private func print(_ content: String?, before: Bool = true, after: Bool = false) {
        guard let content = content else { return }
        Swift.print("\(before ? "\n" : "")\(content)\(after ? "\n" : "")")
    }
}
