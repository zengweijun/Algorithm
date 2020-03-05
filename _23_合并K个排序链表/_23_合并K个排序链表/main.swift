//
//  main.swift
//  _23_合并K个排序链表
//
//  Created by 曾维俊 on 2020/3/5.
//  Copyright © 2020 Nius. All rights reserved.
//

import Foundation

/**
 合并 k 个排序链表，返回合并后的排序链表。请分析和描述算法的复杂度。

 示例:

 输入:
 [
   1->4->5,
   1->3->4,
   2->6
 ]
 输出: 1->1->2->3->4->4->5->6

 来源：力扣（LeetCode）
 链接：https://leetcode-cn.com/problems/merge-k-sorted-lists
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
    func mergeKLists(_ lists: [ListNode?]) -> ListNode? {
        
        let dummy: ListNode? = ListNode(0)
        
        for <#item#> in <#items#> {
            <#code#>
        }
        
        
        
        
        return dummy?.next
    }
}

do {
    let h1 = ListNode.linkedList([1, 4, 5])
    let h2 = ListNode.linkedList([1, 3, 4])
    let h3 = ListNode.linkedList([2, 6])
    
    let h = Solution().mergeKLists([h1, h2, h3])
    h?.show()
}
