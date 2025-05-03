from typing import Optional

# Định nghĩa lớp ListNode
class ListNode:
    def __init__(self, val=0, next=None):
        self.val = val
        self.next = next

class Solution:
    def addTwoNumbers(self, l1: Optional[ListNode], l2: Optional[ListNode]) -> Optional[ListNode]:
        carry = 0
        ans = ListNode()
        cur = ans
        
        while l1 or l2 or carry:
            v1 = l1.val if l1 else 0
            v2 = l2.val if l2 else 0
            
            val = v1 + v2 + carry
            carry = val // 10
            val = val % 10
            
            cur.next = ListNode(val)
            cur = cur.next
            
            l1 = l1.next if l1 else None
            l2 = l2.next if l2 else None
        
        return ans.next

# Hàm để in danh sách liên kết
def printLinkedList(node: Optional[ListNode]):
    while node:
        print(node.val, end=" -> ")
        node = node.next
    print("None")

# Ví dụ kiểm tra hàm addTwoNumbers
if __name__ == "__main__":
    # Tạo danh sách liên kết l1: 2 -> 4 -> 3
    l1 = ListNode(2, ListNode(4, ListNode(3)))
    
    # Tạo danh sách liên kết l2: 5 -> 6 -> 4
    l2 = ListNode(5, ListNode(6, ListNode(4)))
    
    # Tạo đối tượng Solution và gọi phương thức addTwoNumbers
    solution = Solution()
    result = solution.addTwoNumbers(l1, l2)
    
    # In kết quả
    print("Kết quả:")
    printLinkedList(result)
