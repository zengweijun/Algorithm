//
//  main.swift
//  _25_K 个一组翻转链表
//
//  Created by 曾维俊 on 2020/3/7.
//  Copyright © 2020 Nius. All rights reserved.
//

import Foundation

/**
 给你一个链表，每 k 个节点一组进行翻转，请你返回翻转后的链表。

 k 是一个正整数，它的值小于或等于链表的长度。

 如果节点总数不是 k 的整数倍，那么请将最后剩余的节点保持原有顺序。

  

 示例：
 给你这个链表：1->2->3->4->5
 当 k = 2 时，应当返回: 2->1->4->3->5
 当 k = 3 时，应当返回: 3->2->1->4->5

  

 说明：
 你的算法只能使用常数的额外空间。
 你不能只是单纯的改变节点内部的值，而是需要实际进行节点交换。

 来源：力扣（LeetCode）
 链接：https://leetcode-cn.com/problems/reverse-nodes-in-k-group
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
    func reverseKGroup(_ head: ListNode?, _ k: Int) -> ListNode? {
        // 和 `_206_反转链表` 以及 `_24_两两交换链表中的节点` 思路相同
        // 这里将k个节点视为一组
        // 这里需要反转k个，使用递归应该比较优
        // 时间：O(n) 空间：O(1)
        
        // 反转单链表(递归)
        @discardableResult func reverseList(_ head: ListNode?) -> ListNode? {
            if head === nil || head?.next === nil { return head }
            
            // 经过反转，head.next成为了新表尾部，把当前头结点接在之后
            let newHead = reverseList(head?.next)
            head?.next?.next = head
            head?.next = nil
            return newHead
        }
        
        // 总体思路：先反转前k个，后边递归该过程，并接在前k个之后，一直递归到尾部
        
        if head === nil || head?.next === nil { return head }
        var newHead: ListNode? = head
        
        // 选取前一段链表（k个节点），反转后接在新链表尾部
        var tail = head
        
        // 选取前k节点个元素，之后反转它
        // 这里选取k个，由于tail初始值为head，后边只需要再选取k-1个即可
        for _ in 0..<(k-1) { tail = tail?.next }
        
        // 数量达到k个才反转
        if tail !== nil {
            let nextHead = tail?.next // 记录下一段链表头
            tail?.next = nil  // 截取该链表
            reverseList(head) // 反转该链表
            
            // 反转后tail已经变成头部
            // newHead默认是head，但是第一次发生反转后修改为第一段反转后的头部
            if newHead === head { newHead = tail }
            
            // 反转后，head变为尾部，接上下一段反转后的头
            head?.next = reverseKGroup(nextHead, k)
        }
        
        return newHead
    }
}

do {
    do {
        let h = ListNode.linkedList([1, 2, 3, 4, 5])
        h?.show()
        let result = Solution().reverseKGroup(h, 2)
        result?.show()
    }
    do {
        let h = ListNode.linkedList([1, 2, 3, 4, 5])
        h?.show()
        let result = Solution().reverseKGroup(h, 3)
        result?.show()
    }
}
