//
//  Coordinator.swift
//  OneDance
//
//  Created by Burak Can on 9/11/17.
//  Copyright © 2017 Burak Can. All rights reserved.
//

import Foundation

protocol Coordinator : class {
    
    func start()
    //var childCoordinators : [String : Coordinator] { get set }
    
}

// Apply extension for default methods for add and remove child coordinator


struct CoordinatorKeyName {
    static let TIMELINE : String = "Timeline"
    static let USER : String = "User"
    static let ORGANIZATION : String = "Organization"
    static let EVENT : String = "Event"
    static let POST : String = "Post"
    static let LIST : String = "List"
}


public struct Stack<T> {
    fileprivate var array = [T]()
    
    public var isEmpty: Bool {
        return array.isEmpty
    }
    
    public var count: Int {
        return array.count
    }
    
    public mutating func push(_ element: T) {
        array.append(element)
    }
    
    @discardableResult
    public mutating func pop() -> T? {
        return array.popLast()
    }
    
    public var top: T? {
        return array.last
    }
}

extension Stack: Sequence {
    public func makeIterator() -> AnyIterator<T> {
        var curr = self
        return AnyIterator {
            return curr.pop()
        }
    }
}
