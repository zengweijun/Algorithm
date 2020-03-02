//
//  main.swift
//  _160_相交链表
//
//  Created by 曾维俊 on 2020/2/29.
//  Copyright © 2020 Nius. All rights reserved.
//

import Foundation
/**
 编写一个程序，找到两个单链表相交的起始节点。
 如下面的两个链表：



 在节点 c1 开始相交。

  

 示例 1：



 输入：intersectVal = 8, listA = [4,1,8,4,5], listB = [5,0,1,8,4,5], skipA = 2, skipB = 3
 输出：Reference of the node with value = 8
 输入解释：相交节点的值为 8 （注意，如果两个列表相交则不能为 0）。从各自的表头开始算起，链表 A 为 [4,1,8,4,5]，链表 B 为 [5,0,1,8,4,5]。在 A 中，相交节点前有 2 个节点；在 B 中，相交节点前有 3 个节点。
  

 示例 2：



 输入：intersectVal = 2, listA = [0,9,1,2,4], listB = [3,2,4], skipA = 3, skipB = 1
 输出：Reference of the node with value = 2
 输入解释：相交节点的值为 2 （注意，如果两个列表相交则不能为 0）。从各自的表头开始算起，链表 A 为 [0,9,1,2,4]，链表 B 为 [3,2,4]。在 A 中，相交节点前有 3 个节点；在 B 中，相交节点前有 1 个节点。
  

 示例 3：



 输入：intersectVal = 0, listA = [2,6,4], listB = [1,5], skipA = 3, skipB = 2
 输出：null
 输入解释：从各自的表头开始算起，链表 A 为 [2,6,4]，链表 B 为 [1,5]。由于这两个链表不相交，所以 intersectVal 必须为 0，而 skipA 和 skipB 可以是任意值。
 解释：这两个链表不相交，因此返回 null。
  

 注意：

 如果两个链表没有交点，返回 null.
 在返回结果后，两个链表仍须保持原有的结构。
 可假定整个链表结构中没有循环。
 程序尽量满足 O(n) 时间复杂度，且仅用 O(1) 内存。

 来源：力扣（LeetCode）
 链接：https://leetcode-cn.com/problems/intersection-of-two-linked-lists
 
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
    func getIntersectionNode(_ headA: ListNode?, _ headB: ListNode?) -> ListNode? {
        // 1 --> 8 --> 4 --> 5
        // 5 --> 0 --> 1 --> 8 --> 4 --> 5
        // 要让两个链表公共节点（8 --> 4 --> 5），内存地址相同
        /**
         由于使用两个指针进行同步移动，但链表长度不同，因此不宜寻找，一种比价特别的思路是将两个链表变为一样长
         {1 --> (8 --> 4 --> 5)} | {5 --> 0 --> 1 --> (8 --> 4 --> 5)}
         {5 --> 0 --> 1 --> (8 --> 4 --> 5)} | {1 --> (8 --> 4 --> 5)}
         方法是将链表1拼接在链表2后边，同时将链表2拼接在链表1前后边，行测如同上边结果
         可以发现，此时只要两个指针从头到尾扫描，发现第一个相同的节点就是我们要找的相交链表的起始点 “8” 节点
         当然实际操作中不需要真的做拼接操作，这只是逻辑思维过程，实际操作是只需链表1跑完后指向链表2，链表2同理
         即curA == nil时，headA结束，此时将curA = headB继续，就满足了如上逻辑，curB同理
         
         由于curA中途需要切换到headB，因此headB要一直保留B链表的头部，headA也一样
         */
        headA?.show()
        headB?.show()
        // 注意边界
        if headA == nil || headB == nil {
            return nil
        }
        
        var curA = headA
        var curB = headB
        
        // 退出循环的条件为curA == curB，找到了公共节点
        // 如果链表不相交，最终结果是curA == nil，curB == nil，同样能退出
        // swift中判断内存地址使用 ===，三个等号判断引用类型地址，== 两个等号判断值类型，如结构体等
        while curA !== curB {
//            if curA == nil {
//                curA = headB
//            } else {
//                curA = curA?.next
//            }
//
//            if curB == nil {
//                curB = headA
//            } else {
//                curB = curB?.next
//            }
            
            curA = (curA == nil) ? headB : curA?.next
            curB = (curB == nil) ? headA : curB?.next
        }
        
        return curA // === curB
    }
}

do {
    // [4,1,8,4,5], listB = [5,0,1,8,4,5]
    // 相交于 8->4->5
    let headA = ListNode.linkedList([4, 1])
    let headB = ListNode.linkedList([5,0,1])

    // 构造8->4->5公共节点（公共节点需要内存地址相同）
    var tailA = headA
    while tailA?.next != nil {
        tailA = tailA?.next
    }
    var tailB = headB
    while tailB?.next != nil {
        tailB = tailB?.next
    }

    for val in [8, 4, 5] {
        tailA?.next = ListNode(val)
        tailB?.next = tailA?.next
        tailA = tailA?.next
        tailB = tailB?.next
    }

    let head1 = Solution().getIntersectionNode(headA, headB)
    head1?.show()
}
