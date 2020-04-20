//
//  main.swift
//  _63_不同路径 II
//
//  Created by nius on 2020/3/24.
//  Copyright © 2020 nius. All rights reserved.
//

import Foundation

/*
 一个机器人位于一个 m x n 网格的左上角 （起始点在下图中标记为“Start” ）。

 机器人每次只能向下或者向右移动一步。机器人试图达到网格的右下角（在下图中标记为“Finish”）。

 现在考虑网格中有障碍物。那么从左上角到右下角将会有多少条不同的路径？

 ┏━━━━━━━━━┳━━━━━━━━━┳━━━━━━━━━┳━━━━━━━━━┳━━━━━━━━━┳━━━━━━━━━┳━━━━━━━━━┓
 ┃ start   ┃         ┃         ┃         ┃         ┃         ┃         ┃
 ┣━━━━━━━━━╋━━━━━━━━━╋━━━━━━━━━╋━━━━━━━━━╋━━━━━━━━━╋━━━━━━━━━╋━━━━━━━━━┫
 ┃         ┃         ┃         ┃         ┃         ┃         ┃         ┃
 ┣━━━━━━━━━╋━━━━━━━━━╋━━━━━━━━━╋━━━━━━━━━╋━━━━━━━━━╋━━━━━━━━━╋━━━━━━━━━┫
 ┃         ┃         ┃         ┃         ┃         ┃         ┃ finished┃
 ┗━━━━━━━━━┻━━━━━━━━━┻━━━━━━━━━┻━━━━━━━━━┻━━━━━━━━━┻━━━━━━━━━┻━━━━━━━━━┛

 网格中的障碍物和空位置分别用 1 和 0 来表示。

 说明：m 和 n 的值均不超过 100。

 示例 1:

 输入:
 [
   [0,0,0],
   [0,1,0],
   [0,0,0]
 ]
 输出: 2
 解释:
 3x3 网格的正中间有一个障碍物。
 从左上角到右下角一共有 2 条不同的路径：
 1. 向右 -> 向右 -> 向下 -> 向下
 2. 向下 -> 向下 -> 向右 -> 向右

 来源：力扣（LeetCode）
 链接：https://leetcode-cn.com/problems/unique-paths-ii
 */

class Solution {
    // 时间：O(m*n)，空间：O(m*n)
    func uniquePathsWithObstacles1(_ obstacleGrid: [[Int]]) -> Int {
        /*
         dp[i][j]为走到(i,j)位置格子的所有路劲
         来到这个格子只有两种方式:
            ①一种是从上边下来，另一种是从左边过来 dp[i][j] = dp[i-1][j] + dp[i][j-1]
            ③有障碍物，则 dp[i][j] = 0
         */
        
        if obstacleGrid.count == 0 || obstacleGrid[0].count == 0  {
            return 0
        }
        
        let rows = obstacleGrid.count
        let columns = obstacleGrid[0].count
        
        var dp = [[Int]](repeating: [Int](repeating: 0, count: columns), count: rows)
        // 初始化左上角
        dp[0][0] = (obstacleGrid[0][0] == 1) ? 0 : 1
        // 初始化第一列
        for i in 1..<rows {
            if dp[i-1][0] == 0 {
                // 如果上一个格子已经被阻断，则直接设置为0
                dp[i][0] = 0
            } else {
                // 如果上一个格子没有被阻断，则看看当前格子是否存在障碍物
                dp[i][0] = (obstacleGrid[i][0] == 1) ? 0 : 1
            }
        }
        // 初始化第一行
        for j in 1..<columns {
            if dp[0][j-1] == 0 {
                // 如果前一个格子已经被阻断，则直接设置为0
                dp[0][j] = 0
            } else {
                // 如果前一个格子没有被阻断，则看看当前格子是否存在障碍物
                dp[0][j] = (obstacleGrid[0][j] == 1) ? 0 : 1
            }
        }
        
        for i in 1..<rows {
            for j in 1..<columns {
                if obstacleGrid[i][j] == 1 { // 有障碍物
                    dp[i][j] = 0
                } else {
                    dp[i][j] = dp[i-1][j] + dp[i][j-1]
                }
            }
        }
        return dp[rows-1][columns-1]
    }
    
    // 优化空间复杂度为一维数组
    // 时间：O(m*n)，空间：O(m)
    func uniquePathsWithObstacles2(_ obstacleGrid: [[Int]]) -> Int {
        /*
         dp[i][j]为走到(i,j)位置格子的所有路劲
         来到这个格子只有两种方式:
            ①一种是从上边下来，另一种是从左边过来 dp[i][j] = dp[i-1][j] + dp[i][j-1]
            ③有障碍物，则 dp[i][j] = 0
         */
        
        if obstacleGrid.count == 0 || obstacleGrid[0].count == 0  {
            return 0
        }
        
        let rows = obstacleGrid.count
        let columns = obstacleGrid[0].count
        
        // 优化为数组
        // var dp = [[Int]](repeating: [Int](repeating: 0, count: columns), count: rows)
        var dp = [Int](repeating: 0, count: columns)
        // 初始化
        dp[0] = (obstacleGrid[0][0] == 1) ? 0 : 1;
        for j in 1..<columns {
            if dp[j-1] == 0 {
                // 如果前一个格子已经被阻断，则直接设置为0
                dp[j] = 0
            } else {
                // 如果前一个格子没有被阻断，则看看当前格子是否存在障碍物
                dp[j] = (obstacleGrid[0][j] == 1) ? 0 : 1
            }
        }
        
        for i in 1..<rows {
            for j in 0..<columns {
                if obstacleGrid[i][j] == 1 { // 有障碍物
                    dp[j] = 0
                } else {
                    if j == 0 {
                        let top = dp[j]
                        dp[j] = top == 0 ? 0 : (obstacleGrid[i][0] == 1) ? 0 : 1
                    } else {
                        dp[j] = dp[j] + dp[j-1]
                    }
                }
            }
        }
        return dp[columns-1]
    }
}









do {
   do {
        let obstacles =  [
            [0, 0, 0],
            [0, 1, 0],
            [0, 0, 0],
        ]
        print(Solution().uniquePathsWithObstacles1(obstacles))
    }
    do {
        let obstacles =  [
            [0, 1, 0],
            [0, 1, 0],
            [1, 0, 0],
        ]
        print(Solution().uniquePathsWithObstacles1(obstacles))
    }
    do {
        let obstacles =  [
            [0, 1, 0]
        ]
        print(Solution().uniquePathsWithObstacles1(obstacles))
    }
    do {
        let obstacles =  [
            [1]
        ]
        print(Solution().uniquePathsWithObstacles1(obstacles))
    }
}

print("=========")
do {
   do {
        let obstacles =  [
            [0, 0, 0],
            [0, 1, 0],
            [0, 0, 0],
        ]
        print(Solution().uniquePathsWithObstacles2(obstacles))
    }
    do {
        let obstacles =  [
            [0, 1, 0],
            [0, 1, 0],
            [1, 0, 0],
        ]
        print(Solution().uniquePathsWithObstacles2(obstacles))
    }
    do {
        let obstacles =  [
            [0, 1, 0]
        ]
        print(Solution().uniquePathsWithObstacles2(obstacles))
    }
    do {
        let obstacles =  [
            [1]
        ]
        print(Solution().uniquePathsWithObstacles2(obstacles))
    }
}
