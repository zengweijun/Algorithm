//
//  main.swift
//  _49_字母异位词分组
//
//  Created by nius on 2020/3/14.
//  Copyright © 2020 nius. All rights reserved.
//

import Foundation
/*
 给定一个字符串数组，将字母异位词组合在一起。字母异位词指字母相同，但排列不同的字符串。

 示例:

 输入: ["eat", "tea", "tan", "ate", "nat", "bat"],
 输出:
 [
   ["ate","eat","tea"],
   ["nat","tan"],
   ["bat"]
 ]
 
 说明：
 所有输入均为小写字母。
 不考虑答案输出的顺序。

 来源：力扣（LeetCode）
 链接：https://leetcode-cn.com/problems/group-anagrams
 */

class Solution {
    //MARK: - 最坏 ≈ O(n^3)
    func groupAnagrams(_ strs: [String]) -> [[String]] {
        func isAnagram(_ s1: String, _ s2: String) -> Bool { // O(n)
            if s1.count != s2.count { return false }
            var counts = [Int](repeating: 0, count: 26) // 小写字母
            let baseIndex = Int(("a" as Character).asciiValue ?? 97)
            
            // unicodeScalar.value取出字符的unicode值（单字节字符会取出ASCII值）
            // 1.记录第一个串每个字符出现的次数
            for unicodeScalar in s1.unicodeScalars {
                let charToIndex = Int(unicodeScalar.value) - baseIndex
                counts[charToIndex] += 1
            }
            
            // 2.根据第二个串字符出现的次数抵消第一个中记录的次数，看是否刚好抵消
            for unicodeScalar in s2.unicodeScalars {
                let charToIndex = Int(unicodeScalar.value) - baseIndex
                if counts[charToIndex] == 0 {
                    return false // 将3合并到这里
                }
                counts[charToIndex] -= 1
            }
            
            /*
            // 3.检查是否刚好抵消(应该全部为0)
            for count in counts {
                if count != 0 { return false }
            }
            */
            return true
        }
        
        if strs.count == 0 { return [] }
        
        var results = [[String]]()
        for str in strs { // O(n)
            
            var findIndex = -1
            var subResult: [String] = []
            for i in 0..<results.count { // 序列长度类型数量m O(m)
                let result = results[i]
                if let last = result.last, isAnagram(last, str) { // O(k) 字符串平均长度k
                    subResult = result
                    subResult.append(str)
                    findIndex = i
                    break
                }
            }
            if findIndex == -1 {
                subResult.append(str)
                results.append(subResult)
            } else {
                results[findIndex] = subResult
            }
        } // O(n * m * k) 最坏 ≈ O(n^3)
        return results
    }
    
    
    //MARK: - O(n * k * logk)
    func groupAnagrams1(_ strs: [String]) -> [[String]] {
        // 用map分组，吧遍历到的每个字符串排序作为key，添加到key对应的分组中
        // 因为字母异位词排序后相同
        if strs.count == 0 { return [] }
        var resultDic = [String: [String]]()
        for str in strs { // O(n)
            let key = String(str.sorted()) // O(k * logk)
            if let result = resultDic[key] {
                var result = result
                result.append(str)
                resultDic[key] = result
            } else {
                resultDic[key] = [str]
            }
            
        }
        return Array(resultDic.values)
    }
    
    //MARK: - O(n * k * logk) 重构
    func groupAnagrams2(_ strs: [String]) -> [[String]] {
        // 用map分组，吧遍历到的每个字符串排序作为key，添加到key对应的分组中
        // 因为字母异位词排序后相同
        if strs.count == 0 { return [] }
        var resultDic = [String: [String]]()
        for str in strs { // O(n)
            let key = String(str.sorted()) // O(k * logk)
            resultDic[key, default: []].append(str)
        }
        return Array(resultDic.values)
    }
    
    // MARK: - O(n * k) 计数排序思想(计数散列)
    func groupAnagrams3(_ strs: [String]) -> [[String]] {
        // 用map分组，吧遍历到的每个字符串排序作为key，添加到key对应的分组中
        // 因为字母异位词排序后相同
        // key：都是小写字母，所以统计每个字符出现的次数放入counts数组（长度26）中，将counts数组结果拼接为一个字符串
        // 思路：当且仅当它们的字符计数（每个字符的出现次数）相同时，两个字符串是字母异位词
        func countingKey(_ str: String) -> String { // O(n)
            // 采用计数散列算法
            var counts = [Int](repeating: 0, count: 26)
            let baseIndex = Int(("a" as Character).asciiValue ?? 97)
            
            for unicodeScalar in str.unicodeScalars {
                let charToIndex = Int(unicodeScalar.value) - baseIndex
                counts[charToIndex] += 1
            }
            
            // 使用#分割拼接字符串，否则 [1, 23] -> "123", [12, 3] -> "123" 无法区分
            // [1, 0, 3, 0 ...] --> 使用 # 分割，#1#0#3#0...
            var key = ""
            for count in counts {
                key.append("#\(count)")
            }
            return key
        }
        
        if strs.count == 0 { return [] }
        var resultDic = [String: [String]]()
        // O(n * k)
        for str in strs { // O(n)
            let key = countingKey(str) // O(k)
            resultDic[key, default: []].append(str)
        }
        return Array(resultDic.values)
    }
    
    // MARK: - O(n * k) 散列，未看散列算法(效率最高)
    func groupAnagrams4(_ strs: [String]) -> [[String]] {
        // 用map分组，吧遍历到的每个字符串排序作为key，添加到key对应的分组中
        // 因为字母异位词排序后相同
        // key：都是小写字母，所以统计每个字符出现的次数放入counts数组（长度26）中，将counts数组结果拼接为一个字符串
        // 思路：当且仅当它们的字符计数（每个字符的出现次数）相同时，两个字符串是字母异位词
        func hashValue(_ str: String) -> UInt64 { // O(n)
            // 采用计数散列算法（该算法未看懂，待研究）
            var hash: UInt64 = 0
            for unicodeScalar in str.unicodeScalars {
                let value = unicodeScalar.value - 97
                hash += UInt64(pow(5.0, Double(value)))
            }
            return hash
        }
        
        if strs.count == 0 { return [] }
        var resultDic = [UInt64: [String]]()
        // O(n * k)
        for str in strs { // O(n)
            let key = hashValue(str) // O(k)
            resultDic[key, default: []].append(str)
        }
        return Array(resultDic.values)
    }
}

do {
    do {
        print(Solution().groupAnagrams(["eat", "tea", "tan", "ate", "nat", "bat"]))
        print(Solution().groupAnagrams1(["eat", "tea", "tan", "ate", "nat", "bat"]))
        print(Solution().groupAnagrams2(["eat", "tea", "tan", "ate", "nat", "bat"]))
        print(Solution().groupAnagrams3(["eat", "tea", "tan", "ate", "nat", "bat"]))
    }
}

