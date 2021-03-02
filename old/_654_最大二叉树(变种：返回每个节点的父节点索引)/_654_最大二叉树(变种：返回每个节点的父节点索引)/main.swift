//
//  main.swift
//  _654_最大二叉树(变种：返回每个节点的父节点索引)
//
//  Created by nius on 2020/3/4.
//  Copyright © 2020 nius. All rights reserved.
//

import Foundation

/**
 给定一个不含重复元素的整数数组。一个以此数组构建的最大二叉树定义如下：

 二叉树的根是数组中的最大元素。
 左子树是通过数组中最大值左边部分构造出的最大二叉树。
 右子树是通过数组中最大值右边部分构造出的最大二叉树。
 通过给定的数组构建最大二叉树，并且输出这个树的根节点。

  

 示例 ：
 输入：[3,2,1,6,0,5]
 输出：返回下面这棵树的根节点：

       6
     /   \
    3     5
     \    /
      2  0
        \
         1
 
 ---------------------------------------------
 ---------------------------------------------
 ---------------------------------------------
  变种：[3,2,1,6,0,5]是一个最大二叉树，每个最大值（相对）左边的是其左子树，右边的是其右子树
    求出该二叉树每一个节点的父节点索引，没有父节点的使用 -1
 
 示例：
    输入：[3,2,1,6,0,5]
    输出：[3, 0, 1, -1, 5, 3]
  
  分析：根据最大二叉树的性质，对于每一个元素有如下性质
    1、根节点没有父节点
    2、正常节点拥有父节点，在数组中每个节点右边的第一个比它大的一定在它的上边层次，左边的同理
       而这个节点的父节点一定是这两个节点中的最小值
    3、某些节点在数组中可能只有某一边存在比它大的值，而另一边不存在，那么在这一边中比它大的第一个值即为它的父节点
       比如 [1，3，2, 4]，3的左边没有比它大的值，而右边第一个比它大的值是4，根据最大二叉树的性质，3的父节点就是4
    
    因此：此题的解决思路是搞两个数组，分别求出每一个元素左边比它大的第一个元素和右边比它大的第一个元素，然后再这两个数组中求出最小值就是它的父节点
    方法：求左边或者右边第一个比它大的值需要用到栈
 ---------------------------------------------
 ---------------------------------------------
 ---------------------------------------------
  

 提示：
 给定的数组的大小在 [1, 1000] 之间。

 来源：力扣（LeetCode）
 链接：https://leetcode-cn.com/problems/maximum-binary-tree
 */

public class TreeNode {
    public var val: Int
    public var left: TreeNode?
    public var right: TreeNode?
    public init(_ val: Int) {
        self.val = val
        self.left = nil
        self.right = nil
    }
}

class Solution {
    func parentIndexs(_ nums: [Int]) -> [Int] {
        /**
          变种：[3,2,1,6,0,5]是一个最大二叉树，每个最大值（相对）左边的是其左子树，右边的是其右子树
            求出该二叉树每一个节点的父节点索引，没有父节点的使用 -1
         
         示例：
            输入：[3,2,1,6,0,5]
            输出：[3, 0, 1, -1, 5, 3]
          
          分析：根据最大二叉树的性质，对于每一个元素有如下性质
            1、根节点没有父节点
            2、正常节点拥有父节点，在数组中每个节点右边的第一个比它大的一定在它的上边层次，左边的同理
               而这个节点的父节点一定是这两个节点中的最小值
            3、某些节点在数组中可能只有某一边存在比它大的值，而另一边不存在，那么在这一边中比它大的第一个值即为它的父节点
               比如 [1，3，2, 4]，3的左边没有比它大的值，而右边第一个比它大的值是4，根据最大二叉树的性质，3的父节点就是4
            
            因此：此题的解决思路是搞两个数组，分别求出每一个元素左边比它大的第一个元素和右边比它大的第一个元素，然后再这两个数组中求出最小值就是它的父节点
            方法：利用栈求左边和右边第一个比它大的数
         
            栈为单调递减栈（底-->顶）,入栈是检查栈顶元素是否比当前元素大
                如果大则入栈，并且栈顶元素为当前元素的左边第一个比它大的元素
                如果小栈删除栈顶元素，并且当前元素为栈顶元素的右边第一个比它大的元素
         */
        
        print("nums", nums)
        let count = nums.count
        var leftMaxIndexs = [Int](repeating: -1, count: count)  // 每个元素左边比它大的第一个元素对应的（索引），默认-1
        var rightMaxIndexs = [Int](repeating: -1, count: count) // 每个元素右边比它大的第一个元素对应的（索引），默认-1
        var results = [Int](repeating: -1, count: count) // 每个元素(节点)的父节点索引
        var stack = [Int]() // 单调递减栈（索引）
        
        // 求的左右比之大的第一个元素索引
        for i in 0..<count {
            let value = nums[i]
            
            // 先将栈中比value小的元素全部删除，删除的同时设置当前元素索引为栈顶元素右边第一个最大值索引
            // 如果栈中没有比当前索引的元素更小的值，说明当前索引的元素不是之前索引元素的右边第一个更大的值
            // 此时rightMaxIndexs自动使用默认值-1
            
            while let topElement = stack.last, value > nums[topElement] { // == !stack.isEmpty
                rightMaxIndexs[stack.removeLast()] = i
            }
            
            // 来到这里，说明栈为空 或者 栈顶索引对应的值大于当前value
            // 如果栈顶元索引在，将栈顶索引设置为当前元素左边第一个更大的元素索引
            // 如果栈为空，这无需设置，使用leftMaxIndexs的默认值-1
            if let topElement = stack.last {  // == !stack.isEmpty
                leftMaxIndexs[i] = topElement
            }
            
            // 栈要么为空，要么栈顶索引对应的值比当前索引对应的值更大，将当前索引入栈
            stack.append(i)
        }
        
        
        for i in 0..<count {
            // 取出每一个元素左右比之更大的第一个元素的最小值索引，设置为当前元素的父节点索引
            var parentIndex = -1
            let leftMaxIndex = leftMaxIndexs[i]
            let rightMaxIndex = rightMaxIndexs[i]
            if leftMaxIndex == -1 && rightMaxIndex == -1  {
                continue // default -1
            } else if leftMaxIndex == -1 {
                parentIndex = rightMaxIndex
            } else if rightMaxIndex == -1 {
                parentIndex = rightMaxIndex
            } else {
                if nums[leftMaxIndex] > nums[rightMaxIndex] {
                    parentIndex = rightMaxIndex
                } else {
                    parentIndex = leftMaxIndex
                }
            }
            results[i] = parentIndex;
        }
        
        print("leftMaxIndexs", leftMaxIndexs)
        print("rightMaxIndexs", rightMaxIndexs)
        print("results", results)
        return results
    }
}

do {
    /**
     示例：
        输入：[3,2,1,6,0,5]
        输出：[3, 0, 1, -1, 5, 3]
     思路总结：求左边或者右边第一个比它大的数，使用栈
     */
    let results = Solution().parentIndexs([3,2,1,6,0,5])
    print("results", results)
}



