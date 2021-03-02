//
//  main.swift
//  _155_最小栈
//
//  Created by nius on 2020/3/3.
//  Copyright © 2020 nius. All rights reserved.
//

import Foundation

/**
 设计一个支持 push，pop，top 操作，并能在常数时间内检索到最小元素的栈。

 push(x) -- 将元素 x 推入栈中。
 pop() -- 删除栈顶的元素。
 top() -- 获取栈顶元素。
 getMin() -- 检索栈中的最小元素。
 
 示例:
 MinStack minStack = new MinStack();
 minStack.push(-2);
 minStack.push(0);
 minStack.push(-3);
 minStack.getMin();   --> 返回 -3.
 minStack.pop();
 minStack.top();      --> 返回 0.
 minStack.getMin();   --> 返回 -2.

 来源：力扣（LeetCode）
 链接：https://leetcode-cn.com/problems/min-stack
 */

// 方法一，使用两个栈实现
class MinStack {
    /**
     使用一个栈(普通栈)装载数据
     使用一个栈(最小栈)装载当前普通对应位置的最小值
     例如：
        普通栈  [5] 、[5, 6] 、[5, 6, 3] 、[5, 6, 3, 7] 、[5, 6, 3, -2] 、[5, 6, 3, -2, 8]
        最小栈  [5] 、[5, 5] 、[5, 5, 3] 、[5, 5, 3, 3]、 [5, 5, 3, -2] 、[5, 6, 3, -2, -2]
     从上边可以看出，最小栈栈顶元素是当前普通栈水平下（普通栈中的）最小值
        再如：普通栈[1, 2, 3, 4] --> 最小栈[1, 1, 1, 1]
     
     此方法的话时间每个方法的时间复杂度O(1)，控件复杂度为O(n)
     */

    private var stack: [Int]
    private var minStack: [Int]
    
    /** initialize your data structure here. */
    init() {
        stack = []
        minStack = []
    }
    
    func push(_ x: Int) {
        stack.append(x)
        minStack.append(min(x, minStack.last ?? Int.max))
    }
    
    func pop() {
        stack.removeLast()
        minStack.removeLast()
    }
    
    func top() -> Int {
        return stack.last ?? Int.max
    }
    
    func getMin() -> Int {
        return minStack.last ?? Int.max
    }
}

// 方法二，使用链表，每个节点装载当前值已经目前情况下栈应该的最小值
// 链表头作为栈顶
class MinStack1 {
    class Node {
        let val: Int
        let min: Int
        var next: Node?
        init(val: Int, min: Int, next: Node?) {
            self.val = val
            self.min = min
            self.next = next
        }
    }
    
    let head: Node
    
    /** initialize your data structure here. */
    init() {
        head = Node(val: Int.max, min: Int.max, next: nil)
    }
    
    func push(_ x: Int) {
        let node = Node(val: x, min: Swift.min(x, head.next?.min ?? Int.max), next: nil)
        node.next = head.next
        head.next = node
    }
    
    func pop() {
        head.next = head.next?.next
    }
    
    func top() -> Int {
        return head.next?.val ?? Int.max
    }
    
    func getMin() -> Int {
        return head.next?.min ?? Int.max
    }
}

// 方法三，思路同方法一，不过将两个栈合并
// 将两个元素视为一个整体（逻辑整体）
class MinStack2 {
    var stack: [Int] // push一个x的同时，将此时最小值push进入

    init() {
        stack = []
    }
    
    func push(_ x: Int) {
        if stack.isEmpty {
            stack.append(x)
            stack.append(x)
        } else {
            let lastMin = stack.last ?? Int.max
            stack.append(x)
            stack.append(Swift.min(lastMin, x))
        }
    }
    
    func pop() {
        stack.removeLast()
        stack.removeLast()
    }
    
    func top() -> Int {
        return stack[stack.count - 2]
    }
    
    func getMin() -> Int {
        return stack.last ?? Int.max
    }
}

