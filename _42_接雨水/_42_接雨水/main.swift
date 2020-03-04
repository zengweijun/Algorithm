//
//  main.swift
//  _42_接雨水
//
//  Created by nius on 2020/3/4.
//  Copyright © 2020 nius. All rights reserved.
//

import Foundation

/**
 给定 n 个非负整数表示每个宽度为 1 的柱子的高度图，计算按此排列的柱子，下雨之后能接多少雨水。
 图片：https://assets.leetcode-cn.com/aliyun-lc-upload/uploads/2018/10/22/rainwatertrap.png
 上面是由数组 [0,1,0,2,1,0,1,3,2,1,2,1] 表示的高度图，在这种情况下，可以接 6 个单位的雨水（蓝色部分表示雨水）。 感谢 Marcos 贡献此图。

 示例:
 输入: [0,1,0,2,1,0,1,3,2,1,2,1]
 输出: 6

 来源：力扣（LeetCode）
 链接：https://leetcode-cn.com/problems/trapping-rain-water
 */

class Solution {
    // 方法1
    func trap(_ height: [Int]) -> Int {
        /**
         双指针法： O(n)
            1.先找到中间最大值位置，以此将图（数组）分为两段
            2.左边一个指针从头开始遍历，右边一个指针从尾开始遍历，直到两个指针相遇
         
            提示：实际上两个指针都是往蓄水的方向进行遍历计算，虽然该方法是O(n)，但是仍然可以优化，请看方法2
         */
        
        let count = height.count
        guard count > 2 else { return 0 }
        
        // 分为两段，两边遍历 [0, maxIndex),[maxIndex + 1, count)
        var maxIndex = 0
        for i in 1..<count {
            if height[i] > height[maxIndex] {
                maxIndex = i
            }
        }
        
        var sum = 0
        
        // 遍历左边一半
        // stride方法注意：stride(from: 1, to: 1, by: 1) 不会进入for循环
        //      要使1能进入for循环，必须stride(from: 1, to: 2, by: 1)
        // 它实际上可以看成是一个半开区间 stride(from: m, to: n, by: 1) === [m, n)
        var leftMax = height[0]
        for leftIndex in stride(from: 1, to: maxIndex, by: 1) {
            let leftValue = height[leftIndex]
            if leftValue >= leftMax {
                leftMax = leftValue
            } else {
                sum += leftMax - leftValue
            }
        }
        
        // 遍历右边一半
        var rightMax = height[count - 1]
        for rightIndex in stride(from: count - 2, to: maxIndex, by: -1) {
            let rightValue = height[rightIndex]
            if rightValue >= rightMax {
                rightMax = rightValue
            } else {
                sum += rightMax - rightValue
            }
        }
        
        return sum
    }
    
    // 方法1中的逻辑
    // 也是使用头尾指针，使用方法1中的逻辑，不过无需求最大值位置
    // 该方法时间复杂度也为O(n)，不过省略了找最大值得过程
    func trap1(_ height: [Int]) -> Int {
        // 总体思路： 左右两指针left、right，不断向中间靠拢，那个指针的值小就移动那个指针
        
        let count = height.count
//        guard count > 2 else { return 0 }
        
        // 分为两段，两边遍历 [0, maxIndex),[maxIndex + 1, count)
        var leftMax = 0
        var rightMax = 0
        var left = 0
        var right = count - 1
        
        var sum = 0
        while left < right { // left == right 说明左右指针指向了同一个地方，需水量计算完成
            // 值相等的时候移动哪个指针都无所谓，不会改变结果
            let leftValue = height[left]
            let rightValue = height[right]
            if leftValue < rightValue {     // 右边值大，移动左边指针
                if leftMax <= leftValue {   // 没有蓄水
                    leftMax = leftValue     // 修改左边最大值
                } else { // 有蓄水
                    sum += leftMax - leftValue
                }
                left += 1
            } else { // 左边值大，移动右边指针
                if rightMax <= rightValue {
                    rightMax = rightValue
                } else {
                    sum += rightMax - rightValue
                }
                right -= 1
            }
        }
        return sum
    }
}

do {
    print(Solution().trap1([0,1,0,2,1,0,1,3,2,1,2,1]))
    print(Solution().trap1([1,0,2]))
    print(Solution().trap1([2,0,2]))
    print(Solution().trap1([1,0]))
    
}
