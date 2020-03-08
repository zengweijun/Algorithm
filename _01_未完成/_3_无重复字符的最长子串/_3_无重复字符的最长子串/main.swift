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
        // 使用滑动窗口，并用set记录是否存在重复值
        // 滑动窗口使用双指针 left/right
        
        let count = s.count
        if count == 0 { return 0 }
        if count == 1 { return 1 }
        
        func charAt(_ s: String, _ index: Int) -> Character {
            return s[s.index(s.startIndex, offsetBy: index)]
        }
        
        var maxLength = 1
        
        // var subLength = 1
        var left = 0  // 遇到重复字符，subLength = right - left，left++，right++，更新maxLength
        var right = 1 // 没有遇到重复字符，right++
        var set: Set<Character> = [charAt(s, left)] // 检查重复字符O(1)
        while right < count {
            let char = charAt(s, right)
            if set.contains(char) {
                let subLength = right - left
                if maxLength < subLength {
                    maxLength = subLength
                }
                left += 1
                right += 1
            } else {
                set.insert(char)
                right += 1
            }
        }
        if right - left > maxLength {
            maxLength = right - left
        }
        return maxLength
    }
}

do {
    print("abcabcbb --> 3：" ,Solution().lengthOfLongestSubstring("abcabcbb"))
    print("bbbbb    --> 1：" ,Solution().lengthOfLongestSubstring("bbbbb"))
    print("pwwkew   --> 3：" ,Solution().lengthOfLongestSubstring("pwwkew"))
}

