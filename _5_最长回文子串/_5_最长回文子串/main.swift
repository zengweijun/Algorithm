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
    func longestPalindrome1(_ s: String) -> String {
        // 时间：O(n^2)、空间：O(n^2)
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
    
    
    func longestPalindrome2(_ s: String) -> String {
        // 时间：O(n^2)、空间：O(1)
        // 扩展中心算法
        /*
         "babad"
         扩展中心算法核心：连续相同的字符组成的子串作为扩展中心，左边为l，右边为r，之后由l和r向两边扩展
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
    
    func longestPalindrome3(_ s: String) -> String {
        // 时间：接近O(n),最坏O(n^2)、空间：O(1)
        // 马拉车算法 Manacher （实际上是扩展中心算法的升级版）
        /*
         马拉车算法处理"babad"
                                       ┏━━━━━━━━━┓         ┏━━━━━━━━━┓         ┏━━━━━━━━━┓         ┏━━━━━━━━━┓         ┏━━━━━━━━━┓
                                       ┃  0      ┃         ┃   1     ┃         ┃  2      ┃         ┃   3     ┃         ┃   4     ┃
         ┏━━━━━━━━━┳━━━━━━━━━┳━━━━━━━━━╋━━━━━━━━━╋━━━━━━━━━╋━━━━━━━━━╋━━━━━━━━━╋━━━━━━━━━╋━━━━━━━━━╋━━━━━━━━━╋━━━━━━━━━╋━━━━━━━━━╋━━━━━━━━━┳━━━━━━━━━┓
         ┃ idx     ┃ 0       ┃  1      ┃  2      ┃   3     ┃   4     ┃   5     ┃  6      ┃  7      ┃   8     ┃   9     ┃   10    ┃   11    ┃   12    ┃
         ┣━━━━━━━━━╋━━━━━━━━━╋━━━━━━━━━╋━━━━━━━━━╋━━━━━━━━━╋━━━━━━━━━╋━━━━━━━━━╋━━━━━━━━━╋━━━━━━━━━╋━━━━━━━━━╋━━━━━━━━━╋━━━━━━━━━╋━━━━━━━━━╋━━━━━━━━━┫
         ┃ cs      ┃ ^       ┃  #      ┃  b      ┃   #     ┃   a     ┃   #     ┃  b      ┃  #      ┃   a     ┃   #     ┃   d     ┃   #     ┃   $     ┃
         ┣━━━━━━━━━╋━━━━━━━━━╋━━━━━━━━━╋━━━━━━━━━╋━━━━━━━━━╋━━━━━━━━━╋━━━━━━━━━╋━━━━━━━━━╋━━━━━━━━━╋━━━━━━━━━╋━━━━━━━━━╋━━━━━━━━━╋━━━━━━━━━╋━━━━━━━━━┫
         ┃ m       ┃ 0       ┃  0      ┃  1      ┃   0     ┃   3     ┃   0     ┃  3      ┃  0      ┃   1     ┃   0     ┃   1     ┃   0     ┃   0     ┃
         ┗━━━━━━━━━┻━━━━━━━━━╋━━━━━━━━━╋━━━━━━━━━╋━━━━━━━━━╋━━━━━━━━━╋━━━━━━━━━╋━━━━━━━━━╋━━━━━━━━━╋━━━━━━━━━┻━━━━━━━━━┻━━━━━━━━━┻━━━━━━━━━┻━━━━━━━━━┛
                             ┃ left    ┃  li     ┃         ┃ center  ┃         ┃  i      ┃ right   ┃
                             ┗━━━━━━━━━┻━━━━━━━━━┛         ┗━━━━━━━━━┛         ┗━━━━━━━━━┻━━━━━━━━━┛
                             ┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┻━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛
                                                              对称
         
         马拉车（manacher）算法思想
            1、先将源字符串s头尾添加符号（有区分性），再在这些字符间插入区分符得到cs，比如 s="babad"，cs="^#b#a#b#a#d#$"
            2、对于处理后的字符串cs，有以下特性
                ①头^、尾$、中间#必须是原字符串中没有出现字符
                ②m[i]是以cs[i]为扩展中心的最大回文子串长度（不包含#），最大回文子串在原字符串中的开始索引：(i-m[i])/2
                ③m[i]是以cs[i]为扩展中心的最大回文子串的左半部分或者又半部分的长度（包含#）
         
         分析：算法关键在于求出m数组的值，该算法缺陷是头尾以及中间分隔符不能与原字符串中的字符重复
            上图中left-right为一个回文子串，则他们之间区域为对称区域，对称轴为中心center=(left+right)/2
            如果left-center内的li对应的m[li]=1，则以li为扩展中心的最大回文子串为1，那么与它对称的i一定拥有同样的性质m[i]=m[li]（li的回文范围没有超过对称范围left-right）
            如果li的回文范围超过了对称范围left-right，即i+m[li]>right，那以i为扩展中心并处于left-right内的部分一定满足是回文串，则有m[i]>=right-i
         
         综上：①i处于left-right范围内，一定有m[i]=m[li]（范围内）或者m[i]=right-i（范围外）
              ②超过范围时，超过或者刚刚处于范围临界的时候，还需要继续使用扩展中心算法检查是否存在更大回文串可能
         */
        
        if s.count < 2 { return s }
        
        let s = [Character](s)
        var cs = [Character](repeating: Character("#"), count: s.count << 1 + 3)
        cs[0] = "^"
        cs[1] = "#"
        cs[cs.count-1] = "$"
        
        for sIdx in 0..<s.count {
            let csIdx = sIdx << 1 + 2
            cs[csIdx] = s[sIdx]
            cs[csIdx + 1] = "#"
        }
        
        var m = [Int](repeating: 0, count: cs.count)
        
        // 该对称特性，只需要使用到right和center，left只是便于理解，实则无用
        var center = 0 // 初始值随便，等第一次扩展中心走完就会有正确值
        var right  = 0 // 初始值只要小于2即可，等第一次扩展中心走完就会有正确值，即不要进入第一个if语句
        
        var maxLen = 0
        var maxCenter = 0
        
        for i in 2..<cs.count-2 {
            if i < right {
                let li = center << 1 - i
                if i + m[li] <= right {
                    m[i] = m[li] // 在left-right对称范围内
                } else {
                    m[i] = right-i // 超过了对称范围
                }
            }
            
            // 尝试使用扩展中心算法对其进行扩展，看是否能寻找奥更大范围的回文串
            while cs[i-m[i]-1] == cs[i+m[i]+1] {
                m[i] += 1
            }
            
            // 更新center、right
            right = i + m[i]
            center = i
            
            // 最大回文串长度
            if maxLen < m[i] {
                maxLen = m[i]
                maxCenter = i
            }
        }
        let startIndex = (maxCenter - maxLen) >> 1
        return String(s[startIndex..<(startIndex+maxLen)])
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
