//
//  Describes.swift
//  SOP
//
//  Created by Chris Eidhof on 29.11.18.
//  Copyright © 2018 Chris Eidhof. All rights reserved.
//

import Foundation

public protocol Describes {
    associatedtype Value
}

public struct TypeName<A>: Describes where A: Describes {
    public let name: String
    public let a: A
    
    public typealias Value = A.Value
    
    public init(_ name: String, _ a: A) {
        self.name = name
        self.a = a
    }
}
public struct Product<A,B>: Describes where A: Describes, B: Describes {
    public let a: A
    public let b: B
    
    public typealias Value = (A.Value, B.Value)
    
    public init(_ a: A, _ b: B) {
        self.a = a
        self.b = b
    }
}

public struct Case<A, OtherCases>: Describes where A: Describes, OtherCases: Describes {
    public let name: String
    public let a: A
    public let b: OtherCases
    
    public init(_ aName: String, _ a: A, _ b: OtherCases) {
        self.a = a
        self.b = b
        self.name = aName
    }
    
    public typealias Value = Either<A.Value, OtherCases.Value>
}

public enum Either<A, B> {
    case l(A)
    case r(B)
}

// Labelled
public struct Label<A>: Describes where A: Describes {
    public let label: String
    public let a: A
    public typealias Value = A.Value
    
    public init(_ label: String, _ a: A) {
        self.label = label
        self.a = a
    }
}

public struct K<A>: Describes {
    public typealias Value = A
    public init() { }
}

// Could be named `Unit`, but that conflicts with Foundation.
public struct One: Describes {
    public typealias Value = ()
    public init() { }
}

public struct Sum<A: Describes, B: Describes>: Describes {
    public typealias Value = Either<A.Value, B.Value>
    public let a: A
    public let b: B
    
    public init(_ a: A, _ b: B) {
        self.a = a
        self.b = b
    }
}

public struct Zero {
    public init() { }
}
extension Zero: Describes {
    public typealias Value = Never
}

public protocol Generic {
    associatedtype Structure: Describes
    static var structure: Structure { get }
    var to: Structure.Value { get }
    init(_ from: Structure.Value)
}
