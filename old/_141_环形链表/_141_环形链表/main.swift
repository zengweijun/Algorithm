//
//  main.swift
//  _141_环形链表
//
//  Created by 曾维俊 on 2020/3/5.
//  Copyright © 2020 Nius. All rights reserved.
//

import Foundation

/**
 给定一个链表，判断链表中是否有环。

 为了表示给定链表中的环，我们使用整数 pos 来表示链表尾连接到链表中的位置（索引从 0 开始）。 如果 pos 是 -1，则在该链表中没有环。

  

 示例 1：
 输入：head = [3,2,0,-4], pos = 1
 输出：true
 解释：链表中有一个环，其尾部连接到第二个节点。


 示例 2：
 输入：head = [1,2], pos = 0
 输出：true
 解释：链表中有一个环，其尾部连接到第一个节点。


 示例 3：
 输入：head = [1], pos = -1
 输出：false
 解释：链表中没有环。


  

 进阶：
 你能用 O(1)（即，常量）内存解决此问题吗？

 来源：力扣（LeetCode）
 链接：https://leetcode-cn.com/problems/linked-list-cycle
 */

public class ListNode {
    
    public var val: Int
    public var next: ListNode?
    public init(_ val: Int) {
        self.val = val
        self.next = nil
    }
    
    
    public func show() {
        var head: Optional = self
        while head != nil {
            print(head?.val ?? "nil", terminator: "-->")
            head = head?.next
        }
        print("nil")
    }
    
    public static func linkedList(_ nums: [Int]) -> ListNode? {
        let dummyHead: ListNode? = ListNode(0)
        var cur = dummyHead
        
        for i in 0..<nums.count {
            cur?.next = ListNode(nums[i])
            cur = cur?.next
        }
        
        return dummyHead?.next
    }
}

extension ListNode: Hashable {
    public static func == (lhs: ListNode, rhs: ListNode) -> Bool {
        return lhs === rhs
    }
    public func hash(into hasher: inout Hasher) {
    }
}

class Solution {
    func hasCycle1(_ head: ListNode?) -> Bool {
        // Set，空间复杂度为O(n)，时间O(n)
        // 推荐使用方法2
        
        // 空表 或者 表头next为空，不可能存在环
        if head === nil || head?.next === nil { return false }
        
        var set = Set<ListNode>()
        var cur = head
        while cur !== nil {
            if set.contains(cur!) {
                return true // 遇到了相同内存地址的节点，存在环
            }
            set.insert(cur!)
            cur = cur?.next
        }
        
        return false
    }
    
    
    func hasCycle2(_ head: ListNode?) -> Bool {
        // 双指针，空间复杂度为O(1)，时间O(n)
        
        // 空表 或者 表头next为空，不可能存在环
        if head === nil || head?.next === nil { return false }
        
        // 判断是否有环，使用快慢指针
        var slow = head
        // 要判断环，即要判断是否相等，作为循环控制条件防止初次结束，先让快指针走一步
        var fast = head?.next
        
        while slow != fast {
            // 这里先判断快指针是否到了末尾
            // 由于快指针走的额快，所以快指针会最先到尾部，如果快指针为nil，则无环
            if fast === nil || fast?.next === nil {
                return false
            }
            slow = slow?.next
            fast = fast?.next?.next
        }
        return true
    }
}

do {
    
}
