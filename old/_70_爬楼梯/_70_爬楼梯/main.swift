//
//  main.swift
//  _70_爬楼梯
//
//  Created by nius on 2020/3/24.
//  Copyright © 2020 nius. All rights reserved.
//

import Foundation

/*
 假设你正在爬楼梯。需要 n 阶你才能到达楼顶。

 每次你可以爬 1 或 2 个台阶。你有多少种不同的方法可以爬到楼顶呢？

 注意：给定 n 是一个正整数。

 示例 1：

 输入： 2
 输出： 2
 解释： 有两种方法可以爬到楼顶。
 1.  1 阶 + 1 阶
 2.  2 阶
 示例 2：

 输入： 3
 输出： 3
 解释： 有三种方法可以爬到楼顶。
 1.  1 阶 + 1 阶 + 1 阶
 2.  1 阶 + 2 阶
 3.  2 阶 + 1 阶

 来源：力扣（LeetCode）
 链接：https://leetcode-cn.com/problems/climbing-stairs
 */

class Solution {
    
    // 时间O(n) 空间O(n)
    func climbStairs(_ n: Int) -> Int {
        // 动态规划解法
        // dp[i]为到i阶的所有爬法，到i仅有两种可能 ①从i-1阶爬一步到达 ②从i-2阶爬两部到达
        // 因此 dp[i] = dp[i-1] + dp[i-2] 两种可能之和
        if n < 3 { return n }
        var dp = [Int](repeating: 0, count: n + 1)
        dp[1] = 1
        dp[2] = 2
        
        for i in 3...n {
            dp[i] = dp[i-1] + dp[i-2]
        }
        
        return dp[n]
    }
    
    // 时间O(n) 空间O(1)
    func climbStairs1(_ n: Int) -> Int {
        // 动态规划解法
        // dp[i]为到i阶的所有爬法，到i仅有两种可能 ①从i-1阶爬一步到达 ②从i-2阶爬两部到达
        // 因此 dp[i] = dp[i-1] + dp[i-2] 两种可能之和
        if n < 3 { return n }
        var prePre = 1
        var pre = 2
        for _ in 3...n {
            let lastPre = pre
            pre = pre + prePre
            prePre = lastPre
        }
        
        return pre
    }
}



do {
    do {
        // 斐波拉契数列
        print(Solution().climbStairs(1))
        print(Solution().climbStairs(2))
        print(Solution().climbStairs(3))
        print(Solution().climbStairs(4))
        print(Solution().climbStairs(5))
        print(Solution().climbStairs(6))
    }
    do {
        // 斐波拉契数列
        print(Solution().climbStairs1(1))
        print(Solution().climbStairs1(2))
        print(Solution().climbStairs1(3))
        print(Solution().climbStairs1(4))
        print(Solution().climbStairs1(5))
        print(Solution().climbStairs1(6))
    }
}


























