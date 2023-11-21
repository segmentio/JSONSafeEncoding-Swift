# JSONSafeEncoder for Swift

This library is a direct copy of JSONEncoder and it's associated types.  It expands upon JSONEncoder's `nonConformingFloatEncodingStrategy` to give developers more options in how to handle NaN / Infinity / -Infinity values.

## Why?

When using Codable, it's an onerous task to make sure all floating point values do not contain NaN or Infinity solely for the purposes of JSON encoding.  The options of what to do came down to either a custom number type (too heavy of an approach), or modifying the encoding process.

Since _some_ options existed already, it seemed like the most prudent and less invasive choice.

## What are the options?

The following values now exist for the `nonConformingFloatEncodingStrategy` options:

### `.zero`

Outputs a `0` as the value when NaN/Infinity are encountered.  This is the default.  It's the safest option to use in conjunction with JSONDecoder, as the value to be assigned in the struct does not need to change in any way.

### `.null`

Outputs `null` when NaN/Infinity are encountered.  This mimics how Javascript handles these values.

### `.convertToString(...)`

Convert NaN/Infinity to strings.  This was present already, however without defaults or guidance.

### `.throw`

This is the original behavior and will throw an error when NaN/Infinity is encountered.

### `.convertToStringDefaults`

This operates similarly to `.convertToString(...)`, however it provides defaults to match languages like Python, etc. The defaults are `NaN`, `Infinity` and `-Infinity`.

## Example

```swift
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
```

## License
```
Copyright (c) 2014 - 2021 Apple Inc. and the Swift project authors
Licensed under Apache License v2.0 with Runtime Library Exception

See https://swift.org/LICENSE.txt for license information
See https://swift.org/CONTRIBUTORS.txt for the list of Swift project authors

TWILIO NOTICE: Filenames and functionality have been modified from their original counterparts @
https://github.com/apple/swift-corelibs-foundation/blob/main/Sources/Foundation/JSONEncoder.swift

Copyright (c) 2023 Twilio Inc.
```

