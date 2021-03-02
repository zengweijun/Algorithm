//
//  main.swift
//  _76_最小覆盖子串
//
//  Created by 曾维俊 on 2020/3/15.
//  Copyright © 2020 Nius. All rights reserved.
//

import Foundation

/*
 给你一个字符串 S、一个字符串 T，请在字符串 S 里面找出：包含 T 所有字母的最小子串。

 示例：

 输入: S = "ADOBECODEBANC", T = "ABC"
 输出: "BANC"
 
 说明：
 如果 S 中不存这样的子串，则返回空字符串 ""。
 如果 S 中存在这样的子串，我们保证它是唯一的答案。

 来源：力扣（LeetCode）
 链接：https://leetcode-cn.com/problems/minimum-window-substring
 */

/* 遇到子串问题，先考虑“滑动窗口”
窗口算法抽象 {
    int left = 0, right = 0;
    while (right < s.size()) {
        window.add(s[right]);
        right++;
        
        while (valid) {
            window.remove(s[left]);
            left++;
        }
    }
}

作者：labuladong
链接：https://leetcode-cn.com/problems/find-all-anagrams-in-a-string/solution/hua-dong-chuang-kou-tong-yong-si-xiang-jie-jue-zi-/
*/
class Solution {
    // MARK: - 滑动窗口 O(n + m)
    func minWindow1(_ s: String, _ t: String) -> String {
        let sChars = s.map{$0}
        let tChars = t.map{$0}
        let sCount = sChars.count
        let tCount = tChars.count
        if sCount < tCount { return "" }
        
        var needs = [Character: Int]()
        var window = [Character: Int]()
        
        // 记录t每个字符出现次数 aaabcdd [a:3, b:1, c:1, d:2]
        for char in tChars { needs[char, default: 0] += 1 } // O(m)
        let needCount = needs.count
        
        var left = 0
        var right = 0
        var match = 0
        
        var start = 0
        var minLen = Int.max
        
        while right < sCount { // O(2n)
            // 1.扩大窗口
            let char1 = sChars[right]
            if needs[char1] != nil { // t中存在同样字符，则在窗口中记录
                window[char1, default: 0] += 1
                if window[char1] == needs[char1] {
                    match += 1 // 匹配成功一个字符
                }
            }
            right += 1
            
            // 2.缩小窗口
            while match == needCount { // 匹配字符数量满足条件
                let windLen = right - left
                if windLen < minLen {
                    start = left
                    minLen = windLen
                }
                
                let char2 = sChars[left]
                if needs[char2] != nil {
                    window[char2, default: 0] -= 1
                    if window[char2, default: 0] < needs[char2, default: 0] {
                        match -= 1
                    }
                }
                left += 1
            }
        }

        return minLen == Int.max ? "" : String( sChars[start...(start+minLen-1)] )
    }
    
    
    // https://leetcode-cn.com/problems/minimum-window-substring/solution/zui-xiao-fu-gai-zi-chuan-by-leetcode-2/
    // MARK: - 滑动窗口优化 O(n + m) [S中包含大量T中不存在的字符时，效果才比较明显，否则无需优化]
    // 优化思路是剔除s中无效字符（这些字符不在t中）得到一个新序列filtered_S，然后在这个filtered_S上使用滑动窗口
    // filtered_S需要保留有效字符（这些字符在t中）和其对应的下标
    /* "ADOBECODEBANC", "ABC"
        filtered_S = [(A,0), (B,3), (C,5), (B,9), (A,10), (C,12)]
     */
    // 当 filtered_S.length <<< S.length 时，优化效果显著。这种情况可能是由于T 的长度远远小于S，因此S 中包括大量T中不存在的字符
    func minWindow2(_ s: String, _ t: String) -> String {
        let sChars = s.map{$0}
        let tChars = t.map{$0}
        let sCount = sChars.count
        let tCount = tChars.count
        if sCount < tCount { return "" }
        
        var needs = [Character: Int]()
        var window = [Character: Int]()
        
        // 记录t每个字符出现次数 aaabcdd [a:3, b:1, c:1, d:2]
        for char in tChars { needs[char, default: 0] += 1 } // O(m)
        let needCount = needs.count
        
        // 上滑动窗口滑动的字符串变得更短
        var filtered_S = [(Character, Int)]()
        for i in 0..<sCount { // O(n)
            let char = sChars[i]
            if needs[char] != nil { // 有效字符
                filtered_S.append((char, i))
            }
        }
        
        var left = 0
        var right = 0
        var match = 0
        
        var start = 0
        var minLen = Int.max
        
        while right < filtered_S.count { // O(filtered_S.count)
            // 1.扩大窗口
            let char1 = filtered_S[right].0
            // t中一定存在同样字符，在窗口中记录
            window[char1, default: 0] += 1
            if window[char1] == needs[char1] {
                match += 1 // 匹配成功一个字符
            }
            right += 1
            
            // 2.缩小窗口
            while match == needCount { // 匹配字符数量满足条件
                let leftIndex = filtered_S[left].1
                let rightIndex = filtered_S[right - 1].1
                let windLen = rightIndex - leftIndex + 1 // 闭区间[rightIndex, leftIndex]
                if windLen < minLen {
                    start = leftIndex
                    minLen = windLen
                }
                
                let char2 = filtered_S[left].0
                window[char2, default: 0] -= 1
                if window[char2, default: 0] < needs[char2, default: 0] {
                    match -= 1
                }
                left += 1
            }
        }

        return minLen == Int.max ? "" : String( sChars[start...(start+minLen-1)] )
    }
}

do {
    do {
//        print(Solution().minWindow2("aa", "s"))
        print(Solution().minWindow2("ADOBECODEBANC", "ABC"))
    }
}

