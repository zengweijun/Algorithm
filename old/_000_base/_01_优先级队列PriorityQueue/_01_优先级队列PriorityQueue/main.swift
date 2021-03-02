//
//  main.swift
//  _01_优先级队列PriorityQueue
//
//  Created by nius on 2020/3/6.
//  Copyright © 2020 nius. All rights reserved.
//

import Foundation

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

do {
    var nums = [1, 2, 8, 3, 5, 3, 2, 0]
    var p = PriorityQueue(nums: nums, minHeap: false)
    
    while !p.isEmpty() {
        print(p.poll())
    }
}

