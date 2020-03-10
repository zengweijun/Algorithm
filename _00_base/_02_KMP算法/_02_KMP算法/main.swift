//
//  main.swift
//  _02_KMP算法
//
//  Created by nius on 2020/3/10.
//  Copyright © 2020 nius. All rights reserved.
//

import Foundation

extension String {
    func charAt(_ i: Int) -> Character {
        return self[index(startIndex, offsetBy: i)]
    }
}

do {
    let text = "ABCDABCEABC😝🙄试试sssABC"
    let pattern = "ABC"
    
    
    
}

do {
    // 求next表
    let s = "ABCDABCEABC😝🙄试试sssABC"
    
    func next(_ s: String) -> [Int] {
        // 求每一个子模式串的公共真前缀和真后缀最大长度，0索引位置默认为-1
        let count = s.count
        var next = [Int](repeating: 0, count: count)
        
        // 当前遍历到自费索引，包含子串[0, i]范围
        // 使用[0, i]求的最大公共真前缀和真后缀最大长度就是next表中[i+1]的值
        var i = 0
        
        // n位置（n永远指向[0, i]范围最大公共真前缀后的第一个字符）
        // 初始0位置没有真前缀和真后缀，这里默认为-1
        var n = -1
        
        next[0] = -1 // 0索引位置默认为-1
        
        // 由于我们使用[0, i]求next[i+1]，对于最后一个字符count - 1
        // 的值，只需遍历到字符串[0, i-2]即可求出，由于最后一个字符的
        // 最大公共真前缀和真后缀已经求出，而包含最后一个字符的最大公共
        // 真前缀和真后缀没有意义，因此无需再求，这里使用（i < count - 1）
        let iMax = count - 1
        while i < iMax {
            if n < 0 {
                // n < 0 (n==-1)，[0, i]没有找到最大公共真前缀和真后缀，设置i+1位置为0
                // 由于n == -1，next[++i] = ++n ==> i = i+1、n = 0
                // swift不支持++，这里提前加好
                i += 1
                n += 1
                next[i] = n
            } else {
                // n >= 0，查看i和n位置是否是相同字符，如果是，这将i和n都++（相当于累加前边）
                if s.charAt(i) == s.charAt(n) {
                    i += 1
                    n += 1
                    next[i] = n
                } else {
                    // 不相等，继续寻找上一个next[n]位置的最大公共真前缀和真后缀
                    n = next[n]
                }
            }
        }
        return next
    }
    
    print(s)
    print(next(s))
}

