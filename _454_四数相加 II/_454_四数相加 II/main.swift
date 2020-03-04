//
//  main.swift
//  _454_四数相加 II
//
//  Created by nius on 2020/3/4.
//  Copyright © 2020 nius. All rights reserved.
//

import Foundation

/**
 给定四个包含整数的数组列表 A , B , C , D ,计算有多少个元组 (i, j, k, l) ，使得 A[i] + B[j] + C[k] + D[l] = 0。

 为了使问题简单化，所有的 A, B, C, D 具有相同的长度 N，且 0 ≤ N ≤ 500 。所有整数的范围在 -228 到 228 - 1 之间，最终结果不会超过 231 - 1 。

 例如:
 输入:
 A = [ 1, 2]
 B = [-2,-1]
 C = [-1, 2]
 D = [ 0, 2]

 输出:
 2

 解释:
 两个元组如下:
 1. (0, 0, 0, 1) -> A[0] + B[0] + C[0] + D[1] = 1 + (-2) + (-1) + 2 = 0
 2. (1, 1, 0, 0) -> A[1] + B[1] + C[0] + D[0] = 2 + (-1) + (-1) + 0 = 0

 来源：力扣（LeetCode）
 链接：https://leetcode-cn.com/problems/4sum-ii
 */


class Solution {
    func fourSumCount(_ A: [Int], _ B: [Int], _ C: [Int], _ D: [Int]) -> Int {
        /** 注册法 算法时间复杂度为O(n^2)  空间复杂度O(n)
         四数相加：a+b+c+d = 0，变化一线即为 a+b = -(c+d)
         因此只需要将 sum =  -(A[i]+B[j]) 记录下来，然后找到 sum = (C[k]+D[l])
         这样就满足了：A[i] + B[j] + C[k] + D[l] = 0。
         
         提示：将 target =  -(A[i]+B[j]) 的所有排列组合记录下来，比如记录有5个排列这的值为8，这记录为dic[-8] = 5
              然后排列组合C[k]+D[l]，如果发现值为-8，则说明找到了一个符合条件的值，记录下来，再继续进行
         */
        
        // key：-(A[i]+B[j])，value：出现次数
        // dic[key]取值的时候，为了防止没取到可以给个默认值 dic[key, default: 0]
        // 当字典中key不存在时，可以取得0
        var dic = [Int: Int]()
        
        // 所有的 A, B, C, D 具有相同的长度 N
        let count = A.count
        
        for i in 0..<count {
            for j in 0..<count {
                let sum = -(A[i] + B[j])
                dic[sum, default: 0] += 1
            }
        }
        
        /**
         此时，dic的值可能是这样的，key是 A[i] + B[j]  的相反数
         [ 3 : 5,      6 : 1,       -7 : 2 ]
         只要后边遍历sum = C[k]+D[l]，发现target等于 A[i] + B[j]  的相反数，则说明找到了加和为0的排列
         比如 sum = 3，由于-3的排列在 A[i] + B[j] 中存在5个，因此加和为0的排列为5
         如果再找到一个 sum = 3，则此时又产生了5个新排列，此时加和为0的排列总数就为 （上一次的5 + 本次的5 = 10）
         */
        var sumEqualToZeroCount = 0
        for k in 0..<count {
            for l in 0..<count {
                let target = C[k] + D[l]
                if let count = dic[target] {
                    sumEqualToZeroCount += count
                }
            }
        }
        
        return sumEqualToZeroCount
    }
}


do {
    print(Solution().fourSumCount([ 1, 2], [-2,-1], [-1, 2], [ 0, 2]))
}
