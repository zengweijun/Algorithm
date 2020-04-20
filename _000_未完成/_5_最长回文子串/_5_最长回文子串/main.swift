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
    // 时间：O(n^2)、空间：O(n^2)
    func longestPalindrome1(_ s: String) -> String {
        /*
         "babad"
         dp[i][j]表示，s[i, j]即s中i到j范围是否是回文串
         ┏━━━━━━━━━┳━━━━━━━━━┳━━━━━━━━━┳━━━━━━━━━┳━━━━━━━━━┳━━━━━━━━━┳━━━━━━━━━┓
         ┃ -       ┃  j      ┃  0      ┃   1     ┃   2     ┃   3     ┃   4     ┃
         ┣━━━━━━━━━╋━━━━━━━━━╋━━━━━━━━━╋━━━━━━━━━╋━━━━━━━━━╋━━━━━━━━━╋━━━━━━━━━┫
         ┃ i       ┃  dp     ┃  b      ┃   a     ┃   b     ┃   a     ┃   d     ┃
         ┣━━━━━━━━━╋━━━━━━━━━╋━━━━━━━━━╋━━━━━━━━━╋━━━━━━━━━╋━━━━━━━━━╋━━━━━━━━━┫
         ┃ 0       ┃  b      ┃  T      ┃   F     ┃   T     ┃   F     ┃   F     ┃
         ┣━━━━━━━━━╋━━━━━━━━━╋━━━━━━━━━╋━━━━━━━━━╋━━━━━━━━━╋━━━━━━━━━╋━━━━━━━━━┫
         ┃ 1       ┃  a      ┃         ┃   T     ┃   F     ┃   T     ┃   F     ┃
         ┣━━━━━━━━━╋━━━━━━━━━╋━━━━━━━━━╋━━━━━━━━━╋━━━━━━━━━╋━━━━━━━━━╋━━━━━━━━━┫
         ┃ 2       ┃  b      ┃         ┃         ┃   T     ┃   F     ┃   F     ┃
         ┣━━━━━━━━━╋━━━━━━━━━╋━━━━━━━━━╋━━━━━━━━━╋━━━━━━━━━╋━━━━━━━━━╋━━━━━━━━━┫
         ┃ 3       ┃  a      ┃         ┃         ┃         ┃   T     ┃   F     ┃
         ┣━━━━━━━━━╋━━━━━━━━━╋━━━━━━━━━╋━━━━━━━━━╋━━━━━━━━━╋━━━━━━━━━╋━━━━━━━━━┫
         ┃ 4       ┃  d      ┃         ┃         ┃         ┃         ┃   T     ┃
         ┗━━━━━━━━━┻━━━━━━━━━┻━━━━━━━━━┻━━━━━━━━━┻━━━━━━━━━┻━━━━━━━━━┻━━━━━━━━━┛
         
         dp[i][j]是否是回文串分为以下两种情况
         ①如果s[i, j].length <= 2 长度小于等于2时，dp[i][j] = s[i]==s[j]
         ②如果s[i, j].length > 2 长度大于2时，先看中间，再看两边，dp[i][j] = dp[i+1][j-1] && s[i]==s[j]
         
         从表达式的值可以看出，①无需依赖其他dp值 ②需要依赖其左下角的值
         因此这个dp表需要从左下向左上计算（注意，dp表的左下半部分是i>j，这个索引不合理，所以留空）
         */
        
//        if s.count == 0 { return s }
        let s = [Character](s)
        
        var dp = [[Bool]](repeating: [Bool](repeating: false, count: s.count), count: s.count)
        
        var maxSubLen = 0
        var startIndex = 0
        for i in (0..<s.count).reversed() {
            for j in i..<s.count {
                if i == j { // 对角线
                    dp[i][j] = true
                } else {
                    let tmpLen = j - i + 1
                    if tmpLen <= 2 {
                        dp[i][j] = s[i]==s[j]
                    } else {
                        dp[i][j] = dp[i+1][j-1]&&s[i]==s[j]
                    }
                }
                if dp[i][j] == true && j - i + 1 > maxSubLen {
                    startIndex = i
                    maxSubLen = j - i + 1
                }
            }
        }
        return String(s[startIndex..<(startIndex+maxSubLen)])
    }
    
    
    // 时间：O(n^2)、空间：O(1)
    // 中心扩展算法
    func longestPalindrome2(_ s: String) -> String {
        /*
         "babad"
         中心扩展算法核心：连续相同的字符组成的子串作为扩展中心，左边为l，右边为r，之后由l和r向两边扩展
         */
        let s = [Character](s)
        
        var left = 0
        var right = 0
        
        var maxSubLen = 0
        var startIndex = 0
        for i in 0..<s.count {
            if s[i] != s[left] { // 获得一个大于长度大于1的扩展中心
                right = i-1
                // 开始扩展
                repeat {
                    if maxSubLen < right - left + 1 {
                        maxSubLen = right - left + 1
                        startIndex = left
                    }
                    left -= 1
                    right += 1
                } while left >= 0 && right < s.count && s[left] == s[right]
                // 本次扩展结束
               
                // 重置left
                left = i
            } else {
                // 相同字符，在这里更新，因为连续相同字符就是回文串
                if maxSubLen < i - left + 1 {
                    maxSubLen = i - left + 1
                    startIndex = left
                }
            }
        }
        return String(s[startIndex..<(startIndex+maxSubLen)])
    }
    
    // 时间：O(n^2)、空间：O(1)
    // 马拉车算法 Manacher
    func longestPalindrome3(_ s: String) -> String {
        /*
         "babad"
         算法核心：连续相同的字符组成的子串作为扩展中心，左边为l，右边为r，之后由l和r向两边扩展
         注意：单个字符也似为也符合上述条件
         */
        
//        if s.count == 0 { return s }
        let s = [Character](s)
        
        var left = 0
        var right = 0
        
        
        var maxSubLen = 0
        var startIndex = 0
        for i in 0..<s.count {
            if s[i] != s[left] { // 获得一个大于长度大于1的扩展中心
                right = i-1
                // 开始扩展
                while left >= 0 && right < s.count && s[left] == s[right] {
                    if maxSubLen < right - left + 1 {
                        maxSubLen = right - left + 1
                        startIndex = left
                    }
                    left -= 1
                    right += 1
                } // 本次扩展结束
               
                // 重置left
                left = i
            }
        }
        maxSubLen = maxSubLen > 0 ? maxSubLen : s.count
        return String(s[startIndex..<(startIndex+maxSubLen)])
    }
}

do {
    do {
        print(Solution().longestPalindrome1("babad"))
        print(Solution().longestPalindrome1("cbbd"))
        print(Solution().longestPalindrome1("ccc"))
        print(Solution().longestPalindrome1(""))
    }
    do {
        print(Solution().longestPalindrome2("babad"))
        print(Solution().longestPalindrome2("cbbd"))
        print(Solution().longestPalindrome2("abb"))
        print(Solution().longestPalindrome2("ccc"))
        print(Solution().longestPalindrome2(""))
    }
    do {
        print(Solution().longestPalindrome3("babad"))
        print(Solution().longestPalindrome3("cbbd"))
        print(Solution().longestPalindrome3("ccc"))
        print(Solution().longestPalindrome3(""))
    }
}
