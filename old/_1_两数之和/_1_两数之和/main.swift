//
//  main.swift
//  _1_两数之和
//
//  Created by nius on 2020/3/3.
//  Copyright © 2020 nius. All rights reserved.
//

import Foundation

/**
 给定一个整数数组 nums 和一个目标值 target，请你在该数组中找出和为目标值的那 两个 整数，并返回他们的数组下标。

 你可以假设每种输入只会对应一个答案。但是，你不能重复利用这个数组中同样的元素。

 示例:
 给定 nums = [2, 7, 11, 15], target = 9
 因为 nums[0] + nums[1] = 2 + 7 = 9
 所以返回 [0, 1]

 来源：力扣（LeetCode）
 链接：https://leetcode-cn.com/problems/two-sum
 */

class Solution {
    // 时间复杂度：O(n^2)
    // 方法二使用空间换时间，推荐
    func twoSum(_ nums: [Int], _ target: Int) -> [Int] {
        if nums.count == 0 {
            return []
        }
        
        let count = nums.count
        for i in 0..<count {
            for j in (i + 1)..<count {
                if nums[i] + nums[j] == target {
                    return [i, j]
                }
            }
        }
        return []
    }
    
    // 空间换时间，时间复杂度为O(n)，空间：O(n)
    func twoSum1(_ nums: [Int], _ target: Int) -> [Int] {
        // 空间换时间，时间复杂度为O(n)，空间：O(n)
        // 登记注册法：每个人都去寻找适合自己的对象，如果找到了返回，没找到的话把自己的要求写上，以便后边同伴容易能找到自己
        
        if nums.count == 0 {
            return []
        }
        
        // 使用一个map，记录当前i对应的“补数”，使用“补数”作为key，当前i作为value
        // 当后边遍历到对应的“补数”时，直使用“补数”取出value即为结果数组的第一个索引
        // 而被遍历到的i作为第二个索引即可
        var dic: Dictionary<Int, Int> = [:]
        let count = nums.count
        for i in 0..<count {
            // 使用当前的元素检查map，是否当前元素刚好是之前某个元素的“补数”
            // 先假设当前元素为之前某个元素的“补数”，尝试取值
            let valueAtI = nums[i]
            if let fisrtIndex = dic[valueAtI] {
                // 取值成功，说明之前fisrtIndex对应的补数即为当前元素，直接返回
                return [fisrtIndex, i]
            }
            
            // 当前元素不是之前元素的补数，计算出当前元素的补数存储到字典，供后边元素检查
            dic[target - valueAtI] = i // 记录i位置元素的补数，作为key存储
        }
        
        return []
    }
}

do {
    print(Solution().twoSum1([2, 7, 11, 15], 9))
    print(Solution().twoSum1([0], 9))
    
}
