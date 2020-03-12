//
//  main.swift
//  _297_二叉树的序列化与反序列化
//
//  Created by nius on 2020/3/12.
//  Copyright © 2020 nius. All rights reserved.
//

import Foundation

/**
 序列化是将一个数据结构或者对象转换为连续的比特位的操作，进而可以将转换后的数据存储在一个文件或者内存中，同时也可以通过网络传输到另一个计算机环境，采取相反方式重构得到原数据。

 请设计一个算法来实现二叉树的序列化与反序列化。这里不限定你的序列 / 反序列化算法执行逻辑，你只需要保证一个二叉树可以被序列化为一个字符串并且将这个字符串反序列化为原始的树结构。

 示例:

 你可以将以下二叉树：

     1
    / \
   2   3
      / \
     4   5

 序列化为 "[1,2,3,null,null,4,5]"
 提示: 这与 LeetCode 目前使用的方式一致，详情请参阅 LeetCode 序列化二叉树的格式。你并非必须采取这种方式，你也可以采用其他的方法解决这个问题。

 说明: 不要使用类的成员 / 全局 / 静态变量来存储状态，你的序列化和反序列化算法应该是无状态的。

 来源：力扣（LeetCode）
 链接：https://leetcode-cn.com/problems/serialize-and-deserialize-binary-tree
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

class Codec {
    // Encodes a tree to a single string.
    func serialize(_ root: TreeNode?) -> String {
        guard let root = root else { return "" }
        
        // 层序遍历二叉树（BFS：广度优先）
        var queue: [TreeNode?] = []
        queue.append(root)
        
        var serializeResult = ""
        while !queue.isEmpty {
            let node = queue.removeFirst()
            if let unpackedNode = node {
                serializeResult = serializeResult + String(unpackedNode.val)
                queue.append(unpackedNode.left)
                queue.append(unpackedNode.right)
            } else {
                serializeResult = serializeResult + "#"
            }
            if !queue.isEmpty { serializeResult += "," }
        }
        
        return serializeResult
    }

    // Decodes your encoded data to tree.
    func deserialize(_ data: String) -> TreeNode? {
        let vals = data.split(separator: ",")
        if vals.count == 0 { return nil }
        
        guard let rootVal = Int(vals[0]) else {
            return nil
        }
        
        let root = TreeNode(rootVal)
        var queue: [TreeNode?] = []
        queue.append(root)
        
        var i = 1
        while !queue.isEmpty {
            let node = queue.removeFirst()
            
            if i < vals.count, let leftVal = Int(vals[i]) {
                node?.left = TreeNode(leftVal)
                queue.append(node?.left)
            }
            if i + 1 < vals.count, let rightVal = Int(vals[i + 1]) {
                node?.right = TreeNode(rightVal)
                queue.append(node?.right)
            }
            i += 2
        }
        return root
    }
}

do {
    do {
        let root = TreeNode(1)
        root.left = TreeNode(2)
        root.right = TreeNode(3)
        root.right?.left = TreeNode(4)
        root.right?.right = TreeNode(5)
        let data = Codec().serialize(root)
        print(data)
        let newRoot = Codec().deserialize(data)
        //print(newRoot as Any)
        let data1 = Codec().serialize(newRoot)
        print(data1)
    }
//    do {
//        let root = TreeNode(1)
//        root.left = TreeNode(2)
//        root.right = TreeNode(3)
//        root.left?.left = TreeNode(4)
//        root.left?.right = TreeNode(5)
//        print(Codec().serialize(root))
//    }
}

