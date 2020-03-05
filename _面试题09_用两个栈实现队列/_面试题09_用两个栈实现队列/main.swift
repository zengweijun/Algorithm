//
//  main.swift
//  _面试题09_用两个栈实现队列
//
//  Created by nius on 2020/3/5.
//  Copyright © 2020 nius. All rights reserved.
//

import Foundation

/**
 用两个栈实现一个队列。队列的声明如下，请实现它的两个函数 appendTail 和 deleteHead ，分别完成在队列尾部插入整数和在队列头部删除整数的功能。(若队列中没有元素，deleteHead 操作返回 -1 )

  

 示例 1：

 输入：
 ["CQueue","appendTail","deleteHead","deleteHead"]
 [[],[3],[],[]]
 输出：[null,null,3,-1]
 示例 2：

 输入：
 ["CQueue","deleteHead","appendTail","appendTail","deleteHead","deleteHead"]
 [[],[],[5],[2],[],[]]
 输出：[null,-1,null,null,5,2]
 提示：

 1 <= values <= 10000
 最多会对 appendTail、deleteHead 进行 10000 次调用

 来源：力扣（LeetCode）
 链接：https://leetcode-cn.com/problems/yong-liang-ge-zhan-shi-xian-dui-lie-lcof
 */


class CQueue {
    private var inStack = [Int]()
    private var outStack = [Int]()
    
    init() {

    }
    
    // 队列尾部插入整数
    func appendTail(_ value: Int) {
        inStack.append(value)
    }
    
    // 队列头部删除整数
    // 若队列中没有元素，deleteHead 操作返回 -1
    func deleteHead() -> Int {
        if outStack.isEmpty {
            while let top = inStack.popLast() {
                outStack.append(top)
            }
        }
        return outStack.popLast() ?? -1
    }
}
