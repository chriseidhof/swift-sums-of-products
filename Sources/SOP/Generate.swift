//
//  Generate.swift
//  SOP
//
//  Created by Chris Eidhof on 26.11.18.
//  Copyright © 2018 Chris Eidhof. All rights reserved.
//

import Foundation

struct Field {
    let name: String
    let type: String
}

struct Struct_ {
    let name: String
    let fields: [Field]
}

enum EnumField {
    case anonymous(type: String)
    case named(name: String, type: String)
}

struct EnumCase {
    let name: String
    let fields: [EnumField]
}

struct Enum {
    let name: String
    let cases: [EnumCase]
}


extension EnumCase {
    var prettyFields: String {
        guard !fields.isEmpty else { return "" }
        return "(" + fields.map { field in
            switch field {
            case let .anonymous(type: t): return t
            case let .named(name: n, type: t): return "\(n): \(t)"
            }
        }.joined(separator: ", ") + ")"
    }
}

extension EnumField {
    var asField: String {
        switch self {
        case let .anonymous(type: t): return "K<\(t)>"
        case let .named(name: _, type: t): return "Label<K<\(t)>>"
        }
    }
    
    var impl: String {
        switch self {
        case let .anonymous(type: t): return "K<\(t)>()"
        case let .named(name: n, type: t): return "Label(\"\(n)\", K<\(t)>())"
        }
    }
}

extension Array where Element == EnumField {
    var reprType: String {
        return reversed().reduce("UnitR", { result, el in
            "Product<\(el.asField),\(result)>"
        })
    }
    
    var impl: String {
        return reversed().reduce("UnitR()", { result, el in
            "Product(\(el.impl),\(result))"
        })
    }
    
    var toFields: String {
        return zip(0..., self).map {
            let access = String(repeating: ".1", count: $0.0)
            switch $0.1 {
            case .anonymous(_): return "x\(access).0"
            case .named(let n, _): return "\(n): x\(access).0"
            }
        }.joined(separator: ", ")
    }
}

extension Array where Element == EnumCase {
    var reprType: String {
        return reversed().reduce("Sentinel", { result, el in
            "Case<\(el.fields.reprType),\(result)>"
        })
    }
    
    var reprImpl: String {
        return reversed().reduce("Sentinel()", { result, el in
            "Case(\"\(el.name)\", \(el.fields.impl),\(result))"
        })
    }
    
    var fromSwitchImpl: [String] {
        var result: [String] = []
        for (index, c) in zip(0..., self) {
            let prefix = String(repeating: ".r(", count: index)
            let suffix = String(repeating: ")", count: index)
            let binding = c.fields.isEmpty ? "" : "(x)"
            let params = c.fields.isEmpty ? "" : "(\(c.fields.toFields))"
            result.append("case let \(prefix).l\(binding)\(suffix): self = .\(c.name)\(params)")
        }
        return result
    }
    
    var toImpl: [String] {
        return zip(0..., self).map { value in
            let i = value.0
            let c = value.1
            let bindings = (0..<c.fields.count).map { "x_\($0)" }
            let rhs = bindings.reversed().reduce("()") { res, el in
                return "(\(el), \(res))"
            }
            let prefix = String(repeating: ".r(", count: i)
            let suffix = String(repeating: ")", count: i)
            let lhsBindings = bindings.isEmpty ? "" : "(\(bindings.joined(separator: ", ")))"
            let let_ = bindings.isEmpty ? "" : "let "
            return "case \(let_).\(c.name)\(lhsBindings): return \(prefix).l(\(rhs)\(suffix))"
        }
    }
}

extension Enum {
    var code: [Doc] {
        return [
            .text("enum \(name) {"),
            .indent(.lines(cases.map { c in
                .text("case \(c.name)" + c.prettyFields)
            })),
            .text("}"),
            .text(""),
            .text("extension \(name): Generic {"),
            .indent(.lines([
                .text("typealias Repr = Named<\(cases.reprType)>"),
                .text(""),
                .text("static let repr: Repr = Named(\"\(name)\", \(cases.reprImpl))"),
                .text(""),
                .text("var to: Repr.Result {"),
                .indent(.lines([
                    .text("switch self {"),
                    .indent(.lines(cases.toImpl.map { .text($0) })),
                    .text("}")
                    ])),
                .text("}"),
                .text("init(_ from: Repr.Result) {"),
                .indent(.lines([
                    .text("switch from {"),
                    .indent(.lines(cases.fromSwitchImpl.map({ .text($0) }))),
                    .text("}")
                ])),
                .text("}")
            ])),
            .text("}"),
        ]
    }
}
