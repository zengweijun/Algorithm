//
//  main.swift
//  _15_三数之和
//
//  Created by nius on 2020/3/3.
//  Copyright © 2020 nius. All rights reserved.
//

import Foundation

/**
 给定一个包含 n 个整数的数组 nums，判断 nums 中是否存在三个元素 a，b，c ，使得 a + b + c = 0 ？找出所有满足条件且不重复的三元组。

 注意：答案中不可以包含重复的三元组。

  

 示例：
 给定数组 nums = [-1, 0, 1, 2, -1, -4]，

 满足要求的三元组集合为：
 [
   [-1, 0, 1],
   [-1, -1, 2]
 ]

 来源：力扣（LeetCode）
 链接：https://leetcode-cn.com/problems/3sum
 */

class Solution {
    func threeSum(_ nums: [Int]) -> [[Int]] {
        /**
            思路：
            1、先将数组排序（排序以后方便过滤相同的结果）
            2、从小打到遍历这个数组，每次遍历到一个元素，将这个元素的相反数设置为target
            3、每次遍历中，使用双指针对当前元素后边的所有元素进行处理，找到两个元素的和为target，这样三个元素的和就是 0
            4、双指针的具体处理：头尾各一个指针，每次判断两个指针所指的元素之和与target对比，如果大了，由指针迁移，如果小了，左指针右移，直到两个指针相遇
         
            注意事项：
            1、在2步骤中，只需要遍历到数组倒数第三个元素，因为要求3元素之和
            2、因为不能有重复，所以前后两次遍历的元素相等则跳过
         
            复杂度分析：排序 O(n * logn)    +       for循环 O(n)  *  while循环 O(n)   ==>   O(n^2)
         */
        
        var results = [[Int]]()
        let count = nums.count
        guard count >= 3 else { return results }
        
        var nums = nums
        nums.sort(by: <)
        
        // 此处有可能是[0, 0, 0]，需要将0包含进去
        guard nums.first ?? -1 <= 0 else { return results }
        guard nums.last ?? 1 >= 0 else { return results }
        
        for i in 0..<(count - 2) { // 只需要遍历到数组倒数第三个元素
            let target = -nums[i]
            if i > 0 && target == -nums[i - 1] {
                continue // 看看上一次是否已经检查过同值元素，跳过避免重复
            }
            
            var left = i + 1        // 从i的下一个元素开始
            var right = count - 1   // 到倒数第一个元素
            while left < right {
                if nums[left] + nums[right] < target {
                    left += 1
                } else if nums[left] + nums[right] > target {
                    right -= 1
                } else {
                    results.append([nums[i], nums[left], nums[right]]) // 找到了一个，继续寻找
                    
                    left += 1
                    right -= 1
                    while left < right && nums[left] == nums[left - 1] { left += 1 }    // 刚刚已经检查过同值元素，跳过避免重复
                    while left < right && nums[right] == nums[right + 1] { right -= 1 } // 刚刚已经检查过同值元素，跳过避免重复
                }
            }
        }
        
        return results
    }
}


do {
    print(Solution().threeSum([-1, 0, 1, 2, -1, -4]))
    print(Solution().threeSum([-1, 1, 1, 2, -1, 2, -4]))
}
