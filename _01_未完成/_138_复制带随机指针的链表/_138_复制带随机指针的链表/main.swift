//
//  main.swift
//  _138_复制带随机指针的链表
//
//  Created by nius on 2020/3/7.
//  Copyright © 2020 nius. All rights reserved.
//

import Foundation

/**
 给定一个链表，每个节点包含一个额外增加的随机指针，该指针可以指向链表中的任何节点或空节点。

 要求返回这个链表的 深拷贝。

 我们用一个由 n 个节点组成的链表来表示输入/输出中的链表。每个节点用一个 [val, random_index] 表示：

 val：一个表示 Node.val 的整数。
 random_index：随机指针指向的节点索引（范围从 0 到 n-1）；如果不指向任何节点，则为  null 。
 
 示例 1：
 输入：head = [[7,null],[13,0],[11,4],[10,2],[1,0]]
 输出：[[7,null],[13,0],[11,4],[10,2],[1,0]]
 
 示例 2：
 输入：head = [[1,1],[2,1]]
 输出：[[1,1],[2,1]]
 
 示例 3：
 输入：head = [[3,null],[3,0],[3,null]]
 输出：[[3,null],[3,0],[3,null]]
 
 示例 4：
 输入：head = []
 输出：[]
 解释：给定的链表为空（空指针），因此返回 null。


 来源：力扣（LeetCode）
 链接：https://leetcode-cn.com/problems/copy-list-with-random-pointer
 */

public class ListNode {
    public var val: Int
    public var next: ListNode?
    public var random: ListNode?
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

extension ListNode: Hashable {
    public static func == (lhs: ListNode, rhs: ListNode) -> Bool {
        return lhs === rhs
    }
    public func hash(into hasher: inout Hasher) {
    }
}

class Solution {
    func copyRandomList(_ head: ListNode?) -> ListNode? {
        if head == nil {
            return nil
        }
        
        var nodes = [ListNode]()
        var cur = head
        while let unpackCur = cur {
            nodes.append(unpackCur)
            cur = unpackCur.next
        }
        
        var randomIndexs = [Int](repeating: -1, count: nodes.count)
        for i in 0..<nodes.count {
            let node = nodes[i]
            if let random = node.random, let randomIndex = nodes.firstIndex(of: random) {
                randomIndexs[i] = randomIndex
            }
        }
        
        
        let dummy: ListNode? = ListNode(0)
        var tail = dummy
        var newNodes = [ListNode]()
        cur = head
        while let unpackCur = cur {
            tail?.next = ListNode(unpackCur.val)
            newNodes.append(tail!.next!)
            cur = unpackCur.next
            tail = tail?.next
        }
        
        var index = 0
        var newCur = dummy?.next
        while let unpackNewCur = newCur {
            let randomIndex = randomIndexs[index]
            unpackNewCur.random = newNodes[randomIndex]
            newCur = unpackNewCur.next
            index += 1
        }
        
        return dummy?.next
    }
}



do {
    do {
        
        
        
        
    }
}
    
