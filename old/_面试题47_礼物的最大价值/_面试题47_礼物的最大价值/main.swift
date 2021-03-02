//
//  main.swift
//  _面试题47_礼物的最大价值
//
//  Created by nius on 2020/3/14.
//  Copyright © 2020 nius. All rights reserved.
//

import Foundation

/*
 在一个 m*n 的棋盘的每一格都放有一个礼物，每个礼物都有一定的价值（价值大于 0）。你可以从棋盘的左上角开始拿格子里的礼物，并每次向右或者向下移动一格、直到到达棋盘的右下角。给定一个棋盘及其上面的礼物的价值，请计算你最多能拿到多少价值的礼物？

 示例 1:
 输入:
 [
   [1,3,1],
   [1,5,1],
   [4,2,1]
 ]
  输出: 12
 解释: 路径 1→3→5→2→1 可以拿到最多价值的礼物
  

 提示：
 0 < grid.length <= 200
 0 < grid[0].length <= 200

 来源：力扣（LeetCode）
 链接：https://leetcode-cn.com/problems/li-wu-de-zui-da-jie-zhi-lcof
*/

class Solution {
    // MARK: - 使用dp二维数组
    func maxValue(_ grid: [[Int]]) -> Int {
        /* 涉及到求最值，有限考虑是否可以使用动态规划 dp 解决，不行再考虑其他
           这里看出来是一个二维数组(矩阵)，要求某一个位置[row][col]的最大价值
           由于知道路径只能是向右或者向下，因此该路径只能从[row-1][col]或者[row][col-1]这两个格子过来
           因此这两个格子中最大的哪一个，加上当前格子的值，就得到[row][col]的最大价值
         所以：设置[row][col]位置的最大价值为 dp[row][col]，则有
              状态转移方程为 db[row][col] = max(db[row-1][col], db[row][col-1]) + grid[row][col]
         grid                       dp
         [                          [
           [1,3,1],                   [1,4,5],
           [1,5,1],                   [2,9,10],
           [4,2,1]                    [6,11,12]
         ]                          ]
         */
        
        let rows = grid.count    // 行数
        if rows == 0 { return 0 }
        let cols = grid[0].count // 列数
        
        // 创建dp二维数组
        var dp = [[Int]](repeating: [Int](repeating: 0, count: cols), count: rows)
        
        // 1、初始化dp
        dp[0][0] = grid[0][0] // 左上角第一个格子能拿到的最大价值就是它本身
        // 有移动路径方向可知，第一行和第一列都只能单方向移动，因此可以直接求得
        // 第一行(第一行的每一个列)
        for col in 1..<cols { // 第0行的第0个位置已经求得
            dp[0][col] = dp[0][col - 1] + grid[0][col]
        }
        //print("dp" ,dp)
        // 第一列(第一列的每一行)
        for row in 1..<rows { // 第0列的第0个位置已经求得
            dp[row][0] = dp[row - 1][0] + grid[row][0]
        }
        //print("dp" ,dp)
        
        
        // 2、计算dp[row][col]
        // 要计算 dp[row][col]，必须知道 左边（dp[row][col-1]）和上边（dp[row-1][col]）
        // 因此我们的求解思路是 从上到下，从左到右，遍历二位数组，所以我们可以逐行求解，其实逐列求解也可以
        for row in 1..<rows {
            for col in 1..<cols {
                dp[row][col] = max(dp[row-1][col], dp[row][col-1]) + grid[row][col]
            }
        }
        //print("dp" ,dp)
        
        return dp[rows - 1][cols - 1]
    }
    
    // MARK: - 使用dp思想，但用一维数组
    // 事实上每一步骤都只需要用到两个值，即上边和左边。如果我们每次都从上到下，从左到右的求值
    // 那只需要知道上一列的值即可，求得左边的值记录一下，推导出右边的值
    func maxValue1(_ grid: [[Int]]) -> Int {
        /* 涉及到求最值，有限考虑是否可以使用动态规划 dp 解决，不行再考虑其他
           这里看出来是一个二维数组(矩阵)，要求某一个位置[row][col]的最大价值
           由于知道路径只能是向右或者向下，因此该路径只能从[row-1][col]或者[row][col-1]这两个格子过来
           因此这两个格子中最大的哪一个，加上当前格子的值，就得到[row][col]的最大价值
         所以：设置[row][col]位置的最大价值为 dp[row][col]，则有
              状态转移方程为 db[row][col] = max(db[row-1][col], db[row][col-1]) + grid[row][col]
         grid                       dp
         [                          [
           [1,3,1],                   [1,4,5],
           [1,5,1],                   [2,9,10],
           [4,2,1]                    [6,11,12]
         ]                          ]
         */
        
        /*
         0 < grid.length <= 200
         0 < grid[0].length <= 200
         */
        let rows = grid.count    // 行数
        let cols = grid[0].count // 列数（题目限定大于0，这里可以不会越界）
        
        /* 每一行的最大价值
         这个rowMaxValues事实上，rc位置左边装当前行的值（覆盖），右边装上一行的值
            4   5
         2  rc
         */
        var rowMaxValues = [Int](repeating: 0, count: cols)
        // 先求出第一行（第0行）
        for col in 0..<cols {
            rowMaxValues[col] = (col == 0 ? 0 : rowMaxValues[col - 1]) + grid[0][col]
        }
        
        for row in 1..<rows { // 上边已经求得了第一行（第0行），这里从第二行开始
            for col in 0..<cols {
                // 第0列，直接使用上边的值
                // 其他情况，使用 max(rowMaxValues[col - 1], rowMaxValues[col])
                let topMax = rowMaxValues[col]
                let leftMax = col == 0 ? topMax : rowMaxValues[col - 1]
                rowMaxValues[col] = max(topMax, leftMax) + grid[row][col]
            }
        }
        
        return rowMaxValues[cols - 1]
    }
}

do {
    do {
        let grid = [
        [1, 3, 1],
        [1, 5, 1],
        [4, 2, 1]
        ]
        print(grid)
        print(Solution().maxValue(grid))
    }
    do {
        let grid = [[1,3,1],[1,5,1],[4,2,1]]
        print(grid)
        print(Solution().maxValue1(grid))
    }
}

