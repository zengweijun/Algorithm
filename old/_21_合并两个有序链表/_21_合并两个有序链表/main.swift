//
//  main.swift
//  _21_合并两个有序链表
//
//  Created by 曾维俊 on 2020/2/28.
//  Copyright © 2020 Nius. All rights reserved.
//

import Foundation

/**
 将两个有序链表合并为一个新的有序链表并返回。新链表是通过拼接给定的两个链表的所有节点组成的。

 示例：
 输入：1->2->4, 1->3->4
 输出：1->1->2->3->4->4

 来源：力扣（LeetCode）
 链接：https://leetcode-cn.com/problems/merge-two-sorted-lists
 */


// Definition for singly-linked list.
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
    
class Solution {
    // 迭代解法
    func mergeTwoLists(_ l1: ListNode?, _ l2: ListNode?) -> ListNode? {
        // 后边涉及到强制解包，需要判定nil
        // 任何一个为空，直接返回另一个
        if l1 == nil { return l2 }
        if l2 == nil { return l1 }
        
        var cur1 = l1
        var cur2 = l2
        
        let dummy: ListNode?  = ListNode(0)
        var tail = dummy
        
        // 由于两个量表长短和大小都未知，因此不能预测谁先结束，所以两个链表都进入循环控制条件
        while cur1 != nil && cur2 != nil {
            if cur1!.val < cur2!.val {
                tail?.next = cur1
                cur1 = cur1?.next
            } else {
                tail?.next = cur2
                cur2 = cur2?.next
            }
            tail = tail?.next
        }

        // 找到还未结束的那一条链表 接在后边
        if cur1 != nil {
            tail?.next = cur1
        } else {
            tail?.next = cur2
        }
        
        return dummy?.next
    }
    
    // 递归解法(只需呀考虑函数返回结果)
    func mergeTwoLists1(_ l1: ListNode?, _ l2: ListNode?) -> ListNode? {
        // 递归基
        if l1 == nil { return l2 }
        if l2 == nil { return l1 }
        
        // 以下每个递归函数都会执行的逻辑
        
        var head: ListNode? = nil
        if l1!.val < l2!.val {
            head = l1
            // mergeTwoLists1返回的是剩余链表合并后的头
            // 只需将next接上即可
            head?.next = mergeTwoLists1(head?.next, l2)
        } else {
            head = l2
            head?.next = mergeTwoLists1(l1, head?.next)
        }
        
        return head
    }
}

// 迭代
do {
    let head = Solution().mergeTwoLists(ListNode.linkedList([1, 2, 4]), ListNode.linkedList([1, 3, 4]))
    head?.show()
}
 
// 递归
do {
    let head = Solution().mergeTwoLists1(ListNode.linkedList([1, 2, 4]), ListNode.linkedList([1, 3, 4]))
    head?.show()
}
