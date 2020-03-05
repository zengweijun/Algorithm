//
//  main.swift
//  _977_有序数组的平方
//
//  Created by nius on 2020/3/5.
//  Copyright © 2020 nius. All rights reserved.
//

import Foundation

/**
 给定一个按非递减顺序排序的整数数组 A，返回每个数字的平方组成的新数组，要求也按非递减顺序排序。

  

 示例 1：
 输入：[-4,-1,0,3,10]
 输出：[0,1,9,16,100]
 示例 2：

 输入：[-7,-3,2,3,11]
 输出：[4,9,9,49,121]
  

 提示：

 1 <= A.length <= 10000
 -10000 <= A[i] <= 10000
 A 已按非递减顺序排序。

 来源：力扣（LeetCode）
 链接：https://leetcode-cn.com/problems/squares-of-a-sorted-array
 */

class Solution {
    
    // 暴力方法
    func sortedSquares1(_ A: [Int]) -> [Int] {
        // 先平方:O(n)，再排序O(n * logn) ==> O(n * logn)
        // 空间O(1)，时间O(n * logn)
        
        var A = A
        for i in 0..<A.count {
            A[i] = A[i] * A[i]
        }
        
        A.sort()
        return A
    }
    
    
    // 使用双指针
    func sortedSquares2(_ A: [Int]) -> [Int] {
        // 使用双指针
        // 非递减顺序，如[-4,-1,0,3,10] 平方后 [16, 1, 0, 9, 100]
        // 特征：两边高中间低
        // 因此使用头尾两个指针，逻辑上将数组分为两个部分，合并到一个新数组中即可
        
        let count = A.count
        
        var result = [Int](repeating: 0, count: count)
        var left = 0
        var right = count - 1
        var cur = right
        
        while cur >= 0 {
            let leftValue = A[left] * A[left]
            let rightValue = A[right] * A[right]
            if rightValue > leftValue  {
                result[cur] = rightValue
                right -= 1
            } else {
                result[cur] = leftValue
                left += 1
            }
            cur -= 1
        }
        return result
    }
}

do {
    /**

     示例 1：
     输入：[-4,-1,0,3,10]
     输出：[0,1,9,16,100]
     
     示例 2：
     输入：[-7,-3,2,3,11]
     输出：[4,9,9,49,121]
     */
    print(Solution().sortedSquares2([-4,-1,0,3,10]))
    print(Solution().sortedSquares2([-7,-3,2,3,11]))
}
