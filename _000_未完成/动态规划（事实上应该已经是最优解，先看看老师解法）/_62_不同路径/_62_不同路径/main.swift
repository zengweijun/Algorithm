//
//  main.swift
//  _62_不同路径
//
//  Created by nius on 2020/3/14.
//  Copyright © 2020 nius. All rights reserved.
//

import Foundation

/*
 一个机器人位于一个 m x n 网格的左上角 （起始点在下图中标记为“Start” ）。

 机器人每次只能向下或者向右移动一步。机器人试图达到网格的右下角（在下图中标记为“Finish”）。

 问总共有多少条不同的路径？



 例如，上图是一个7 x 3 的网格。有多少可能的路径？

  

 示例 1:

 输入: m = 3, n = 2
 输出: 3
 解释:
 从左上角开始，总共有 3 条路径可以到达右下角。
 1. 向右 -> 向右 -> 向下
 2. 向右 -> 向下 -> 向右
 3. 向下 -> 向右 -> 向右
 示例 2:

 输入: m = 7, n = 3
 输出: 28
  

 提示：

 1 <= m, n <= 100
 题目数据保证答案小于等于 2 * 10 ^ 9

 来源：力扣（LeetCode）
 链接：https://leetcode-cn.com/problems/unique-paths
 */


class Solution {
    
    // MARK: - 使用dp二维数组
    func uniquePaths1(_ m: Int, _ n: Int) -> Int {
        /* 这个其实也是一个球最值题目，涉及到求最值，优先考虑是否可以使用动态规划 dp 解决，不行再考虑其他
           这里可以看成是一个二维数组(矩阵)，要求某一个位置[row][col]的最大可能路径数量
           由于知道路径只能是向右或者向下，因此该路径只能从[row-1][col]或者[row][col-1]这两个格子过来
           要求[row][col]位置最大可能路径数量，则需要先知道[row-1][col]和[row][col-1]的最大可能路径数
         
         设置[row][col]位置最大可能路径数量 dp[row][col]
         因为到[row][col]位置只有两种走法，要么从上边位置[row-1][col]来，要么从左边位置[row][col-1]来
         所以因为到[row][col]的所有可能即为 到[row-1][col](上边)所有可能 + 到[row][col-1](左边)所有可能
         状态转移方程为 db[row][col] = db[row-1][col] + db[row][col-1]
         路径节点矩阵                         dp 从右上角其到每个节点最大可能的路径数
         [11] [12] [13] [14] [15]           [0] [1] [1] [1]  [1]
         [21] [22] [23] [24] [25]           [1] [2] [3] [4]  [5]
         [31] [32] [33] [34] [35]           [1] [3] [6] [10] [15]
        */
        
        // 前置条件判断
        // 由于 1 <= m, n <= 100，即不会存在 m, n == 0的情况
        let cols = m
        let rows = n
        
        // 创建 dp 二维数组，记录每一个位置 db[row][col] 的最小值
        var dp = [[Int]](repeating: [Int](repeating: 0, count: cols), count: rows)
        
        // 初始化
        // 由于只能每次向左或向下移动，一次第一列和第一行只能单向移动，可求得dp第一列和第一行所有值
        dp[0][0] = 1
        for row in 1..<rows { //  dp[0][0] 位置已经有值
            dp[row][0] = 1
        }
        //print(dp)
        for col in 1..<cols { //  dp[0][0] 位置已经有值
            dp[0][col] = 1
        }
        //print(dp)
        
        for row in 1..<rows {
            for col in 1..<cols {
                dp[row][col] = dp[row-1][col] + dp[row][col-1]
            }
        }
        return dp[rows - 1][cols - 1]
    }
    
    // MARK: - 使用dp思想，但用一维数组
    // 事实上每一步骤都只需要用到两个值，即上边和左边。如果我们每次都从上到下，从左到右的求值
    // 那只需要知道上一列的值即可，求得左边的值记录一下，推导出右边的值
    func uniquePaths2(_ m: Int, _ n: Int) -> Int {
        /* 这个其实也是一个球最值题目，涉及到求最值，优先考虑是否可以使用动态规划 dp 解决，不行再考虑其他
           这里可以看成是一个二维数组(矩阵)，要求某一个位置[row][col]的最大可能路径数量
           由于知道路径只能是向右或者向下，因此该路径只能从[row-1][col]或者[row][col-1]这两个格子过来
           要求[row][col]位置最大可能路径数量，则需要先知道[row-1][col]和[row][col-1]的最大可能路径数
         
         设置[row][col]位置最大可能路径数量 dp[row][col]
         因为到[row][col]位置只有两种走法，要么从上边位置[row-1][col]来，要么从左边位置[row][col-1]来
         所以因为到[row][col]的所有可能即为 到[row-1][col](上边)所有可能 + 到[row][col-1](左边)所有可能
         状态转移方程为 db[row][col] = db[row-1][col] + db[row][col-1]
         路径节点矩阵                         dp 从右上角其到每个节点最大可能的路径数
         [11] [12] [13] [14] [15]           [1] [1] [1] [1]  [1]
         [21] [22] [23] [24] [25]           [1] [2] [3] [4]  [5]
         [31] [32] [33] [34] [35]           [1] [3] [6] [10] [15]
        */
        
        // 前置条件判断
        // 由于 1 <= m, n <= 100，即不会存在 m, n == 0的情况
        let cols = m
        let rows = n
        
        // dp 思想，但是不是用二维数组，因为每次我们其实值使用到了左边和上边一个值
        /* 每一行的最小值
         这个rowMinValues事实上，rc位置左边装这当前行的值（覆盖），右边装上一行的值
                  1   1
         1  2  3  rc
         */
        var rowMaxValues = [Int](repeating: 1, count: cols) // 默认为第一行（第0行的值）,全是1
        for _ in 1..<rows { // 第0行上边已经默认为1
            for col in 1..<cols {
                // 第0列也默认1，由于rowMaxValues[0]的位置初始化为1，且永远不会被修改，之后每一行都会以1来复用
                let topMax = rowMaxValues[col]
                let leftMax = rowMaxValues[col - 1]
                rowMaxValues[col] = topMax + leftMax
            }
        }
        return rowMaxValues[cols - 1]
    }
}


do {
    do {
        print("3 x 2 --> 3  ", Solution().uniquePaths1(3, 2))
        print("7 x 3 --> 28 ", Solution().uniquePaths1(7, 3))
    }
    print("-----------------------")
    do {
        print("3 x 2 --> 3  ", Solution().uniquePaths2(3, 2))
        print("7 x 3 --> 28 ", Solution().uniquePaths2(7, 3))
    }
}


