//
//  main.swift
//  _75_颜色分类
//
//  Created by 曾维俊 on 2020/2/29.
//  Copyright © 2020 Nius. All rights reserved.
//

import Foundation

/**
 给定一个包含红色、白色和蓝色，一共 n 个元素的数组，原地对它们进行排序，使得相同颜色的元素相邻，并按照红色、白色、蓝色顺序排列。

 此题中，我们使用整数 0、 1 和 2 分别表示红色、白色和蓝色。

 注意:
 不能使用代码库中的排序函数来解决这道题。

 示例:
 输入: [2,0,2,1,1,0]
 输出: [0,0,1,1,2,2]
 
 进阶：
 一个直观的解决方案是使用计数排序的两趟扫描算法。
 首先，迭代计算出0、1 和 2 元素的个数，然后按照0、1、2的排序，重写当前数组。
 你能想出一个仅使用常数空间的一趟扫描算法吗？
 */


class Solution {
    func sortColors(_ nums: inout [Int]) {
        if nums.count == 0 {
            return
        }
        // 此题实际上就是对一个包含0、1、2的数组进行排序
        
        // 要求：1.一趟扫描，挤时间复杂度为O(n)；2.原地排序，即空间复杂度为O(1)
        // 这种题通常使用3指针（也可称为双指针，即头尾指针）
        // 使用一个指针标记在开始位置，目标是存入0，使用一个指针标记结尾，目标存入2，使用一个指针进行扫描
        /**
         总体思路
         nums[cur] = 0，与头指针交换，cur、和begin后移
         nums[cur] = 2，与尾指针交换，cur不动，end指针前移
         nums[cur] = 1，cur跳过(后移)
         为什么与begin交换时，cur和begin都后移，而与end交换时，只有end前移呢
         因为cur是从前向后扫描，因此前面的值都已经被扫描过，如果扫描过程遇到2，一定已经交换到end位置，因此无担心会有2被跳过的情况
         但与end指针交换后，从end指针交换的值可能是2，因此仍然需要比较
         */
        
        var begin = 0 // 标识这个位置应该存入的值是0，即将0放到开头
        var end = nums.count - 1 // 标识这个位置应该存入2，即2放到结尾
        var cur = 0 // 扫描指针，遇到1跳过
        
        // 注意，cur == end的时候还需要继续比较一次
        // 因为end位置赋值为2以后会向前移动，所以end指向的位置并不一定是2
        // 所以只有当 cur > end 的时候才能提出循环
        while cur <= end {
            if nums[cur] == 0 {
                swap(&nums, cur, begin)
                cur += 1    // cur后移
                begin += 1  // begin后移
            } else if nums[cur] == 2 {
                swap(&nums, cur, end)
                end -= 1 // end前移，cur不动，因为cur可能或的值是2，还需再进行比较
            } else { // nums[cur] == 1
                cur += 1 // 跳过
            }
        }
    }
    func swap(_ nums: inout [Int], _ i: Int, _ j: Int) {
        let tmp = nums[i]
        nums[i] = nums[j]
        nums[j] = tmp
    }
}


//var nums = [2,0,2,1,1,0]
var nums = [2,0,1]
Solution().sortColors(&nums)
print(nums)

