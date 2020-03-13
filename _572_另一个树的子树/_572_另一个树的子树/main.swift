//
//  main.swift
//  _572_另一个树的子树
//
//  Created by nius on 2020/3/12.
//  Copyright © 2020 nius. All rights reserved.
//

import Foundation

/**
 
 给定两个非空二叉树 s 和 t，检验 s 中是否包含和 t 具有相同结构和节点值的子树。s 的一个子树包括 s 的一个节点和这个节点的所有子孙。s 也可以看做它自身的一棵子树。

 示例 1:
 给定的树 s:

      3
     / \
    4   5
   / \
  1   2
 给定的树 t：

   4
   / \
  1   2
 返回 true，因为 t 与 s 的一个子树拥有相同的结构和节点值。

 示例 2:
 给定的树 s：

      3
     / \
    4   5
   / \
  1   2
     /
    0
 给定的树 t：

   4
   / \
  1   2
 返回 false。

 来源：力扣（LeetCode）
 链接：https://leetcode-cn.com/problems/subtree-of-another-tree
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
    // 使用递归方法
    // 时间复杂度O(n * m)
    func isSubtree1(_ s: TreeNode?, _ t: TreeNode?) -> Bool {
        func isEqual(_ t1: TreeNode?, _ t2: TreeNode?) -> Bool {
            // t1和t2完全相等(注意：题目要求不是包含，而是相等)
            
            // 两棵树都为空，相等
            if t1 === nil && t2 === nil {
                return true
            }
            
            if t1 === nil || t2 === nil {
                // 来到这里，必定有一棵树不为空，如果发现另外一棵树为空，则说明不相等
                return false
            }
            
            // 来到这里，两棵树都不为空
            // 两棵树要相等，必须根节点和左右子节点都相等才行
            if t1?.val != t2?.val {
                // 1、如果发现根节点不相等，返回false（递归基）
                return false
            }
            
            // 2、根节点相等，递归检查左右子节点也要相等才行
            return isEqual(t1?.left, t2?.left) && isEqual(t1?.right, t2?.right)
        }
        
        // 若t为空，则无论s是否空都成立
        if t === nil {
            return true
        }
        
        // 来到这里，t不可能为空，如s为空，则t不是s的子树
        if s === nil {
            return false
        }
        
        // 来到这里，s 和 t 都不为空
        // 1、先判断两个树是否相等
        var equal = isEqual(s, t)
        if !equal {
            // 2、不相等，使用 s 的左子树去和 t 对比 (递归)
            equal = isSubtree1(s?.left, t)
        }
        if !equal {
            // 3、如果 s 的左子树递归检查不符合，使用右子树递归检查
            equal = isSubtree1(s?.right, t)
        }
        return equal
    }
    
    // 使用二叉树序列化方法，序列化的方法只需要判断字符串s的字符串是否包含t即可
    // 注意，要将序列化的每个节点左右子树都填满，不足的使用空节点替代
    // 时间复杂度分析：contains若使用KMP实现，则其时间复杂度为O(n+m)，二叉树的遍历一次为O(n)，一次为O(m)
    // 综合时间复杂度为 O(n+m) + O(n) + O(m) ≈ O(n+m)
    // 从时间复杂度看，这里成了线性时间复杂度
    func isSubtree2(_ s: TreeNode?, _ t: TreeNode?) -> Bool {
        func postTraversal(_ root: TreeNode?) -> String {
            if let root = root {
                // 节点不为空，先递归拼接左子树，再递归拼接右子树
                var serializedStr = postTraversal(root.left)
                serializedStr += postTraversal(root.right)
                serializedStr += "\(String(root.val)),"
                return serializedStr
            }
            return "#," // 节点为空(递归基)，空节点使用 # 替代值，使用逗号“,”分隔
        }
        
//        // 若t为空，则无论s是否空都成立
//        guard let t = t else { return true }
//        // 来到这里，t不可能为空，如s为空，则t不是s的子树
//        guard let s = s else { return false }
        
        // 后边代码没有要求 t、s 必须解包，相较上边代码，这里省去了解包的过程
        if t === nil { return true }  // 若t为空，则无论s是否空都成立
        if s === nil { return false } // 来到这里，t不可能为空，如s为空，则t不是s的子树
        
        // 来到这里，s 和 t 都不为空
        // 使用后序遍历二叉树方式序列化采用后序
        // 如果采用先序遍历，需要加个头部才行，比如 12,3,4 和 2,3,4是包含关系，但实际上根节点一个是12、另一个则是2
        //    解决办法是添加一个开头标识，比如使用 @12,3,4 和 @2,3,4，这样就避免了上述问题
        // 这里可以序列化为字符串，也可以序列化为数组，为了之后使用方便，这里使用数组
        let serializedS = postTraversal(s)
        let serializedT = postTraversal(t)
        
        // 由于补齐空节点序列化，之后能够反向构建一个唯一二叉树，t 是否是 s 的子树，只需判断字符串是否包含即可
        return serializedS.contains(serializedT)
    }
}

do {
    do {
        let s = TreeNode(3)
        s.left = TreeNode(4)
        s.right = TreeNode(5)
        s.left?.left = TreeNode(1)
        s.left?.right = TreeNode(2)
//        s.left?.right?.left = TreeNode(0)


        let t = TreeNode(4)
        t.left = TreeNode(1)
        t.right = TreeNode(2)

        print(Solution().isSubtree2(s, t))
    }
    
    do {
        let s = TreeNode(1)
        s.left = TreeNode(2)
        
        let t = TreeNode(1)
        print(Solution().isSubtree2(s, t))
    }
}
