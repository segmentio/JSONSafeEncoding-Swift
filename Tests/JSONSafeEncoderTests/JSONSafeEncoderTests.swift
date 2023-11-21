import XCTest
@testable import JSONSafeEncoder

final class JSONSafeEncoderTests: XCTestCase {
    func testRegularEncoding() throws {
        struct TestStruct: Codable {
            let myString: String
            let myDouble: Double
        }
        
        let test = TestStruct(myString: "this is a test", myDouble: 3.1)
        
        let encoder = JSONSafeEncoder()
        encoder.outputFormatting = .prettyPrinted
        
        let json = try encoder.encode(test)
        XCTAssertNotNil(json)
        
        let prettyString = String(data: json, encoding: .utf8)!
        print(prettyString)
        
        
        let decoder = JSONDecoder()
        let newTest = try decoder.decode(TestStruct.self, from: json)
        
        XCTAssertEqual(newTest.myString, "this is a test")
        XCTAssertEqual(newTest.myDouble, 3.1)
    }
    
    func testRegularEncodingThrows() throws {
        struct TestStruct: Codable {
            let myString: String
            let myDouble: Double
        }
        
        let test = TestStruct(myString: "this is a test", myDouble: Double.nan)
        
        let encoder = JSONSafeEncoder()
        encoder.nonConformingFloatEncodingStrategy = .throw
        encoder.outputFormatting = .prettyPrinted
        
        var didThrow = false
        do {
            let json = try encoder.encode(test)
            
            let prettyString = String(data: json, encoding: .utf8)!
            print(prettyString)
        } catch {
            didThrow = true
        }
        XCTAssertTrue(didThrow)
    }

    func testRegularEncodingZeros() throws {
        struct TestStruct: Codable {
            let myString: String
            let myDouble: Double
        }
        
        let test = TestStruct(myString: "this is a test", myDouble: Double.nan)
        
        let encoder = JSONSafeEncoder()
        encoder.nonConformingFloatEncodingStrategy = .zero
        encoder.outputFormatting = .prettyPrinted
        
        let json = try encoder.encode(test)
        XCTAssertNotNil(json)
        
        let prettyString = String(data: json, encoding: .utf8)!
        print(prettyString)
        
        
        let decoder = JSONDecoder()
        let newTest = try decoder.decode(TestStruct.self, from: json)
        
        XCTAssertEqual(newTest.myString, "this is a test")
        XCTAssertEqual(newTest.myDouble, 0)
    }

    func testRegularEncodingNulls() throws {
        struct TestStruct: Codable {
            let myString: String
            let myDouble: Double?
        }
        
        let test = TestStruct(myString: "this is a test", myDouble: Double.nan)
        
        let encoder = JSONSafeEncoder()
        encoder.nonConformingFloatEncodingStrategy = .null
        encoder.outputFormatting = .prettyPrinted
        
        let json = try encoder.encode(test)
        XCTAssertNotNil(json)
        
        let prettyString = String(data: json, encoding: .utf8)!
        print(prettyString)
        
        let decoder = JSONDecoder()
        let newTest = try decoder.decode(TestStruct.self, from: json)
        
        XCTAssertEqual(newTest.myString, "this is a test")
        XCTAssertEqual(newTest.myDouble, nil)
    }
    
    func testRegularEncodingStrings() throws {
        struct TestStruct: Codable {
            let myString: String
            let myDouble: Double
        }
        
        var test: TestStruct
        var json: Data
        var prettyString: String
        let encoder = JSONSafeEncoder()
        encoder.nonConformingFloatEncodingStrategy = .convertToString(positiveInfinity: "inf", negativeInfinity: "-inf", nan: "nan")
        encoder.outputFormatting = .prettyPrinted

        test = TestStruct(myString: "this is a test", myDouble: Double.nan)
        json = try encoder.encode(test)
        XCTAssertNotNil(json)
        prettyString = String(data: json, encoding: .utf8)!
        print(prettyString)
        // not my favorite thing to do, but this one is a bit difficult to test.
        XCTAssertTrue(prettyString.contains("nan"))
        
        test = TestStruct(myString: "this is a test", myDouble: Double.infinity)
        json = try encoder.encode(test)
        XCTAssertNotNil(json)
        prettyString = String(data: json, encoding: .utf8)!
        print(prettyString)
        // not my favorite thing to do, but this one is a bit difficult to test.
        XCTAssertTrue(prettyString.contains("inf"))
        
        test = TestStruct(myString: "this is a test", myDouble: -Double.infinity)
        json = try encoder.encode(test)
        XCTAssertNotNil(json)
        prettyString = String(data: json, encoding: .utf8)!
        print(prettyString)
        // not my favorite thing to do, but this one is a bit difficult to test.
        XCTAssertTrue(prettyString.contains("-inf"))
        
        // check the defaults we made
        encoder.nonConformingFloatEncodingStrategy = .convertToStringDefaults
        
        test = TestStruct(myString: "this is a test", myDouble: Double.nan)
        json = try encoder.encode(test)
        XCTAssertNotNil(json)
        prettyString = String(data: json, encoding: .utf8)!
        print(prettyString)
        // not my favorite thing to do, but this one is a bit difficult to test.
        XCTAssertTrue(prettyString.contains("NaN"))
        
        test = TestStruct(myString: "this is a test", myDouble: Double.infinity)
        json = try encoder.encode(test)
        XCTAssertNotNil(json)
        prettyString = String(data: json, encoding: .utf8)!
        print(prettyString)
        // not my favorite thing to do, but this one is a bit difficult to test.
        XCTAssertTrue(prettyString.contains("Infinity"))
        
        test = TestStruct(myString: "this is a test", myDouble: -Double.infinity)
        json = try encoder.encode(test)
        XCTAssertNotNil(json)
        prettyString = String(data: json, encoding: .utf8)!
        print(prettyString)
        // not my favorite thing to do, but this one is a bit difficult to test.
        XCTAssertTrue(prettyString.contains("-Infinity"))

    }
}
