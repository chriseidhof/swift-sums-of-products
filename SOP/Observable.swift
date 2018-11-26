//
//  Observable.swift
//  SOP
//
//  Created by Chris Eidhof on 26.11.18.
//  Copyright © 2018 Chris Eidhof. All rights reserved.
//

import Foundation

final class Observable<A> {
    let value: A
    init(_ value: A) {
        self.value = value
    }
}

protocol AsObservable {
    associatedtype O
    var observable: Observable<O> { get }
}
