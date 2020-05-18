package com.nius.node;

import java.lang.reflect.Array;
import java.util.List;

public class LinkedList {
    public static ListNode createList(int list[]) {
        ListNode dummyHead = new ListNode(0);
        ListNode tail = dummyHead;

        for (int i = 0; i < list.length; i++) {
            tail.next = new ListNode(list[i]);
            tail = tail.next;
        }
        return dummyHead.next;
    }

    public static void showList(ListNode head) {
        head.showList();
    }
}
