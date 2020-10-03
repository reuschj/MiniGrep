/// Iterates content and finds all ranges of the query
public struct QueryRangeIterator<Content> where Content: StringProtocol {
    var inverted: Bool
    let query: Content
    var currentContent: Content.SubSequence
    let fullContent: Content

    public init(_ query: Content, in content: Content, inverted: Bool = false) {
        self.query = query
        self.currentContent = content[content.startIndex..<content.endIndex]
        self.fullContent = content
        self.inverted = inverted
    }
}

/// Conforms to the iterator protocol
extension QueryRangeIterator: IteratorProtocol {
    public typealias Element = Range<String.Index>
    
    /// Gets the next item in the iterator
    public mutating func next() -> Element? {
        if inverted {
            return nextInverted()
        }
        return nextStandard()
    }
    
    /// Maps all iterated elements to a collection type
    public mutating func map<R>(_ transform: (Element) -> R) -> [R] {
        var mappedCollection: [R] = []
        while let next = self.next() {
            let result: R = transform(next)
            mappedCollection.append(result)
        }
        return mappedCollection
    }
    
    /// Collects all iterated elements to a collection type and performs a side effect
    public mutating func forEach(_ body: (Element) -> Void) -> [Element] {
        var mappedCollection: [Element] = []
        while let next = self.next() {
            body(next)
            mappedCollection.append(next)
        }
        return mappedCollection
    }
    
    /// Collects all iterated elements to a collection type
    public mutating func collect() -> [Element] {
        var collection: [Element] = []
        while let next = self.next() {
            collection.append(next)
        }
        return collection
    }

    /// Gets the next query range in the content
    private mutating func nextStandard() -> Element? {
        guard let range = currentContent.range(of: query) else { return nil }
        let endIndex = range.upperBound
        guard endIndex <= currentContent.endIndex else { return nil }
        let shiftedRange = range.shift(by: 0, in: fullContent)
        currentContent = currentContent[endIndex..<currentContent.endIndex]
        return shiftedRange
    }

    /// Gets the next non-query range in the content (content between queries)
    private mutating func nextInverted() -> Element? {
        let startIndex = currentContent.startIndex
        let queryRange = currentContent.range(of: query)
        let endIndex = queryRange?.lowerBound ?? currentContent.endIndex
        let nextQueryEnd = queryRange?.upperBound ?? currentContent.endIndex
        let nextStart = nextQueryEnd <= currentContent.endIndex ? nextQueryEnd : currentContent.endIndex
        let range = startIndex..<endIndex
        let shiftedRange = range.shift(by: 0, in: fullContent)
        currentContent = currentContent[nextStart..<currentContent.endIndex]
        guard startIndex < endIndex || !currentContent.isEmpty else { return nil }
        return shiftedRange
    }
}
