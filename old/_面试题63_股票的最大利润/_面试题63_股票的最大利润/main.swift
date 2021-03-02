//
//  main.swift
//  _面试题63_股票的最大利润
//
//  Created by nius on 2020/3/24.
//  Copyright © 2020 nius. All rights reserved.
//

import Foundation

/*
 假设把某股票的价格按照时间先后顺序存储在数组中，请问买卖该股票一次可能获得的最大利润是多少？

  

 示例 1:
 输入: [7,1,5,3,6,4]
 输出: 5
 解释: 在第 2 天（股票价格 = 1）的时候买入，在第 5 天（股票价格 = 6）的时候卖出，最大利润 = 6-1 = 5 。
      注意利润不能是 7-1 = 6, 因为卖出价格需要大于买入价格。
 
 示例 2:
 输入: [7,6,4,3,1]
 输出: 0
 解释: 在这种情况下, 没有交易完成, 所以最大利润为 0。
  

 限制：
 0 <= 数组长度 <= 10^5
  

 注意：本题与主站 121 题相同：https://leetcode-cn.com/problems/best-time-to-buy-and-sell-stock/

 来源：力扣（LeetCode）
 链接：https://leetcode-cn.com/problems/gu-piao-de-zui-da-li-run-lcof
 */

class Solution {
    // 使用一个指针来标记，在i之前能够买入的最低价格 O(n)
    func maxProfit1(_ prices: [Int]) -> Int {
        if (prices.count < 2) { return 0 }
        
        // 之前能够买入的最低价格，默认为第一天
        // 注意：第一天不能卖，因为之前没有买入
        var preCanBuyMinValue = prices[0]
        
        // 最大利润，开始默认为0，因为第一天只能买，不能卖
        var maxProfit = 0
        
        for i in 1..<prices.count {
            if prices[i] > preCanBuyMinValue {
                // 当前价格大于之前买入的最低价格，可以卖出，卖出后更新当前最大利润
                maxProfit = max(maxProfit, prices[i] - preCanBuyMinValue)
            } else {
                // 当前价格小于之前买入的最低价格，不应该卖出，而且应该讲当前价格更新为目前为止能够买入的最低价格
                preCanBuyMinValue = prices[i]
            }
        }
        
        return maxProfit
    }
    
    
    // 动态规划大法 O(n)
    func maxProfit2(_ prices: [Int]) -> Int {
        // 第 i 天买入，第 j 天卖出， [i, j] 区间总利润为 区间内两两相邻两天的价格差 全部加和
        // 如 [1, 3, 1, 5] 段利润，(3-1) + (1-3) + (5-1) = 4
        
        // 对于 [7, 1, 5, 3, 6, 4]，两两相邻两天的价格差为 [-6, 4, -2, 3, -2]
        // 如果在第一天7买入，最后一天4卖出，能获取的总利润为：(-6) + 4 + (-2) + 3 + (-2) = -3
        // 如果在第二天1买入，倒数第二天6卖出，能够获取总利润为：4 + (-2) + 3 = 5
        // 也就是说，要在这个价格差数组中找出能加和得到最大值得那一段，这样问题就转化为求取数组最大连续子序列和的问题
        
        // 最大连续子序列和可以使用动态规划思路解决 dp[i]为以i结尾的连续最大子序列之和
        // 1.先求出相邻两天的价格差数组(也就是每个相邻两天利润数组)
        if (prices.count < 2) { return 0 }
        var profits = [Int](repeating: 0, count: prices.count-1)
        for i in 0..<prices.count-1 {
            profits.append(prices[i+1] - prices[i])
        }
        
        // 2.求dp
        /* [-6, 4, -2, 3, -2]
        dp [-6, 4, 2, 5, 3] 到达dp[i]的时候，如果dp[i-1]>0就接上，否则就只包括自己
         */
        var dp = [Int](repeating: 0, count: profits.count)
        dp[0] = profits[0]
        
        var maxProfit = max(0, dp[0])
        for i in 1..<profits.count {
            let profit = profits[i]
            if dp[i-1] > 0 {
                dp[i] = profit + dp[i-1]
            } else {
                dp[i] = profit
            }
            maxProfit = max(maxProfit, dp[i])
        }
        return maxProfit
    }
    
    // 动态规划大法(优化，去掉一维数组) O(n)
    func maxProfit3(_ prices: [Int]) -> Int {
        // 第 i 天买入，第 j 天卖出， [i, j] 区间总利润为 区间内两两相邻两天的价格差 全部加和
        // 如 [1, 3, 1, 5] 段利润，(3-1) + (1-3) + (5-1) = 4
        
        // 对于 [7, 1, 5, 3, 6, 4]，两两相邻两天的价格差为 [-6, 4, -2, 3, -2]
        // 如果在第一天7买入，最后一天4卖出，能获取的总利润为：(-6) + 4 + (-2) + 3 + (-2) = -3
        // 如果在第二天1买入，倒数第二天6卖出，能够获取总利润为：4 + (-2) + 3 = 5
        // 也就是说，要在这个价格差数组中找出能加和得到最大值得那一段，这样问题就转化为求取数组最大连续子序列和的问题
        
        // 最大连续子序列和可以使用动态规划思路解决 dp[i]为以i结尾的连续最大子序列之和
        // 1.先求出相邻两天的价格差数组(也就是每个相邻两天利润数组)
        if (prices.count < 2) { return 0 }
        var profits = [Int](repeating: 0, count: prices.count-1)
        for i in 0..<prices.count-1 {
            profits.append(prices[i+1] - prices[i])
        }
        
        // 2.求dp
        /* [-6, 4, -2, 3, -2]
        dp [-6, 4, 2, 5, 3] 到达dp[i]的时候，如果dp[i-1]>0就接上，否则就只包括自己
         
         观察发现，我们每次只用到上一个最大dp,这里我们使用一个临时空间记录替代数组，记录上一个dp值即可
         */
        var dpValue = profits[0]
        
        var maxProfit = max(0, dpValue)
        for i in 1..<profits.count {
            let profit = profits[i]
            if dpValue > 0 {
                dpValue = profit + dpValue
            } else {
                dpValue = profit
            }
            maxProfit = max(maxProfit, dpValue)
        }
        return maxProfit
    }
}

