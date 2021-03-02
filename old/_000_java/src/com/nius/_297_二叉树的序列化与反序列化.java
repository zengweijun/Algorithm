package com.nius;


import java.util.Arrays;
import java.util.LinkedList;
import java.util.Queue;


// https://leetcode-cn.com/problems/serialize-and-deserialize-binary-tree/

/************************************
***** 这里采用层序遍历序列化方式 ********
*************************************/
class _297_二叉树的序列化与反序列化1 {
    // Encodes a tree to a single string.
    public String serialize(TreeNode root) {
        if (root == null) return null;
        Queue<TreeNode> queue = new LinkedList<>();
        queue.offer(root);

        StringBuilder sb = new StringBuilder();
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
        _297_二叉树的序列化与反序列化1 o = new _297_二叉树的序列化与反序列化1();
        TreeNode root = new TreeNode(1);
        root.left = new TreeNode(2);
        root.right = new TreeNode(3);
        root.right.left = new TreeNode(4);
        root.right.right = new TreeNode(5);
        String data = o.serialize(root);
        System.out.println(1 + " ==>:" + data);
        TreeNode newRoot = o.deserialize(data);
        String data1 = o.serialize(newRoot);
        System.out.println(1 + " ==>:" + data1);

    }
}

/************************************
 ***** 这里采用先序遍历序列化方式 ********
 *************************************/
class _297_二叉树的序列化与反序列化2 {
    // 先序遍历比较容易反序列化
    public String serialize(TreeNode root) {
        if (root == null) return null;
        StringBuilder sb = new StringBuilder();
        serialize(root, sb);
        return sb.toString();
    }
    public void serialize(TreeNode root, StringBuilder sb) {
        if (root == null) {
            sb.append("#,");
        } else {
            sb.append(String.valueOf(root.val)).append(",");
            serialize(root.left, sb);
            serialize(root.right, sb);
        }
    }

    // 使用队列遍历数据进行反序列化
    public TreeNode deserialize(String data) {
        if (data == null || data.length() == 0) return null;
        String[] values = data.split(",");
        Queue<String> queue = new LinkedList<String>();
        for (int i = 0; i < values.length; i++) {
            queue.offer(values[i]);
        }
        return deserialize(queue);
    }
    public TreeNode deserialize(Queue<String> queue) {
        String subStr = queue.poll();
        if (subStr.equals("#")) { return null; }
        TreeNode root = new TreeNode(Integer.valueOf(subStr));
        root.left = deserialize(queue);
        root.right = deserialize(queue);
        return root;
    }

    // 不使用队列遍历数据进行反序列化
    public TreeNode deserialize2(String data) {
        if (data == null || data.length() == 0) return null;
        String[] values = data.split(",");

        // 由于java不支持int引用传递，这里使用长度为1的数组代替
        int[] index = new int[1]; // 初始化后默认为0
        return deserialize2(values, index);
    }
    public TreeNode deserialize2(String[] values, int[] index) {
        String subStr = values[index[0]++]; // 取值后index后移，下次取出下一个值
        if (subStr.equals("#")) { return null; } // 直接返回空，不构建节点
        TreeNode root = new TreeNode(Integer.valueOf(subStr));
        root.left = deserialize2(values, index);
        root.right = deserialize2(values, index);
        return root;
    }

    public static void main(String[] args) {
        _297_二叉树的序列化与反序列化2 o = new _297_二叉树的序列化与反序列化2();
        TreeNode root = new TreeNode(1);
        root.left = new TreeNode(2);
        root.right = new TreeNode(3);
        root.right.left = new TreeNode(4);
        root.right.right = new TreeNode(5);
        String data = o.serialize(root);
        System.out.println(2 + " ==>:" + data);
        TreeNode newRoot = o.deserialize2(data);
        String data1 = o.serialize(newRoot);
        System.out.println(2 + " ==>:" + data1);
    }
}

