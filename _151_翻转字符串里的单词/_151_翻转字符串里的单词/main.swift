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
     3.翻转（逆序）单个单词
     例子："  a good   example "
     1. "a good example"
     2. "elpmaxe doog a"
     3. "example good a" (结果)
     
     其中，第二三步功能一致，只是翻转的范围不同，可以封装一个函数
     */
    func reverseWords(_ s: String) -> String {
        
        // [begin, end)，左闭右开
        func reverseChars(_ chars: inout [Character], begin: Int, end: Int) {
            var begin = begin
            var end = end - 1 // end 左闭右开
            while begin < end { // 对称交换
                let char = chars[begin]
                chars[begin] = chars[end]
                chars[end] = char
                begin += 1
                end -= 1
            }
        }
        
        
        var chars = s.map{$0}
        
        
        // 1.去除字符串中多余的空格（首尾多余，单词间多余），将后边字符往前拷贝以重新排布，下面用+代替空格表示
        // "a+good+++example"  ==> "a+good+examplele"，该字符数组有效长度应该比以前少2（丢弃尾部le）
        // "+++a+good+++example++"  ==> "a+good+exampleample++"，该字符数组有效长度应该比以前少6（丢弃尾部ample++）
        // 将后边的字符向前拷贝(如果有多余的空格)，过滤掉多余的字符
        var destIndex = 0           // 目标位置(遍历到的字符拷贝到这个位置)
        let validatedLength: Int    // 去除多余空格后的有效字符串长度
        var prevCharIsWhitespace = true // 当前字符的上一个字符是否是空格(一开始默认为true，如果字符串首部有空格，则直接过滤掉)
        for i in stride(from: 0, to: chars.count, by: 1) {
            // "a good   example"
            // "  a good   example  "
            let curChar = chars[i]
            if !curChar.isWhitespace || !prevCharIsWhitespace {
                // ①当前字符不是空格，向前destIndex位置拷贝，destIndex后移一个字符
                // ②当前字符是空格，但上一个不是空格，那就属于正常现象，该空格也要往前destIndex位置拷贝，destIndex后移一个字符
                chars[destIndex] = curChar
                destIndex += 1
            } else {
                // 当前字符是空格 并且 上一个字符也是空格，直接跳过
            }
            
            // 记录当前字符是否是空格，供下一个判断
            prevCharIsWhitespace = curChar.isWhitespace
        }
        // 该算法以空格结尾的时候，会造成多拷贝一个空格字符，这里去掉。来到这里prevCharIsWhitespace表示末尾是否是空格字符
        validatedLength = prevCharIsWhitespace ? destIndex - 1 : destIndex
        //print(chars)
        
        
        // 2.翻转（逆序）整个字符串
        reverseChars(&chars, begin: 0, end: validatedLength)
        //print(chars)
        
        // 3.翻转（逆序）单个单词，使用滑块技术
        var left = 0
        for right in stride(from: 1, to: validatedLength, by: 1) {
            let curChar = chars[right]
            if curChar.isWhitespace {
                // 遍历到空格，说明[left, right)为一个单词，执行单词反转
                reverseChars(&chars, begin: left, end: right)
                left = right + 1 // 滑块右移
                // 这里使用空格来标识单词结束，会导致最后一个单词没有反转，最后需要补充处理
            }
        }
        // 反转最后一个单词
        reverseChars(&chars, begin: left, end: validatedLength)
        //print(chars)
        
        // 4.使用数组构建字符串
        var result = ""
        for i in stride(from: 0, to: validatedLength, by: 1) {
            result.append(chars[i])
        }
        return result
    }
    
    // 使用系统API
    func reverseWords1(_ s: String) -> String {
        // 1、先使用空格切割字符串（空格不会进入序列）+ 逆序序列 + 变为数组
        let strs = s.split(separator: " ").reversed().map { String($0) }
        
        // 2、重组字符串
        var result = ""
        for i in 0..<strs.count {
            // 非首字符，前边添加空格
            result += i == 0 ? strs[i] : " \(strs[i])"
        }
        return result
    }
}

do {
    
    
    do {
        print("^\(Solution().reverseWords1("the sky is blue"))$")
        print("^\(Solution().reverseWords1("a good   example"))$")
        print("^\(Solution().reverseWords1("  a good   example  "))$")
        print("^\(Solution().reverseWords1("  hello world!  "))$")
    }
}
