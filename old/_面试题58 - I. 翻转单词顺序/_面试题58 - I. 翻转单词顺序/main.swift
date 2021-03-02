//
//  main.swift
//  _面试题58 - I. 翻转单词顺序
//
//  Created by nius on 2020/3/14.
//  Copyright © 2020 nius. All rights reserved.
//

import Foundation

/*
 输入一个英文句子，翻转句子中单词的顺序，但单词内字符的顺序不变。为简单起见，标点符号和普通字母一样处理。例如输入字符串"I am a student. "，则输出"student. a am I"。

  

 示例 1：

 输入: "the sky is blue"
 输出: "blue is sky the"
 示例 2：

 输入: "  hello world!  "
 输出: "world! hello"
 解释: 输入字符串可以在前面或者后面包含多余的空格，但是反转后的字符不能包括。
 示例 3：

 输入: "a good   example"
 输出: "example good a"
 解释: 如果两个单词间有多余的空格，将反转后单词间的空格减少到只含一个。
  

 说明：

 无空格字符构成一个单词。
 输入字符串可以在前面或者后面包含多余的空格，但是反转后的字符不能包括。
 如果两个单词间有多余的空格，将反转后单词间的空格减少到只含一个。
 注意：本题与主站 151 题相同：https://leetcode-cn.com/problems/reverse-words-in-a-string/

 注意：此题对比原题有改动

 来源：力扣（LeetCode）
 链接：https://leetcode-cn.com/problems/fan-zhuan-dan-ci-shun-xu-lcof
 */

class Solution {
    // 参考151
    func reverseWords1(_ s: String) -> String {
        // 1.去掉空格（标记有效部分长度len）
        let len = 0
        let sChars = s.map {$0}
        var prevIsWhitespace = true
        for char in sChars {
            
        }
        
        // 2.逆序len
        // .. 头尾两两交换 reverse(0, len)
        
        // 3.逆序单个单词
        // .. 头尾两两交换 reverse(start, wLen)
        
        return s
    }
    
    func reverseWords2(_ s: String) -> String {
        let strs = s.split(separator: " ").reversed().map{String($0)}
        var result = ""
        for i in 0..<strs.count {
            result += (i == 0) ? strs[i] : " " + strs[i]
        }
        return result
    }
}


do {
    do {
        
//        print("^\(Solution().reverseWords1("the sky is blue"))^")
//        print("^\(Solution().reverseWords1("a good   example"))^")
//        print("^\(Solution().reverseWords1("  a good   example  "))^")
//        print("^\(Solution().reverseWords1("  hello world!  "))^")
    }
    print("-----------------------")
    do {
        print("^\(Solution().reverseWords2("the sky is blue"))^")
        print("^\(Solution().reverseWords2("a good   example"))^")
        print("^\(Solution().reverseWords2("  a good   example  "))^")
        print("^\(Solution().reverseWords2("  hello world!  "))^")
    }
}

