//
//  MyQueue.swift
//  Example
//
//  Created by admin on 1/5/21.
//

import Foundation

class Queue<T> {
    private var elements: [T] = []
    let dispathQueue = DispatchQueue(label: "Queue")
    func pushDispatch(_ element: T) {
        dispathQueue.async {
            self.elements.append(element)
        }
    }
    
    func popDispatch() -> T? {
        // su dụng sync vì lúc đó sync block lại thread hiện tại cho đến khi chạy xong mới chạy các tác vụ khác còn lại của thread đó
        var element:T?
        if self.elements.isEmpty {
            element = nil
        }
        dispathQueue.sync {
            element = self.elements.removeFirst()
        }
        return element
    }
    
    let semaphore = DispatchSemaphore(value: 1)
    func pushSemaphore(_ element: T) {
        semaphore.wait()
        self.elements.append(element)
        semaphore.signal()
    }
    
    func popSemaphore() -> T? {
        var element:T?
        semaphore.wait()
        if self.elements.isEmpty {
            element = nil
        }
         element = self.elements.removeFirst()
        semaphore.signal()
        return element
    }
    
    let myLog = NSLock()
    func pushLock(_ element: T) {
        myLog.lock()
        self.elements.append(element)
        myLog.unlock()
    }
    
    func popLock() -> T? {
        var element:T?
        myLog.lock()
        if self.elements.isEmpty {
            element = nil
        }
        element = self.elements.removeFirst()
        myLog.unlock()
        return element
    }
}
