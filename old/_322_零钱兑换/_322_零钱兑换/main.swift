//
//  main.swift
//  _322_零钱兑换
//
//  Created by nius on 2020/3/24.
//  Copyright © 2020 nius. All rights reserved.
//

import Foundation

/*
 给定不同面额的硬币 coins 和一个总金额 amount。编写一个函数来计算可以凑成总金额所需的最少的硬币个数。如果没有任何一种硬币组合能组成总金额，返回 -1。

 示例 1:
 输入: coins = [1, 2, 5], amount = 11
 输出: 3
 解释: 11 = 5 + 5 + 1

 示例 2:
 输入: coins = [2], amount = 3
 输出: -1
 说明:
 你可以认为每种硬币的数量是无限的。

 来源：力扣（LeetCode）
 链接：https://leetcode-cn.com/problems/coin-change
 */

class Solution {
    func coinChange(_ coins: [Int], _ amount: Int) -> Int {
        // dp[i]为筹够能够凑够i金额的钱，所需要的最少硬币数
        /* 如果面值为 [1, 2, 5]
         如果最后一次拿的硬币为1，则dp[i] = 1 + dp[i-1]，从i-1时拿1凑到i
         如果最后一次拿的硬币为2，则dp[i] = 1 + dp[i-2]，从i-2时拿2凑到i
         如果最后一次拿的硬币为5，则dp[i] = 1 + dp[i-5]，从i-5时拿5凑到i
         要办到最小：dp[i] = 1 + min{dp[i-1], dp[i-2], dp[i-5]}
         */
        if amount < 1 { return 0 }
        if coins.count == 0 { return -1 }
        var dp = [Int](repeating: 0, count: amount+1)
        // 初始化所有面值的最小值，因为面值对应的金额直接拿当前面值即可
        for i in 1...amount {
            var min = Int.max
            for coin in coins {
                // i >= coin: 面值小于等于金额的时候才继续
                // dp[i - coin] < 0(就是-1): i - coin金额没有凑到，也就不可能用它来凑当前金额 i
                // min > dp[i - coin]: min记录的是dp[i - coin]的最小值
                if i >= coin && dp[i - coin] >= 0 && min > dp[i - coin] {
                    min = dp[i - coin]
                }
            }
            
            if min == Int.max {
                dp[i] = -1
            } else {
                dp[i] = min + 1
            }
        }
        
        return dp[amount]
    }
}

do {
    do {
        print(Solution().coinChange([1, 2, 5], 11))
        print(Solution().coinChange([2], 3))
        print(Solution().coinChange([1], 0))
        print(Solution().coinChange([1,2], 2))
    }
}
