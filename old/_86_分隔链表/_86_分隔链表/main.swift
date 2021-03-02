//
//  main.swift
//  _86_分隔链表
//
//  Created by nius on 2020/3/2.
//  Copyright © 2020 nius. All rights reserved.
//

import Foundation

/**
 
 给定一个链表和一个特定值 x，对链表进行分隔，使得所有小于 x 的节点都在大于或等于 x 的节点之前。
 你应当保留两个分区中每个节点的初始相对位置。

 示例:
 输入: head = 1->4->3->2->5->2, x = 3
 输出: 1->2->2->4->3->5
 
 进阶：分割成3部分 1->2->2->3->4->5

 来源：力扣（LeetCode）
 链接：https://leetcode-cn.com/problems/partition-list
 
 同源题目：面试题 02.04. 分割链表 https://leetcode-cn.com/problems/partition-list-lcci/
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
        输入: head = 1->4->3->2->5->2, x = 3
        输出: 1->2->2->4->3->5 【1->2->2    分割    4->3->5】
     
        思路：构建两个新链表 head1和head2
            其中head1中节点都小于3，head2中节点都大于等于3
            head1和head2的构建可以使用“头尾框选法”
            保留节点相对位置，只需按顺序遍历即可
     */
    
    func partition(_ head: ListNode?, _ x: Int) -> ListNode? {
        if head == nil || head?.next == nil {
            return head
        }
        
        let dummyHead1:ListNode? = ListNode(0)
        let dummyHead2:ListNode? = ListNode(0)
        
        // tail1和tail2既作为尾指针，也做做游标指针的功能
        var tail1 = dummyHead1
        var tail2 = dummyHead2
        
        var cur = head
        
        while cur != nil {
            if cur!.val < x {
                tail1?.next = cur // 放入到head1链表中
                tail1 = tail1?.next
            } else {
                tail2?.next = cur // 放入到head2链表中
                tail2 = tail2?.next
            }
            
            cur = cur?.next
        }
        
        tail1?.next = dummyHead2?.next // 拼接两个链表
        
        // 最终tail2作为全链表的尾巴，必须将tail2.next清空
        // 因为tail2是从原来链表中提取的，有可能tail2.next仍然指向之前链表中的节点
        // 而之前链表中的节点除了出于head2之外就出于head1中，这样tail2.next有可能
        // 会指向head1中节点，此时将head1接上head2之后可能导致链表产生环
        // 一个特例 head = 1 -> 4 -> 2,x = 3 --> head1 = 1 -> 2 -> nil  head2 = 4 (-> 2)
        // 这种情况下会产生环 1 -> 2 -> 4 -> 2 -> 4 .....
        // 因此最后一定要记得清掉尾巴
        tail2?.next = nil
        
        return dummyHead1?.next
    }
    
    // 分割为3部分
    // 输入: head = 1->4->3->2->5->2->3, x = 3
    // 输出: 1->2->2->3->3->4->5 【1->2->2  分割  3->3 分割  4->3->5】
    func partitionThree(_ head: ListNode?, _ x: Int) -> ListNode? {
        // 思路同分割为2部分
        if head == nil || head?.next == nil {
            return head
        }
        let dummyHead1:ListNode? = ListNode(0) // < x
        let dummyHead2:ListNode? = ListNode(0) // == x
        let dummyHead3:ListNode? = ListNode(0) // > x
        
        var tail1 = dummyHead1
        var tail2 = dummyHead2
        var tail3 = dummyHead3
        
        var cur = head
        
        while cur != nil {
            if cur!.val < x {
                tail1?.next = cur // 放入到head1链表中
                tail1 = tail1?.next
            } else if cur!.val == x {
                tail2?.next = cur // 放入到head2链表中
                tail2 = tail2?.next
            } else {
                tail3?.next = cur // 放入到head3链表中
                tail3 = tail3?.next
            }
            cur = cur?.next
        }
        
        tail1?.next = dummyHead2?.next // 拼接三个链表
        tail2?.next = dummyHead3?.next
        tail3?.next = nil // 清掉尾巴
        
        return dummyHead1?.next
    }
}


let head = ListNode.linkedList([1, 4, 3, 2, 5, 2])
head?.show()
let result = Solution().partition(head, 3)
result?.show()

print("---------------------------")
let head2 = ListNode.linkedList([3, 5, 8, 5, 10, 2, 1])
head2?.show()
let result2 = Solution().partition(head2, 5)
result2?.show()


print("---------------------------")
let head3 = ListNode.linkedList([1, 5, 3, 2, 4, 2, 3])
head3?.show()
let result3 = Solution().partitionThree(head3, 3)
result3?.show()

