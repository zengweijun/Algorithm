//
//  main.swift
//  _151_翻转字符串里的单词
//
//  Created by 曾维俊 on 2020/3/13.
//  Copyright © 2020 Nius. All rights reserved.
//

import Foundation

/**
 给定一个字符串，逐个翻转字符串中的每个单词。

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
  

 进阶：
 请选用 C 语言的用户尝试使用 O(1) 额外空间复杂度的原地解法。

 来源：力扣（LeetCode）
 链接：https://leetcode-cn.com/problems/reverse-words-in-a-string
 */

class Solution {
    /**
     分为三步
     1.去除字符串中多余的空格（首尾多余，单词间多余）
     2.翻转（逆序）整个字符串
     3.翻转（逆序）单个单次
     例子："  a good   example "
     1. "a good example"
     2. "elpmaxe doog a"
     3. "example good a" (结果)
     
     其中，第二三步功能一致，只是翻转的范围不同，可以封装一个函数
     */
    func reverseWords(_ s: String) -> String {
        
        // [begin, end)
        func reverseChars(_ chars: inout [Character], begin: Int, end: Int) {
            
        }
        
        
        var chars = s.map{$0}
        
        
        // 1.去除字符串中多余的空格（首尾多余，单词间多余）
        // 将后边的字符向前拷贝(如果有多余的空格)，过滤掉多余的字符
        var destIndex = 0 // 目标位置
        var length = 0    // 去除多余空格后的字符串长度
        var prevCharIsWhitespace = false // 当前字符的上一个字符是否是空格
        for curChar in chars {
            // "a good   example"
            // "  a good   example  "
            print(curChar == " " ? "空格" : curChar)
            if curChar.isWhitespace {
                if prevCharIsWhitespace {
                    // 上一个也是空格，过滤掉该字符（跳过），继续下一个
                } else {
                    // 上一个不是空格，那就属于正常现象，该空格也要往前拷贝
                    chars[destIndex] = curChar
                    destIndex += 1
                }
                prevCharIsWhitespace = true // 遍历到了一个空格
            } else {
                // 不是空格，记录上一个字符不是空格
                prevCharIsWhitespace = false

                // 将当前字符拷贝到目标位置（有可能原地不动，如果没有多余的空格）
                chars[destIndex] = curChar
                destIndex += 1
            }
        }
        length = destIndex
        
        print(chars)
        reverseChars(&chars, begin: 0, end: length)
        print(chars)
        for i in 0..<length {
            
        }
        
        return "Hello, World!"
    }
    
    
    
    func reverseWords1(_ s: String) -> String {
        
        
        return "Hello, World!"
    }
}

do {
    do {

//        print(Solution().reverseWords("  a good   example  "))
        print(Solution().reverseWords("a good   example"))
//        print(Solution().reverseWords("the sky is blue"))
//        print(Solution().reverseWords("  hello world!  "))
    }
}
