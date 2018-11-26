//
//  Describes.swift
//  SOP
//
//  Created by Chris Eidhof on 29.11.18.
//  Copyright © 2018 Chris Eidhof. All rights reserved.
//

import Foundation

protocol Describes {
    associatedtype Value
}

struct TypeName<A>: Describes where A: Describes {
    let name: String
    let a: A
    
    typealias Value = A.Value
    
    init(_ name: String, _ a: A) {
        self.name = name
        self.a = a
    }
}
struct Product<A,B>: Describes where A: Describes, B: Describes {
    let a: A
    let b: B
    
    typealias Value = (A.Value, B.Value)
    
    init(_ a: A, _ b: B) {
        self.a = a
        self.b = b
    }
}

struct Case<A, OtherCases>: Describes where A: Describes, OtherCases: Describes {
    let name: String
    let a: A
    let b: OtherCases
    
    init(_ aName: String, _ a: A, _ b: OtherCases) {
        self.a = a
        self.b = b
        self.name = aName
    }
    
    typealias Value = Either<A.Value, OtherCases.Value>
}

enum Either<A, B> {
    case l(A)
    case r(B)
}

// Labelled
struct Label<A>: Describes where A: Describes {
    let label: String
    let a: A
    
    init(_ label: String, _ a: A) {
        self.label = label
        self.a = a
    }
    typealias Value = A.Value
}

struct K<A>: Describes {
    typealias Value = A
}

struct Unit: Describes {
    typealias Value = ()
}

struct Sum<A: Describes, B: Describes>: Describes {
    typealias Value = Either<A.Value, B.Value>
    let a: A
    let b: B
    
    init(_ a: A, _ b: B) {
        self.a = a
        self.b = b
    }
}

struct Sentinel { }
extension Sentinel: Describes {
    typealias Value = Never
}

protocol Generic {
    associatedtype Structure: Describes
    static var structure: Structure { get }
    var to: Structure.Value { get }
    init(_ from: Structure.Value)
}
