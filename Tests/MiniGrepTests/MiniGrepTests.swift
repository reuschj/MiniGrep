import XCTest
import class Foundation.Bundle
import QueryRangeIterator

@testable import MiniGrepLib

final class MiniGrepTests: XCTestCase {

    // Test filename
    let filename: String = "./Tests/MiniGrepTests/Assets/poem.txt"

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testRangeIterator() {
        let query = "foo"
        let content = "foobarfoobazbarfoobazboofoob"
        var selects = QueryRangeIterator(query, in: content)
        var nonSelects = QueryRangeIterator(query, in: content, inverted: true)
        print(selects.collectStrings())
        print(nonSelects.collectStrings())
//        selects.collect().forEach { print($0.getIndexRange(in: content)) }
//        nonSelects.collect().forEach { print($0.getIndexRange(in: content)) }
//        content.getRanges(of: query)?.forEach { print($0.getIndexRange(in: content)) }
//        content.getRanges(of: query, inverted: true)?.forEach { print($0.getIndexRange(in: content)) }
        var foo: String = ""
        measure {
            foo = QueryRangeIterator.transform(query, in: content) { $0.uppercased() }
        }
        print(foo)
    }

    func testReadingFile() {
        let file = readFile(at: filename)
        XCTAssertNotNil(file)
    }

    func testSearch() throws {
        let query = "you"
        let search = Search(
            for: query,
            in: filename
        )
        do {
            let results = try search.getResults()
            XCTAssertEqual(results.count, 4)
        } catch SearchError.fileNotFound(let filename) {
            XCTFail("Could not find filename: \(filename)")
        } catch SearchError.queryNotFound(let query, _) {
            XCTFail("Could not find query in file: \(query)")
        }
    }

    func testCaseInsensitiveSearch() throws {
        let query = "Are"
        let search = Search(
            for: query,
            in: filename,
            caseInsensitive: true
        )
        do {
            let results = try search.getResults()
            XCTAssertEqual(results.count, 2)
        } catch SearchError.fileNotFound(let filename) {
            XCTFail("Could not find filename: \(filename)")
        } catch SearchError.queryNotFound(let query, _) {
            XCTFail("Could not find query in file: \(query)")
        }
    }

    func testSearchAndDisplayAll() throws {
        let query = "you"
        let search = Search(
            for: query,
            in: filename,
            showAllLines: true
        )
        do {
            let results = try search.getResults()
            XCTAssertEqual(results.count, 8)
        } catch SearchError.fileNotFound(let filename) {
            XCTFail("Could not find filename: \(filename)")
        } catch SearchError.queryNotFound(let query, _) {
            XCTFail("Could not find query in file: \(query)")
        }
    }

    func testSearchFailureForMissingFile() throws {
        let query = "you"
        let search = Search(
            for: query,
            in: "notThere.txt"
        )
        do {
            let results = try search.getResults()
            XCTAssertEqual(results.count, 0)
        } catch SearchError.fileNotFound(_) {
            // Should get here
        } catch SearchError.queryNotFound(let query, _) {
            XCTFail("Could not find query in file: \(query)")
        }
    }

    func testSearchQueryNotFound() throws {
        let query = "this will not be found"
        let search = Search(
            for: query,
            in: filename
        )
        do {
            let results = try search.getResults()
            XCTAssertEqual(results.count, 0)
        } catch SearchError.fileNotFound(let filename) {
            XCTFail("Could not find filename: \(filename)")
            // Should get here
        } catch SearchError.queryNotFound(_, _) {
            // Should get here
        }
    }

    func testGetRangesInString() {
        let testString = "Foo bar baz bar barbazbar"
        let query = "bar"
        let ranges = testString.getRanges(of: query)
        XCTAssertEqual(ranges?.count, 4)
        let expectations: [(Int, Int)] = [
            (4, 7),
            (12, 15),
            (16, 19),
            (22, 25)
        ]
        ranges?.getIndexList(in: testString).enumerated().forEach { (index, range) in
            XCTAssertEqual(range.lowerBound, expectations[index].0)
            XCTAssertEqual(range.upperBound, expectations[index].1)
        }
    }
}
