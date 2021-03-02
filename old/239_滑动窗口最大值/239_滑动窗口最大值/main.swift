//
//  main.swift
//  239_滑动窗口最大值
//
//  Created by nius on 2020/3/3.
//  Copyright © 2020 nius. All rights reserved.
//

import Foundation

/**
 给定一个数组 nums，有一个大小为 k 的滑动窗口从数组的最左侧移动到数组的最右侧。你只可以看到在滑动窗口内的 k 个数字。滑动窗口每次只向右移动一位。

 返回滑动窗口中的最大值。

 
 示例:
 输入: nums = [1,3,-1,-3,5,3,6,7], 和 k = 3
 输出: [3,3,5,5,6,7]
 解释:

   滑动窗口的位置                最大值
 ---------------               -----
  [1  3  -1] -3  5  3  6  7      3
  1 [3  -1  -3] 5  3  6  7       3
  1  3 [-1  -3  5] 3  6  7       5
  1  3  -1 [-3  5  3] 6  7       5
  1  3  -1  -3 [5  3  6] 7       6
  1  3  -1  -3  5 [3  6  7]      7
  

 提示：
 你可以假设 k 总是有效的，在输入数组不为空的情况下，1 ≤ k ≤ 输入数组的大小。

  
 进阶：
 你能在线性时间复杂度内解决此题吗？O(n)

 来源：力扣（LeetCode）
 链接：https://leetcode-cn.com/problems/sliding-window-maximum
 */

class Solution {
    // 推荐法
    // 使用双端队列（队列中的值从大到小排列）
    // 时间：O(n)
    // 这里有一篇很好的帖子可以帮助理解 https://zhuanlan.zhihu.com/p/34456480
    func maxSlidingWindow(_ nums: [Int], _ k: Int) -> [Int] {
        // 滑块右边从0开始，滑块每次滑动，就将滑块最右边的值与队尾最后一个值比较
        //      如果队尾的值比的当前滑块最右边的值大，则将该值入队
        //      否则移除队尾值，继续比较下一个队尾，重复上述逻辑
        //      如果最终队列为空，则直接入队
        // 滑块最右端的值入队以后，检查对头元素索引是否有效（滑块范围内），无效出队
        // 有效，则出队并且放入到结果数组
        // 重复以上过程
        
        // 边界条件
        let numsCount = nums.count
        if numsCount < 2 || k < 2 {
            return nums
        }
        
        // 根据示例可知，滑块最大值数组长度即为滑块移动步数
        // 移动步数比数组长度少k - 1步，所以最大值数组元素个数应该为：nums.count - (k - 1)
        var maxes = [Int](repeating: 0, count: numsCount - k + 1)
        
        // 双端队列不限定长度，因为该队列中元素的数量不固定
        // 注意，为了方便索引操作，双端队列内部存储元素索引
        // 规定：0为对头，last为队尾
        // 对头到队尾从大到小排列，如 [9, 6, 4, 3, 2]
        // 单调队列（这里是单调递减队列）
        // 队头元素就是当前滑动窗口的最大值
        var deque = [Int]()
        
        // 滑块索引范围[begin, end]
        // end：滑块最右边的索引
        // begin：滑块最左边的索引
        // 这里默认滑块最右端从0开始
        for end in 0..<numsCount {
            // 滑块左边索引
            let begin = end - k + 1
            
            // 将滑块最右端的值检查入队，保证双端队列大到小排列，循环检查
            while !deque.isEmpty && nums[deque[deque.count - 1]] <= nums[end] { // 这里保证队列不为空，deque.count-1不会越界
                deque.removeLast() // 从尾部删除
            }
            
            // 来到这里，队列中没有比 nums[end] 小的元素，或者队列已被清空
            deque.append(end)
            
            // 检查滑块左边索引，只有当左边索引 >= 0的时候，此时滑块才有意义，否则的话滑块视为无效的
            if begin < 0 { continue }
            
            // 有效滑块，此时检查一下双端队列的索引是否有效，只有索引出于当前滑块范围内才有意义
            // 当前队列对头的元素就是滑块目前框选到的范围内最大值
            if deque[0] < begin {
                // 这里只需要删除一次，因为每次滑块只会移动异步，最多只会造成队列内的一个索引无效
                // 我们是从队尾入队，所以无效索引应该在对头
                deque.removeFirst()
            }
            
            // 取出队头，即为当前滑块框选到的最大值
            maxes[begin] = nums[deque[0]]
        }
        return maxes
    }
    
    // 记忆法（该算法最坏时间复杂度O(n*k)），有运气成分
    // 虽然在LeetCode上，该算法表现更好，但综合评价不一定比方法1好，得看具体应用场景
    func maxSlidingWindow2(_ nums: [Int], _ k: Int) -> [Int] {
        
        // 边界条件
        let numsCount = nums.count
        if numsCount < 2 || k < 2 {
            return nums
        }
        
        var maxes = [Int](repeating: 0, count: numsCount - k + 1)
        let maxesCount = maxes.count
        
        // 先找到前k个中最大值，然后不断移动滑块进行判断
        var maxIndex = 0
        for i in 1..<k {
            if nums[i] > nums[maxIndex] {
                maxIndex = i
            }
        }
        
        for left in 0..<maxesCount {
            let right = left + k - 1
            
            // 先判断当前maxIndex是否处于滑块内，如果是，设置最大值，然后滑动滑块
            if maxIndex < left { // 不在滑块内，重新计算滑块内的最大值
                maxIndex = left
                for i in (left+1)...right { if nums[i] > nums[maxIndex] { maxIndex = i } }
            } else { // 在滑块内，和新进的元素比较
                if nums[right] > nums[maxIndex] { maxIndex = right }
            }
            maxes[left] = nums[maxIndex]
        }
        
        return maxes
    }
    
    // 使用动态规划解决
    func maxSlidingWindow3(_ nums: [Int], _ k: Int) -> [Int] {
        return nums
    }
}

do {
    print(Solution().maxSlidingWindow2([1,3,-1,-3,5,3,6,7], 3))
    print(Solution().maxSlidingWindow2([1,3,-1,-3,5,3,6,7], 2))
    print(Solution().maxSlidingWindow2([1,3,-1,-3,5,3,6,7], 1))
}
