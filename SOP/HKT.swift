////
////  HKT.swift
////  SOP
////
////  Created by Chris Eidhof on 26.11.18.
////  Copyright © 2018 Chris Eidhof. All rights reserved.
////
//
//import Foundation
//
//// From inamiy
//
///// `F` as `* -> *`.
//public struct Kind<F1, A1>
//{
//    internal let _value: Any
//    
//    public init(_ value: Any)
//    {
//        self._value = value
//    }
//}
//
//extension Kind: KindConvertible
//{
//    public init(kind: Kind<F1, A1>)
//    {
//        self = kind
//    }
//    
//    public var kind: Kind<F1, A1>
//    {
//        return self
//    }
//}
//
//public protocol KindConvertible
//{
//    associatedtype F1
//    associatedtype A1
//    
//    init(kind: Kind<F1, A1>)
//    
//    var kind: Kind<F1, A1> { get }
//}
//
//extension Array: KindConvertible
//{
//    public typealias F = ForArray
//    public typealias A1 = Element
//    
//    /// - Note: autogeneratable
//    public init(kind: Kind<F, A1>)
//    {
//        self = kind._value as! Array<A1>
//    }
//    
//    /// - Note: autogeneratable
//    public var kind: Kind<F, A1>
//    {
//        return Kind(self as Any)
//    }
//}
//
//public enum ForArray {}
//
///// - Note: autogeneratable
//extension Kind where F1 == ForArray
//{
//    public var value: Array<A1>
//    {
//        return Array(kind: self)
//    }
//}
//
//extension ForArray: ForFunctor
//{
//    public static func fmap<A, B>(_ f: @escaping (A) -> B) -> (Kind<ForArray, A>) -> Kind<ForArray, B>
//    {
//        return { $0.value.map(f).kind }
//    }
//}
//
//
//public protocol Functor
//{
//    associatedtype F1: ForFunctor
//    associatedtype A1
//    
//    func fmap<B>(_ f: @escaping (A1) -> B) -> Kind<F1, B>
//}
//
//// MARK: - ForFunctor
//
//public protocol ForFunctor
//{
//    static func fmap<A, B>(_ f: @escaping (A) -> B) -> (Kind<Self, A>) -> Kind<Self, B>
//}
//
//// MARK: - Default implementation
//
//extension Kind: Functor where F1: ForFunctor
//{
//    // Default implementation.
//    public func fmap<B>(_ f: @escaping (A1) -> B) -> Kind<F1, B>
//    {
//        return F1.fmap(f)(self)
//    }
//}
//
//
//
//struct Fix<F> {
//    let out: Kind<F, Fix<F>>
//}
//
//indirect enum Expr {
//    case const(Int)
//    case add(Expr, Expr)
//    case mul(Expr, Expr)
//}
//
//enum PFExpr<R> {
//    case const(Int)
//    case add(R, R)
//    case mul(R, R)
//}
//
//extension PFExpr {
//    func map<B>(_ f: (R) -> B) -> PFExpr<B> {
//        switch self {
//        case .const(let x): return .const(x)
//        case let .add(l,r): return .add(f(l), f(r))
//        case let .mul(l,r): return .mul(f(l), f(r))
//        }
//    }
//}
//
//enum ForPFExpr { }
//
//extension PFExpr: KindConvertible
//{
//    public typealias F = ForPFExpr
//    public typealias A1 = R
//    
//    /// - Note: autogeneratable
//    public init(kind: Kind<F, A1>)
//    {
//        self = kind._value as! PFExpr<A1>
//    }
//    
//    /// - Note: autogeneratable
//    public var kind: Kind<F, A1>
//    {
//        return Kind(self as Any)
//    }
//}
//
//extension Kind where F1 == ForPFExpr
//{
//    var value: PFExpr<A1>
//    {
//        return PFExpr(kind: self)
//    }
//}
//
//extension ForPFExpr: ForFunctor {
//    static func fmap<A, B>(_ f: @escaping (A) -> B) -> (Kind<ForPFExpr, A>) -> Kind<ForPFExpr, B> {
//        return { $0.value.map(f).kind  }
//    }
//}
//
