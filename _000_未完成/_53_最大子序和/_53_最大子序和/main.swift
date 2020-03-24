//
//  main.swift
//  _53_最大子序和
//
//  Created by nius on 2020/3/24.
//  Copyright © 2020 nius. All rights reserved.
//

import Foundation

/*
 给定一个整数数组 nums ，找到一个具有最大和的连续子数组（子数组最少包含一个元素），返回其最大和。

 示例:
 输入: [-2,1,-3,4,-1,2,1,-5,4],
 输出: 6
 解释: 连续子数组 [4,-1,2,1] 的和最大，为 6。
 
 进阶:
 如果你已经实现复杂度为 O(n) 的解法，尝试使用更为精妙的分治法求解。

 来源：力扣（LeetCode）
 链接：https://leetcode-cn.com/problems/maximum-subarray
 */

class Solution {
    // 动态规划
    func maxSubArray1(_ nums: [Int]) -> Int {
        // dp[i]为以i结尾的最大连续子序列和
        // dp[i]检查，dp[i-1]>0 则接上，否则单独成为一个子序列
        if (nums.count == 0) { return 0 }
        var dp = [Int](repeating: 0, count: nums.count)
        dp[0] = nums[0]
        
        var maxValue = dp[0]
        for i in 1..<nums.count {
            dp[i] = max(dp[i-1], 0) + nums[i]
            maxValue = max(maxValue, dp[i])
        }
        return maxValue
    }
    
    // 动态规划(去掉一维数组)
    func maxSubArray2(_ nums: [Int]) -> Int {
        // dp[i]为以i结尾的最大连续子序列和
        // dp[i]检查，dp[i-1]>0 则接上，否则单独成为一个子序列
        if (nums.count == 0) { return 0 }
        var dp = nums[0]
        var maxValue = dp
        for i in 1..<nums.count {
            dp = max(dp, 0) + nums[i]
            maxValue = max(maxValue, dp)
        }
        return maxValue
    }
}

do{
    do {
        print(Solution().maxSubArray1([-2,1,-3,4,-1,2,1,-5,4]))
        print(Solution().maxSubArray2([-2,1,-3,4,-1,2,1,-5,4]))
    }
}
