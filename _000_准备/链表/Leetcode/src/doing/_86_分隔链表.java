package doing;

import com.nius.node.LinkedList;
import com.nius.node.ListNode;

import java.util.List;

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

        int arr[] = new int[]{1, 4, 3, 2, 5, 2};
        ListNode head = LinkedList.createList(arr);
        head.showList();

        ListNode newHead = new _86_分隔链表().partition(head, 3);
        newHead.showList();
    }
}
