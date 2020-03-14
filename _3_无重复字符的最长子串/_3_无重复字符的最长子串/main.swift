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
    //MARK: - 蛮力解法1（找出以每一个字符开始的最大无重复子串） 最坏 O(n^2)/最好 O(n)
    func lengthOfLongestSubstring(_ s: String) -> Int {
        // 最坏 O(n^2)：没有重复字符
        // 最好 O(n)  ：全部重复字符
        /**
         完全不重复的字符串：
         s = O(n-1) + O(n-2) + O(n-3) + ... + O(1)
         s = O( (n-1) *(n-1 + 1) / 2 ) = O( (n-1)^2/2 + 1/2 ) ≈  O( (n-1)^2/2 ) ≈ O(n^2)
         */
        // 暴力解法，使用set辅助检查是否重复
        // 思路：[left, right]为以某个字符left为开始的最大无重复子串范围
        // 滑动窗口使用双指针 left/right
        let chars = Array(s.utf8)
        let count = chars.count
        if count <= 1 { return count }
        
        // 默认字符串第一个字符为 无重复最大子串，长度为1（最少都有一个字符：首字符）
        // 但是检查的时候，第一轮需要将第0个字符包含进去(即作为左边界)，比如abcd，如果不包含首字符有可能漏掉
        var maxLength = 1
        // 右边界[left, right]
        for left in 0..<(count-1) { // O(n)
            var set: Set<UInt8> = [chars[left]] // 将首字符加入集合
            
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
    
    //MARK: - 蛮力解法2 滑动窗口（找出以每一个字符开始的最大无重复子串） 最坏 O(n^2)/最好 O(n)
    func lengthOfLongestSubstring1(_ s: String) -> Int {
        // 最坏 O(n^2)：没有重复字符
        // 最好 O(n)  ：全部重复字符
        
        if s.isEmpty { return 0 }
        let utf8Chars = Array(s.utf8)
        var left = 0   // 窗口左边left
        var right = 0  // 窗口右边right
        var maxLength = 0

        while right < utf8Chars.count {
            var i = left
            while i < right { // 遍历窗口内是否有和right相同字符，有的话就缩小窗口
                if (utf8Chars[i] == utf8Chars[right]) {
                    left = i + 1 // 左边缩小窗口
                    break        // 重置i，重新检查串口
                }
                i += 1 // 继续检查
            }

            let windowWidth = right - left + 1
            if maxLength < windowWidth {
                maxLength = windowWidth
            }

            right += 1 // 窗口向右扩大
        }
        return maxLength
    }
    
    //MARK: - 进阶解法1（找出以每一个字符结尾的最大无重复子串） ，假设字符串可能包含所有Unicode字符 O(n)
    func lengthOfLongestSubstring3(_ s: String) -> Int {
        // 1. 遍历到某个字符 i，先看以 i-1 结尾的最大无重复子串的起始位置 prevStart [prevStart, i-1]范围内的字符不重复
        // 2. 查看遍历过的字符串中，找出上次出现和 i 同字符的位置 lasti （如果没出现过，则为默认 -1）
        // 3. ①如果 lasti 在 [prevStart, i-1] 范围内，即 i >= prevStart，则以i结尾的最大无重复子串为 [lasti + 1, i]
        //    ②如果 lasti 在 [prevStart, i-1] 范围外，即 i < prevStart 或者 i = -1，则以i结尾的最大无重复子串为 [prevStart, i]
        // 4. 3中①要更新 prevStart = lasti，供下一个字符i+1使用，3中②无需更新，下次仍然使用prevStart
        
        if s.isEmpty { return 0 }
        let chars = s.map{$0}
        var lastDic = [Character : Int]() // 记录每个字符上一次出现的位置
        var prevStart = 0 // i - 1 位置最大无重复子串为起始位置
        
        // 0位置默认值
        lastDic[chars[0]] = 0
        prevStart = 0 // [0, 0] <== [prevStart, i]
        var maxLength = 1 // 0 - 0 + 1 (length = i - prevStart + 1)
        for i in 1..<chars.count { // i应该从1开始，0位置特殊，默认为1
            // 找到该字符上一次出现的位置，没有则默认为 -1
            let lasti = lastDic[chars[i], default: -1]
            // 记录当前字符
            lastDic[chars[i]] = i
            
            if lasti < prevStart {
                // 如果上一个字符出现在 [prevStart, i-1] 的左边，则当前结果为 [prevStart, i]
                // 无需改变prevStart
            } else {
                // 如果上一个字符出现在 [prevStart, i-1] 范围内，则当前结果为 [lasti + 1, i]
                // 更新prevStart，记录 i 结尾的最大无重复子串范围
                prevStart = lasti + 1
            }
            maxLength = max(maxLength, i - prevStart + 1)
        }
        return maxLength
    }
     
    //MARK: - 进阶解法2（找出以每一个字符结尾的最大无重复子串），假设字符串只包含小写字母 O(n)
    func lengthOfLongestSubstring4(_ s: String) -> Int {
        // 1. 遍历到某个字符 i，先看以 i-1 结尾的最大无重复子串的起始位置 prevStart [prevStart, i-1]范围内的字符不重复
        // 2. 查看遍历过的字符串中，找出上次出现和 i 同字符的位置 lasti （如果没出现过，则为默认 -1）
        // 3. ①如果 lasti 在 [prevStart, i-1] 范围内，即 i >= prevStart，则以i结尾的最大无重复子串为 [lasti + 1, i]
        //    ②如果 lasti 在 [prevStart, i-1] 范围外，即 i < prevStart 或者 i = -1，则以i结尾的最大无重复子串为 [prevStart, i]
        // 4. 3中①要更新 prevStart = lasti，供下一个字符i+1使用，3中②无需更新，下次仍然使用prevStart
        
        if s.isEmpty { return 0 }
        let utf8Chars = Array(s.utf8)
        var lastIndexs = [Int](repeating: -1, count: 26) // 只包含小写字母，使用26长度数组存储，ASCII值作为索引
        var prevStart = 0 // i - 1 位置最大无重复子串为起始位置
        let baseIndex = Int(("a" as Character).asciiValue ?? 97) // a-z (97..)
        
        // 0位置默认值
        lastIndexs[Int(utf8Chars[0]) - baseIndex] = 0
        prevStart = 0 // [0, 0] <== [prevStart, i]
        var maxLength = 1 // 0 - 0 + 1 (length = i - prevStart + 1)
        
        for i in 1..<utf8Chars.count { // i应该从1开始，0位置特殊，之前已经处理默认为1
            // 找到该字符上一次出现的位置，没有则默认为 -1
            
            let lastIndex = Int(utf8Chars[i]) - baseIndex
            let lasti = lastIndexs[lastIndex]
            // 记录当前字符
            lastIndexs[lastIndex] = i
            
            if lasti < prevStart {
                // 如果上一个字符出现在 [prevStart, i-1] 的左边，则当前结果为 [prevStart, i]
                // 无需改变prevStart
            } else {
                // 如果上一个字符出现在 [prevStart, i-1] 范围内，则当前结果为 [lasti + 1, i]
                // 更新prevStart，记录 i 结尾的最大无重复子串范围
                prevStart = lasti + 1
            }
            maxLength = max(maxLength, i - prevStart + 1)
        }
        return maxLength
    }
    
    //MARK: - 进阶解法3（找出以每一个字符结尾的最大无重复子串），假设字符串只包含单字符字母（ASCII字符 0-127）O(n)
    func lengthOfLongestSubstring5(_ s: String) -> Int {
        // 1. 遍历到某个字符 i，先看以 i-1 结尾的最大无重复子串的起始位置 prevStart [prevStart, i-1]范围内的字符不重复
        // 2. 查看遍历过的字符串中，找出上次出现和 i 同字符的位置 lasti （如果没出现过，则为默认 -1）
        // 3. ①如果 lasti 在 [prevStart, i-1] 范围内，即 i >= prevStart，则以i结尾的最大无重复子串为 [lasti + 1, i]
        //    ②如果 lasti 在 [prevStart, i-1] 范围外，即 i < prevStart 或者 i = -1，则以i结尾的最大无重复子串为 [prevStart, i]
        // 4. 3中①要更新 prevStart = lasti，供下一个字符i+1使用，3中②无需更新，下次仍然使用prevStart
        
        if s.isEmpty { return 0 }
        let utf8Chars = Array(s.utf8)
        var lastIndexs = [Int](repeating: -1, count: 128) // 只包含单字符字母（ASCII字符 0-127），使用128长度数组存储，ASCII值作为索引
        var prevStart = 0 // i - 1 位置最大无重复子串为起始位置
        
        // 0位置默认值
        lastIndexs[Int(utf8Chars[0])] = 0
        prevStart = 0 // [0, 0] <== [prevStart, i]
        var maxLength = 1 // 0 - 0 + 1 (length = i - prevStart + 1)
        
        for i in 1..<utf8Chars.count { // i应该从1开始，0位置特殊，之前已经处理默认为1
            // 找到该字符上一次出现的位置，没有则默认为 -1
            let lastIndex = Int(utf8Chars[i])
            let lasti = lastIndexs[lastIndex]
            // 记录当前字符
            lastIndexs[lastIndex] = i
            
            if lasti < prevStart {
                // 如果上一个字符出现在 [prevStart, i-1] 的左边，则当前结果为 [prevStart, i]
                // 无需改变prevStart
            } else {
                // 如果上一个字符出现在 [prevStart, i-1] 范围内，则当前结果为 [lasti + 1, i]
                // 更新prevStart，记录 i 结尾的最大无重复子串范围
                prevStart = lasti + 1
            }
            maxLength = max(maxLength, i - prevStart + 1)
        }
        return maxLength
    }
}

do {
    let chars = Array("abcabcbb".utf8)
    
    print(chars.count)
    
    
    print("au       --> 2：" ,Solution().lengthOfLongestSubstring1("au"))
    print("abcabcbb --> 3：" ,Solution().lengthOfLongestSubstring1("abcabcbb"))
    print("bbbbb    --> 1：" ,Solution().lengthOfLongestSubstring1("bbbbb"))
    print("pwwkew   --> 3：" ,Solution().lengthOfLongestSubstring1("pwwkew"))
}

