//
//  main.swift
//  _236_二叉树的最近公共祖先
//
//  Created by nius on 2020/4/24.
//  Copyright © 2020 nius. All rights reserved.
//

import Foundation

/*
 给定一个二叉树, 找到该树中两个指定节点的最近公共祖先。

 百度百科中最近公共祖先的定义为：“对于有根树 T 的两个结点 p、q，最近公共祖先表示为一个结点 x，满足 x 是 p、q 的祖先且 x 的深度尽可能大（一个节点也可以是它自己的祖先）。”

 例如，给定如下二叉树:  root = [3,5,1,6,2,0,8,null,null,7,4]
 
                  ┏━━━━━━━━━ 3 ━━━━━━━━━┓
                  ┃                     ┃
             ┏━━━ 5 ━━━┓           ┏━━━ 1 ━━━┓
             ┃         ┃           ┃         ┃
             6    ┏━━━ 2 ━━━┓      0         8
                  ┃         ┃
                  7         4
 
 示例 1:
 输入: root = [3,5,1,6,2,0,8,null,null,7,4], p = 5, q = 1
 输出: 3
 解释: 节点 5 和节点 1 的最近公共祖先是节点 3。

 示例 2:
 输入: root = [3,5,1,6,2,0,8,null,null,7,4], p = 5, q = 4
 输出: 5
 解释: 节点 5 和节点 4 的最近公共祖先是节点 5。因为根据定义最近公共祖先节点可以为节点本身。

 说明:
     所有节点的值都是唯一的。
     p、q 为不同节点且均存在于给定的二叉树中。

 来源：力扣（LeetCode）
 链接：https://leetcode-cn.com/problems/lowest-common-ancestor-of-a-binary-tree
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
    // 使用父指针迭代
    func lowestCommonAncestor1(_ root: TreeNode?, _ p: TreeNode?, _ q: TreeNode?) -> TreeNode? {
        // 时间：O(n)，空间：O(n)
        /*
         思路：如果每个节点都有父指针，则只需沿着父指针遍历，使用双链表相交的思想即可找到最近公共祖先
              这里没有父指针，但我们可以使用hash表来为每一个节点记录其父指针
         
         过程：
         1.从根开始层序遍历，并将遍历到的节点都装入一个hash表中，同时使用左右子树为key、父节点为value【相当于为子节点设置了一个parent指针】，当hash表中同时存在p和q时停止
         2.从p开始一直向parent到根，装入一个Set中，即p到根这一条链上的节点都装入了Set中，而这些节点都算是p的祖先节点（包含p）
         3.从q开始一直向parent到根，如果发现任何一个节点出于q的Set中，说明这个节点即时他们的最近公共祖先节点
         */
        
        var queue: [TreeNode?] = []
        // 元素需要Hash协议，这里使用节点值
        // 题目指明所有节点值唯一，这里可以使用值来做key
        var parent: [Int? : TreeNode?] = [:]
        
        queue.append(root)
        parent[root?.val] = nil
        
        while !queue.isEmpty && (!parent.keys.contains(p?.val) || !parent.keys.contains(q?.val)) {
            let node = queue.removeFirst()
            
            if node?.left !== nil {
                queue.append(node?.left)
                parent[node?.left?.val] = node // 为left记录其父节点
            }
            if node?.right !== nil {
                queue.append(node?.right)
                parent[node?.right?.val] = node // 为right记录其父节点
            }
        }
        
        // 来到这里，p和q的parent一定都知道了，我们先从p开始，找出p的祖先链表
        // 并用一个Set来记录p的祖先链表节点
        var ancestors = Set<Int?>() // 由于Set元素需要Hash协议，这里使用节点值
        
        // p的祖先set
        var p = p
        while p !== nil {
            ancestors.insert(p?.val)
            p = parent[p?.val] ?? nil
        }
        
        // 从q开始向上遍历祖先，找到与p相同的祖先即为最近公共祖先
        var q = q
        while q !== nil && !ancestors.contains(q?.val) {
            q = parent[q?.val] ?? nil
        }
        
        return q
    }
    
    // 递归法
    // 该方法的最终目的就是返回最近公共祖先节点
    func lowestCommonAncestor2(_ root: TreeNode?, _ p: TreeNode?, _ q: TreeNode?) -> TreeNode? {
        // 时间：O(n)，空间：O(n) 【空间本应该是O(h)，即树高，但最坏情况是二叉树是一条链表】
        /*
         1.如果两个node在root的两边，那么最早的公共祖先就是root。
         2.如果两个node在root的左边，那么把root的左子树作为root，再递归。
         3.如果两个node在root的右边，那么把root的右子树作为root，再递归。
         */
        
        if root == nil || p === root || q === root {
            return root // 空树 或者 其中一个节点已经处于二叉树根节点，那此时的根节点一定是最近的公共祖先节点
        }
        
        let left = lowestCommonAncestor1(root?.left, p, q)
        let right = lowestCommonAncestor1(root?.right, p, q)
        
        /*
        if left !== nil && right !== nil {
            // ①如果两棵树返回都不为空，则能判断这两个节点分散在两棵树中，因为当root==节点本身是会返回本身，不会再继续往下走
            return root
        } else if left !== nil {
            // ②如果left不为空且right为空，则说明两个节点都处于左子树中。那此时返回的left就是最近的公共祖先节点
            return left
        } else if right !== nil {
            // ②如果left不为空且right为空，则说明两个节点都处于左子树中。那此时返回的left就是最近的公共祖先节点
            return right
        } else {
            // ④都为空
            return nil
        }
         */
        
        // 简化为如下两句
        if left !== nil && right !== nil { return root }
        return (left !== nil) ? left : right
    }
    
}


do {
    let vals = [3,5,1,6,2,0,8,nil,nil,7,4]
    var root: TreeNode? = nil
    var p: TreeNode?
    var q: TreeNode?
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
            if vals[i] == 0 { p = node }
            if vals[i] == 8 { q = node }
        }
    }
    
    let s = Solution().lowestCommonAncestor2(root, p, q)
    print("")
}
