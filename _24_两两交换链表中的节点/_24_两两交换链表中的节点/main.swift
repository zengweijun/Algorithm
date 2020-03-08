//
//  main.swift
//  _24_两两交换链表中的节点
//
//  Created by nius on 2020/3/7.
//  Copyright © 2020 nius. All rights reserved.
//

import Foundation

/**
 给定一个链表，两两交换其中相邻的节点，并返回交换后的链表。

 你不能只是单纯的改变节点内部的值，而是需要实际的进行节点交换。
  
 示例:
 给定 1->2->3->4, 你应该返回 2->1->4->3.

 来源：力扣（LeetCode）
 链接：https://leetcode-cn.com/problems/swap-nodes-in-pairs
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

class Solution {
    func swapPairs1(_ head: ListNode?) -> ListNode? {
        // 时间：O(n)，此题还可以用递归
        if head === nil || head?.next === nil {
            return head
        }
        
        var cur = head
        // 这里要想追求LeetCode时间极致降低，可以去掉虚拟头节点
        let dummy: ListNode? = ListNode(0)
        var tail = dummy
        
        while cur !== nil {
            // 先记录第三个
            let tmp = cur?.next?.next
            
            // 交换 第一个cur和第二个cur.next
            cur?.next?.next = cur
            
            // 交换后的结果接在新链表尾部
            // 如果cur已经是最后一个节点，无法交换，则cur.next为空，此时直接将cur接在链表尾部
            tail?.next = cur?.next ?? cur
            
            tail = cur // 更新链表尾部为cur
            cur = tmp  // cur跨步到第三个节点
        }
        tail?.next = nil
        
        return dummy?.next
    }
    
    func swapPairs2(_ head: ListNode?) -> ListNode? {
        // O(n)
        // 递归（事实上和单链表反转同样逻辑，只不过这里将两个节点视为一个对象）
        if head === nil || head?.next === nil {
            return head
        }
        
        // 1.先将第三个节点之后链表执行两两反转逻辑
        let lastHead = swapPairs2(head?.next?.next)
        
        // 2.记录第二节点，作为头部返回。将头两个节点交换后，之后将第三个节点之后反转的链表接在后边
        let newHead = head?.next
        head?.next?.next = head
        head?.next = lastHead
        
        // 之前记录的第二个节点作为头返回
        return newHead
    }
}

do {
    do {
        let h = ListNode.linkedList([1, 2, 3])
        h?.show()
        let result = Solution().swapPairs1(h)
        result?.show()
    }
    do {
        let h = ListNode.linkedList([1, 2, 3, 4])
        h?.show()
        let result = Solution().swapPairs2(h)
        result?.show()
    }
}
