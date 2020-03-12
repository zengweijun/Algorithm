package com.nius;


import java.util.Arrays;
import java.util.LinkedList;
import java.util.Queue;


// https://leetcode-cn.com/problems/serialize-and-deserialize-binary-tree/

public class _297_二叉树的序列化与反序列化 {
    // Encodes a tree to a single string.
    public String serialize(TreeNode root) {
        if (root == null) return null;
        Queue<TreeNode> queue = new LinkedList<>();
        queue.offer(root);

        StringBuffer sb = new StringBuffer();
        while (!queue.isEmpty()) {
            TreeNode node = queue.poll();
            if (node != null) {
                sb.append(node.val);
                queue.offer(node.left);
                queue.offer(node.right);
            } else {
                sb.append("#");
            }
            if (!queue.isEmpty()) {
                sb.append(",");
            }
        }
        return sb.toString();
    }

    // Decodes your encoded data to tree.
    public TreeNode deserialize(String data) {
        if (data == null || data.length() == 0) return null;
        String[] values = data.split(",");

        // System.out.println(Arrays.toString(strings));
        TreeNode root = new TreeNode(Integer.valueOf(values[0]));
        Queue<TreeNode> queue = new LinkedList<>();
        queue.offer(root);

        int i = 1;
        while (!queue.isEmpty()) {
            TreeNode node = queue.poll();
            if (i < values.length && !values[i].equals("#")) {
                int value = Integer.valueOf(values[i]);
                node.left = new TreeNode(value);
                queue.offer(node.left);
            }
            int next = i + 1;
            if (next < values.length && !values[next].equals("#")) {
                int value = Integer.valueOf(values[next]);
                node.right = new TreeNode(value);
                queue.offer(node.right);
            }
            i += 2;
        }
        return root;
    }

    public static void main(String[] args) {
        _297_二叉树的序列化与反序列化 o = new _297_二叉树的序列化与反序列化();
        TreeNode root = new TreeNode(1);
        root.left = new TreeNode(2);
        root.right = new TreeNode(3);
        root.right.left = new TreeNode(4);
        root.right.right = new TreeNode(5);
        String data = o.serialize(root);
        System.out.println(data);
        TreeNode newRoot = o.deserialize(data);
        String data1 = o.serialize(newRoot);
        System.out.println(data1);

    }
}

