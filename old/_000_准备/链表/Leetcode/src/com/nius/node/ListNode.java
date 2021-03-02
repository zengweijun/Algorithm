package com.nius.node;

public class ListNode {
    public int val;
    public ListNode next;
    public ListNode(int x) { val = x; }

    public void showList() {
        ListNode cur = this;
        while (cur != null) {
            System.out.print(cur.val + " -> ");
            cur = cur.next;
        }
        System.out.print("null \n");
    }
}
