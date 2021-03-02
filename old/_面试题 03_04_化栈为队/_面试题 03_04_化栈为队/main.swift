//
//  main.swift
//  _面试题 03_04_化栈为队
//
//  Created by nius on 2020/3/5.
//  Copyright © 2020 nius. All rights reserved.
//

import Foundation

/**
 实现一个MyQueue类，该类用两个栈来实现一个队列。


 示例：

 MyQueue queue = new MyQueue();

 queue.push(1);
 queue.push(2);
 queue.peek();  // 返回 1
 queue.pop();   // 返回 1
 queue.empty(); // 返回 false

 说明：

 你只能使用标准的栈操作 -- 也就是只有 push to top, peek/pop from top, size 和 is empty 操作是合法的。
 你所使用的语言也许不支持栈。你可以使用 list 或者 deque（双端队列）来模拟一个栈，只要是标准的栈操作即可。
 假设所有操作都是有效的 （例如，一个空的队列不会调用 pop 或者 peek 操作）。

 来源：力扣（LeetCode）
 链接：https://leetcode-cn.com/problems/implement-queue-using-stacks-lcci
 */

class MyQueue {

    private var inStack = [Int]()
    private var outStack = [Int]()
    
    /** Initialize your data structure here. */
    init() {

    }
    
    /** Push element x to the back of queue. */
    func push(_ x: Int) {
        inStack.append(x)
    }
    
    /** Removes the element from in front of queue and returns that element. */
    func pop() -> Int {
        if outStack.isEmpty {
            while let top = inStack.popLast() {
                outStack.append(top)
            }
        }
        return outStack.popLast()!
    }
    
    /** Get the front element. */
    func peek() -> Int {
        if outStack.isEmpty {
            while let top = inStack.popLast() {
                outStack.append(top)
            }
        }
        return outStack.last!
    }
    
    /** Returns whether the queue is empty. */
    func empty() -> Bool {
        return inStack.isEmpty && outStack.isEmpty
    }
}
