import Foundation
import ArgumentParser
import MiniGrepLib
import TerminalColor

/// A command line tool to search text in a file.
struct Minigrep: ParsableCommand {

    @Argument(help: "The search string you are looking for.")
    var query: String

    @Argument(help: "The path to the file you wish to search.")
    var filename: String

    @Flag(
        name: .shortAndLong,
        inversion: .prefixedNo,
        help: "Prints all lines."
    )
    var all: Bool = false

    @Flag(
        name: .shortAndLong,
        inversion: .prefixedNo,
        help: "Tags the lines with query results with the position(s) of the query in each line."
    )
    var tagged: Bool = false

    @Flag(
        name: .shortAndLong,
        inversion: .prefixedNo,
        help: "Enables case insensitive search."
    )
    var insensitive: Bool = false

    @Option(
        name: .shortAndLong,
        help: "Sets the highlight color for found query [yellow|red|blue|green|white]."
    )
    var color: HighlightColor = .yellow

    /// Generates the search string text.
    private var searchString: String { "Searching for \"\(highlight(query, with: .green))\" in \(highlight(filename, with: .green))..." }

    /// Prints the given string with (optional)
    /// new line before (off by default) and
    /// new line after (off by default)
    private func print(_ content: String?, before: Bool = false, after: Bool = false) {
        guard let content = content else { return }
        Swift.print("\(before ? "\n" : "")\(content)\(after ? "\n" : "")")
    }

    /// Runs the command
    func run() {
        print(self.searchString, before: true, after: true)
        let search = Search(
            for: query,
            in: filename,
            highlightColor: color.terminalColor,
            caseInsensitive: insensitive,
            showAllLines: all,
            tagLines: tagged
        )
        do {
            let output = try search.getResults()
            output.forEach { print($0) }
        } catch {
            print(String(describing: error))
        }
    }
}

Minigrep.main()
