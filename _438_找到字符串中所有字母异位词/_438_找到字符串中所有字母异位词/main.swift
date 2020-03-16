//
//  main.swift
//  _438_找到字符串中所有字母异位词
//
//  Created by nius on 2020/3/14.
//  Copyright © 2020 nius. All rights reserved.
//

import Foundation

/*
 给定一个字符串 s 和一个非空字符串 p，找到 s 中所有是 p 的字母异位词的子串，返回这些子串的起始索引。

 字符串只包含小写英文字母，并且字符串 s 和 p 的长度都不超过 20100。

 说明：
 字母异位词指字母相同，但排列不同的字符串。
 不考虑答案输出的顺序。

 示例 1:
 输入:
 s: "cbaebabacd" p: "abc"
 输出:
 [0, 6]

 解释:
 起始索引等于 0 的子串是 "cba", 它是 "abc" 的字母异位词。
 起始索引等于 6 的子串是 "bac", 它是 "abc" 的字母异位词。
  示例 2:

 输入:
 s: "abab" p: "ab"

 输出:
 [0, 1, 2]

 解释:
 起始索引等于 0 的子串是 "ab", 它是 "ab" 的字母异位词。
 起始索引等于 1 的子串是 "ba", 它是 "ab" 的字母异位词。
 起始索引等于 2 的子串是 "ab", 它是 "ab" 的字母异位词。

 来源：力扣（LeetCode）
 链接：https://leetcode-cn.com/problems/find-all-anagrams-in-a-string
 */

// 优秀题解：https://leetcode-cn.com/problems/find-all-anagrams-in-a-string/solution/hua-dong-chuang-kou-tong-yong-si-xiang-jie-jue-zi-/
class Solution {
    // MARK: - 蛮力
    func findAnagrams(_ s: String, _ p: String) -> [Int] {
        func isAnagrams(_ s1: String, _ s2: String) -> Bool {
            // 私有方法，外部保证s1.count == s2.count
            var counts = [Int](repeating: 0, count: 26)
            let baseIndex = Int(("a" as Character).asciiValue ?? 97)
            for unicodeScalar in s1.unicodeScalars {
                counts[Int(unicodeScalar.value) - baseIndex] += 1
            }
            for unicodeScalar in s2.unicodeScalars {
                let index = Int(unicodeScalar.value) - baseIndex
                let count = counts[index]
                if count == 0 {
                    return false
                }
                counts[index] -= 1
            }
            return true
        }
        
        var results = [Int]()
        let sCount = s.count
        let pCount = p.count
        if (sCount < pCount) {return results}
        for i in 0...(sCount - pCount) {
            let startIndex = s.index(s.startIndex, offsetBy: i)
            let endIndex = s.index(startIndex, offsetBy: pCount - 1)
            let subStr = s[startIndex...endIndex]
            if isAnagrams(String(subStr), p) {
                results.append(i)
            }
        }
        return results
    }
    
    
    // MARK: - 滑动窗口（双指针算法） O(n)
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
    func findAnagrams1(_ s: String, _ p: String) -> [Int] {
        var results = [Int]()
        let sCount = s.count
        let pCount = p.count
        if (sCount < pCount) {return results}
        
        // 只包含小写英文字母
        // 只有窗口window内字符和要检查串needs字符相同时，才算匹配成功
        // aaabcdd ==> needs (a:3, b:1, c:1, d:2) pCharTypeCount: 4
        var needs =  [Int](repeating: 0, count: 128) // 记录p串字符数
        let pChars = Array(p.utf8)
        for i in 0..<pCount {
            needs[Int(pChars[i])] += 1
        }
        var pCharTypeCount = 0 //  p中字符种类数量 aaabcdd ==> 4 (a b c d)
        for charCount in needs {
            if charCount > 0 {
                pCharTypeCount += 1
            }
        }
        
        var window = [Int](repeating: 0, count: 128) // 记录串口（s子串）串字符数
        let sChars = Array(s.utf8)
        
        // 窗口边界
        var left = 0
        var right = 0
        
        var match = 0 // 匹配到的字符数
        while right < sCount {
            // 1.扩大窗口，加入right字符，right右移
            let char1 = sChars[right]
            let charToIndex1 = Int(char1)
            window[charToIndex1] += 1
            if window[charToIndex1] == needs[charToIndex1] { // 匹配成功一个字符
                match += 1
            }
            right += 1
            
            // 2.缩小窗口，移除left字符，left右移
            while match == pCharTypeCount { // 匹配成功一个子串
                if right - left == pCount { // 窗口长度合适，记录结果
                    results.append(left)
                }
                let char2 = sChars[left]
                let charToIndex2 = Int(char2)
                window[charToIndex2] -= 1
                if window[charToIndex2] < needs[charToIndex2] {
                    match -= 1
                }
                left += 1
            }
        }
        
        return results
    }
    
    
    // https://leetcode-cn.com/problems/minimum-window-substring/solution/zui-xiao-fu-gai-zi-chuan-by-leetcode-2/
    // MARK: - 滑动窗口可考虑优化（双指针算法） O(n)
    // 滑动窗口优化 [S中包含大量T中不存在的字符时，效果才比较明显，否则无需优化]
    // 优化思路是剔除s中无效字符（这些字符不在t中）得到一个新序列filtered_S，然后在这个filtered_S上使用滑动窗口
    // filtered_S需要保留有效字符（这些字符在t中）和其对应的下标
    /* "ADOBECODEBANC", "ABC"
        filtered_S = [(A,0), (B,3), (C,5), (B,9), (A,10), (C,12)]
     */
    // 当 filtered_S.length <<< S.length 时，优化效果显著。这种情况可能是由于T 的长度远远小于S，因此S 中包括大量T中不存在的字符
}

do {
    do {
        print(Solution().findAnagrams1("aaaaaa", "aa"))
        print(Solution().findAnagrams1("baa", "aa"))
        print(Solution().findAnagrams1("cbaebabacd", "abc"))
        print(Solution().findAnagrams1("abab", "ab"))
    }
}

