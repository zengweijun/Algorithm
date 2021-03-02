//
//  main.swift
//  _300_最长上升子序列
//
//  Created by nius on 2020/3/24.
//  Copyright © 2020 nius. All rights reserved.
//

import Foundation

/*
 给定一个无序的整数数组，找到其中最长上升子序列的长度。

 示例:

 输入: [10,9,2,5,3,7,101,18]
 输出: 4
 解释: 最长的上升子序列是 [2,3,7,101]，它的长度是 4。
 说明:

 可能会有多种最长上升子序列的组合，你只需要输出对应的长度即可。
 你算法的时间复杂度应该为 O(n2) 。
 进阶: 你能将算法的时间复杂度降低到 O(n log n) 吗?

 来源：力扣（LeetCode）
 链接：https://leetcode-cn.com/problems/longest-increasing-subsequence
 */

class Solution {
    func lengthOfLIS1(_ nums: [Int]) -> Int {
        // 时间：O(n^2)，空间：O(n)
        // dp[i] 为以nums[i]结尾的最长上升子序列的长度
        // 状态转移：dp[i] = max{ dp[j] },  j ∈ [0, i)
        if nums.count == 0 { return 0 }
        
        var maxans = 1
        var dp = [Int](repeating: 0, count: nums.count)
        dp[0] = 1
        for i in 1..<nums.count {
            var tmpMaxans = 0
            for j in 0..<i {
                if nums[i] > nums[j] { // 有比它还小的数值，取出那个对应的dp值，并综合看最大一个
                    tmpMaxans = max(tmpMaxans, dp[j])
                }
            }
            dp[i] = tmpMaxans + 1
            maxans = max(maxans, dp[i])
        }
        return maxans
    }
    
    func lengthOfLIS2(_ nums: [Int]) -> Int {
        // 时间：O(n * logn)，空间：O(n)
        https://leetcode-cn.com/problems/longest-increasing-subsequence/solution/dong-tai-gui-hua-er-fen-cha-zhao-tan-xin-suan-fa-p/
        // 使用一个tail数组，tail第i个位置存储长度为i+1的元素值，并且要使得该值尽量小，以利于后边接上更小的值获取更大的长度
        // 当需要查找某一个值value能链接的前缀时，只需要二分搜索tail数组即可
        if nums.count == 0 { return 0 }
        
        // tail 数组的定义：长度为 i + 1 的上升子序列的末尾最小是几
        var tail = [Int](repeating: 0, count: nums.count)
        // end 表示有序数组 tail 中目前所有赋值过元素的长度
        
        // 特殊处理首位
        // 直接将第一个元素结尾的最长上升子序列定义为1，并放在 tail 头部
        tail[0] = nums[0]
        
        var end = 0
        for i in 1..<nums.count { // O(n)
            // 去tail中搜索大于它nums[i]的值所处的位置（二分搜索）
            // [left, right) 半开闭区间
            var left = 0
            var right = end + 1
            while left < right { // O(logn)
                let mid = (left + right) >> 1
                if nums[i] > tail[mid] {
                    left = mid + 1
                } else {
                    right = mid
                }
            }
            
            // 二分逻辑一定能找到第 1 个大于等于 nums[i] 的元素
            // 这里找到第一个比nums[i]大的值位置为begin，由于begin值比它更大的，因此这里无需判断
            // 既然原来left位置的值比它更大（或者没有），那将当前元素替换之（贪心）
            tail[left] = nums[i]
            
            // 如果当前赋值的元素已经是最后一个元素，则更新end
            if left == end + 1 {
                end += 1
            }
        }
        return end + 1 // 长度应该为 最后一个元素索引+1
    }
    
}

do {
   do {
        print(Solution().lengthOfLIS1([10,9,2,5,3,7,101,18])) // 4
        print(Solution().lengthOfLIS1([1,3,6,7,9,4,10,5,6]))  // 6
    }
    do {
        print(Solution().lengthOfLIS2([10,9,2,5,3,7,101,18])) // 4
        print(Solution().lengthOfLIS2([1,3,6,7,9,4,10,5,6]))  // 6
    }
}

