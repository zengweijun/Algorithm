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

extension ListNode: Comparable {
    public static func < (lhs: ListNode, rhs: ListNode) -> Bool {
        return lhs.val < rhs.val
    }
    
    public static func == (lhs: ListNode, rhs: ListNode) -> Bool {
        return lhs.val == rhs.val
    }
}

struct PriorityQueue<E: Comparable> {
    
    private var minHeap = false
    private var elements: [E] = []
    
    var isMinHeap: Bool { return minHeap }
    
    init() { }
    init(minHeap: Bool) {
        self.minHeap = minHeap
    }
    
    // 批量建堆 O(n) + O(n * logn) ≈ O(n * logn)
    init(nums: [E], minHeap: Bool) {
        self.minHeap = minHeap

        for item in nums { // O(n)
            elements.append(item)
        }
        heapify()  // O(n * logn)
    }
    
    mutating func offer(_ x: E) {
        // 【描述针对大顶堆】
        // 添加一个元素倒二叉堆的末尾，需要堆该元素执行上浮（上虑）操作，因为不知道该元素是否比它的父节点大
        elements.append(x)
        siftUp(elements.count - 1)
    }
    
    mutating func poll()-> E {
        // 【描述针对大顶堆】
        // 删掉堆顶后，需要将最后一个位置元素填补到堆顶，需要对该元素执行下层（下虑）操作，因为它可能比下边的子节点小
        // 这里先记录堆顶（根节点）元素的值，然后让最后一个元素覆盖根节点，执行下虑
        let last = elements.removeLast()
        if elements.isEmpty {
            return last
        }
        
        let top = elements[0]
        elements[0] = last
        siftDown(0) // 执行下虑
        return top
    }
    
    func peek() ->E? {
        return elements.count > 0 ? elements[0] : nil
    }
    
    mutating func clear() {
        elements = []
    }
    
    func count() -> Int {
        return elements.count
    }
    
    
    func isEmpty() -> Bool {
        return elements.isEmpty
    }
    
    mutating func siftUp(_ index: Int) {
        // 【描述针对大顶堆】
        var index = index // Copy On Write
        let element = elements[index]
        // 不断上虑，index会不断减小，直到index上虑到0位置
        while index > 0 {
            // 一开始添加的时候，element是一个叶子节点
            // 根据完全二叉树的性质（二叉堆就是一个逻辑完全二叉树），获取其父节点
            let parentIndex = (index - 1) / 2
            let parentElement = elements[parentIndex]
            
            // 如果已经比父节点小了，无需再上虑
            if compare(element, parentElement) < 0 {
                break
            }
            
            // 否则，将父节点的值存储在index位置（没有执行交换操作，这里直接赋值，因为index之前有备份）
            elements[index] = parentElement
            index = parentIndex // index指向父节点，继续和上一层的父节点比较，直到index=0（根节点）
        }
        elements[index] = element
    }
    
    mutating func siftDown(_ index: Int) {
        // 【描述针对大顶堆】
        var index = index // Copy On Write
        let element = elements[index]
        
        // 完全二叉树第一个叶子节点的索引 == 非叶子节点的数量
        // half为第一个叶子节点的索引，因此index下虑如果到达half
        // 说明已经到了叶子节点（无子节点），无需再下虑
        let half = elements.count / 2
        
        while index < half {
            // index的节点有2种情况
            // 1.只有左子节点
            // 2.同时有左右子节点
            
            // 默认左边的子节点比较大
            var maxChildIndex = 2 * index  + 1 // (2n + 1：完全二叉树左子节点下表，下标0开始)
            var maxChildValue = elements[maxChildIndex]
            
            // 检查右子节点是否更大
            let rightChildIndex = maxChildIndex + 1
            
            // 右子节点存在 且 比左子节点大，那下虑的目标使用右子节点
            if rightChildIndex < elements.count && compare(elements[rightChildIndex], maxChildValue) > 0 {
                maxChildValue = elements[rightChildIndex]
                maxChildIndex = rightChildIndex
            }
            
            // 如果已经比父节点大了，无需再下虑
            if compare(element, maxChildValue) > 0 {
                break
            }
            
            // 下虑，直接拷贝下边的值上去（没有执行交换操作，这里直接赋值，因为index之前有备份）
            elements[index] = maxChildValue
            index = maxChildIndex // index指向被下虑的节点，继续与其子节点对比，直到index >= half（叶子节点）
        }
        elements[index] = element
    }
    
    // 返回值
    // >  1：e1 >  e2    // .orderedDescending.rawValue = 1
    // == 0：e1 == e2    // .orderedSame.rawValue = 0
    // < -1：e1 <  e2    // .orderedAscending.rawValue = -1
    func compare(_ e1: E, _ e2: E) -> Int {
        var result = 0
        if e1 > e2 {
            result = 1
        } else if e1 < e2 {
            result = -1
        } else {
            result = 0
        }
        // 反过来使之成为最小堆
        if isMinHeap { result = -result }
        return result
    }
    
    // 批量建堆（堆化）
    // 综合时间复杂度：O(n * logn)
    mutating func heapify() {
        /* 选择自下而上的下沉，遍历次数更小
        // 自上而下的上滤(从顶部一个一个向上浮) --> O(n)
        for i in 0..<elements.count {
            siftUp(i)
        }
        */
        
        // 自下而上的下滤(从第一个非叶子节点一个一个向下沉)  --> O(n/2 - 1)
        // 综合时间复杂度：O(n * logn)
        for i in stride(from: elements.count / 2 - 1, to: -1, by: -1) { // O(n)
            siftDown(i) // O(logn)
        }
    }
}


class Solution {
    func mergeKLists1(_ lists: [ListNode?]) -> ListNode? {
        // 暴力解法 时间：O(nlogn)   空间：O(n)
        // 将所有节点加入到一个数组中，然后排序数组，最后将数组中的元素串为一条新链表返回
        
        guard lists.count > 0 else { return nil }
        
        // 1.将所有节点加入到一个数组中 O(n)
        var nodes = [ListNode]()
        for head in lists {
            var cur = head
            while let node = cur {
                nodes.append(node)
                cur = cur?.next
            }
        }
        
        // 2.排序数组  O(nlogn)
        // [begin, end)
        func quickSort(_ nodes: inout [ListNode], _ begin: Int, _ end: Int) {
            guard (end - begin) >= 2 else { return }
            
            let pivotNode = nodes[begin]
            var left = begin
            var right = end - 1
            
            while left < right {
                while left < right && nodes[right].val >= pivotNode.val { right -= 1 }
                while left < right && nodes[left].val <= pivotNode.val { left += 1 }
                
                if left == right {
                    nodes[begin] = nodes[left]
                    nodes[left] = pivotNode
                } else {
                    let tmp = nodes[left]
                    nodes[left] = nodes[right]
                    nodes[right] = tmp
                }
            }
            quickSort(&nodes, begin, left)
            quickSort(&nodes, left + 1, end)
        }
        quickSort(&nodes, 0, nodes.count)
        
        // 3.将数组中的元素串为一条新链表 O(n)
        let dummy: ListNode? = ListNode(0)
        var tail = dummy
        for node in nodes {
            tail?.next = node
            tail = tail?.next
        }
        tail?.next = nil // 记得清掉尾巴，防止出现环
        
        return dummy?.next
    }
    
    func mergeKLists2(_ lists: [ListNode?]) -> ListNode? {
        // 逐一比较(swift版目前LeetCode跑不起来，java版可以)
        // 参考两条链表合并的思路，全部遍历所有头，每次都取出最小头接在新链表上，被取出链表后移，知道所有链表都为空退出
        // O(n * k) [当n >> k的时候，≈ O(n)]，空间O(1)
        guard lists.count > 0 else { return nil }
        
        var lists = lists // Copy On Write
        let dummy: ListNode? = ListNode(0)
        var tail = dummy
        
        while true {
            // 一轮 (重复该过程，直到所有链表头都为nil)
            var minHeadListIndex = -1 // 默认不指定哪条链表头最小，因为有些链表可能已经遍历到尾部
            for i in stride(from: 0, to: lists.count, by: 1) {
                let curHead = lists[i]
                if curHead === nil { continue } // 如果当前聊表已经到末尾，则跳过
                
                // 没有找到最小头聊表，默认使用当前这一条链表头作为最小
                if minHeadListIndex == -1 {
                    minHeadListIndex = i
                } else {
                    // 或者 已经找到了最小头的那一条，那和当前这一条对比，如果大于当前这一条，那就使用当前这一条
                    let minHead = lists[minHeadListIndex]
                    if let curHeadValue = curHead?.val, let minHeadValue = minHead?.val, curHeadValue < minHeadValue {
                        minHeadListIndex = i
                    }
                }
            } // O(k)
            
            // 这里判断，如果minHeadListIndex == -1，说明所有链表都遍历完成，退出while
            if minHeadListIndex == -1 { break }
            
            // 来到这里，minHeadListIndex一定不为-1，即找到了某条链表最小头
            // 根据minHeadListIndex取出最小头的那一条链表，接到新链表上，被取出头的链表头向后移动
            tail?.next = lists[minHeadListIndex]  // O(n)
            tail = tail?.next
            lists[minHeadListIndex] = lists[minHeadListIndex]?.next
        }  // O(n * k)
        
        // 此处可以不用，因为最终tail?.next一定是某条链表的尾部，因此tail?.next一定为nil
        // 但是在方法1中，由于使用不稳定排序（快排），所以尾部需要清空
        // tail?.next = nil
        
        return dummy?.next
    }
    
    func mergeKLists3(_ lists: [ListNode?]) -> ListNode? {
        // 逐一两两合并链表(swift版目前LeetCode跑不起来，java版可以)
        // 该方法有许多重复比较，比如第一条链表0号位置，比较了k-1次
        // 每次都将后边链表合并到第一条上，1、2-->1，1、3-->1
        // 数据规模：k * n = O(n * k)，[n >> k,近似 O(n)] ，空间O(k)
        func merge2List(_ head1: ListNode?, _ head2: ListNode?) -> ListNode? {
            if head1 === nil { return head2 }
            if head2 === nil { return head1 }
            
            var cur1 = head1
            var cur2 = head2
            
            // 虚拟头
            let dummy: ListNode? = ListNode(0)
            var tail = dummy
            
            // 遍历两条链表，有一条先结束就停止，吧未结束的那一条接上
            while cur1 !== nil && cur2 !== nil {
                if cur1!.val < cur2!.val {
                    tail?.next = cur1
                    cur1 = cur1?.next
                } else {
                    tail?.next = cur2
                    cur2 = cur2?.next
                }
                tail = tail?.next
            }
            
            // 找到还未结束的那一条链表 接在后边
            if cur1 == nil {
                tail?.next = cur2
            } else {
                tail?.next = cur1
            }
            
            // 可以不用，最终的尾节点一定是之前某一条的尾部
            // tail?.next = nil
            
            return dummy?.next
        }
        
        if lists.count == 0 { return nil }
        if lists.count == 1 { return lists[0] }
        
        // 每次都将合并的结果放到第一条上，然后再和后边的合并
        var lists = lists
        for i in stride(from: 1, to: lists.count, by: 1) {
            lists[0] = merge2List(lists[0], lists[i])
        }
        
        return lists[0]
    }
    
    func mergeKLists4(_ lists: [ListNode?]) -> ListNode? {
        // 使用优先级队列（小顶堆）
        // 先将所有链表头节点装入堆中（堆自动排序）
        // 每次取出堆顶元素作为接入到新链表，然后删除该节点（重新堆化），将该节点链表的下一个节点入队（重新堆化）
        // 从新入队的节点经过堆化后，堆顶元素即为下一个最小的节点，重复上述步骤
        // O(n * logk)，空间O(k)
        
        let dummy: ListNode? = ListNode(0)
        var tail = dummy
        
        // 1.先将所有链表头节点装入堆中（堆自动排序）
        var queue = PriorityQueue<ListNode>(minHeap: true)
        for list in lists {
            if let list = list {
                queue.offer(list)
            }
        } // O(n)
        
        // 2.构建新链表
        while !queue.isEmpty() { // O(n)
            var node: ListNode? = queue.poll() // O(logk)
            
            tail?.next = node
            tail = tail?.next
            
            node = node?.next
            if let node = node {
                queue.offer(node) // O(logk)
            }
        }  // --> O(n * 2 * logk) ≈ O(n * logk)
        
        // 这里不需要
        // tail?.next = nil
        
        return dummy?.next
    }
    
    func mergeKLists5(_ lists: [ListNode?]) -> ListNode? {
        // 分治策略 O(n * logk)
        // 该方法比较次数减少，比如第一条链表0号位置，比较了logk次
        // 1、2、3、4、5、6、7、8 链表
        // 1 = [1、2]  3 = [3、4]  5 = [5、5]  7 = [7、8]
        // 1 = [1、5] 最终全部合并到1上
        // 数据规模：n，合并次数（二叉树高度）logk --> O(n*logk)
        
        if lists.count == 0 { return nil }
        if lists.count == 1 { return lists[0] }
        
        
        let dummy: ListNode? = ListNode(0)
        var tail = dummy
        
        
        return dummy?.next
    }
    
}

do {
//    do {
//        // 暴力解法
//        do {
//            let h1 = ListNode.linkedList([1, 4, 5])
//            let h2 = ListNode.linkedList([1, 3, 4])
//            let h3 = ListNode.linkedList([2, 6])
//            // 1->1->2->3->4->4->5->6
//            let h = Solution().mergeKLists1([h1, h2, h3])
//            h?.show()
//        }
//
//        do {
//            let h1 = ListNode.linkedList([-2,-2])
//            let h2 = ListNode.linkedList([-3])
//            // -3-->-2-->-2
//            let h = Solution().mergeKLists1([h1, h2])
//            h?.show()
//        }
//    }
    
    do {
        // 遍历k条链表法
//        do {
//            let h1 = ListNode.linkedList([1, 4, 5])
//            let h2 = ListNode.linkedList([1, 3, 4])
//            let h3 = ListNode.linkedList([2, 6])
//            // 1->1->2->3->4->4->5->6
//            let h = Solution().mergeKLists2([h1, h2, h3])
//            h?.show()
//        }
//
//        do {
//            let h1 = ListNode.linkedList([-2,-2])
//            let h2 = ListNode.linkedList([-3])
//            // -3-->-2-->-2
//            let h = Solution().mergeKLists2([h1, h2])
//            h?.show()
//        }
    }
        
//    do {
////        // 逐一两两合并链表
//        do {
//            let h1 = ListNode.linkedList([1, 4, 5])
//            let h2 = ListNode.linkedList([1, 3, 4])
//            let h3 = ListNode.linkedList([2, 6])
//            // 1->1->2->3->4->4->5->6
//            let h = Solution().mergeKLists3([h1, h2, h3])
//            h?.show()
//        }
//
//        do {
//            let h1 = ListNode.linkedList([-2,-2])
//            let h2 = ListNode.linkedList([-3])
//            // -3-->-2-->-2
//            let h = Solution().mergeKLists3([h1, h2])
//            h?.show()
//        }
//    }
    

            
//    do {
//    // 使用优先级队列（小顶堆）
//        do {
//            let h1 = ListNode.linkedList([1, 4, 5])
//            let h2 = ListNode.linkedList([1, 3, 4])
//            let h3 = ListNode.linkedList([2, 6])
//            // 1->1->2->3->4->4->5->6
//            let h = Solution().mergeKLists4([h1, h2, h3])
//            h?.show()
//        }
//
//        do {
//            let h1 = ListNode.linkedList([-2,-2])
//            let h2 = ListNode.linkedList([-3])
//            // -3-->-2-->-2
//            let h = Solution().mergeKLists4([h1, h2])
//            h?.show()
//        }
//    }

    do {
    // 使用优先级队列（小顶堆）
        do {
            let h1 = ListNode.linkedList([1, 4, 5])
            let h2 = ListNode.linkedList([1, 3, 4])
            let h3 = ListNode.linkedList([2, 6])
            // 1->1->2->3->4->4->5->6
            let h = Solution().mergeKLists5([h1, h2, h3])
            h?.show()
        }

        do {
            let h1 = ListNode.linkedList([-2,-2])
            let h2 = ListNode.linkedList([-3])
            // -3-->-2-->-2
            let h = Solution().mergeKLists5([h1, h2])
            h?.show()
        }
    }
        
    
}
