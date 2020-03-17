//
//  main.swift
//  _7_整数反转
//
//  Created by nius on 2020/3/17.
//  Copyright © 2020 nius. All rights reserved.
//

import Foundation
/*
 给出一个 32 位的有符号整数，你需要将这个整数中每位上的数字进行反转。

 示例 1:
 输入: 123
 输出: 321

  示例 2:
 输入: -123
 输出: -321

 示例 3:
 输入: 120
 输出: 21
 注意:
 假设我们的环境只能存储得下 32 位的有符号整数，则其数值范围为 [−2^31,  2^31 − 1]。请根据这个假设，如果反转后整数溢出那么就返回 0。

 来源：力扣（LeetCode）
 链接：https://leetcode-cn.com/problems/reverse-integer
 */

class Solution {
    func reverse(_ x: Int) -> Int {
        
        // 记录符号(变为正数处理)
        var symbol = 1
        var num = x
        if x < 0 {
            symbol = -1
            num = -x
        }
        
        // 逆序读取一个整数的方式，使用 % 取个位，使用 / 去掉个位 --> 最终会变为 0
        var result = 0
        while num > 0 {
            result = result * 10 + num % 10
            num /= 10
            guard result < INT32_MAX else {
                return 0
            }
        }
        return result * symbol
    }
}

do {
    do {
        print(Solution().reverse(123))
        print(Solution().reverse(-123))
        print(Solution().reverse(120))
        print(Solution().reverse(1534236469))
    }
}
