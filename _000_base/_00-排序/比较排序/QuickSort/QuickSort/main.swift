//
//  main.swift
//  QuickSort
//
//  Created by nius on 2020/3/5.
//  Copyright © 2020 nius. All rights reserved.
//

import Foundation

/**
 快速排序
 https://blog.csdn.net/qq_40941722/article/details/94396010
 */

class Solution {
    // 最好坏时间复杂度：O(n^2)，平均时间复杂度：O(n*logn)
    func quickSort(_ nums: inout [Int]) -> [Int] {
        // [begin, end)
        @discardableResult func quickSort(_ nums: inout [Int], _ begin: Int, _ end: Int) -> [Int] {
            // 总体思路：
            // 1、选定轴点（通常选第一个begin）
            //  ①然后让从右边开始扫描（选左边就从右边开始扫，反之亦然），直到找到第一个小于轴点的元素
            //  ②从左边开始扫描，直到直到第一个大于轴点的点
            //  ③交换这两个点
            //  继续①②③，直到左右两个指针相遇，此时将这个位置与轴点位置进行交换
            //  得到的结果是该店左边的都比它小，右边的都比它大，数组被分为两个区
            // 2.分别对左右两个区实行上述递归
            // 参考:https://blog.csdn.net/qq_40941722/article/details/94396010
            
            // [begin, end)
            if end - begin < 2 { // 元素数量小于2，无需再排
                return nums
            }
            
            let pivotValue = nums[begin]
            var left = begin
            var right = end - 1 // 半开闭区间
            while left < right {
                while left < right && nums[right] >= pivotValue {
                    // 从后往前找，直到直到一个比轴点更小的元素
                    right -= 1
                }
                while left < right && nums[left] <= pivotValue {
                    // 从前往后找，直到直到一个比轴点更大的元素
                    left += 1
                }
                
                // 来到这里，要么已经找到满足条件的两个元素，要么此时已经相遇（left==right）
                // 如果找到了满足条件的两个元素则交换
                if left == right { // 与轴点交换
                    nums[begin] = nums[left]
                    nums[left] = pivotValue
                } else { // 互相交换
                    let tmp = nums[left]
                    nums[left] = nums[right]
                    nums[right] = tmp
                }
            }
            
            quickSort(&nums, begin, left)
            quickSort(&nums, left + 1, right)
            return nums
        }
        
        let nums = quickSort(&nums, 0, nums.count)
        return nums
    }
}

do {
    var nums = [9, -2, 1, 1, 7]
    print(nums)
    print(Solution().quickSort(&nums))
}
