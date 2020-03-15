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
}

do {
    do {
        print(Solution().findAnagrams("cbaebabacd", "abc"))
        print(Solution().findAnagrams("abab", "ab"))
    }
}

