//
//  main.swift
//  _20_有效的括号
//
//  Created by nius on 2020/3/3.
//  Copyright © 2020 nius. All rights reserved.
//

import Foundation

/**
 
 给定一个只包括 '('，')'，'{'，'}'，'['，']' 的字符串，判断字符串是否有效。

 有效字符串需满足：

 左括号必须用相同类型的右括号闭合。
 左括号必须以正确的顺序闭合。
 注意空字符串可被认为是有效字符串。

 示例 1:
 输入: "()"
 输出: true
 
 示例 2:
 输入: "()[]{}"
 输出: true
 
 示例 3:
 输入: "(]"
 输出: false
 
 示例 4:
 输入: "([)]"
 输出: false
 
 示例 5:
 输入: "{[]}"
 输出: true

 来源：力扣（LeetCode）
 链接：https://leetcode-cn.com/problems/valid-parentheses
  */

class Solution {
    func isValid(_ s: String) -> Bool {
        /**
         分析：对称性问题，可以考虑使用栈，而当前题目中括号问题属于对称性问题
         比如 () 左边扩入栈 [(] ，遇到右括号)时，弹出左边栈顶 (，发现与 ) 匹配，配合字典

         (){[()]} 遇到左括号入栈
          1. [(] 入栈，遇到右括号，弹出栈顶 ( 匹配右括号 )，成功，继续下一次
          2. 遇到左括号依次入栈 [{] -> [{[] -> [{[(]
          3. 遇到右括号依次弹出栈顶匹配 ①栈顶 (匹配) ②栈顶[匹配] ③栈顶 {匹配}
          4.循环退出，返回true
         
         ()         ==> 入栈[(]，出栈 ( 匹配 )，继续  ---> 最终true
         ()[]{}  ==> 入栈[(]，出栈 ( 匹配 )，继续 入栈[[]，出栈 [ 匹配 ]，继续入栈[{]，出栈 { 匹配 } ---> 最终true
         (]         ==> 入栈[(]，出栈 ( 不匹配 ]，返回 false 结束逻辑
         ([)]  ==> 入栈[(]，入栈[([]，出栈[ 不匹配 )，，返回 false 结束逻辑
         {[]}    ==> 入栈[(]，入栈[([]，出栈 [ 匹配 ]，继续出栈 { 匹配 } ---> 最终true
         */
        
        /**
         总体思路：
            遍历字符串，遇到左括号入栈，遇到右括号时，弹出栈顶进行匹配
            如果匹配失败，返回false；如果匹配成功，则继续
         
            边界条件：①栈已经为空，但是还有右括号，返回false
                    ②右括号已经匹配完成，但是栈中还有左括号，返回false

            若一直到最终都没有返回false，并且栈中的左括号全部匹配完成，说明全部匹配成功，则返true
         */
        
        
        if s.count == 0 {
            return true
        }
        
        // let leftSet: [Character] = ["(", "[", "{"]
        // let buckets: [Character: Character] = ["(" : ")", "[" : "]", "{" : "}"]
        let buckets: [Character: Character] = [")" : "(", "]" : "[", "}" : "{"]
        var leftStack: [Character] = []
        
        // 遍历字符串
        for char in s { // Character
            // 假设是右括号(取出与之匹配的左括号)
            let expectedLeftBracket = buckets[char]
            if expectedLeftBracket == nil {
                // 如果是右括号一定能取到值，没取到说明是左括号，直接入栈，继续检查下一个
                leftStack.append(char)
                continue
            }
            
            // 来到这里，说明是右括号，并且已经取到了与之匹配的左括号 expectedLeftBracket
            // 对比栈顶元素（先判断栈是否已经为空，使用last判断）
            // last: If the collection is empty, the value of this property is nil.
            if let last = leftStack.last, last == expectedLeftBracket {
                // 栈最后一个元素存在，并且和当前右括号对应的左括号 expectedLeftBracket相等
                // 删掉栈顶元素，继续下一次匹配
                leftStack.removeLast()
            } else {
                // 这里char是右括号，但是左括号栈已经空了，匹配失败
                // 虽然然左括号栈不空，但是取出的栈顶元素和当前右括号不对应，匹配失败
                return false
            }
        }
        // leftStack 提前结束或者延后结束都说明没有提配成功，只有结束的时候leftStack刚好是空的才刷成功
        // leftStack.isEmpty == true : 右括号匹配完成，但是还有栈中还有左括号，匹配失败
        return leftStack.isEmpty
    }
    
    func isValid1(_ s: String) -> Bool {
        if s.count == 0 {
            return true
        }
        
        var leftStack: [Character] = []
        let buckets: [Character: Character] = [")" : "(", "]" : "[", "}" : "{"]
        
        for char in s {
            // 假设char是一个右括号，看能否取出左括号'
            // 如果取出了左括号，说明假设成功，char确实是一个右括号
            guard let expectedLeftBracket = buckets[char] else {
                // 来到这里，说明没有取到左括号，说明char不是一个右括号，那它一定是左括号，入栈
                leftStack.append(char)
                continue // 如果是左括号入栈完成后，继续下一次检查，这里直接continue
            }
            
            // 来到这里，说明char是右括号，因为成功的取出了左括号 expectedLeftBracket
            // 用这个左括号和当前栈顶元素相比，如果相同，则本次匹配成功，继续，否则匹配失败，直接返回false
            // 注意，这里需要先检查栈是否已空，可以使用last，尝试取出最后一个元素
            // last: If the collection is empty, the value of this property is nil.
            if let last = leftStack.last, last == expectedLeftBracket {
                leftStack.removeLast()
            } else {
                return false
            }
        }
        
        return leftStack.isEmpty
    }
}

do {
    print("()", "     [true] --> ", Solution().isValid1("()"))
    print("()[]{}", " [true] --> ", Solution().isValid1("()[]{}"))
    print("{[()]}", " [true] --> ", Solution().isValid1("{[()]}"))
    print("(]", "     [false]--> ", Solution().isValid1("(]"))
    print( "([)]","   [false]--> ", Solution().isValid1("([)]"))
    print("({[]}", "  [false]--> ", Solution().isValid1("({[]}"))
    print("{[]})", "  [false]--> ", Solution().isValid1("{[]})"))
}


