//
//  main.swift
//  _2_两数相加
//
//  Created by 曾维俊 on 2020/2/29.
//  Copyright © 2020 Nius. All rights reserved.
//

import Foundation
/**
 给出两个 非空 的链表用来表示两个非负的整数。其中，它们各自的位数是按照 逆序 的方式存储的，并且它们的每个节点只能存储 一位 数字。

 如果，我们将这两个数相加起来，则会返回一个新的链表来表示它们的和。

 您可以假设除了数字 0 之外，这两个数都不会以 0 开头。

 示例：
 输入：(2 -> 4 -> 3) + (5 -> 6 -> 4)
 输出：7 -> 0 -> 8
 原因：342 + 465 = 807

 来源：力扣（LeetCode）
 链接：https://leetcode-cn.com/problems/add-two-numbers
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
    func addTwoNumbers(_ l1: ListNode?, _ l2: ListNode?) -> ListNode? {
        // 链表非空
        let resultHead: ListNode? = ListNode(0)
        var cur = resultHead
        
        var cur1 = l1
        var cur2 = l2
        var tmp = 0 // 是否进位，进位1，不进位0
        while cur1 != nil && cur2 != nil {
            let sum = cur1!.val + cur2!.val + tmp
            if sum >= 10 {
                tmp = 1
                cur?.next = ListNode(sum - 10)
            } else {
                tmp = 0
                cur?.next = ListNode(sum)
            }
            cur = cur?.next
            cur1 = cur1?.next
            cur2 = cur2?.next
        }
        
        while cur1 != nil {
            let sum = cur1!.val + tmp
            if sum >= 10 {
                tmp = 1
                cur?.next = ListNode(sum - 10)
            } else {
                tmp = 0
                cur?.next = ListNode(sum)
            }
            cur = cur?.next
            cur1 = cur1?.next
        }
        
        while cur2 != nil {
            let sum = cur2!.val + tmp
            if sum >= 10 {
                cur?.next = ListNode(sum - 10)
            } else {
                tmp = 0
                cur?.next = ListNode(sum)
            }
            cur = cur?.next
            cur2 = cur2?.next
        }
        
        // 链表都结束了，但是最后一个数组存在进位，此时需要再增加一个节点
        if tmp == 1 {
            cur?.next = ListNode(1)
        }
        
        return resultHead?.next
    }
    
    
    // 优化
    func addTwoNumbers1(_ l1: ListNode?, _ l2: ListNode?) -> ListNode? {
        // 题目说明非空链表，这里不做判断
        let dummyHead: ListNode? = ListNode(0) // 设置虚拟头结点
        var tail = dummyHead // 尾指针（也是移动光标）
        
        var cur1 = l1
        var cur2 = l2
        
        var carry = 0 // 进位
        
        // 两个链表都要结束才行
        while cur1 != nil || cur2 != nil {
            let v1 = cur1?.val ?? 0  // 如果cur1提前结束，默认为0
            let v2 = cur2?.val ?? 0  // 如果cur2提前结束，默认为0
            cur1 = cur1?.next // swift中访问空指针是安全的
            cur2 = cur2?.next // swift中访问空指针是安全的
            
            let sum = v1 + v2 + carry
            carry =  sum / 10 // 计算进位
            tail?.next = ListNode(sum % 10) // 取个位数
            tail = tail?.next // tail后移
        }
        
        // 两个链表都结束了，但是有可能还存在进位未完成
        if carry > 0 {
            tail?.next = ListNode(carry) // carry == 1
        }
        
        return dummyHead?.next
    }
}


let head1 = Solution().addTwoNumbers1(ListNode.linkedList([2, 4, 3]), ListNode.linkedList([5, 6, 4]))
head1?.show()

let head2 = Solution().addTwoNumbers1(ListNode.linkedList([5]), ListNode.linkedList([5]))
head2?.show()

let head3 = Solution().addTwoNumbers1(ListNode.linkedList([9]), ListNode.linkedList([9]))
head3?.show()

let head4 = Solution().addTwoNumbers1(ListNode.linkedList([2, 4, 3]), ListNode(0))
head4?.show()

let head = ListNode.linkedList([1, 8, 20, 5])
head?.show()
