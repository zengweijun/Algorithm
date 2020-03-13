//
//  main.swift
//  _242_有效的字母异位词
//
//  Created by nius on 2020/3/13.
//  Copyright © 2020 nius. All rights reserved.
//

import Foundation

/**
 给定两个字符串 s 和 t ，编写一个函数来判断 t 是否是 s 的字母异位词。
 示例 1:

 输入: s = "anagram", t = "nagaram"
 输出: true
 示例 2:

 输入: s = "rat", t = "car"
 输出: false
 说明:
 你可以假设字符串只包含小写字母。

 进阶:
 如果输入字符串包含 unicode 字符怎么办？你能否调整你的解法来应对这种情况？

 来源：力扣（LeetCode）
 链接：https://leetcode-cn.com/problems/valid-anagram
 */

class Solution {
    // 字母异位词，即单词的组成字母相同，但是字母的位置不同
    // 基本思想：遍历第一个字符串，记录每个字符出现的次数，再遍历第二个字符串，对比字符出现次数是否相同
    func isAnagram_conatainsUnicode(_ s: String, _ t: String) -> Bool {
        // if s.count == 0 || t.count == 0 { return true } // 都为空，返回true
        if s.count != t.count { return false } // 长度不等，不是异位词
        
        // 使用字典记录每个词出现次数
        var dic = [Character : Int]()
        
        // 字符串charAt取字符需要调用方法，这里先转为字符数组，使用下标字符避免方法调用(数组下标应该是编译器优化或者内联)
        let sArr = s.map{$0}
        let tArr = t.map{$0}
        
        // 1.遍历第一个字符串，记录每个字符出现次数
        for char in sArr {
            if var cnt = dic[char] {
                cnt += 1
                dic[char] = cnt
            } else {
                dic[char] = 1
            }
        }
        
        // 2.遍历第二个字符串，去dic中取出该字符出现次数，如果次数为0或nil，直接返回false
        // 如果次数大于0，则将该次数减1，继续遍历下一个字符
        // 重复字符下（比如2个a），当第一次遍历a时，次数2-1=1，第二次遍历到a，1-1=0，当第三次再遍历到a，发现为0，返回false
        for char in tArr {
            if var cnt = dic[char] {
                if cnt == 0 { return false } // 次数为0
                cnt -= 1
                dic[char] = cnt
            } else { // 次数为nil，说明第一个字符串没有出现过该字符
                return false
            }
        }
        
        // 来到这里，说明是字母异位词
        return true
    }
    
    // 假设小写字母
    // 如果只有小写字母，使用array替代dictionary，会更加高效
    func isAnagram_conatainsLowercase(_ s: String, _ t: String) -> Bool {
        // if s.count == 0 || t.count == 0 { return true } // 都为空，返回true
        if s.count != t.count { return false } // 长度不等，不是异位词
        
        // 使用数组记录（由于只有小写字母，使用26个位置即可）
        var counts = [Int](repeating: 0, count: 26)
        let beginValue = Int(("a" as Character).asciiValue ?? 97)
        
        
        // swift要获取字符串中每个字符的ascii值，使用unicodeScalars遍历
        // 1.遍历第一个字符串，记录每个字符出现次数
        for charScalar in s.unicodeScalars {
            let index = Int(charScalar.value) - beginValue
            counts[index] += 1
        }
        
        // 2.遍历第二个字符串，去counts中取出该字符对应索引出现次数，如果次数为0，直接返回false
        // 如果次数大于0，则将该次数减1，继续遍历下一个字符
        // 重复字符下（比如2个a），当第一次遍历a时，次数2-1=1，第二次遍历到a，1-1=0，当第三次再遍历到a，发现为0，返回false
        for charScalar in t.unicodeScalars {
            let index = Int(charScalar.value) - beginValue
            if counts[index] == 0 { return false } // 字符索引对应次数为0
            counts[index] -= 1
        }

        return true
    }
    
    // 最后再去检查数组是否清0
    func isAnagram_conatainsLowercase1(_ s: String, _ t: String) -> Bool {
        // if s.count == 0 || t.count == 0 { return true } // 都为空，返回true
        if s.count != t.count { return false } // 长度不等，不是异位词
        
        // 使用数组记录（由于只有小写字母，使用26个位置即可）
        var counts = [Int](repeating: 0, count: 26)
        let beginValue = Int(("a" as Character).asciiValue ?? 97)
        
        
        // swift要获取字符串中每个字符的ascii值，使用unicodeScalars遍历
        // 1.遍历第一个字符串，记录每个字符出现次数
        for charScalar in s.unicodeScalars {
            let index = Int(charScalar.value) - beginValue
            counts[index] += 1
        }
        
        // 2.遍历第二个字符串，去counts中取出该字符对应索引出现次数，如果次数为0，直接返回false
        // 如果次数大于0，则将该次数减1，继续遍历下一个字符
        // 重复字符下（比如2个a），当第一次遍历a时，次数2-1=1，第二次遍历到a，1-1=0，当第三次再遍历到a，发现为0，返回false
        for charScalar in t.unicodeScalars {
            let index = Int(charScalar.value) - beginValue
            counts[index] -= 1
        }
        
        for count in counts {
            if count != 0 {
                return false
            }
        }

        return true
    }
}


do {
    print("conatainsUnicode----------------------------------------")
    print("conatainsUnicode", "            anagram、nagaram: ", Solution().isAnagram_conatainsUnicode("anagram", "nagaram"))
    print("conatainsUnicode", "      anagram哈哈、哈na哈garam: ", Solution().isAnagram_conatainsUnicode("anagram哈哈", "哈na哈garam"))
    print("conatainsUnicode", "                    rat、car: ", Solution().isAnagram_conatainsUnicode("rat", "car"))
    
    print("conatainsLowercase----------------------------------------")
    print("conatainsLowercase", "      anagram、nagaram: ", Solution().isAnagram_conatainsLowercase("anagram", "nagaram"))
    print("conatainsLowercase", "              rat、car: ", Solution().isAnagram_conatainsLowercase("rat", "car"))
}
