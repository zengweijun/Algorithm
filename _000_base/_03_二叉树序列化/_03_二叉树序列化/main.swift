//
//  main.swift
//  _03_二叉树序列化
//
//  Created by nius on 2020/3/12.
//  Copyright © 2020 nius. All rights reserved.
//

import Foundation

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


//MARK: - 二叉树的序列化
func serialize(_ root: TreeNode) -> String {
    
    return ""
}

do {
    /**
     下图序列化结果：
        ①前序遍历：@3!4!1!#!#!2!#!#!5!#!#!
        ②中序遍历：@#!1!#!4!#!2!#!3!#!5!#!
        ③后序遍历：@#!#!1!#!#!2!4!#!#!5!3!
        ④层序遍历：@3!4!5!1!2!#!#!#!#!#!#!
        3
        / \
       4   5
       / \
      1   2
     节点：数值 + ! (eg.根节点3表示为 3!，节点4表示为 4!)；空节点 # + ! (eg. 节点5的左子树 #! )
     注意：二叉树的序列化必须将空节点也一起计算，否则反序列化的时候无法得到一颗唯一的二叉树
        如上图二叉树中，1、2、5等所有节点都必须使用空节点补齐其子树
     */
    
    
    
    
}




//MARK: - 二叉树的反序列化
func deserialize(_ root: String) -> String {
    
    return ""
}

