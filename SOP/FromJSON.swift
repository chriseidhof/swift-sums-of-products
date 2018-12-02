//
//  FromJSONDict.swift
//  SOP
//
//  Created by Chris Eidhof on 29.11.18.
//  Copyright © 2018 Chris Eidhof. All rights reserved.
//

import Foundation

struct JSONError: Error {
    enum Reason {
        case keyNotFound(String, context: Any)
        case wrongType(expected: Any.Type, got: Any.Type)
        case multiple(Error, Error)
        case or(Error, Error)
    }
    let file: StaticString
    let line: UInt
    let reason: Reason
    init(_ reason: Reason, file: StaticString = #file, line: UInt = #line) {
        self.reason = reason
        self.file = file
        self.line = line
    }
}



protocol FromJSON {
    init(json: Any) throws
}

protocol FromJSONHelper: Describes {
    func parse(_ value: Any) throws -> Value
}

func asResult<A>(_ f: () throws -> A) -> Either<A, Error> {
    do {
        return .l(try f())
    } catch {
        return .r(error)
    }
}

extension Product: FromJSONHelper where A: FromJSONHelper, B: FromJSONHelper {
    func parse(_ value: Any) throws -> (A.Value, B.Value) {
        switch asResult({ try a.parse(value) }) {
        case let .l(p1):
            let p2 = try b.parse(value)
            return (p1, p2)
        case let .r(e1):
            do {
                let _ = try b.parse(value)
            } catch {
                throw JSONError(.multiple(e1, error))
            }
            throw e1
        }
    }
}

extension Sum: FromJSONHelper where A: FromJSONHelper, B: FromJSONHelper {
    func parse(_ value: Any) throws -> Either<A.Value, B.Value> {
        do { return try .l(a.parse(value)) }
        catch {
            return try .r(b.parse(value))
        }
    }
}



extension Label: FromJSONHelper where A: FromJSONHelper {
    func parse(_ value: Any) throws -> A.Value {
        guard let x = value as? [String:Any], let y = x[label] else {
            throw JSONError(.keyNotFound(label, context: value))
            
        }
        return try a.parse(y)
    }
}

extension TypeName: FromJSONHelper where A: FromJSONHelper {
    func parse(_ value: Any) throws -> A.Value {
        return try a.parse(value)
    }
}

extension K: FromJSONHelper where A: FromJSON {
    func parse(_ value: Any) throws -> A {
        return try A(json: value)
    }
}

extension Unit: FromJSONHelper {
    func parse(_ value: Any) throws -> () {
        return ()
    }
}

extension Case: FromJSONHelper where A: FromJSONHelper, OtherCases: FromJSONHelper {
    func parse(_ value: Any) throws -> Either<A.Value, OtherCases.Value> {
        let s: Either<A.Value, Error> = asResult {
            guard let s = value as? [String:Any], let x = s[name] else {
                throw JSONError(.keyNotFound(name, context: value))
            }
            return try a.parse(x)
        }
        
        switch s {
            case let .l(value): return .l(value)
        case let .r(err):
            do {
                return try .r(b.parse(value))
            } catch {
                throw JSONError(.or(err, error))
            }

        }

    }
}

extension Sentinel: FromJSONHelper {
    func parse(_ value: Any) throws -> Never {
        throw JSONError(.keyNotFound("sentinel", context: value))
    }
}

struct OrErr: Error {
    let one: Error
    let two: Error
    let context: Any
}
extension FromJSON {
    init(json: Any) throws {
        guard let s = json as? Self else {
            throw JSONError(.wrongType(expected: Self.self, got: type(of: json)))
        }
        self = s
    }
}
extension String: FromJSON {}
extension Int: FromJSON {}
extension Bool: FromJSON {}

extension Generic where Structure: FromJSONHelper {
    init(json: Any) throws {
        self.init(try Self.structure.parse(json))
    }
}
