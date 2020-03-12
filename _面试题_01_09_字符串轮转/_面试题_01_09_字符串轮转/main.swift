//
//  main.swift
//  _面试题_01_09_字符串轮转
//
//  Created by nius on 2020/3/12.
//  Copyright © 2020 nius. All rights reserved.
//

import Foundation

/**
 字符串轮转。给定两个字符串s1和s2，请编写代码检查s2是否为s1旋转而成（比如，waterbottle是erbottlewat旋转后的字符串）。

 示例1:

  输入：s1 = "waterbottle", s2 = "erbottlewat"
  输出：True
 示例2:

  输入：s1 = "aa", "aba"
  输出：False
 提示：

 字符串长度在[0, 100000]范围内。
 
 说明:
 你能只调用一次检查子串的方法吗？

 来源：力扣（LeetCode）
 链接：https://leetcode-cn.com/problems/string-rotation-lcci
 */

class Solution {
    func isFlipedString(_ s1: String, _ s2: String) -> Bool {
        /** 分析
            s = ABCD 的所有旋转词 --> DABC --> CDAB --> BCDA
            将两个s拼接红藕 s + s = ABCD + ABCD = ABCDABCD
            发现，s 的所有旋转词都是 s+s 的子串
            所以，只需判断 s2 是否是 s1 + s1 的子串即可
         
            旋转词两个条件：
            1、s1和s2长度必须相等，比如 abc 和 ab 不能构成旋转词
            2、s2 是 s1+s1 的子串
         */
        if s1.count != s2.count { return false }
        if s1.count == 0 || s2.count == 0 { return true }
        return (s1 + s1).contains(s2)
    }
}

do {
    print("", Solution().isFlipedString("waterbottle", "erbottlewat"))
    print("", Solution().isFlipedString("aa", "aba"))
    print("", Solution().isFlipedString("", ""))
}
