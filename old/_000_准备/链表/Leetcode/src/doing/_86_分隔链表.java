package doing;

import com.nius.node.LinkedList;
import com.nius.node.ListNode;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

// 给定一个链表和一个特定值 x，对链表进行分隔，使得所有小于 x 的节点都在大于或等于 x 的节点之前。
//
//你应当保留两个分区中每个节点的初始相对位置。
//
//示例:
//
//输入: head = 1->4->3->2->5->2, x = 3
//输出: 1->2->2->4->3->5
//
//来源：力扣（LeetCode）
//链接：https://leetcode-cn.com/problems/partition-list

public class _86_分隔链表 {
    public ListNode partition(ListNode head, int x) {
        if (head == null) return head;

        ListNode dummyHead1 = new ListNode(0);
        ListNode dummyHead2 = new ListNode(0);
        ListNode tail1 = dummyHead1;
        ListNode tail2 = dummyHead2;
        ListNode cur = head;
        while (cur != null) {
            if (cur.val < x) {
                tail1.next = cur;
                tail1 = cur;
            } else {
                tail2.next = cur;
                tail2 = cur;
            }
            cur = cur.next;
        }
        tail2.next = null;
        tail1.next = dummyHead2.next;
        return dummyHead1.next;
    }

    public static void main(String[] args) {

//        int arr[] = new int[]{1, 4, 3, 2, 5, 2};
//        ListNode head = LinkedList.createList(arr);
//        head.showList();
//
//        ListNode newHead = new _86_分隔链表().partition(head, 3);
//        newHead.showList();


        int arr[] = new int[]{1, 2, 3, 3, 4, 4, 5};
        ListNode head = LinkedList.createList(arr);
        head.showList();
        ListNode newHead = deleteDuplication(head);
        newHead.showList();

    }

    static public ListNode deleteDuplication(ListNode pHead)
    {
        if (pHead == null || pHead.next == null) return pHead;

        // 虚拟头
        ListNode dummyHead = new ListNode(0);
        dummyHead.next = pHead;

        // 三指针
        ListNode dummyTail = dummyHead;
        ListNode cur = dummyTail.next;
        ListNode next = cur.next;

        while(next != null) {
            // 1.使用cur - next框选相同值的节点；由于是排序的链表，因此相同节点一定会在一起
            while(next != null && next.val == cur.val) {
                next = next.next; // 只要发现值相同，就将next后移，直到不同
            }

            // 2.如果cur和next之间存在重复节点，那么next经过上面while以后，一定不会和cur相邻
            if (cur.next == next) {
                // cur和next相邻，说明中间不存在重复节点
                // 则直接让pre指向cur，并将cur和next同时后移，继续检查
                dummyTail.next = cur;
                dummyTail = cur;
                cur = dummyTail.next;
                next = cur.next;
            } else {
                // cur和next不相邻，说明之间存在重复节点，则应过掉，由于经过上面while之后，cur和next一定不相等
                // 因此直接删掉cur及cur到next之前的节点即可
                dummyTail.next = next;
                dummyTail = next;

                cur = dummyTail.next;
                if (cur != null) {
                    next = cur.next;
                }
            }
        }

        return dummyHead.next;
    }
}
