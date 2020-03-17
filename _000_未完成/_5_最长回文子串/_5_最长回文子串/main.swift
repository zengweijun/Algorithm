//
//  main.swift
//  _5_最长回文子串
//
//  Created by nius on 2020/3/14.
//  Copyright © 2020 nius. All rights reserved.
//

import Foundation

/*
 给定一个字符串 s，找到 s 中最长的回文子串。你可以假设 s 的最大长度为 1000。

 示例 1：
 输入: "babad"
 输出: "bab"
 注意: "aba" 也是一个有效答案。
 
 示例 2：
 输入: "cbbd"
 输出: "bb"

 来源：力扣（LeetCode）
 链接：https://leetcode-cn.com/problems/longest-palindromic-substring
 */

class Solution {
    func longestPalindrome(_ s: String) -> String {
        /*
         "babad"
         b      a       b       a         d         f
         b      a      bab    aba         d         f
        (0,1)  (1,1)  (0,3)  (1,3)       (4,1)     (5,1)
         */
        
        if s.count < 2 { return s }
        let sChars = s.map {$0}
        var ls = (0, 0)
        var dp = [(Int, Int)](repeating: (0, 0), count: sChars.count)
        dp[0] = (0, 1)
        for i in 1..<sChars.count {
            let preTuple = dp[i-1]
            if preTuple.1 == 1 {
                if sChars[i] == sChars[i-1] {
                    dp[i] = (i-1, 2)
                }
                if i-2 >= 0 && sChars[i] == sChars[i-2] {
                    dp[i] = (i-2, 3)
                }
                if dp[i] == (0, 0) {
                    dp[i] = (i, 1)
                }
            } else {
                if i-dp[i-1].1 - 1 >= 0 && sChars[i] == sChars[i-dp[i-1].1 - 1] {
                    dp[i] = (i-dp[i-1].1 - 1, dp[i-1].1 + 2)
                }
            }
            if dp[i].1 > ls.1 {
                ls = dp[i]
            }
        }
        
        let start = s.index(s.startIndex, offsetBy: ls.0)
        let end = s.index(s.startIndex, offsetBy: ls.0 + ls.1)
        return String(s[start..<end])
    }
}

do {
//    print(Solution().longestPalindrome("babad"))
//    print(Solution().longestPalindrome("cbbd"))
    print(Solution().longestPalindrome("ccc"))
}
