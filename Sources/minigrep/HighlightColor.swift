import ArgumentParser

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
}