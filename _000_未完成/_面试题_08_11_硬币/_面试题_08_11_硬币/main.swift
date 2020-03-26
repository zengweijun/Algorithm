//
//  main.swift
//  _面试题_08_11_硬币
//
//  Created by nius on 2020/3/24.
//  Copyright © 2020 nius. All rights reserved.
//

import Foundation

/*
 硬币。给定数量不限的硬币，币值为25分、10分、5分和1分，编写代码计算n分有几种表示法。(结果可能会很大，你需要将结果模上1000000007)

 示例1:
  输入: n = 5
  输出：2
  解释: 有两种方式可以凑成总金额:
 5=5
 5=1+1+1+1+1

 示例2:
  输入: n = 10
  输出：4
  解释: 有四种方式可以凑成总金额:
 10=10
 10=5+5
 10=5+1+1+1+1+1
 10=1+1+1+1+1+1+1+1+1+1

 说明：

 注意:
 你可以假设：

 0 <= n (总金额) <= 1000000

 来源：力扣（LeetCode）
 链接：https://leetcode-cn.com/problems/coin-lcci
 */

class Solution {
    func waysToChange(_ n: Int) -> Int {
        // let coins = [1, 5, 10, 25]
        // dp[i]表示n分钱的所有可能
        /* [1, 5, 10, 25]
         dp[i][j]：取i个硬币，构成金额j的种数
         每当遍历到一个硬币时，有两种情况：①取当前硬币 dp[i][j]
         
         筹够1：取1的时候1种，不取1的时候0中，总数为
         */
        let coins = [1, 5, 10, 25]
        var dp = [Int](repeating: 0, count: n+1)
        dp[0] = 1
        dp[1] = 1
        for i in 1...n {
            var count = 0
            for coin in coins {
                if coin <= i {
                    count += dp[i - coin]
                }
            }
            dp[i] = count
        }
        return dp[n]
    }
}


do {
    do {
        print(Solution().waysToChange(5))
        print(Solution().waysToChange(10))
    }
}
