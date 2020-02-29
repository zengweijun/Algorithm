//
//  main.swift
//  _88_ 合并两个有序数组
//
//  Created by 曾维俊 on 2020/2/28.
//  Copyright © 2020 Nius. All rights reserved.
//

import Foundation

/**
 给定两个有序整数数组 nums1 和 nums2，将 nums2 合并到 nums1 中，使得 num1 成为一个有序数组。

 说明:
 初始化 nums1 和 nums2 的元素数量分别为 m 和 n。
 你可以假设 nums1 有足够的空间（空间大小大于或等于 m + n）来保存 nums2 中的元素。
 示例:

 输入:
 nums1 = [1,2,3,0,0,0], m = 3
 nums2 = [2,5,6],       n = 3

 输出: [1,2,2,3,5,6]

 来源：力扣（LeetCode）
 链接：https://leetcode-cn.com/problems/merge-sorted-array
 */

class Solution {
    func merge(_ nums1: inout [Int], _ m: Int, _ nums2: [Int], _ n: Int) {
        
        // 归并排序思路
        // 逆序遍历的目的是防止前边元素被覆盖
        // 基本是逆序遍历两个数组，然后比较，将大的一个元素放到第一个数组最后一个位置
        // 两种情况(结束判定)
        // 1.如若第一个数组先结束(nums1元素已经全部拷贝到后半段)，但是nums2还有元素，则此时直接将nums2的元素拷贝到nums1的前半部即可（nums2结束为止）
        // 2.如若第二个数组先结束(nums2元素已经全部拷贝到nums1后半段)，说明nums2的元素较大，先排到最后，此时nums1是已排序状态，直接结束（nums2已结束）
        // 综合两种情况看，是否结束该算法的条件时看nums2是否已结束
        
        var i1 = m - 1  // 指向nums1的最后一个元素（有效元素）
        var i2 = n - 1  // 指向nums2的最后一个元素（i2 < 0 说明nums2结束，可以停止算法）
        var cur = m + n - 1 // 指向nums1的最后一个位置
        
        while i2 >= 0 {
            // 只有nums1还有元素(i1 >= 0) 并且nums[i1]更大的时候，才讲nums1的元素往后移动，其它情况都是将nums2的元素赋值到nums1的后边
            if i1 >= 0 && nums1[i1] > nums2[i2] {
                // 这里要访问nums1，必须保证 i1>=0 即num1还没结束的情况，只有nums1还未结束的时候才去比较
                // nums1的元素较大，将nums1中元素移动到后边cur标定的位置
                nums1[cur] = nums1[i1]
                cur -= 1 // cur目标位置往前移动
                i1 -= 1  // nums1下一个要检查的元素
            } else {
                // 来到这里，1.表示i1 < 0（nums1已结束） 或者 nums1中元素比nums2中的小
                // 无论是nums1结束了，还是nums2中的元素较大，都是将nums2的元素复制到nums1的cur位置
                nums1[cur] = nums2[i2]
                cur -= 1 // cur目标位置往前移动
                i2 -= 1  // nums2下一个要检查的元素
            }
        }
    }
}


let s = Solution()


var nums1 = [1, 2, 3, 0, 0, 0]
let nums2 = [2, 5, 6]

//var nums1 = [3, 5, 6, 0, 0, 0]
//let nums2 = [1, 2, 2]

s.merge(&nums1, 3, nums2, 3)

print("结果:", nums1)
