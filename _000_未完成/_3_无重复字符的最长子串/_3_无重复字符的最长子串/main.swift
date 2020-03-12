//
//  main.swift
//  _3_无重复字符的最长子串
//
//  Created by 曾维俊 on 2020/3/8.
//  Copyright © 2020 Nius. All rights reserved.
//

import Foundation

/**
 给定一个字符串，请你找出其中不含有重复字符的 最长子串 的长度。

 示例 1:
 输入: "abcabcbb"
 输出: 3
 解释: 因为无重复字符的最长子串是 "abc"，所以其长度为 3。
 示例 2:

 输入: "bbbbb"
 输出: 1
 解释: 因为无重复字符的最长子串是 "b"，所以其长度为 1。
 示例 3:

 输入: "pwwkew"
 输出: 3
 解释: 因为无重复字符的最长子串是 "wke"，所以其长度为 3。
      请注意，你的答案必须是 子串 的长度，"pwke" 是一个子序列，不是子串。

 来源：力扣（LeetCode）
 链接：https://leetcode-cn.com/problems/longest-substring-without-repeating-characters
 */

class Solution {
    func lengthOfLongestSubstring(_ s: String) -> Int {
        // O(n * maxLength)
        // 暴力解法，使用set辅助检查是否重复
        // 滑动窗口使用双指针 left/right
//        func charAt(_ s: String, _ index: Int) -> Character {
//            return s[s.index(s.startIndex, offsetBy: index)]
//        }
        
        let chars = s.map{$0}
        let count = chars.count
        if count <= 1 { return count }
        
        // 默认字符串第一个字符为 无重复最大子串，长度为1（最少都有一个字符：首字符）
        // 但是检查的时候，第一轮需要将第0个字符包含进去(即作为左边界)，比如abcd，如果不包含首字符有可能漏掉
        var maxLength = 1
        // 右边界[left, right]
        for left in 0..<(count-1) { // O(n)
            var set: Set<Character> = [chars[left]] // 将首字符加入集合
            
            var right = left + 1
            while right < count {
                let char = chars[right]
                if set.contains(char) {
                    break // 退出内层循环，继续下一轮比较
                }
                // 没有发现重复字符，记录当前字符，继续检查下一个字符是否可行
                set.insert(char)
                right += 1
            }
            
            // 来到这里，要么是出现了重复字符，要么是到达了尾巴，无论是哪一种情况
            // 无重复最大子串都是 right - left，更新maxLength
            let stepLen = right - left
            if stepLen > maxLength {
                maxLength = stepLen
            }
        }
        return maxLength
    }
}

do {
    print("au       --> 2：" ,Solution().lengthOfLongestSubstring("au"))
    print("abcabcbb --> 3：" ,Solution().lengthOfLongestSubstring("abcabcbb"))
    print("bbbbb    --> 1：" ,Solution().lengthOfLongestSubstring("bbbbb"))
    print("pwwkew   --> 3：" ,Solution().lengthOfLongestSubstring("pwwkew"))
}

