//
//  DemoAlt.swift
//  SOP
//
//  Created by Chris Eidhof on 29.11.18.
//  Copyright © 2018 Chris Eidhof. All rights reserved.
//

import Foundation

struct Address: Codable, Equatable {
    var street: String
    var city: String
}

extension Address: Generic {
    typealias Structure = TypeName<Product<Label<K<String>>, Product<Label<K<String>>, Unit>>>
    static let structure: Structure = TypeName("Address", Product(Label("street", K()), Product(Label("city", K()), Unit())))
    var to: Structure.Value {
        return (street, (city, ()))
    }
    init(_ from: Structure.Value) {
        self.street = from.0
        self.city = from.1.0
    }
}

struct Person: Codable, Equatable {
    var name: String
    var age: Int
    var test: Bool?
    var address: Address
}

extension Person: Generic {
    // Todo generate with Sourcery
    typealias Structure = TypeName<Product<Label<K<String>>,Product<Label<K<Int>>,Product<Label<K<Bool?>>, Product<Label<K<Address>>, Unit>>>>>
    
    static let structure: Structure = TypeName("Address", Product(Label("name", K()), Product(Label("age", K()), Product(Label("test", K()), Product(Label("address", K()), Unit())))))
    
    var to: Structure.Value {
        return (name, (age, (test, (address, ()))))
    }
    
    init(_ from: Structure.Value) {
        self.name = from.0
        self.age = from.1.0
        self.test = from.1.1.0
        self.address = from.1.1.1.0
    }
}

//let a = Address(street: "Testing", city: "Street")
let p = Person(name: "One", age: 14, test: nil, address: Address(street: "test", city: "test city"))


extension Address: ToXML {
    var xml: Node {
        return Address.structure.xml(to)
    }
}

extension Person: ToXML {
    var xml: Node {
        return Person.structure.xml(to)
    }
}

extension Array: ToXMLNodes where Element: ToXML {
    var nodes: [Node] {
        return map { $0.xml }
    }
}

//let z = PersonOrCompany.person(p).to
//let y = PersonOrCompany.company(name: "abc", city: "def").to
//print(PersonOrCompany.repr.xml(y).render())


let person = Struct_(name: "Person", fields: [
    Field(name: "name", type: "String"),
    Field(name: "age", type: "Int")
    ])

let personOrCompany = Enum(name: "PersonOrCompany", cases: [
    EnumCase(name: "person", fields: [.anonymous(type: "Person")]),
    EnumCase(name: "company", fields:
        [.named(name: "name", type: "String"),
         .named(name: "city", type: "String")
        ])
    ])

//print(personOrCompany.code.render())

let usersRoute = Enum(name: "UsersRoute", cases: [
    EnumCase(name: "index", fields: []),
    EnumCase(name: "view", fields: [
        .anonymous(type: "Int")
        ]),
    ])

let route = Enum(name: "Route", cases: [
    EnumCase(name: "index", fields: []),
    EnumCase(name: "user", fields: [
        .anonymous(type: "UsersRoute")
        ]),
    ])

//print(usersRoute.code.render())
//print(route.code.render())

