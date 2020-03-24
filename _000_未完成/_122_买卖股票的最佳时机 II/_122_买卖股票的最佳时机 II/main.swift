//
//  main.swift
//  _122_买卖股票的最佳时机 II
//
//  Created by nius on 2020/3/24.
//  Copyright © 2020 nius. All rights reserved.
//

import Foundation

/*
 给定一个数组，它的第 i 个元素是一支给定股票第 i 天的价格。

 设计一个算法来计算你所能获取的最大利润。你可以尽可能地完成更多的交易（多次买卖一支股票）。

 注意：你不能同时参与多笔交易（你必须在再次购买前出售掉之前的股票）。

 示例 1:

 输入: [7,1,5,3,6,4]
 输出: 7
 解释: 在第 2 天（股票价格 = 1）的时候买入，在第 3 天（股票价格 = 5）的时候卖出, 这笔交易所能获得利润 = 5-1 = 4 。
      随后，在第 4 天（股票价格 = 3）的时候买入，在第 5 天（股票价格 = 6）的时候卖出, 这笔交易所能获得利润 = 6-3 = 3 。
 示例 2:

 输入: [1,2,3,4,5]
 输出: 4
 解释: 在第 1 天（股票价格 = 1）的时候买入，在第 5 天 （股票价格 = 5）的时候卖出, 这笔交易所能获得利润 = 5-1 = 4 。
      注意你不能在第 1 天和第 2 天接连购买股票，之后再将它们卖出。
      因为这样属于同时参与了多笔交易，你必须在再次购买前出售掉之前的股票。
 示例 3:

 输入: [7,6,4,3,1]
 输出: 0
 解释: 在这种情况下, 没有交易完成, 所以最大利润为 0。

 来源：力扣（LeetCode）
 链接：https://leetcode-cn.com/problems/best-time-to-buy-and-sell-stock-ii
 */

class Solution {
    
    func maxProfit1(_ prices: [Int]) -> Int {
        // 某个点买入，如果发现股票一直涨就不卖，如果发现跌就卖掉之前的，修改买入点为当前跌的位置
        if prices.count < 2 { return 0 }
        
        var hold = false        // 是否持有
        var buyPointValue = 0   // 买入点价格
        
        var preValue = prices[0] // 相邻上一个价格
        var maxProfit = 0        // 最大利润
        
        for i in 1..<prices.count {
            if preValue < prices[i] {
                // 涨，如昨天没有买，补买
                if hold == false {
                    buyPointValue = preValue
                    hold = true
                }
            } else {
                // 跌，卖掉跌之前的
                if hold {
                    maxProfit += preValue - buyPointValue
                    hold = false
                }
            }
            preValue = prices[i]
        }
        
        // 如果循环结束，仍然持有，比如[1,2,3,4,5]，在这里卖掉
        if hold {
            maxProfit += preValue - buyPointValue
        }
        
        return maxProfit
    }
    
    func maxProfit2(_ prices: [Int]) -> Int {
        // 涨就买入，跌就卖出，画出趋势图可以看出，只要是涨的利润都可以全部获得
        if prices.count < 2 { return 0 }
        
        var maxProfit = 0
        for i in 1..<prices.count {
            if prices[i] > prices[i-1] { // 涨，或利润
                maxProfit += prices[i] - prices[i-1]
            } else {
                // 跌/持平，卖出
            }
        }
        return maxProfit
    }
}


do {
    do {
        print(Solution().maxProfit1([7,1,5,3,6,4]))
        print(Solution().maxProfit1([1,2,3,4,5]))
        print(Solution().maxProfit1([7,6,4,3,1]))
    }
    do {
        print(Solution().maxProfit2([7,1,5,3,6,4]))
        print(Solution().maxProfit2([1,2,3,4,5]))
        print(Solution().maxProfit2([7,6,4,3,1]))
    }
}
