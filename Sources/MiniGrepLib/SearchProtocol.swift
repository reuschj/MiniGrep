import TerminalColor

public protocol SearchProtocol {
    var query: String { get set }
    var filename: String { get set }
    var highlightColor: TerminalColor? { get set }
    var caseInsensitive: Bool { get set }
    var allLines: Bool { get set }
    var tagged: Bool { get set }
    func getResults() throws -> [String]
}
