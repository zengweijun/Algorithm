//
//  main.swift
//  _739_每日温度
//
//  Created by nius on 2020/3/4.
//  Copyright © 2020 nius. All rights reserved.
//

import Foundation

/**
 根据每日 气温 列表，请重新生成一个列表，对应位置的输入是你需要再等待多久温度才会升高超过该日的天数。如果之后都不会升高，请在该位置用 0 来代替。

 例如，给定一个列表 temperatures = [73, 74, 75, 71, 69, 72, 76, 73]，你的输出应该是 [1, 1, 4, 2, 1, 1, 0, 0]。

 提示：气温 列表长度的范围是 [1, 30000]。每个气温的值的均为华氏度，都是在 [30, 100] 范围内的整数。

 来源：力扣（LeetCode）
 链接：https://leetcode-cn.com/problems/daily-temperatures
 */

class Solution {
    func dailyTemperatures(_ T: [Int]) -> [Int] {
        // [73, 74, 75, 71, 69, 72, 76, 73]
        // 要求的其实就是，隔几个索引该值为变大
        // 比如 75 索引为2，一直到76 索引为6 气温才升高，中间间隔为 6-2=4
        // 因此，其实转化为求每个元素右边比自己大的第一个数，再将第一个大的数的索引减去当前位置索引，就得到最终结果
        
        // 寻找数组中左边或者右边第一个比自己大的数，通常可以使用栈(单调递减栈)
        var stack = [Int]()
        
        // 每个数右边比自己大的第一个数对应的索引值
        let count = T.count
        var rightMaxIndexs = [Int](repeating: 0, count: count)
        
        for i in 0..<count {
            let value = T[i]
            // 检查栈中元素是否都比当前元素小，如果是则将这些元素出栈，并且当前元素索引设置为这些元素的右边第一个比之大的索引
            // 对于相等的情况，不要出栈，因为相等没有发现右边比之大的第一个数
            while let topElement = stack.last, value > T[topElement] {
                // 删掉栈顶索引的同时，记录将当前元素索引为栈顶索引元素右边第一个比之更大的元素
                rightMaxIndexs[stack.removeLast()] = i
            }
            
            // 如果也需要记录左边更大的第一个，可以在入栈时记录，不过这里我们不需要
            //if let topElement = stack.last {
            //    // 记录栈顶索引为当前索引元素左边第一个更大的元素索引
            //    leftMaxIndexs[i] = topElement
            //}
            
            // 栈中此时不会出现比当前索引元素更小的元素索引，满足单调递减特性，直接入栈
            stack.append(i)
        }
        
        var result = [Int](repeating: 0, count: count)
        for i in 0..<count {
            // 求出右边第一个更大元素的索引与当前元素的索引差值
            let rightMaxIndex = rightMaxIndexs[i]
            result[i] = (rightMaxIndex == 0) ? 0 : (rightMaxIndex - i)
        }
        
        return result
    }
    
    // 改进，无需 rightMaxIndexs
    func dailyTemperatures1(_ T: [Int]) -> [Int] {
        // 边界：空数组算法表现安全
        var stack = [Int]() // 单点递减栈
        
        let count = T.count
        var result = [Int](repeating: 0, count: count)
        
        for i in 0..<count {
            let value = T[i]
            while let topElement = stack.last, value > T[topElement] {
                // i位置元素比之前元素大，则i是之前元素的右边第一个更大元素，可以求的之前元素升温间隔
                // 计算之前元素的升温间隔
                result[topElement] = i - stack.removeLast()
            }
                
            // 入栈记录当前元素
            stack.append(i)
        }
        return result
     }
    
    
    // 改进，无需 rightMaxIndexs，逆袭遍历，代码没有方法二简洁，不过也是一种思路
    // 逆向遍历数组，并将遍历到的元素索引注册到栈
    // 每次遍历到一个元素，就栈中找到比它大的元素，使用该元素索引-当前i即可
    func dailyTemperatures2(_ T: [Int]) -> [Int] {
        // 边界：空数组算法表现安全
        let count = T.count
        var stack = [Int]()
        var result = [Int](repeating: 0, count: count)
        for i in stride(from: count - 1, to: -1, by: -1) {
            // 检查栈，将栈中比当前元素更小的元素索引删除
            // 因为要找的是比之更大的第一个数，所以小的没必要保留，而该操作不会影响更前边的元素
            // 相等也删掉，因为相等不算右边更大的数
            // 这里事实上也是一个单调栈
            while let topElement = stack.last, T[topElement] <= T[i] {
                stack.removeLast()
            }
            
            // 来到这里，栈是空的 或者 栈中存在元素更大
            if let topElement = stack.last {
                // 栈中存在元素更大，栈顶元素一定是当前元素右边第一个更大的数的索引
                result[i] = topElement - i // 计算距离
            }
            //else { // 栈是空的
                // 右边没有更大的元素，初始化数组默认就是0
                // result[i] = 0
            //}
            stack.append(i) // 注册当前元素
        }
        return result
    }
    
    // 逆序遍历
    func dailyTemperatures3(_ T: [Int]) -> [Int] {
        // 边界：空数组算法表现安全
        let count = T.count
        var result = [Int](repeating: 0, count: count)
        result[count - 1] = 0 // 最后一个默认为0
        
        // 从倒数第二个开始寻找
        for i in stride(from: count - 2, to: -1, by: -1) {
            if T[i] < T[ i+1 ] {
                result[i] = 1
                continue
            }
            
            // 下一个不比它大，就找它的下一个最大的第一个
            var rightMaxIndex = (i + 1) + result[ i+1 ]
            
            // 注意：这里遇到某一个T[rightMaxIndex] == 0，说明T[rightMaxIndex]已经是后半部分数组所有值中的最大值了，或者说已经结尾了
            while result[rightMaxIndex] != 0 && T[i] >= T[rightMaxIndex] {
                rightMaxIndex += result[rightMaxIndex]
            }
            
            // rightMaxIndex指向末尾(但末尾不是更大的值)，或者指向一个更大的值
            result[i] =  T[i] >= T[rightMaxIndex] ? 0 : rightMaxIndex - i
        }
        return result
    }
}

do {
    //    [73, 74, 75, 71, 69, 72, 76, 73]
    // -->[ 1,  1,  4,  2,  1,  1,  0,  0]
//    print(Solution().dailyTemperatures([73, 74, 75, 71, 69, 72, 76, 73]))
//    print(Solution().dailyTemperatures1([73, 74, 75, 71, 69, 72, 76, 73]))
//    print(Solution().dailyTemperatures2([73, 74, 75, 71, 69, 72, 76, 73]))
//    print(Solution().dailyTemperatures3([73, 74, 75, 71, 69, 72, 76, 73]))
    

//    print(Solution().dailyTemperatures([34,80,80,34,34,80,80,80,80,34]))
//    print(Solution().dailyTemperatures3([34,80,80,34,34,80,80,80,80,34]))
    
    
}
