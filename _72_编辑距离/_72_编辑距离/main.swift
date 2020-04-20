//
//  main.swift
//  _72_编辑距离
//
//  Created by nius on 2020/3/14.
//  Copyright © 2020 nius. All rights reserved.
//

import Foundation

/*
 给定两个单词 word1 和 word2，计算出将 word1 转换成 word2 所使用的最少操作数 。

 你可以对一个单词进行如下三种操作：

 插入一个字符
 删除一个字符
 替换一个字符
 
 示例 1:
 输入: word1 = "horse", word2 = "ros"
 输出: 3
 解释:
 horse -> rorse (将 'h' 替换为 'r')
 rorse -> rose (删除 'r')
 rose -> ros (删除 'e')
 
 示例 2:
 输入: word1 = "intention", word2 = "execution"
 输出: 5
 解释:
 intention -> inention (删除 't')
 inention -> enention (将 'i' 替换为 'e')
 enention -> exention (将 'n' 替换为 'x')
 exention -> exection (将 'n' 替换为 'c')
 exection -> execution (插入 'u')

 来源：力扣（LeetCode）
 链接：https://leetcode-cn.com/problems/edit-distance
 */

class Solution {
    func minDistance1(_ word1: String, _ word2: String) -> Int {
        /*
         案例分析：horse -> ros
         定义：s1 = horse，s2 = ros，用s1[0, i) 表示s1中前i个字符，s2同理，比如s1[0, 3)表示s1前3个字符hor，即s1[0]、s1[1]、s1[2]
         定义dp[i][j]：从s1[0, i) 转换成 s2[0, j) 所需的最小操作数
         由于是字符串，我们加入空串考虑，并将dp中0位置定义为空串，则有如下dp表
         ┏━━━━━━━━━┳━━━━━━━━━┳━━━━━━━━━┳━━━━━━━━━┳━━━━━━━━━┳━━━━━━━━━┓
         ┃ -       ┃  j      ┃   0     ┃   1     ┃   2     ┃   3     ┃
         ┣━━━━━━━━━╋━━━━━━━━━╋━━━━━━━━━╋━━━━━━━━━╋━━━━━━━━━╋━━━━━━━━━┫
         ┃ i       ┃  -      ┃  ""     ┃   r     ┃   o     ┃   s     ┃
         ┣━━━━━━━━━╋━━━━━━━━━╋━━━━━━━━━╋━━━━━━━━━╋━━━━━━━━━╋━━━━━━━━━┫
         ┃ 0       ┃  ""     ┃   0     ┃   1     ┃   2     ┃   3     ┃
         ┣━━━━━━━━━╋━━━━━━━━━╋━━━━━━━━━╋━━━━━━━━━╋━━━━━━━━━╋━━━━━━━━━┫
         ┃ 1       ┃  h      ┃   1     ┃   -     ┃   -     ┃   -     ┃
         ┣━━━━━━━━━╋━━━━━━━━━╋━━━━━━━━━╋━━━━━━━━━╋━━━━━━━━━╋━━━━━━━━━┫
         ┃ 2       ┃  0      ┃   2     ┃   -     ┃   -     ┃   -     ┃
         ┣━━━━━━━━━╋━━━━━━━━━╋━━━━━━━━━╋━━━━━━━━━╋━━━━━━━━━╋━━━━━━━━━┫
         ┃ 3       ┃  r      ┃   3     ┃   -     ┃   -     ┃   -     ┃
         ┣━━━━━━━━━╋━━━━━━━━━╋━━━━━━━━━╋━━━━━━━━━╋━━━━━━━━━╋━━━━━━━━━┫
         ┃ 4       ┃  s      ┃   4     ┃   -     ┃   -     ┃   -     ┃
         ┣━━━━━━━━━╋━━━━━━━━━╋━━━━━━━━━╋━━━━━━━━━╋━━━━━━━━━╋━━━━━━━━━┫
         ┃ 5       ┃  e      ┃   5     ┃   -     ┃   -     ┃   -     ┃
         ┗━━━━━━━━━┻━━━━━━━━━┻━━━━━━━━━┻━━━━━━━━━┻━━━━━━━━━┻━━━━━━━━━┛
         
         ①第一行dp[0][j]：空串转为s2[0, j) = j，比如""转为s[0, 1) = r,则插入一个字符，空串转为s[0, 2) = ro，插入两个字符
         ②第一列同理dp[i][0]：s1[0, i)转为空串 = i，同理上①，直接删除字符
         这样就获得了第一行和第一列的初始值，后边可以使用递推求出，从表格中可以看出，每个格子的上、左、左上值都已经求出
         因此分为以下几种情况清求出 s1[0, i) ==> s2[0, j) 的最少操作数
         a. s1[0, i)“删掉”最后一个字符为s1[0, i-1)，可得dp[i][j] = dp[i-1][j] + 1，事实上这个值dp[i-1][j]在dp[i][j]的上边，已经求出
         b. 先从s1[0, i)转换为s2[0, j-1)，最后"插入"适合的字符，可得dp[i][j] = dp[i][j-1] + 1，事实上这个值dp[i][j-1]在dp[i][j]的左边，已经求出
         c. 先从s1[0, i-1)转换为s2[0, j-1)，然后判断s1[i-1]字符和s2[j-1]字符（即这两个子串的最后一个字符）是否相等
            如果 s1[i-1] == s2[j-1]，则不需要做什么，直接就满足条件，此时dp[i][j] = dp[i-1][j-1]
            如果 s1[i-1] != s2[j-1]，则在后边只需要在后边"插入"一个适合的字符即可，此时 dp[i][j] = dp[i-1][j-1] + 1
         
         综上：dp[i][j]就是根据左、左上和上三个格子的值推断出来，再求出其中最小值，有如下表达式
         dp[i][j] = min{dp[i-1][j] + 1, dp[i][j] = dp[i][j-1] + 1, (s1[i-1] == s2[j-1]) ? (dp[i-1][j-1]) : (dp[i-1][j-1] + 1)}

         //        [[0, 1, 2, 3],
         //         [1, 1, 2, 3],
         //         [2, 2, 1, 2],
         //         [3, 2, 2, 2],
         //         [4, 3, 3, 2],
         //         [5, 4, 4, 3]]
         */
        
        let s1Count = word1.count
        let s2Count = word2.count
        
        // 特判(有一个长度为0，返回另一个)
        if s1Count * s2Count == 0 {
            return s1Count + s2Count
        }
        
        let s1 = word1.map{ $0 }
        let s2 = word2.map{ $0 }
        
        var dp = [[Int]](repeating: [Int](repeating: 0, count: s2Count + 1), count: s1Count + 1);
        for i in 0...s1Count { dp[i][0] = i } // 初始化第0列
        for j in 0...s2Count { dp[0][j] = j } // 初始化第0行
        
        for i in 1...s1Count {
            for j in 1...s2Count {
                let left = dp[i][j-1]
                let top = dp[i-1][j]
                let leftTop = dp[i-1][j-1]
                let minLeftOrTop = min(left + 1, top + 1) // 先求左和上的最小值
                dp[i][j] = min(minLeftOrTop, (s1[i-1] == s2[j-1]) ? leftTop : (leftTop + 1)) // 在于左上角相比
            }
        }
        return dp[s1Count][s2Count]
    }
    
    // 优化为一维数组
    func minDistance2(_ word1: String, _ word2: String) -> Int {
        /*
         案例分析：horse -> ros
         定义：s1 = horse，s2 = ros，用s1[0, i) 表示s1中前i个字符，s2同理，比如s1[0, 3)表示s1前3个字符hor，即s1[0]、s1[1]、s1[2]
         定义dp[i][j]：从s1[0, i) 转换成 s2[0, j) 所需的最小操作数
         由于是字符串，我们加入空串考虑，并将dp中0位置定义为空串，则有如下dp表
         ┏━━━━━━━━━┳━━━━━━━━━┳━━━━━━━━━┳━━━━━━━━━┳━━━━━━━━━┳━━━━━━━━━┓
         ┃ -       ┃  j      ┃   0     ┃   1     ┃   2     ┃   3     ┃
         ┣━━━━━━━━━╋━━━━━━━━━╋━━━━━━━━━╋━━━━━━━━━╋━━━━━━━━━╋━━━━━━━━━┫
         ┃ i       ┃  -      ┃  ""     ┃   r     ┃   o     ┃   s     ┃
         ┣━━━━━━━━━╋━━━━━━━━━╋━━━━━━━━━╋━━━━━━━━━╋━━━━━━━━━╋━━━━━━━━━┫
         ┃ 0       ┃  ""     ┃   0     ┃   1     ┃   2     ┃   3     ┃
         ┣━━━━━━━━━╋━━━━━━━━━╋━━━━━━━━━╋━━━━━━━━━╋━━━━━━━━━╋━━━━━━━━━┫
         ┃ 1       ┃  h      ┃   1     ┃   -     ┃   -     ┃   -     ┃
         ┣━━━━━━━━━╋━━━━━━━━━╋━━━━━━━━━╋━━━━━━━━━╋━━━━━━━━━╋━━━━━━━━━┫
         ┃ 2       ┃  0      ┃   2     ┃   -     ┃   -     ┃   -     ┃
         ┣━━━━━━━━━╋━━━━━━━━━╋━━━━━━━━━╋━━━━━━━━━╋━━━━━━━━━╋━━━━━━━━━┫
         ┃ 3       ┃  r      ┃   3     ┃   -     ┃   -     ┃   -     ┃
         ┣━━━━━━━━━╋━━━━━━━━━╋━━━━━━━━━╋━━━━━━━━━╋━━━━━━━━━╋━━━━━━━━━┫
         ┃ 4       ┃  s      ┃   4     ┃   -     ┃   -     ┃   -     ┃
         ┣━━━━━━━━━╋━━━━━━━━━╋━━━━━━━━━╋━━━━━━━━━╋━━━━━━━━━╋━━━━━━━━━┫
         ┃ 5       ┃  e      ┃   5     ┃   -     ┃   -     ┃   -     ┃
         ┗━━━━━━━━━┻━━━━━━━━━┻━━━━━━━━━┻━━━━━━━━━┻━━━━━━━━━┻━━━━━━━━━┛
         
         ①第一行dp[0][j]：空串转为s2[0, j) = j，比如""转为s[0, 1) = r,则插入一个字符，空串转为s[0, 2) = ro，插入两个字符
         ②第一列同理dp[i][0]：s1[0, i)转为空串 = i，同理上①，直接删除字符
         这样就获得了第一行和第一列的初始值，后边可以使用递推求出，从表格中可以看出，每个格子的上、左、左上值都已经求出
         因此分为以下几种情况清求出 s1[0, i) ==> s2[0, j) 的最少操作数
         a. s1[0, i)“删掉”最后一个字符为s1[0, i-1)，可得dp[i][j] = dp[i-1][j] + 1，事实上这个值dp[i-1][j]在dp[i][j]的上边，已经求出
         b. 先从s1[0, i)转换为s2[0, j-1)，最后"插入"适合的字符，可得dp[i][j] = dp[i][j-1] + 1，事实上这个值dp[i][j-1]在dp[i][j]的左边，已经求出
         c. 先从s1[0, i-1)转换为s2[0, j-1)，然后判断s1[i-1]字符和s2[j-1]字符（即这两个子串的最后一个字符）是否相等
            如果 s1[i-1] == s2[j-1]，则不需要做什么，直接就满足条件，此时dp[i][j] = dp[i-1][j-1]
            如果 s1[i-1] != s2[j-1]，则在后边只需要在后边"插入"一个适合的字符即可，此时 dp[i][j] = dp[i-1][j-1] + 1
         
         综上：dp[i][j]就是根据左、左上和上三个格子的值推断出来，再求出其中最小值，有如下表达式
         dp[i][j] = min{dp[i-1][j] + 1, dp[i][j] = dp[i][j-1] + 1, (s1[i-1] == s2[j-1]) ? (dp[i-1][j-1]) : (dp[i-1][j-1] + 1)}

         //        [[0, 1, 2, 3],
         //         [1, 1, 2, 3],
         //         [2, 2, 1, 2],
         //         [3, 2, 2, 2],
         //         [4, 3, 3, 2],
         //         [5, 4, 4, 3]]
         */
        
        let s1Count = word1.count
        let s2Count = word2.count
        
        // 特判(有一个长度为0，返回另一个)
        if s1Count * s2Count == 0 {
            return s1Count + s2Count
        }
        
//        let s1 = word1.map{ $0 }
//        let s2 = word2.map{ $0 }
        let s1 = [Character](word1)
        let s2 = [Character](word2)
        
        // 优化为一维数组
        // var dp = [[Int]](repeating: [Int](repeating: 0, count: s2Count + 1), count: s1Count + 1);
        var dp = [Int](repeating: 0, count: s2Count + 1);
        for j in 0...s2Count { dp[j] = j } // 初始化第0行
        for i in 1...s1Count {
            var leftTop = i-1; // 类似二维dp中第一列
            for j in 1...s2Count {
                let left = (j == 1) ? i : dp[j-1]  // 左（第1列初始值需要取i）
                let top = dp[j]     // 上（还没有被覆盖）
                let minLeftOrTop = min(left + 1, top + 1) // 先求左和上的最小值
                let nextLeftTop = dp[j] // 先记录作为下一次计算的左上
                dp[j] = min(minLeftOrTop, (s1[i-1] == s2[j-1]) ? leftTop : (leftTop + 1)) // 在于左上角相比
                leftTop = nextLeftTop // 更新下一次的左上
            }
        }
        
        // s2为空，不会进入到内存循环，导致dp没有值
        return dp[s2Count]
    }
}

do {
    do {
        print("horse     --> ros       ==> 3：", Solution().minDistance1("horse", "ros"))
        print("intention --> execution ==> 5：", Solution().minDistance1("intention", "execution"))
        print("空     --> 空       ==> 0", Solution().minDistance1("", ""))
    }
    print("优化后")
    do {
        print("horse     --> ros       ==> 3：", Solution().minDistance2("horse", "ros"))
        print("intention --> execution ==> 5：", Solution().minDistance2("intention", "execution"))
        print("b     --> 空       ==> 1", Solution().minDistance2("b", ""))
        print("空     --> b       ==> 1", Solution().minDistance2("", "b"))
    }
}

