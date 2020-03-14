//
//  main.swift
//  _64_最小路径和
//
//  Created by nius on 2020/3/14.
//  Copyright © 2020 nius. All rights reserved.
//

import Foundation

/**
 给定一个包含非负整数的 m x n 网格，请找出一条从左上角到右下角的路径，使得路径上的数字总和为最小。

 说明：每次只能向下或者向右移动一步。

 示例:
 输入:
 [
   [1,3,1],
   [1,5,1],
   [4,2,1]
 ]
 输出: 7
 解释: 因为路径 1→3→1→1→1 的总和最小。

 来源：力扣（LeetCode）
 链接：https://leetcode-cn.com/problems/minimum-path-sum
 */

class Solution {
    // MARK: - 使用dp二维数组
    func minPathSum(_ grid: [[Int]]) -> Int {
        /* 涉及到求最值，有限考虑是否可以使用动态规划 dp 解决，不行再考虑其他
           这里看出来是一个二维数组(矩阵)，要求某一个位置[row][col]的最小值
           由于知道路径只能是向右或者向下，因此该路径只能从[row-1][col]或者[row][col-1]这两个格子过来
           因此这两个格子中最小的哪一个，加上当前格子的值，就得到[row][col]的最小值
         所以：设置[row][col]位置的最小值为 dp[row][col]，则有
              状态转移方程为 db[row][col] = min(db[row-1][col], db[row][col-1]) + grid[row][col]
         grid                       dp
         [                          [
           [1,3,1],                   [1,4,5],
           [1,5,1],                   [2,7,6],
           [4,2,1]                    [6,8,7]
         ]                          ]
         */
        
        // 前置条件判断
        let rows = grid.count
        if (rows == 0) { return 0 }
        let cols = grid[0].count
        if (cols == 0) { return 0 }
        
        // 创建 dp 二维数组，记录每一个位置 db[row][col] 的最小值
        var dp = [[Int]](repeating: [Int](repeating: 0, count: cols), count: rows)
        
        // 初始化
        // 由于只能每次向左或向下移动，一次第一列和第一行只能单向移动，可求得dp第一列和第一行所有值
        dp[0][0] = grid[0][0]
        for row in 1..<rows { //  dp[0][0] 位置已经有值
            dp[row][0] = dp[row - 1][0] + grid[row][0]
        }
        //print(dp)
        for col in 1..<cols { //  dp[0][0] 位置已经有值
            dp[0][col] = dp[0][col - 1] + grid[0][col]
        }
        //print(dp)
        
        for row in 1..<rows {
            for col in 1..<cols {
                dp[row][col] = min(dp[row-1][col], dp[row][col-1]) + grid[row][col]
            }
        }
        return dp[rows - 1][cols - 1]
    }
    
    // MARK: - 使用dp思想，但用一维数组
    // 事实上每一步骤都只需要用到两个值，即上边和左边。如果我们每次都从上到下，从左到右的求值
    // 那只需要知道上一列的值即可，求得左边的值记录一下，推导出右边的值
    func minPathSum1(_ grid: [[Int]]) -> Int {
        /* 涉及到求最值，有限考虑是否可以使用动态规划 dp 解决，不行再考虑其他
           这里看出来是一个二维数组(矩阵)，要求某一个位置[row][col]的最小值
           由于知道路径只能是向右或者向下，因此该路径只能从[row-1][col]或者[row][col-1]这两个格子过来
           因此这两个格子中最小的哪一个，加上当前格子的值，就得到[row][col]的最小值
         所以：设置[row][col]位置的最小值为 dp[row][col]，则有
              状态转移方程为 db[row][col] = min(db[row-1][col], db[row][col-1]) + grid[row][col]
         grid                       dp
         [                          [
           [1,3,1],                   [1,4,5],
           [1,5,1],                   [2,7,6],
           [4,2,1]                    [6,8,7]
         ]                          ]
         */
        
        
        let rows = grid.count    // 行数
        //if (rows == 0) { return 0 } // 经测试，LeetCode没有空矩阵案例
        let cols = grid[0].count // 列数
        //if (cols == 0) { return 0 } // 经测试，LeetCode没有空矩阵案例
        
        /* 每一行的最小值
         这个rowMinValues事实上，rc位置左边装这当前行的值（覆盖），右边装上一行的值
            4   5
         2  rc
         */
        var rowMinValues = [Int](repeating: 0, count: cols)
        // 先计算出第1行(第0行)
        for col in 0..<cols {
            rowMinValues[col] = (col == 0 ? 0 : rowMinValues[col - 1]) + grid[0][col]
        }
        
        for row in 1..<rows { // 第0行上边已经计算
            for col in 0..<cols {
                // 第0列(0位置没有左边)，直接使用上边的值rowMinValues[col]
                // 其他情况，使用 min(rowMinValues[col - 1], rowMinValues[col])
                let topMin = rowMinValues[col]
                let leftMin = col == 0 ? topMin : rowMinValues[col - 1]
                rowMinValues[col] = min(leftMin, topMin) + grid[row][col]
            }
        }
        //print(rowMinValues)
        return rowMinValues[cols - 1]
    }
}

do {
    do {
        let grid = [
        [1, 3, 1],
        [1, 5, 1],
        [4, 2, 1]
        ]
        print(grid, Solution().minPathSum1(grid))
    }
    do {
        let grid = [[1,3,1],[1,5,1],[4,2,1]]
        print(grid, Solution().minPathSum1(grid))
    }

    do {
        let grid = [[1,2],
                    [1,1]]
        print(grid, Solution().minPathSum1(grid))
    }
    
    do {
        let grid = [[9,1,4,8]]
        print(grid, Solution().minPathSum1(grid))
    }
}
