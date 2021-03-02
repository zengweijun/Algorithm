//
//  main.swift
//  _654_最大二叉树
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
    func constructMaximumBinaryTree(_ nums: [Int]) -> TreeNode? {
        // 输入：[3,2,1,6,0,5]

        // 寻找[left, right)之间最大值，作为二叉树根节点 rootIndex
        // 然后 rootIndex 左边的部分 [left, rootIndex) 中继续寻找左子树
        // 然后 rootIndex 右边的部分 [left, rootIndex) 中继续寻找右子树
        // 从上边过程可以看出，此过程即为一个递归过程
        
        // 传入一个数组和一个范围，在这个范围内找到根节点，并创建该根节点
        func createRoot(_ nums: [Int], _ left: Int, _ right: Int) -> TreeNode? {
            if (left >= right) { return nil } // 递归基
            
            var rootIndex = left // [left, right)范围内找到最大值作为根
            var rootValue = nums[left] // [left, right)范围内找到最大值作为根
            for i in stride(from: left + 1, to: right, by: 1) {
                let value = nums[i]
                if value > rootValue { // 题目限定了不会相等
                    rootIndex = i
                    rootValue = value;
                }
            }
            
            let root = TreeNode(rootValue) // 创建当前树根节点
            root.left = createRoot(nums, left, rootIndex)  // 在数组左边范围内找到左子树根 [left, rootIndex)
            root.right = createRoot(nums, rootIndex + 1, right) // 在数组右边范围内找到左子树根 [rootIndex + 1, right)
            return root
        }
        
        // 边界条件，数组为空时算法表现安全
        return createRoot(nums, 0, nums.count)
    }
}

do {
    let root = Solution().constructMaximumBinaryTree([3,2,1,6,0,5])
    
    print(root as Any)
}

