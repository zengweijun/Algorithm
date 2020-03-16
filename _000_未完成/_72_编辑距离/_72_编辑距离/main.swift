//
//  main.swift
//  _72_编辑距离
//
//  Created by nius on 2020/3/14.
//  Copyright © 2020 nius. All rights reserved.
//

import Foundation

/*
 给定两个单词 word1 和 word2，计算出将 word1 转换成 word2 所使用的最少操作数 。

 你可以对一个单词进行如下三种操作：

 插入一个字符
 删除一个字符
 替换一个字符
 
 示例 1:
 输入: word1 = "horse", word2 = "ros"
 输出: 3
 解释:
 horse -> rorse (将 'h' 替换为 'r')
 rorse -> rose (删除 'r')
 rose -> ros (删除 'e')
 
 示例 2:
 输入: word1 = "intention", word2 = "execution"
 输出: 5
 解释:
 intention -> inention (删除 't')
 inention -> enention (将 'i' 替换为 'e')
 enention -> exention (将 'n' 替换为 'x')
 exention -> exection (将 'n' 替换为 'c')
 exection -> execution (插入 'u')

 来源：力扣（LeetCode）
 链接：https://leetcode-cn.com/problems/edit-distance
 */

class Solution {
    func minDistance(_ word1: String, _ word2: String) -> Int {

        return 0
    }
}

do {
    do {
        print("horse     --> ros       ==> 3", Solution().minDistance("horse", "ros"))
        print("intention --> execution ==> 5", Solution().minDistance("intention", "execution"))
    }
}

