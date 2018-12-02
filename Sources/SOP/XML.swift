//
//  XML.swift
//  SOP
//
//  Created by Chris Eidhof on 26.11.18.
//  Copyright © 2018 Chris Eidhof. All rights reserved.
//

import Foundation

// convert any type to XML
protocol ToXML {
    var xml: Node { get }
}

protocol ToXMLNodes {
    var nodes: [Node] { get }
}

protocol ToXMLNode: Describes {
    func xml(_ value: Value) -> Node
}

protocol ResultToXMLNodes: Describes {
    func nodes(_ value: Value) -> [Node]
}

extension TypeName: ToXMLNode where A: ResultToXMLNodes {
    func xml(_ value: A.Value) -> Node {
        return Node.node(El(name: "\(name.lowercased())", children: a.nodes(value)))
    }
}

extension Product: ResultToXMLNodes where A: ToXMLNode, B: ResultToXMLNodes {
    func nodes(_ value: (A.Value, B.Value)) -> [Node] {
        return [a.xml(value.0)] + b.nodes(value.1)
    }
}

extension Case: ResultToXMLNodes where A: ResultToXMLNodes, OtherCases: ResultToXMLNodes {
    func nodes(_ value: Either<A.Value, OtherCases.Value>) -> [Node] {
        switch value {
        case let .l(x): return [Node.node(El(name: name, children: a.nodes(x)))]
        case let .r(x): return b.nodes(x)
        }
    }
}

extension Zero: ResultToXMLNodes {
    func nodes(_ value: Never) -> [Node] {
        switch value { }
    }
}

extension One: ResultToXMLNodes {
    func nodes(_ value: ()) -> [Node] {
        return []
    }
}
extension Label: ToXMLNode where A: ToXMLNode {
    func xml(_ value: A.Value) -> Node {
        return Node.node(El(name: label, children: [a.xml(value)]))
    }
}

extension K: ToXMLNode where A: ToXML {
    func xml(_ value: A) -> Node {
        return value.xml
    }
}

extension K: ResultToXMLNodes where A: ToXML {
    func nodes(_ value: A) -> [Node] {
        return [value.xml]
    }
}

extension String: ToXML {
    var xml: Node {
        return Node.text(self)
    }
}

extension Int: ToXML {
    var xml: Node {
        return Node.text("\(self)")
    }
}

extension Bool: ToXML {
    var xml: Node {
        return Node.text("\(self)")
    }
}

extension Optional: ToXML where Wrapped: ToXML {
    var xml: Node {
        switch self {
        case .none: return Node.none
        case .some(let value): return value.xml
        }
    }
}

extension Generic where Structure: ToXMLNode {
    var xml: Node {
        return Self.structure.xml(to)
    }
}
