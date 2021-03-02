//
//  main.swift
//  _235_二叉搜索树的最近公共祖先
//
//  Created by nius on 2020/3/18.
//  Copyright © 2020 nius. All rights reserved.
//

import Foundation

/*
 给定一个二叉搜索树, 找到该树中两个指定节点的最近公共祖先。

 百度百科中最近公共祖先的定义为：“对于有根树 T 的两个结点 p、q，最近公共祖先表示为一个结点 x，满足 x 是 p、q 的祖先且 x 的深度尽可能大（一个节点也可以是它自己的祖先）。”

 例如，给定如下二叉搜索树:  root = [6,2,8,0,4,7,9,null,null,3,5]

 示例 1:
 输入: root = [6,2,8,0,4,7,9,null,null,3,5], p = 2, q = 8
 输出: 6
 解释: 节点 2 和节点 8 的最近公共祖先是 6。
 示例 2:

 输入: root = [6,2,8,0,4,7,9,null,null,3,5], p = 2, q = 4
 输出: 2
 解释: 节点 2 和节点 4 的最近公共祖先是 2, 因为根据定义最近公共祖先节点可以为节点本身。
  

 说明:
 所有节点的值都是唯一的。
 p、q 为不同节点且均存在于给定的二叉搜索树中。
 https://leetcode-cn.com/problems/lowest-common-ancestor-of-a-binary-search-tree/
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
    
    public static func BST(_ vals: [Int?]) -> TreeNode? {
        var root: TreeNode? = nil
        if vals.count == 0 {
            return nil
        }
        
        if let rootVal = vals[0] {
            root = TreeNode(rootVal)
            for i in 1..<vals.count {
                var node = root
                while let nodeVal = node?.val, let unpackedVal = vals[i] {
                    if unpackedVal > nodeVal {
                        if node?.right !== nil {
                            node = node?.right
                        } else {
                            node?.right = TreeNode(unpackedVal)
                            break
                        }
                    } else {
                        if node?.left !== nil {
                            node = node?.left
                        } else {
                            node?.left = TreeNode(unpackedVal)
                            break
                        }
                    }
                }
            }
        }
        return root
    }
}

class Solution {
    // 递归 O(n)
    func lowestCommonAncestor1(_ root: TreeNode?, _ p: TreeNode?, _ q: TreeNode?) -> TreeNode? {
        // 获取根节点的值，获取p、q节点的值
        guard let rootVal = root?.val, let pVal = p?.val, let qVal = q?.val else {
            return nil
        }
        
        /*
        二叉搜索树BST
        节点 node 左子树上的所有节点的值都小于等于节点 node 的值
        节点 node 右子树上的所有节点的值都大于等于节点 node 的值
        左子树和右子树也都是 BST
        */
        if pVal < rootVal && qVal < rootVal {
            // 如果p、q节点值均小于root的值，则说明都出于左子树中，那就去左子树寻找
            return lowestCommonAncestor1(root?.left, p, q)
        } else if (pVal > rootVal && qVal > rootVal) {
            // 如果p、q节点值均大于root的值，则说明都出于右子树中，那就去右子树寻找
            return lowestCommonAncestor1(root?.right, p, q)
        } else {
            // 如果p、q节点值一个大于root的值，另一个小于root，则说明他们出于root的左右子树上
            // 此时root是他们最近公共父节点
            // 注意：节点本身也是可以看成是自己的父节点，因此，值相等的情况也包含进去
            return root
        }
    }
    
    // 迭代 O(n)
    func lowestCommonAncestor2(_ root: TreeNode?, _ p: TreeNode?, _ q: TreeNode?) -> TreeNode? {
        // 获取根节点的值，获取p、q节点的值
        guard let pVal = p?.val, let qVal = q?.val else {
            return nil
        }
        
        /*
        二叉搜索树BST
        节点 node 左子树上的所有节点的值都小于等于节点 node 的值
        节点 node 右子树上的所有节点的值都大于等于节点 node 的值
        左子树和右子树也都是 BST
        */
        
        var node = root
        
        while node !== nil {
            if let nodeVal = node?.val {
                if pVal < nodeVal && qVal < nodeVal {
                    // 如果p、q节点值均小于root的值，则说明都出于左子树中，那就去左子树寻找
                    node = node?.left
                } else if (pVal > nodeVal && qVal > nodeVal) {
                    // 如果p、q节点值均大于root的值，则说明都出于右子树中，那就去右子树寻找
                    node = node?.right
                } else {
                    // 如果p、q节点值一个大于root的值，另一个小于root，则说明他们出于root的左右子树上
                    // 此时root是他们最近公共父节点
                    // 注意：节点本身也是可以看成是自己的父节点，因此，值相等的情况也包含进去
                    return node
                }
            } else {
                break
            }
        }
        return nil
    }
}

