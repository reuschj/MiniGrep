import ArgumentParser
import TerminalColor

/// Enum of highlight options for found query
public enum HighlightColor: ExpressibleByArgument {
    case yellow, red, blue, green, white, none

    public init?(argument: String) {
        switch argument.lowercased() {
        case "yellow", "y": self = .yellow
        case "red", "r": self = .red
        case "blue", "b" : self = .blue
        case "green", "g": self = .green
        case "white", "w": self = .white
        default: return nil
        }
    }
    
    /// Converts to corresponding terminal color
    public var terminalColor: TerminalColor? {
        switch self {
        case .yellow: return .yellow
        case .red: return .lightRed
        case .blue: return .lightBlue
        case .green: return .green
        case .white: return .white
        default: return nil
        }
    }
}
