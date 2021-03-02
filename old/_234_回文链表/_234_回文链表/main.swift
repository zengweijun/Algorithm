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
    /**
     输入：[]
     输出：true
     
     输入：[1]
     输出：true
     
     输入: 1->2
     输出: false
     示例 2:

     输入: 1->2->2->1
     输出: true
     */
    // 空间复杂度O(1) 时间复杂度和 O(n)
    func isPalindrome(_ head: ListNode?) -> Bool {
        if head == nil || head?.next == nil {
            return true // 空节点 或者 只有一个节点，返回true
        }
        
        /** 总体思路：找到链表中部，将链表的后半部分反转，形成双链表逻辑
            链表中部：奇数个节点，中间节点即为中点；偶数个，前半部分节点结尾即为中点
            例子：1->2->2->1 ==> 1->[2]->2->1；1->2->3->2->1 ==> 1->2->[3]->2->1
            反转后部：
            1->2->2->1          ==> [1->2]->2，[1->2]->nil
            1->2->3->2->1    ==> [1->2]->3，[1->2]->nil
         
            同时遍历两个链表，以后边一个链表结束为循环控制结束标志
         */
        
        // 1.找到链表中点（使用快慢指针）
        let mid = findListMid(head)
        
        // 2.反转链表后半部分
        var lastPartReverseList = reverseList(mid?.next)
        // let lastPartReverseListTmp = lastPartReverseList // (若不能破话原链表结构，后边再给它反转回去)
        
        // 3.逐个对比两个链表(以后半部分链表为迭代基准),逐个对比
        var frontPartList = head
        while lastPartReverseList != nil {
            if frontPartList?.val != lastPartReverseList?.val {
                return false
            }
            lastPartReverseList = lastPartReverseList?.next
            frontPartList = frontPartList?.next
        }
        // 来到这里，说明直到后半部分链表遍历结束，都没有发生不相等的情况
        
        // 若不能破话原链表结构，这里再给它反转回去
        // reverseList(lastPartReverseListTmp)

        return true
    }
    
    // 寻找链表中点，使用快慢指针
    // 1->2->2->1 ==> 1->[2]->2->1；1->2->3->2->1 ==> 1->2->[3]->2->1
    func findListMid(_ head: ListNode?) -> ListNode? {
        if head == nil || head?.next == nil {
            return head
        }
        
        var fast = head
        var slow = head
        
        while fast?.next != nil && fast?.next?.next != nil {
            fast = fast?.next?.next
            slow = slow?.next
        }
        return slow
    }
    
    // 反转一个链表
    // 1->2->3->nil   ==>  3->2->1->nil
    func reverseList(_ head: ListNode?) -> ListNode? {
        if head == nil || head?.next == nil {
            return head
        }
        
        var prev: ListNode? = nil
        var cur = head
        var next = cur?.next
        
        while cur != nil {
            cur?.next = prev
            prev = cur
            cur = next
            next = next?.next
        }
        return prev
    }
    
    // 不推荐这种方式
    // 另一种思路：复制一条新链表，反转，然后逐个对比
    // 不过该方式控件浮渣度为O(n)的情况下，并未做到最优
    // 后边再提供一种思路，空间复杂度也为O(n)，但对比次数大大减少
    func isPalindrome1(_ head: ListNode?) -> Bool {
        if head == nil || head?.next == nil {
            return true // 空节点 或者 只有一个节点，返回true
        }
        
        var cur = head
        
        let newHead: ListNode? = ListNode(head!.val)
        var newCur = newHead
        while cur != nil {
            newCur?.next = ListNode(cur!.val)
            newCur = newCur?.next
            cur = cur?.next
        }
        
        // 反转
        newCur = reverseList(newHead)
        
        // 逐个对比
        cur = head
        while cur != nil {
            if cur?.val != newCur?.val {
                return false
            }
        }
        return true
    }
    
    // 空间复杂度也为O(n)，但对比次数大大减少
    // 使用数组
    func isPalindrome2(_ head: ListNode?) -> Bool {
        if head == nil || head?.next == nil {
            return true // 空节点 或者 只有一个节点，返回true
        }
        
        var cur = head
        var tmpArr: [Int]  = []
        while cur != nil {
            tmpArr.append(cur!.val)
            cur = cur?.next
        }
        
        let count = tmpArr.count
        for i in 0..<(count >> 1 ) {
            if tmpArr[i] != tmpArr[count - 1 - i] {
                return false
            }
        }
        return true
    }
}

do {
    do {
        let head = ListNode.linkedList([1, 2, 3, 2, 1])
        head?.show()
        let ret = Solution().isPalindrome(head)
        print(ret)
    }
    
    do {
        let head = ListNode.linkedList([1, 2, 2, 1])
        head?.show()
        let ret = Solution().isPalindrome(head)
        print(ret)
    }
    
    do {
        let head = ListNode.linkedList([])
        head?.show()
        let ret = Solution().isPalindrome(head)
        print(ret)
    }
    
    do {
        let head = ListNode.linkedList([1])
        head?.show()
        let ret = Solution().isPalindrome(head)
        print(ret)
    }
    
    do {
        let head = ListNode.linkedList([1, 2])
        head?.show()
        let ret = Solution().isPalindrome(head)
        print(ret)
    }
    
    do {
        let head = ListNode.linkedList([1, 2, 3, 4, 5])
        head?.show()
        let ret = Solution().isPalindrome(head)
        print(ret)
    }
}
