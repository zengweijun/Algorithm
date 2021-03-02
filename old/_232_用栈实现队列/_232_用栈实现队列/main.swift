//
//  main.swift
//  _232_用栈实现队列
//
//  Created by nius on 2020/3/5.
//  Copyright © 2020 nius. All rights reserved.
//

import Foundation

/**
 使用栈实现队列的下列操作：

 push(x) -- 将一个元素放入队列的尾部。
 pop() -- 从队列首部移除元素。
 peek() -- 返回队列首部的元素。
 empty() -- 返回队列是否为空。
 示例:

 MyQueue queue = new MyQueue();

 queue.push(1);
 queue.push(2);
 queue.peek();  // 返回 1
 queue.pop();   // 返回 1
 queue.empty(); // 返回 false
 说明:

 你只能使用标准的栈操作 -- 也就是只有 push to top, peek/pop from top, size, 和 is empty 操作是合法的。
 你所使用的语言也许不支持栈。你可以使用 list 或者 deque（双端队列）来模拟一个栈，只要是标准的栈操作即可。
 假设所有操作都是有效的 （例如，一个空的队列不会调用 pop 或者 peek 操作）。

 来源：力扣（LeetCode）
 链接：https://leetcode-cn.com/problems/implement-queue-using-stacks
 */


class MyQueue {
    /**
     总体思路：两个栈：一个负责入栈、另一个负责出栈，可以保证队列FIFO操作
        1、入栈的时候入栈到stack1中
        2、出栈的时候，出栈的时候，查看stack2是否为空，为空就将stack1的元素倒入到这里
           每次都stack2空了再将stack1的元素倒进去，这样巧妙第使用stack2保证了出栈顺序
           倒过来，符合了队列FIFO操作
     
        本来栈是LIFO操作，但是使用另外一个栈来控制出栈，综合起来就是FIFO
     */
    private var inStack = [Int]() // 入栈元素都到这里
    private var outStack = [Int]() // 需要出栈的时候，将stack1中的元素倒到这里，再出栈
    
    init() { }
    
    // 入队
    func push(_ x: Int) {
        inStack.append(x)
    }
    
    // 队列头部出队
    func pop() -> Int {
        // 弹出是从stack2进行，如果stack2没有了就将stack1倒入
        if outStack.isEmpty {
            // 栈stack2是空的，此时应该讲stack1中的元素倒进去
            while let top = inStack.popLast() {
                outStack.append(top)
            }
        }
        
        return outStack.popLast()!
    }
    
    // 查看队列头部元素
    func peek() -> Int {
        if outStack.isEmpty {
            // 栈stack2是空的，此时应该讲stack1中的元素倒进去
            while let top = inStack.popLast() {
                outStack.append(top)
            }
        }
        return outStack.last!
    }
    
    // 队列是否为空
    func empty() -> Bool {
        return inStack.isEmpty && outStack.isEmpty
    }
}

do {
    let obj = MyQueue()
    
    obj.push(1)
    obj.push(2)
    obj.push(3)
    obj.push(4)
    
    print("empty", obj.empty())
    print("peek", obj.peek())
    
    print(obj.pop())
    print(obj.pop())
    print(obj.pop())
    print(obj.pop())
    
    print("empty", obj.empty())
    
}
