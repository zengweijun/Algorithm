//
//  main.swift
//  _333_最大 BST 子树
//
//  Created by 曾维俊 on 2020/5/5.
//  Copyright © 2020 Nius. All rights reserved.
//

import Foundation

/*
 返回二叉树中的最大二叉搜索树的节点个数
 注意：二叉树搜索树必须包含其所有后台（即所有子节点，叶子节点）
 
示例:
输入: [10,5,15,1,8,null,7]

   10
   / \
  5  15
 / \   \
1   8   7

输出: 3
解释: 高亮部分为最大的 BST 子树。
     返回值 3 在这个样例中为子树大小。
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

// MARK: - 自顶向下算法思维
class Solution1 {
    // 常规思维（自顶向下的算法过程），O(n^2)
    // 从上到下，每个节点都做了同样的事，这样有些节点被访问了非常多次，综合来看时间复杂度在O(n^2)
    func isBST(root: TreeNode?) -> Bool {
        // 判断一棵二叉树是否是二叉搜索树，
        // 注意，不能针对单个节点判断，那样只能判断局部：节点大于左子节点，小于右子节点
        // 最好的做法是将中序遍历的结果放入一个数组中，然后判断升序
        // 不过判断升序无需存储所有元素，那样会带来O(n)的孔家复杂度，判断是否升序只需要知道当前val和上一个val即可
        
        // 这里遍历使用迭代方式
        var stack = [TreeNode?]()
        var node = root
        var pre:TreeNode?
        while node !== nil || !stack.isEmpty {
            while node !== nil { // DFS
                stack.append(node)
                node = node?.left // 每次入栈节点，都会将左子节点全部入栈
            }
            
            // 1.根据栈的性质，这里会先出栈左子节点，再出栈父节点
            let tmpNode = stack.popLast()! // 上班逻辑使得这里stack不可能为空，直接强制解包
            
            // 处理节点，这里主要是对比一下，是否符合升序规则
            
            let preVal = pre?.val ?? Int.min
            guard let tmpVal = tmpNode?.val, tmpVal >= preVal  else { return false }
            // 记录当前访问的节点
            pre = tmpNode
            
            // 2.访问右子节点（下一次循环入栈）
            node = tmpNode?.right
        }
        return true
    }
    
    // 统计二叉树的节点个数
    func countOf(root: TreeNode?) -> Int {
        if root === nil { return 0 }
        let leftCount = countOf(root: root?.left)
        let rightCount = countOf(root: root?.right)
        return 1 + leftCount + rightCount
    }
    
    // 以root为根的最大二叉搜索子树节点数
    func largestBSTSubtree(root: TreeNode?) -> Int {
        if root === nil { return 0 }
        if isBST(root: root) { return countOf(root: root) }
        return max(largestBSTSubtree(root: root?.left), largestBSTSubtree(root: root?.right))
    }
}

// MARK: - 自低向上算法思维
class Solution2 {
    // https://blog.csdn.net/qq_43658387/article/details/105871328
    // 逆向思维（自低向上的算法过程），O(n)
    // 上诉方案中，由于从根节点到左右子节点都做同样的事情，导致了大量重复，这里使用另一种思维，自底向上
    // 即先判断当前子树是否是BST，如果当前子树不是BST，则包含父节点的子树也不可能是BST
    // 如果当前子树是BST，则根据父节点左右BST情况综合判断包含父节点的子树是否是BST，这样处理起来基本每个节点只被访问一次，时间复杂度O(n)
    func largestBSTSubtree(root: TreeNode?) -> Int {
        
        
        
        return 0
    }
}


// MARK: - 遍历
func inOrderRecursive(root: TreeNode?) {
    if root === nil { return }
    inOrderRecursive(root: root?.left)
    print(root?.val ?? "", terminator: "\t")
    inOrderRecursive(root: root?.right)
}

func inOrderMorris(root: TreeNode?) { // Morris遍历方法，空间复杂度为O(1)
    if root === nil { return }
    
    // 获取前驱节点
    func predcessor(node: TreeNode?) -> TreeNode? {
        if node?.left === nil { return nil }
        var predcessor = node?.left // left -> right -> right ...
        while predcessor?.right !== nil && predcessor?.right !== node { // 因为有修改right指针，这里过滤前驱节点不能是自己
            predcessor = predcessor?.right
        }
        return predcessor
    }
    
    var node = root
    while node !== nil {
        if node?.left === nil { // 左子节点为空，该节点直接打印
            print(node?.val ?? "", terminator: "\t")
            node = node?.right // 打印后指向右子节点
        } else {
            // 左子节点不为空，说明存在前驱，那应该先打印前驱
            let pred = predcessor(node: node)
            
            // 事实上，前驱只有两种情况，要么指向自己，要么为nil
            if pred?.right === node { // 前驱节点的right已经指向自己了，说明前驱节点已经被打印，那直接打印
                print(node?.val ?? "", terminator: "\t")
                node = node?.right // 打印后指向右子节点
                pred?.right = nil  // 去掉前驱right，还原二叉树的结构
            } else if (pred?.right === nil) {
                pred?.right = node  // 为空，说明第一次访问到该前驱，调整right为指向自己，以便遍历的时候能根据right定位到下一个节点即为自己
                node = node?.left   // 继续调整自己的左子树，满足每个节点前驱都right都指向自己
            }
        }
    }
}

func inOrder(root: TreeNode?) {
    if root === nil { return }
    
    var stack = [TreeNode?]()
    
    var node = root
    while node !== nil || !stack.isEmpty {
        while node != nil {
            stack.append(node)
            node = node?.left
        }
        
        let tmpNode = stack.popLast()!
        print(tmpNode?.val ?? "", terminator: "\t")
        
        node = tmpNode?.right
    }
}

do {
    /*
        10
        / \
       5  15
      / \
     1   8
        /
       7
     */
    let root = TreeNode.BST([10,5,15,1,8,nil,7])
    print("==================================================")
    print("---------------inOrderRecursive")
    inOrderRecursive(root: root)
    print("\n---------------inOrderMorris")
    inOrderMorris(root: root)
    print("\n---------------inOrder")
    inOrder(root: root)
    print("\n==================================================")
    
    print(Solution1().isBST(root: root))
    print(Solution1().countOf(root: root))
    print(Solution1().largestBSTSubtree(root: root))
}

//do {
//    /*
//        10
//        / \
//       5  15
//      / \
//     1   8
//        /
//       7
//     */
//    let root = TreeNode.BST([10,5,15,1,8,nil,7])
//    inOrderRecursive(root: root)
//    print("---------------")
//    inOrder(root: root)
//
//}



