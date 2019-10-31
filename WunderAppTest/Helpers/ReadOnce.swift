//
//  ReadOnce.swift
//  WunderAppTest
//
//  Created by Mark Labios on 10/30/19.
//  Copyright © 2019 Mark Labios. All rights reserved.
//

class ReadOnce<Value> {
    var isRead: Bool {
        return value == nil
    }

    private var value: Value?

    init(_ value: Value?) {
        self.value = value
    }

    func read() -> Value? {
        defer { value = nil }

        if value != nil {
            return value
        }

        return nil
    }
}
