//
//  FromJSONDict.swift
//  SOP
//
//  Created by Chris Eidhof on 29.11.18.
//  Copyright © 2018 Chris Eidhof. All rights reserved.
//

import Foundation

struct TwoErrors: Error {
    let err0: Error
    let err1: Error
}

protocol FromJSONDict {
    init(json: Any) throws
}

protocol FromJSONDictHelper: Describes {
    func parse(_ value: Any) throws -> Value
}

func asResult<A>(_ f: () throws -> A) -> Either<A, Error> {
    do {
        return .l(try f())
    } catch {
        return .r(error)
    }
}

extension Product: FromJSONDictHelper where A: FromJSONDictHelper, B: FromJSONDictHelper {
    func parse(_ value: Any) throws -> (A.Value, B.Value) {
        switch asResult({ try a.parse(value) }) {
        case let .l(p1):
            let p2 = try b.parse(value)
            return (p1, p2)
        case let .r(e1):
            do {
                let _ = try b.parse(value)
            } catch {
                throw TwoErrors(err0: e1, err1: error)
            }
            throw e1
        }
    }
}

extension Sum: FromJSONDictHelper where A: FromJSONDictHelper, B: FromJSONDictHelper {
    func parse(_ value: Any) throws -> Either<A.Value, B.Value> {
        do { return try .l(a.parse(value)) }
        catch {
            return try .r(b.parse(value))
        }
    }
}

struct JSONError: Error {
    let file: StaticString
    let line: UInt
    let message: String
    init(message: String = "", file: StaticString = #file, line: UInt = #line) {
        self.message = message
        self.file = file
        self.line = line
    }
}

extension Label: FromJSONDictHelper where A: FromJSONDictHelper {
    func parse(_ value: Any) throws -> A.Value {
        guard let x = value as? [String:Any], let y = x[label] else { throw JSONError(message: "Expected key \(label) in context \(value)") }
        return try a.parse(y)
    }
}

extension TypeName: FromJSONDictHelper where A: FromJSONDictHelper {
    func parse(_ value: Any) throws -> A.Value {
        return try a.parse(value)
    }
}

extension K: FromJSONDictHelper where A: FromJSONDict {
    func parse(_ value: Any) throws -> A {
        return try A(json: value)
    }
}

extension Unit: FromJSONDictHelper {
    func parse(_ value: Any) throws -> () {
        return ()
    }
}

struct ExpectedKey: Error {
    let key: String
}

extension Case: FromJSONDictHelper where A: FromJSONDictHelper, OtherCases: FromJSONDictHelper {
    func parse(_ value: Any) throws -> Either<A.Value, OtherCases.Value> {
        if let s = value as? [String:Any], let x = s[name] {
            return .l(try a.parse(x))
        }

        do {
            return try .r(b.parse(value))
        } catch {
            throw OrErr(one: ExpectedKey(key: name), two: error, context: value)
        }
    }
}

extension Sentinel: FromJSONDictHelper {
    func parse(_ value: Any) throws -> Never {
        throw JSONError()
    }
}

struct OrErr: Error {
    let one: Error
    let two: Error
    let context: Any
}
extension FromJSONDict {
    init(json: Any) throws {
        guard let s = json as? Self else { throw JSONError(message: "Expected \(Self.self), got \(type(of: json))") }
        self = s
    }
}
extension String: FromJSONDict {}
extension Int: FromJSONDict {}
extension Bool: FromJSONDict {}

extension Generic where Structure: FromJSONDictHelper {
    init(json: Any) throws {
        self.init(try Self.structure.parse(json))
    }
}
