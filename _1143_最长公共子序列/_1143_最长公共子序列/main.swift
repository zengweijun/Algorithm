//
//  main.swift
//  _1143_最长公共子序列
//
//  Created by nius on 2020/3/14.
//  Copyright © 2020 nius. All rights reserved.
//

import Foundation

/*
 给定两个字符串 text1 和 text2，返回这两个字符串的最长公共子序列。

 一个字符串的 子序列 是指这样一个新的字符串：它是由原字符串在不改变字符的相对顺序的情况下删除某些字符（也可以不删除任何字符）后组成的新字符串。
 例如，"ace" 是 "abcde" 的子序列，但 "aec" 不是 "abcde" 的子序列。两个字符串的「公共子序列」是这两个字符串所共同拥有的子序列。

 若这两个字符串没有公共子序列，则返回 0。

  
 示例 1:
 输入：text1 = "abcde", text2 = "ace"
 输出：3
 解释：最长公共子序列是 "ace"，它的长度为 3。
 
 示例 2:
 输入：text1 = "abc", text2 = "abc"
 输出：3
 解释：最长公共子序列是 "abc"，它的长度为 3。

 示例 3:
 输入：text1 = "abc", text2 = "def"
 输出：0
 解释：两个字符串没有公共子序列，返回 0。
  

 提示:
 1 <= text1.length <= 1000
 1 <= text2.length <= 1000
 输入的字符串只含有小写英文字符。

 来源：力扣（LeetCode）
 链接：https://leetcode-cn.com/problems/longest-common-subsequence
 */

class Solution {
    // 子序列：不要求连续
    // 设计到递推逻辑，优先考虑动态规划（子序列类：穷举+剪枝类）
    // 另外动态规划通常是递归的优化版，状态转移方程事实上就是递归的递推式
    func longestCommonSubsequence(_ text1: String, _ text2: String) -> Int {
        /*
         text1 = "abcde", text2 = "ace"
         
         dp(commonSubStr)                       dp(commonSubStr.length)
           | a   b   c   d   e                  | a   b   c   d   e
         --- ---------------                  -------------------
         a | a   a   a   a   a      ===>      a | 1   1   1   1   1
             
         c | a   a   ac  ac  ac               c | 1   1   2   2   2
             
         e | a   a   ac  ac  ace              e | 1   1   2   2   3
         
         dp(i, j)为text1中以i结尾，text2中以j结尾的最长公共子序列长度
         ① 若 text1[i] == text2[j]，字符相等，则 dp(i, j) = 1 + dp(i-1, j-1)
            相等：在两个串的前一个字符i-1、j-1结尾公共子串长度基础上 + 1
         ② 若 text1[i] != text2[j]，字符不等，则 dp(i,j) = max(dp(i-1, j), dp(i, j-1))
            不等：虽然不等，但有可能text2因为 i 字符的加入，导致与text1中 j-1 字符结尾的公共子串长度变大
                 例如： text1 = [1, 2, 5]      [1, 2, 5, 6]
                       text2 = [1, 2, 4]      [1, 2, 4, 5]
                      subStr = [1, 2]         [1, 2, 5]
         虽然心如字符 t1[i] = 6, t2[j] = 5 不等，但是却他们的公共子序列却变长了以，此时dp(i,j) = dp(i-1, j)
         反之也可以推出 dp(i,j) = dp(i, j-1)，于是，dp(i,j) = max(dp(i-1, j), dp(i, j-1))
         
         dp(i-1,j-1)：其实是dp表中的左上角元素
         dp(i,j-1)：dp表中上边元素
         dp(i-1,j)：dp表中左边元素
         当计算到 dp(i, j)时，这三个元素的值都在之前已经算过，直接取出即可
         
         为了方便处理，上边的dp table上我们增加了一个虚拟行和虚拟列，以避免因处理 i-1和 j-1是带来的逻辑分割
         因此我们dp表每个维度大小应该是 之前字符串长度+1
          dp(commonSubStr)                       dp(commonSubStr.length)
            | ""  a   b   c   d   e                   | ""  a   b   c   d   e
          -----------------------                  -----------------------
         "" | ""  ""  ""  ""  ""  ""               "" | 0   0   0   0   0   0
                                              
          a | ""   a   a   a   a   a      ===>      a | 0   1   1   1   1   1
                             
          c | ""   a   a   ac  ac  ac               c | 0   1   1   2   2   2
                             
          e | ""   a   a   ac  ac  ace              e | 0   1   1   2   2   3
         */
        
        let text1ExtendCount = text1.count + 1
        let text2ExtendCount = text2.count + 1
        let text2Chars = text2.map{$0}
        let text1Chars = text1.map{$0}
        var dp = [[Int]](repeating: [Int](repeating: 0, count: text2ExtendCount), count: text1ExtendCount)
        
        for i in 1..<text1ExtendCount{
            for j in 1..<text2ExtendCount{
                if text1Chars[i-1] == text2Chars[j-1] { // 使用 dp(i,j) 记录 t1[i-1]、t2[j-1]位置的值
                    dp[i][j] = dp[i-1][j-1] + 1
                } else {
                    dp[i][j] = max(dp[i][j - 1], dp[i - 1][j])
                }
            }
        }
        return dp[text1ExtendCount - 1][text2ExtendCount - 1]
    }
    
    // 优化为一位数组
    func longestCommonSubsequence1(_ text1: String, _ text2: String) -> Int {
        /*
         text1 = "abcde", text2 = "ace"
         
         dp(commonSubStr)                       dp(commonSubStr.length)
           | a   b   c   d   e                  | a   b   c   d   e
         --- ---------------                  -------------------
         a | a   a   a   a   a      ===>      a | 1   1   1   1   1
             
         c | a   a   ac  ac  ac               c | 1   1   2   2   2
             
         e | a   a   ac  ac  ace              e | 1   1   2   2   3
         
         dp(i, j)为text1中以i结尾，text2中以j结尾的最长公共子序列长度
         ① 若 text1[i] == text2[j]，字符相等，则 dp(i, j) = 1 + dp(i-1, j-1)
            相等：在两个串的前一个字符i-1、j-1结尾公共子串长度基础上 + 1
         ② 若 text1[i] != text2[j]，字符不等，则 dp(i,j) = max(dp(i-1, j), dp(i, j-1))
            不等：虽然不等，但有可能text2因为 i 字符的加入，导致与text1中 j-1 字符结尾的公共子串长度变大
                 例如： text1 = [1, 2, 5]      [1, 2, 5, 6]
                       text2 = [1, 2, 4]      [1, 2, 4, 5]
                      subStr = [1, 2]         [1, 2, 5]
         虽然心如字符 t1[i] = 6, t2[j] = 5 不等，但是却他们的公共子序列却变长了以，此时dp(i,j) = dp(i-1, j)
         反之也可以推出 dp(i,j) = dp(i, j-1)，于是，dp(i,j) = max(dp(i-1, j), dp(i, j-1))
         
         dp(i-1,j-1)：其实是dp表中的左上角元素
         dp(i,j-1)：dp表中上边元素
         dp(i-1,j)：dp表中左边元素
         当计算到 dp(i, j)时，这三个元素的值都在之前已经算过，直接取出即可
         
         为了方便处理，上边的dp table上我们增加了一个虚拟行和虚拟列，以避免因处理 i-1和 j-1是带来的逻辑分割
         因此我们dp表每个维度大小应该是 之前字符串长度+1
          dp(commonSubStr)                       dp(commonSubStr.length)
            | ""  a   b   c   d   e                   | ""  a   b   c   d   e
          -----------------------                  -----------------------
         "" | ""  ""  ""  ""  ""  ""               "" | 0   0   0   0   0   0
                                              
          a | ""   a   a   a   a   a      ===>      a | 0   1   1   1   1   1
                             
          c | ""   a   a   ac  ac  ac               c | 0   1   1   2   2   2
                             
          e | ""   a   a   ac  ac  ace              e | 0   1   1   2   2   3
         */
        
        let cols = text1.count
        let rows = text2.count
        let text2Chars = text2.map{$0}
        let text1Chars = text1.map{$0}
        var dp = [Int](repeating: 0, count: cols + 1)
        
        for i in 1...rows {
            var leftTop = 0
            for j in 1...cols {
                let nextLeftTop = dp[j] // 覆盖之前，记录此值，作为下次循环左上角
                if text1Chars[j-1] == text2Chars[i-1] {
                    dp[j] = leftTop + 1  // 左上角 + 1
                } else {
                    dp[j] = max(dp[j - 1], dp[j]) // 左边或者上边
                }
                leftTop = nextLeftTop
            }
        }
        return dp[cols]
    }
}

do {
    // 最长上升子序列
    do {
        print("abcde、ace --> 3: " ,Solution().longestCommonSubsequence("abcde", "ace"))
        print("abc、abc   --> 3: " ,Solution().longestCommonSubsequence("abc", "abc"))
        print("abc、def   --> 0: " ,Solution().longestCommonSubsequence("abc", "def"))
        print("bsbininm、jmjkbkjkv --> 1: " ,Solution().longestCommonSubsequence("bsbininm", "jmjkbkjkv"))
        print("hofubmnylkra、pqhgxgdofcvmr --> 5: " ,Solution().longestCommonSubsequence("hofubmnylkra", "pqhgxgdofcvmr"))
    }
    print("------------------------------------")
    do {
        print("abcde、ace --> 3: " ,Solution().longestCommonSubsequence1("abcde", "ace"))
        print("abc、abc   --> 3: " ,Solution().longestCommonSubsequence1("abc", "abc"))
        print("abc、def   --> 0: " ,Solution().longestCommonSubsequence1("abc", "def"))
        print("bsbininm、jmjkbkjkv --> 1: " ,Solution().longestCommonSubsequence1("bsbininm", "jmjkbkjkv"))
        print("hofubmnylkra、pqhgxgdofcvmr --> 5: " ,Solution().longestCommonSubsequence1("hofubmnylkra", "pqhgxgdofcvmr"))
    }
}

