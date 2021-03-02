//
//  main.swift
//  _237_删除链表中的节点
//
//  Created by 曾维俊 on 2020/3/5.
//  Copyright © 2020 Nius. All rights reserved.
//

import Foundation

/**
 请编写一个函数，使其可以删除某个链表中给定的（非末尾）节点，你将只被给定要求被删除的节点。

 现有一个链表 -- head = [4,5,1,9]，它可以表示为:
 4 --> 5 --> 1 --> 9
 
 示例 1:
 输入: head = [4,5,1,9], node = 5
 输出: [4,1,9]
 解释: 给定你链表中值为 5 的第二个节点，那么在调用了你的函数之后，该链表应变为 4 -> 1 -> 9.
 示例 2:

 输入: head = [4,5,1,9], node = 1
 输出: [4,5,9]
 解释: 给定你链表中值为 1 的第三个节点，那么在调用了你的函数之后，该链表应变为 4 -> 5 -> 9.
  

 说明:

 链表至少包含两个节点。
 链表中所有节点的值都是唯一的。
 给定的节点为非末尾节点并且一定是链表中的一个有效节点。
 不要从你的函数中返回任何结果。

 来源：力扣（LeetCode）
 链接：https://leetcode-cn.com/problems/delete-node-in-a-linked-list
 */

/**
 * Definition for singly-linked list.
 * struct ListNode {
 *     int val;
 *     ListNode *next;
 *     ListNode(int x) : val(x), next(NULL) {}
 * };
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
    func deleteNode(_ node: ListNode) {
        // 通产要删除一个节点的方法是，直接使用prev.next = prev.next.next
        // 然而这里没有给表头，也没有给该链表的上一个节点
        // 直接给要删除的节点，因此我们可以使用另外一个巧妙的办法
        // 即：将它下一个节点的值赋给它，转而删除它的下一个节点
        // 题目已经限定（非末尾），因此不用担心next为空
        node.val = node.next!.val
        node.next = node.next?.next
    }
}
