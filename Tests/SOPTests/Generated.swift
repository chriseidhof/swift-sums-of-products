//
//  Generated.swift
//  SOP
//
//  Created by Chris Eidhof on 26.11.18.
//  Copyright © 2018 Chris Eidhof. All rights reserved.
//

import Foundation
import SOP

enum UsersRoute {
    case index
    case view(Int)
}

extension UsersRoute: Generic {
    typealias Structure = TypeName<Case<One,Case<Product<K<Int>,One>,Zero>>>
    
    static let structure: Structure = TypeName("UsersRoute", Case("index", One(),Case("view", Product(K<Int>(),One()),Zero())))
    
    var to: Structure.Value {
        switch self {
        case .index: return .l(())
        case let .view(x_0): return .r(.l((x_0, ())))
        }
    }
    init(_ from: Structure.Value) {
        switch from {
        case .l: self = .index
        case let .r(.l(x)): self = .view(x.0)
        }
    }
}
enum Route {
    case index
    case user(UsersRoute)
}

extension Route: Generic {
    typealias Structure = TypeName<Case<One,Case<Product<K<UsersRoute>,One>,Zero>>>
    
    static let structure: Structure = TypeName("Route", Case("index", One(), Case("user", Product(K<UsersRoute>(),One()), Zero())))
    
    var to: Structure.Value {
        switch self {
        case .index: return .l(())
        case let .user(x_0): return .r(.l((x_0, ())))
        }
    }
    init(_ from: Structure.Value) {
        switch from {
        case .l: self = .index
        case let .r(.l(x)): self = .user(x.0)
        }
    }
}
