//
//  main.swift
//  _206_反转链表
//
//  Created by nius on 2020/3/2.
//  Copyright © 2020 nius. All rights reserved.
//

import Foundation

/**
 反转一个单链表。

 示例:
 输入: 1->2->3->4->5->NULL
 输出: 5->4->3->2->1->NULL
 进阶:
 你可以迭代或递归地反转链表。你能否用两种方法解决这道题？

 来源：力扣（LeetCode）
 链接：https://leetcode-cn.com/problems/reverse-linked-list
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
    // 迭代法
    func reverseList(_ head: ListNode?) -> ListNode? {
        if (head == nil || head?.next == nil) {
            return head
        }
        
        var prev: ListNode? = nil
        var cur = head
        
        while cur != nil {
            let next = cur?.next // 先记录下一个
            cur?.next = prev     // 反转
            prev = cur           // prev后移到cur
            cur = next           // cur后移
        }
        return prev
    }
    
    // 递归（考虑方法作用）
    // https://zhuanlan.zhihu.com/p/86745433
    // https://leetcode-cn.com/problems/reverse-linked-list/solution/dong-hua-yan-shi-206-fan-zhuan-lian-biao-by-user74/
    func reverseList1(_ head: ListNode?) -> ListNode? {
        // 递归基
        if head == nil || head?.next == nil {
            return head
        }
        // reverseList函数作用
        // 1 -> [2 -> 3 -> 4 -> 5 -> nil] ==> 1 -> [nil <- 2 <- 3 <- 4 <- 5]
        // 再执行：1 <-> [nil <- 2 <- 3 <- 4 <- 5]
        // 最后再清掉尾指针，防止循环出现
        
        let newHead = reverseList1(head?.next)
        // newHead为反转后链表的头部，直接返回
        // 经过这个函数，head.next就变成了反转后链表的尾巴，我们再将改尾巴接上当前head，清掉head.next完成了本次链表的反转。如此不断递归
        head?.next?.next = head
        head?.next = nil
                
        return newHead
    }
    
    // 依次将后边节点移动到第一个
    func reverseList2(_ head: ListNode?) -> ListNode? {
        // 依次将后边节点移动到第一个
        // 1->2->3->4->5 虚拟头 0->1->2->3->4->5
        // 定位到头head = 0, cur = 1, 将cur的next 2移动到头 0->2->1->3->4->5
        // 此时head = 0, cur = 1, 将cur的next 3移动到头 0->3->2->1->4->5
        // 如此往复即可完成
        if head == nil || head?.next == nil {
            return head
        }
        
        let dummy = ListNode(0)
        dummy.next = head
        // 依次将后边节点移动到第一个位置即可
        let cur = dummy.next
        // 这里cur无需cur = cur.next，实际上向头部插入东西，cur就已经会自动后移
        while cur?.next != nil { // cur后边没有东西了就停止
            let next = cur?.next        // 先拿到cur的下一个
            cur?.next = cur?.next?.next // 绕过(删除)cur的下一个
            next?.next = dummy.next     // 将cur的下一个移动到最前边1
            dummy.next = next           // 将cur的下一个移动到最前边2
        }
        
        return dummy.next
    }
}


do {
    // 1->2->3->4->5->NULL
    do {
        let head1 = ListNode.linkedList([1, 2, 3, 4, 5])
        head1?.show()
        let head2 = Solution().reverseList2(head1)
        head2?.show()
    }
    print("-----------------------")
    do {
        let head1 = ListNode.linkedList([1, 2, 3, 4, 5])
        head1?.show()
        let head2 = Solution().reverseList2(head1)
        head2?.show()
    }
}
