//
//  main.swift
//  _234_回文链表
//
//  Created by nius on 2020/3/2.
//  Copyright © 2020 nius. All rights reserved.
//

import Foundation

/**
 请判断一个链表是否为回文链表。

 示例 1:
 输入: 1->2
 输出: false
 示例 2:

 输入: 1->2->2->1
 输出: true
 进阶：
 你能否用 O(n) 时间复杂度和 O(1) 空间复杂度解决此题？

 来源：力扣（LeetCode）
 链接：https://leetcode-cn.com/problems/palindrome-linked-list
 
 同源：面试题 02.06. 回文链表 https://leetcode-cn.com/problems/palindrome-linked-list-lcci/
 */

public class ListNode {
    public var val: Int
    public var next: ListNode?
    public init(_ val: Int) {
        self.val = val
        self.next = nil
    }
    public func show() {
        var head: ListNode? = self
        while head != nil {
            print(head?.val ?? "nil", terminator: "-->")
            head = head?.next
        }
        print("nil")
    }
    
    public static func linkedList(_ nums: [Int])->ListNode? {
        let head: ListNode? = ListNode(0)
        var tail = head
        for value in nums {
            tail?.next = ListNode(value)
            tail = tail?.next
        }
        return head?.next
    }
}


class Solution {
    func isPalindrome(_ head: ListNode?) -> Bool {
        return true
    }
}

