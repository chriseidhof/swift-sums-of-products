//
//  Doc.swift
//  SOP
//
//  Created by Chris Eidhof on 29.11.18.
//  Copyright © 2018 Chris Eidhof. All rights reserved.
//

import Foundation

indirect enum Doc {
    case empty
    case text(String)
    case indent(Doc)
    case lines([Doc])
}

extension Array where Element == Doc {
    func render(indent: Int = 0) -> String {
        return map { $0.render(indent: indent) }.joined(separator: "\n")
    }
}
extension Doc {
    func render(indent: Int = 0) -> String {
        switch self {
        case .empty:
            return ""
        case .text(let s):
            return String(repeating: " ", count: indent) + s
        case .lines(let l):
            return l.render(indent: indent)
        case .indent(let r):
            return r.render(indent: indent + 2)
        }
    }
}
