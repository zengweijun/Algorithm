//
//  main.swift
//  _164_最大间距
//
//  Created by 曾维俊 on 2020/2/29.
//  Copyright © 2020 Nius. All rights reserved.
//

import Foundation

/**
 给定一个无序的数组，找出数组在排序之后，相邻元素之间最大的差值。
 如果数组元素个数小于 2，则返回 0。

 示例 1:

 输入: [3,6,9,1]
 输出: 3
 解释: 排序后的数组是 [1,3,6,9], 其中相邻元素 (3,6) 和 (6,9) 之间都存在最大差值 3。
 示例 2:

 输入: [10]
 输出: 0
 解释: 数组元素个数小于 2，因此返回 0。
 
 说明:
 你可以假设数组中所有元素都是非负整数，且数值在 32 位有符号整数范围内。
 请尝试在线性时间复杂度和空间复杂度的条件下解决此问题。

 来源：力扣（LeetCode）
 链接：https://leetcode-cn.com/problems/maximum-gap
 */

class Solution {
    func maximumGap1(_ nums: [Int]) -> Int {
        // 暴力解法，先排序，再遍历计算
        let count = nums.count
        guard count >= 2 else { return 0 }
        
        // 1.快速排序 O(n * logn)
        // [begin, end)
        func quickSort(_ nums: inout [Int], _ begin: Int, _ end: Int) -> Void {
            guard end - begin >= 2 else { return }
            
            let pivodValue = nums[begin]
            var left = begin
            var right = end - 1
            while left < right {
                while left < right && nums[right] >= pivodValue { right -= 1 }
                while left < right && nums[left] <= pivodValue { left += 1 }
                if left == right {
                    nums[begin] = nums[left]
                    nums[left] = pivodValue
                } else {
                    let tmp = nums[left]
                    nums[left] = nums[right]
                    nums[right] = tmp
                }
            }
            quickSort(&nums, begin, left)    // [begin, left)
            quickSort(&nums, left + 1, end)  // [left + 1, end)
        }
        
        var nums = nums // Copy on Write
        quickSort(&nums, 0, nums.count)
        
        // 2.计算结果 O(n)
        var maxGap = 0
        for i in 0..<(nums.count - 1) {
            let gap = nums[i+1] - nums[i]
            if gap > maxGap {
                maxGap = gap
            }
        }
        return maxGap
    }
    
    
    func maximumGap2(_ nums: [Int]) -> Int {
        let count = nums.count
        guard count > 2 else { return 0 }
        
        // 请尝试在线性时间复杂度和空间复杂度的条件下解决此问题。
        // 时间：O(n)  空间：O(n)
        
        
        
        
        
        
        

        return 1
    }
}

do{
    print(Solution().maximumGap1([3,6,9,1]))
    print(Solution().maximumGap1([10]))
    print(Solution().maximumGap1([1,10000000]))
    print(Solution().maximumGap1([100,3,2,1]))

}

