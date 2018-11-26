//
//  Generated.swift
//  SOP
//
//  Created by Chris Eidhof on 26.11.18.
//  Copyright © 2018 Chris Eidhof. All rights reserved.
//

import Foundation

enum UsersRoute {
    case index
    case view(Int)
}

extension UsersRoute: Generic {
    typealias Structure = TypeName<Case<Unit,Case<Product<K<Int>,Unit>,Sentinel>>>
    
    static let structure: Structure = TypeName("UsersRoute", Case("index", Unit(),Case("view", Product(K<Int>(),Unit()),Sentinel())))
    
    var to: Structure.Value {
        switch self {
        case .index: return .l(())
        case let .view(x_0): return .r(.l((x_0, ())))
        }
    }
    init(_ from: Structure.Value) {
        switch from {
        case let .l: self = .index
        case let .r(.l(x)): self = .view(x.0)
        }
    }
}
enum Route {
    case index
    case user(UsersRoute)
}

extension Route: Generic {
    typealias Structure = TypeName<Case<Unit,Case<Product<K<UsersRoute>,Unit>,Sentinel>>>
    
    static let structure: Structure = TypeName("Route", Case("index", Unit(),Case("user", Product(K<UsersRoute>(),Unit()),Sentinel())))
    
    var to: Structure.Value {
        switch self {
        case .index: return .l(())
        case let .user(x_0): return .r(.l((x_0, ())))
        }
    }
    init(_ from: Structure.Value) {
        switch from {
        case let .l: self = .index
        case let .r(.l(x)): self = .user(x.0)
        }
    }
}
