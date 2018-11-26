import Foundation


struct User {
    var name: String
    var age: Int
    var admin: Bool
}

extension User: Generic {
    typealias Structure = TypeName<Product<Label<K<String>>, Product<Label<K<Int>>, Product<Label<K<Bool>>, Unit>>>>
    static let structure =
        TypeName("User",
            Product(Label("name", K<String>()),
                Product(Label("age", K<Int>()),
                    Product(Label("admin", K<Bool>()),
                        Unit()))))
    
    init(_ from: Structure.Value) {
        self.name = from.0
        self.age = from.1.0
        self.admin = from.1.1.0
    }
    
    var to: Structure.Value {
        return (name, (age, (admin, ())))
    }
}

let address = Address(street: "1st", city: "NYC")
let sample = User(name: "John", age: 40, admin: true)

extension Generic where Structure: PrettyHelper {
    var doc: Doc {
        return Self.structure.pretty(to)
    }
    
}
print(sample.xml.render())

extension UsersRoute: Pretty { }
let r = Route.user(.index)
print(r.doc.render())
