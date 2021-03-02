//
//  main.swift
//  CountingSort
//
//  Created by nius on 2020/3/5.
//  Copyright © 2020 nius. All rights reserved.
//

import Foundation

class Solution {
    // 计数排序缺点
    // 1、不能排序小数
    // 2、如果差值过大，如[1, 100000000, 3]，浪费空间的同时，也增加了时间复杂度
    // 因此需要在特定场合下使用
    func countingSort1(_ nums: inout [Int]) -> [Int] {
        // 时间复杂度为O(n)，但是空间复杂度非常高，极有可能造成大量空间的浪费
        // 而且不支持负数
        var max = nums[0]
        for i in stride(from: 1, to: nums.count, by: 1) {
            if max < nums[i] {
                max = nums[i]
            }
        }
        
        // 比如最大数为100，需要的区间为[0, 100]，100 + 1个空间
        var counts = [Int](repeating: 0, count: max + 1)
        for i in stride(from: 0, to: nums.count, by: 1) {
            counts[nums[i]] += 1
        }
        
        var index = 0
        for i in stride(from: 0, to: counts.count, by: 1) {
            for _ in stride(from: 0, to: counts[i], by: 1) {
                nums[index] = i
                index += 1
            }
        }
        return nums
    }
    
    func countingSort2(_ nums: inout [Int]) -> [Int] {
        // 改进版本，主要针对空间优化(当然空间小了时间也有优化)
        // 参考： https://www.cnblogs.com/kyoner/p/10604781.html
        
        // 1.找到最大最小值，确定计数数组大小
        var max = nums[0]
        var min = nums[0]
        for i in stride(from: 1, to: nums.count, by: 1) {
            if max < nums[i] { max = nums[i] }
            if min > nums[i] { min = nums[i] }
        }
        
        // 2.统计原始数组中每个元素出现的次数
        var counts = [Int](repeating: 0, count: max - min + 1)
        for i in stride(from: 0, to: nums.count, by: 1) {
            let index = nums[i] - min // 索引是当前元素 - 最小元素
            counts[index] += 1
        }
        
        // 3.变形统计数组counts
        // 确定每个元素在最终排序数组中的位置，事实上只需要将比它小的元素的出现次数全部累加，就可以得到它在最终排序数组中的位置
        // 这里统计的时候会将当前元素本身的出现次数也加上，存储在对应位置，方便下个元素继续累加
        // 比如20之前的元素出现次数之和为5，加上它本身出现1次为6，则毫无疑问，排序后的20位置为 index = 6 - 1 = 5
        // 只需要从第1元素开始统计，第0个元素之前没有元素，它之前没有元素出现
        var sum = counts[0]
        for i in stride(from: 1, to: counts.count, by: 1) {
            sum += counts[i]
            counts[i] = sum
            
            // 也可以使用下边简写，不适用sum变量
            // 当前累计次数 = 当前出现次数 + 上一个累计次数
            // counts[i] += counts[i - 1]
        }
        
        // 4.遍历原始数组
        // 经过3可以确定元素在排好序后数组中的位置，这里我直接逆序遍历原始数组，确保算法稳定性
        var sortedArray = [Int](repeating: 0, count: nums.count)
        for i in stride(from: nums.count - 1, to: -1, by: -1) {
            // 该元素counts数组中的统计位置
            let countIndex = nums[i] - min
            // 当前统计累计次数 - 1得到当前元素排序位置，同时更新该次数（减少1，下一次出现同样元素就放在当前元素之前）
            counts[countIndex] -= 1
            let sortedIndex = counts[countIndex]
            sortedArray[sortedIndex] = nums[i]
        }
        return sortedArray
    }
}

do {
    // 计数排序缺点
    // 1、不能排序小数
    // 2、如果差值过大，如[1, 100000000, 3]，浪费空间的同时，也增加了时间复杂度
    // 因此需要在特定场合下使用
    do { // 最初的版本
        var nums = [9, 0, 1, 1, 7]
        print(nums, " --> ", Solution().countingSort1(&nums))
    }
    do { // 改进版本（可以排序负数、稳定）
        var nums = [9, 0, -3, 1, 1, 7, -5]
        print(nums, " --> ", Solution().countingSort2(&nums))
    }
}




