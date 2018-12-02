//
//  XML.swift
//  SOP
//
//  Created by Chris Eidhof on 26.11.18.
//  Copyright © 2018 Chris Eidhof. All rights reserved.
//

import Foundation


enum Node {
    case none
    case node(El)
    case text(String)
}

struct El {
    var name: String
    var attributes: [String:String]
    var block: Bool
    var children: [Node]
    
    init(name: String, block: Bool = true, attributes: [String:String] = [:], children: [Node] = []) {
        self.name = name
        self.attributes = attributes
        self.children = children
        self.block = block
    }
}

extension String {
    var addingUnicodeEntities: String {
        return unicodeScalars.reduce(into: "", { $0.append($1.escapingIfNeeded) })
    }
}

// This extension is from HTMLString: https://github.com/alexaubry/HTMLString
extension UnicodeScalar {
    /// Returns the decimal HTML entity for this Unicode scalar.
    public var htmlEscaped: String {
        return "&#" + String(value) + ";"
    }
    
    /// Escapes the scalar only if it needs to be escaped for Unicode pages.
    ///
    /// [Reference](http://wonko.com/post/html-escaping)
    fileprivate var escapingIfNeeded: String {
        switch value {
        case 33, 34, 36, 37, 38, 39, 43, 44, 60, 61, 62, 64, 91, 93, 96, 123, 125: return htmlEscaped
        default: return String(self)
        }
        
    }
}

extension Dictionary where Key == String, Value == String {
    var asAttributes: String {
        return isEmpty ? "" : " " + map { (k,v) in
            "\(k)=\"\(v.addingUnicodeEntities)\""
            }.joined(separator: " ")
        
    }
}

extension El {
    func render(encodeText: (String) -> String) -> String {
        let atts: String = attributes.asAttributes
        if children.isEmpty && !block {
            return "<\(name)\(atts) />"
        } else if block {
            return "<\(name)\(atts)>\n" + children.map { $0.render(encodeText: encodeText) }.joined(separator: "\n") + "\n</\(name)>"
        } else {
            return "<\(name)\(atts)>" + children.map { $0.render(encodeText: encodeText) }.joined(separator: "") + "</\(name)>"
        }
    }
}

extension Node {
    func render(encodeText: (String) -> String = { $0.addingUnicodeEntities }) -> String {
        switch self {
        case .none: return ""
        case .text(let s): return encodeText(s)
        case .node(let n): return n.render(encodeText: encodeText)
        }
    }    
}
