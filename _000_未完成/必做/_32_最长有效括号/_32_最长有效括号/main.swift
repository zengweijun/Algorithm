//
//  main.swift
//  _32_最长有效括号
//
//  Created by nius on 2020/3/14.
//  Copyright © 2020 nius. All rights reserved.
//

import Foundation

/*
 给定一个只包含 '(' 和 ')' 的字符串，找出最长的包含有效括号的子串的长度。

 示例 1:
 输入: "(()"
 输出: 2
 解释: 最长有效括号子串为 "()"
 
 示例 2:
 输入: ")()())"
 输出: 4
 解释: 最长有效括号子串为 "()()"
 
  示例 3:
 输入: "()(()"
 输出: 2
 解释: 最长有效括号子串为前两个 "()"或后两个"()"

 来源：力扣（LeetCode）
 链接：https://leetcode-cn.com/problems/longest-valid-parentheses
 */

class Solution {
    // MARK: - 动态规划解法 O(n)
    // https://leetcode-cn.com/problems/longest-valid-parentheses/solution/qiao-miao-de-dong-tai-gui-hua-by-byb_boy/
    func longestValidParentheses1(_ s: String) -> Int {
        /*
         dp[i]为以i结尾的 最长包含有效括号的子串的长度，而已 "("结尾的子串，肯定不是无效，因此都为0
         index: 0  1  2  3  4  5  6  7  8  9  10 11  12
             s: (  )  (  (  (  )  (  )  )  )  (   )   )
            dp: 0  2  0  0  0  2  0  4  6 10  0  12   0
         
         ① 遍历到"("，直接dp[i] = 0
         ② 遍历到")"，先检查i的上一个 i-1
            如果是"("：形如...()【如上例i==7位置】，dp[7] = dp[7 - 2] + 2，{dp[i] = dp[i - 1] + 2}
            如果是")"，形如...))【如上例i==9位置】，将中间有效的[3, 8]去掉，检查2位置是否为"("
                如果是"("：那[2, 9]有效，但该段有效，带来的结果可能是上一段有效[0, 1]也可以一起加和进来，当然无效也可以加，因为无效为0
                    所以：dp[9] = dp[8] + 2 + dp[1] = dp[9-1] + 2 + dp[9 - dp[9 - 1] - 2]
                         dp[i] = dp[i - 1] + 2 + dp[i - dp[i-1] - 2]
         ③ 重复①②
         */
        
        if s.count == 0 { return 0 }
        let sChars = s.map{$0}
        var dp = [Int](repeating: 0, count: sChars.count) // dp[0] = 0
        var maxLength = 0
        for i in 1..<sChars.count {
            let char = sChars[i]
            if char == ")" { // == "(" default is 0
                // 检查上一个 i-1
                let preChar = sChars[i - 1]
                if preChar == "(" { // ...()
                    // 和上一个刚好配对，只需要加上 i-2 结尾最大有效即可
                    dp[i] = (i >= 2 ? dp[i - 2] : 0) + 2
                } else { // ...))
                    // 和上一个不配对，为...))，如果 i-1结尾有效部分去掉，检查之前是否为"("
                    let throughPreCharIndex = i - dp[i - 1] - 1    // i-1结尾有效串的前一个字符（跳过i-1结尾有效串）
                    if throughPreCharIndex >= 0 && sChars[throughPreCharIndex] == "("  {
                        // 此时：以i结尾的有效串 [throughPreCharIndex, i]，再检查前一个字符（如存在），如果有效则合并计算
                        // 将中间部分有效长度(i-1结尾有效部) + 2，同时检查此时 i结尾的有效串 之前是否还有一段紧挨着的有效串
                        let throughPrePreCharIndex = i - dp[i - 1] - 2 // 之前是否还有一段紧挨着的有效串
                        dp[i] = dp[i - 1] + 2 + (throughPrePreCharIndex >= 0 ? dp[throughPrePreCharIndex] : 0)
                    }
                }
                maxLength = max(dp[i], maxLength)
            }
        }
        return maxLength
    }
    
    
    // MARK: - 使用栈 O(n)
    func longestValidParentheses2(_ s: String) -> Int {
        return 0
    }
    
    
    // MARK: - 使用左右括号计数器 O(n)
    func longestValidParentheses3(_ s: String) -> Int {
        return 0
    }
}

do {
    do {
        print("(()    ==> 2: ", Solution().longestValidParentheses1("(()"))
        print(")()()) ==> 4: ", Solution().longestValidParentheses1(")()())"))
        print("()(()  ==> 2: ", Solution().longestValidParentheses1("()(()"))
        print("()(()) ==> 6: ", Solution().longestValidParentheses1("()(())"))
    }
    print("--------------------------------------------")
    do {
        print("(()    ==> 2: ", Solution().longestValidParentheses2("(()"))
        print(")()()) ==> 4: ", Solution().longestValidParentheses2(")()())"))
        print("()(()  ==> 2: ", Solution().longestValidParentheses2("()(()"))
    }
    print("--------------------------------------------")
    do {
        print("(()    ==> 2: ", Solution().longestValidParentheses3("(()"))
        print(")()()) ==> 4: ", Solution().longestValidParentheses3(")()())"))
        print("()(()  ==> 2: ", Solution().longestValidParentheses3("()(()"))
    }
    print("--------------------------------------------")
}
