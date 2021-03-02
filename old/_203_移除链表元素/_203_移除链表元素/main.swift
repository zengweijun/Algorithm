//
//  main.swift
//  _203_移除链表元素
//
//  Created by 曾维俊 on 2020/2/29.
//  Copyright © 2020 Nius. All rights reserved.
//

import Foundation


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

/**
 
 删除链表中等于给定值 val 的所有节点。

 示例:
 输入: 1->2->6->3->4->5->6, val = 6
 输出: 1->2->3->4->5
  */
class Solution {
    func removeElements(_ head: ListNode?, _ val: Int) -> ListNode? {
        if head == nil {
            return nil
        }
        
        /** 总体思路
         遍历该链表，使用一个cur指针，检查cur.next.val是否是要删除的值
         如果是：cur.next = cur.next.next 跳过该节点
         如果不是：cur = cur.next         继续检查下一个
         */
        
        // 对比条件，每次都检查node的next，如果next.val等于val，这绕过该next节点即可
        // 由于头元素也需要检查，因此添加一个虚拟头结点
        // 天加一个虚拟头结点能保持代码的统一性
        
        let newHead: ListNode? = ListNode(0)
        newHead?.next = head
        
        var cur = newHead
        
        while cur?.next != nil {
            if cur?.next?.val == val {
                cur?.next = cur?.next?.next // 绕过该节点（走两步）
            } else {
                cur = cur?.next // 后移（走一步），继续遍历
            }
        }
        
        return newHead?.next
    }
    
    /**
     // 使用头尾节点来框选链表(该方案只是拓展思路，更推上边的荐方案)
     func removeElements1(_ head: ListNode?, _ val: Int) -> ListNode? {
          if head == nil {
              return nil
          }
          
          /** 总体思路
           遍历该链表，使用一个cur指针，检查cur.next.val是否是要删除的值
           如果是：cur.next = cur.next.next 跳过该节点
           如果不是：cur = cur.next         继续检查下一个
           */
          
          // 对比条件，每次都检查node的next，如果next.val等于val，这绕过该next节点即可
          // 由于头元素也需要检查，因此添加一个虚拟头结点
          // 天加一个虚拟头结点能保持代码的统一性
          
          let newHead: ListNode? = ListNode(0) // 头结点的next先不设置，找到符合条件的node再设置
          var newTail = newHead // 初始化的时候，链表只有一个虚拟头结点，因此头尾相同
         
          var cur = head // 使用cur遍历链表
         while cur != nil {
             if cur?.val != val {
                 // 这里无需直接操作newHead，因为newTail和newHead相同，因此直接操作newTail即可
                 newTail?.next = cur // 此时newHead.next = cur
                 newTail = cur // newTail向后移动
             }
             cur = cur?.next
          }
          newTail?.next = nil
          return newHead?.next
      }
     
     */
}

let head = Solution().removeElements(ListNode.linkedList([1, 2, 4, 3, 4, 5, 6]), 6)
head?.show()
