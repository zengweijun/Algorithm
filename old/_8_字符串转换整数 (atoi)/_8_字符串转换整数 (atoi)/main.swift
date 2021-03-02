//
//  main.swift
//  _8_字符串转换整数 (atoi)
//
//  Created by nius on 2020/3/17.
//  Copyright © 2020 nius. All rights reserved.
//

import Foundation

/*
 请你来实现一个 atoi 函数，使其能将字符串转换成整数。

 首先，该函数会根据需要丢弃无用的开头空格字符，直到寻找到第一个非空格的字符为止。

 当我们寻找到的第一个非空字符为正或者负号时，则将该符号与之后面尽可能多的连续数字组合起来，作为该整数的正负号；假如第一个非空字符是数字，则直接将其与之后连续的数字字符组合起来，形成整数。

 该字符串除了有效的整数部分之后也可能会存在多余的字符，这些字符可以被忽略，它们对于函数不应该造成影响。

 注意：假如该字符串中的第一个非空格字符不是一个有效整数字符、字符串为空或字符串仅包含空白字符时，则你的函数不需要进行转换。

 在任何情况下，若函数不能进行有效的转换时，请返回 0。

 说明：

 假设我们的环境只能存储 32 位大小的有符号整数，那么其数值范围为 [−231,  231 − 1]。如果数值超过这个范围，请返回  INT_MAX (231 − 1) 或 INT_MIN (−231) 。

 示例 1:

 输入: "42"
 输出: 42
 示例 2:

 输入: "   -42"
 输出: -42
 解释: 第一个非空白字符为 '-', 它是一个负号。
      我们尽可能将负号与后面所有连续出现的数字组合起来，最后得到 -42 。
 示例 3:

 输入: "4193 with words"
 输出: 4193
 解释: 转换截止于数字 '3' ，因为它的下一个字符不为数字。
 示例 4:

 输入: "words and 987"
 输出: 0
 解释: 第一个非空字符是 'w', 但它不是数字或正、负号。
      因此无法执行有效的转换。
 示例 5:

 输入: "-91283472332"
 输出: -2147483648
 解释: 数字 "-91283472332" 超过 32 位有符号整数范围。
      因此返回 INT_MIN (−2^31) 。

 来源：力扣（LeetCode）
 链接：https://leetcode-cn.com/problems/string-to-integer-atoi
 */

class Solution {
    func myAtoi(_ str: String) -> Int {
        // 几条规则
        // 1.开头字符如果不是 +/-或数字，则只能为空格（我们可以针对性地过滤掉开头空格）
        // 2.此时开头部分只能是 +/-或者数字，如果是+/-只能出现一个，比如+3、-3，不能为+-3、--3等
        // 根据此规则，该字符串的合法布局为：{空格...空格}{一个+/-}[数字...数字]{任意字符...}，{}表示可选
        
        let strChars = Array(str)
        let strCount = strChars.count
        var symbol = 1
        
        // 使用指针标识数字位置
        var i = 0
        // 1.过滤掉开始字符
        while i < strCount && strChars[i] == " " { // 非空格不进入
            i += 1
        }
        if i == strCount { return 0 } // 全是空格
        
        // 2.判断正负，空格之后只能出现一个正负号
        // 遇到正号或者负号记录符号，然后后移
        if strChars[i] == "-" {
            i += 1
            symbol = -1
        } else if strChars[i] == "+" {
            i += 1
            symbol = 1
        }
        
        // 3.正负符号之后，只能为数字，如果不是数字，则为0
        var result = 0
        while i < strCount && strChars[i].isNumber { // 非数字进入
            result = result * 10 + (Int(String(strChars[i])) ?? 0)
            if symbol > 0 && result * symbol > Int32.max {
                return Int(Int32.max)
            } else if symbol < 0 && result * symbol < Int32.min {
                return Int(Int32.min)
            }
            i += 1
        }
        result = result * symbol
        return result
    }
}


print("^         42^: ", Solution().myAtoi("42"))
print("^        -42^: ", Solution().myAtoi("   -42"))
print("^       4193^: ", Solution().myAtoi("4193 with words"))
print("^          0^: ", Solution().myAtoi("words and 987"))
print("^-2147483648^: ", Solution().myAtoi("-91283472332"))
print("^20000000000000000000^: ", Solution().myAtoi("20000000000000000000"))


