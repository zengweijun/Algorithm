//
//  main.swift
//  _92_反转链表 II
//
//  Created by 曾维俊 on 2020/3/2.
//  Copyright © 2020 Nius. All rights reserved.
//

import Foundation
/**
 反转从位置 m 到 n 的链表。请使用一趟扫描完成反转。

 说明:
 1 ≤ m ≤ n ≤ 链表长度。

 示例:
 输入: 1->2->3->4->5->NULL, m = 2, n = 4
 输出: 1->4->3->2->5->NULL

 来源：力扣（LeetCode）
 链接：https://leetcode-cn.com/problems/reverse-linked-list-ii
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
    // 推荐使用方法2
    // 使用m-n之间元素构建一条新链表
    // 反转该链表，链接头尾
    func reverseBetween(_ head: ListNode?, _ m: Int, _ n: Int) -> ListNode? {
        if head == nil || head?.next == nil || m == n {
            return head
        }
        
        // 将链表分割为3段
        // head ==> firstTail
        // tmpHead ==> tmpTail   反转
        // lastHead ==> ...
        
        
        var cur = head
        
        var tmpHead: ListNode? = nil
        var tmpTail = tmpHead
        
        var firstTail: ListNode? = nil
        var lastHead: ListNode? = nil
        
        // 第一段 head ==> firstTail
        for _ in 1..<m {
            firstTail = cur
            cur = cur?.next
        }
        
        // 第二段 tmpHead ==> tmpTail
        tmpHead = cur // == firstTail.next
        tmpTail = tmpHead
        for _ in m..<n {
            cur = cur?.next
            tmpTail?.next = cur
            tmpTail = tmpTail?.next
        }
        
        // 第三段 lastHead ==> ...
        lastHead = cur?.next
        
        // 将构造出的新链表去掉尾巴
        // 现将cur.next记录下，去掉尾巴之前
        tmpTail?.next = nil
        
        // 将三段链表链接在一起
        let reversedList = reverseList(tmpHead) // 经过这里，tmpHead就变成了尾部
        firstTail?.next = reversedList
        tmpHead?.next = lastHead
        
        return firstTail != nil ? head : reversedList
    }
    
    // 反转链表
    func reverseList(_ head: ListNode?) -> ListNode? {
        if head == nil || head?.next == nil {
            return head
        }
        
        let newHead = reverseList(head?.next)
        head?.next?.next = head
        head?.next = nil
        return newHead
    }
    
    // 推荐方法
    // 使用头部插入法最简单
    func reverseBetween1(_ head: ListNode?, _ m: Int, _ n: Int) -> ListNode? {
        if head == nil || head?.next == nil || m == n {
            return head
        }
        
        // 构建新链表虚拟头
        let dummy: ListNode? = ListNode(0)
        dummy?.next = head
        
        // 找到插入位置的前驱
        var precursor = dummy
        
        for _ in 1..<m {
            precursor = precursor?.next
        }
        
        // 从precursor开始，知道n之前的节点全部插入到precursor之后
        // 这里cur无需cur = cur.next，实际上向头部插入东西，cur就已经会自动后移
        let cur = precursor?.next
        for _ in m..<n { // 只需之心m-n次插入即可
            let next = cur?.next        // 记录cur的下一个
            cur?.next = cur?.next?.next // 删掉cur的下一个
            
            // 重复该过程
            next?.next = precursor?.next // 将next插入到precursor之后1
            precursor?.next = next       // 将next插入到precursor之后2
        }
        
        return dummy?.next
    }
}

do {
    do {
        //    输入: 1->2->3->4->5->NULL, m = 2, n = 4
        //    输出: 1->4->3->2->5->NULL
            let head = ListNode.linkedList([1, 2, 3, 4, 5])
            head?.show()
            
            let result = Solution().reverseBetween(head, 2, 4)
            result?.show()
    }
    
    do {
        //    输入: 3->5->NULL, m = 1, n = 2
        //    输出: 5->3->NULL
            let head = ListNode.linkedList([3, 5])
            head?.show()
            
            let result = Solution().reverseBetween(head, 1, 2)
            result?.show()
    }
    
    do {
        //    输入: 3->5->NULL, m = 1, n = 1
        //    输出: 3->5->NULL
            let head = ListNode.linkedList([3, 5])
            head?.show()
            
            let result = Solution().reverseBetween(head, 1, 1)
            result?.show()
    }
}

