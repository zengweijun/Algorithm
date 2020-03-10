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

/**
 text = "ABCDABCEABC😝🙄试试sssABC" -->  文本串
 pattern = "ABC""                                           -->  模式串
 寻找pattern在text匹配到的第一个位置
*/

// MARK: - BruteForce (暴力算法)
class BruteForce {
    static let BruteForceIndexNotFound = -1
    
    // 时间复杂度：
    //      最好情况，一开始搞定O(m)
    //      最坏情况，比较了n轮，每一轮都匹配到模式串末尾，直到最后一轮才失败 O(nm)
    static func firstIndex(pattern: String, inText text: String) -> Int {
        // 模式串首字符逐个对比，对比成功就继续对比下一个，对比失败则将整个模式串后移一位，继续从模式串头部开始刚刚逻辑
        // 这里文本串text下标使用 ti，模式串pattern下标使用 pi
        
        let pLength = pattern.count
        let tLength = text.count
        if pLength == 0 || tLength == 0 || tLength < pLength { return BruteForceIndexNotFound }
        
        var ti = 0
        var pi = 0
        
        while pi < pLength && ti < tLength {
            if pattern.charAt(pi) == text.charAt(ti) {
                // 当前字符匹配成功，继续匹配下一个
                pi += 1
                ti += 1
            } else {
                // 当前字符失配，移动pattern滑块，pi变为0，ti变为滑块头部对应字符
                //    B   C   F[ti]
                // A  B   C   D[pi]   E   F
                // 失配位置，pi移动到B的下一个位置C，pattern滑块右移（首字符对准C），重新匹配
                ti = ti - pi + 1 // pi移动到B的下一个位置C
                pi = 0 // pattern滑块右移（首字符对准C）
            }
        }
        
        // 来到这里
        /**
         1、如果 pi == pLength && ti == tLength，模式串匹配成功，返回 ti - pi = 3
                    D      E       F  [pi]    <-- pi = 3(pi == count)
         A  B   C   D   E   F [ti] <-- ti = 6(ti == count)
         
         2、如果 pi == pLength && ti < tLength，模式串匹配成功，返回 ti - pi = 2
                C   D   E [pi]     <-- pi = 3(pi == count)
         A  B   C   D   E [ti]  F  <-- ti = 5(ti <= count)
         
         3、如果 pi < pLength && ti == tLength，模式串匹配失败，返回 -1
         */
        return pi == pLength ?  ti - pi : BruteForceIndexNotFound
    }
    
    // 改进版，减少尾部比较次数
    // 时间复杂度：
    //      最好情况，一开始搞定O(m)
    //      最坏情况，比较了n-m+1轮，每一轮都匹配到模式串末尾，直到最后一轮才失败 O((n-m+1) * m)
    //          O((n-m+1) * m) ==> O(n*m-m*m) ==> O(nm + m^2),如果m远小于n，≈ O(nm)
    static func firstIndex1(pattern: String, inText text: String) -> Int {
        // 模式串首字符逐个对比，对比成功就继续对比下一个，对比失败则将整个模式串后移一位，继续从模式串头部开始刚刚逻辑
        // 这里文本串text下标使用 ti，模式串pattern下标使用 pi
        
        let pLength = pattern.count
        let tLength = text.count
        if pLength == 0 || tLength == 0 || tLength < pLength { return BruteForceIndexNotFound }
        
        var ti = 0
        var pi = 0
        
        // 提前终止检查，减少比较次数
        // 当text的ti之后的字符数量已经不足匹配pattern剩余的数量时，直接退出返回-1
        // text剩余字符 tLength - ti + 1，pattern剩余字符 pLength - pi + 1
        // 当 文本串剩余需要匹配的字符数 < 模式串剩余需要匹配的字符数 是终止检查，翻译如下
        // 当 tLength - ti + 1 < pLength - pi + 1 ==> tLength - pLength < ti - pi 时终止检查
        // ==> 即当 ti - pi <= tLength - pLength 时才需要继续检查
        let deltaLength = tLength - pLength // tLength - pLength是固定值，可以提出来，而ti - pi是变化值，不能提出来
        while pi < pLength && ti - pi <= deltaLength {
            if pattern.charAt(pi) == text.charAt(ti) {
                // 当前字符匹配成功，继续匹配下一个
                pi += 1
                ti += 1
            } else {
                // 当前字符失配，移动pattern滑块，pi变为0，ti变为滑块头部对应字符
                //    B   C   F[ti]
                // A  B   C   D[pi]   E   F
                // 失配位置，pi移动到B的下一个位置C，pattern滑块右移（首字符对准C），重新匹配
                ti = ti - pi + 1 // pi移动到B的下一个位置C
                pi = 0 // pattern滑块右移（首字符对准C）
            }
        }
        
        // 来到这里
        /**
         1、如果 pi == pLength && ti == tLength，模式串匹配成功，返回 ti - pi = 3
                    D      E       F  [pi]    <-- pi = 3(pi == count)
         A  B   C   D   E   F [ti] <-- ti = 6(ti == count)
         
         2、如果 pi == pLength && ti < tLength，模式串匹配成功，返回 ti - pi = 2
                C   D   E [pi]     <-- pi = 3(pi == count)
         A  B   C   D   E [ti]  F  <-- ti = 5(ti <= count)
         
         3、如果 pi < pLength && ti == tLength，模式串匹配失败，返回 -1
         */
        return pi == pLength ?  ti - pi : BruteForceIndexNotFound
    }
    
    // 继续改进版(思路简洁版)，减少尾部比较次数
    // 之前的比较都是同事移动ti和pi指针逐个对比，当比对失败的时候需要同时将ti和pi回调
    // 比对完成后也需判断pi是否已经匹配完成，这里换一种思路，每一轮模式串匹配中
    // ti不动，只移动pi指针，同时使用比较的对象时 pattern[pi]和text[ti+pi]
    // 这样失配时，只需pi归零，ti后移就可以达到pattern滑块后移的效果，而完全匹配成功
    // 时，ti的值即为当前匹配成功的位置
    // 时间复杂度：
    //      最好情况，一开始搞定O(m)
    //      最坏情况，比较了n-m+1轮，每一轮都匹配到模式串末尾，直到最后一轮才失败 O((n-m+1) * m)
    //          O((n-m+1) * m) ==> O(n*m-m*m) ==> O(nm + m^2),如果m远小于n，≈ O(nm)
    static func firstIndex2(pattern: String, inText text: String) -> Int {
        let tlen = text.count
        let plen = pattern.count
        if plen == 0 || tlen == 0 || tlen < plen { return BruteForceIndexNotFound }
        
        var ti = 0
        let deltaLength = tlen - plen
        // 终止：tLen - ti < pLen  ==>  继续：ti <= tLen - pLen
        while ti < deltaLength {
            var pi = 0
            while pi < plen {
                // 失配，pi归零，ti后移
                if pattern.charAt(pi) != text.charAt(ti + pi) { break }
                pi += 1
            }
            if pi == plen { return ti } // 匹配成功，返回此时的ti
            ti += 1 // 失配，pi归零，ti后移
        }
        
        return BruteForceIndexNotFound
    }
}

do {
    do {
        let text = "ABCDABCEABC😝🙄试试sssABC" // 文本串
        let pattern = "23A" // 模式串
        print("BruteForce.firstIndex ", BruteForce.firstIndex(pattern: pattern, inText: text))
        print("BruteForce.firstIndex1", BruteForce.firstIndex1(pattern: pattern, inText: text))
        print("BruteForce.firstIndex2", BruteForce.firstIndex2(pattern: pattern, inText: text))
        print("------------------------------------------")
    }
    do {
        let text = "ABCDABCEABC😝🙄试试sssABC" // 文本串
        let pattern = "BCDA" // 模式串
        print("BruteForce.firstIndex ", BruteForce.firstIndex(pattern: pattern, inText: text))
        print("BruteForce.firstIndex1", BruteForce.firstIndex1(pattern: pattern, inText: text))
        print("BruteForce.firstIndex2", BruteForce.firstIndex2(pattern: pattern, inText: text))
        print("------------------------------------------")
    }
    do {
        let text = "ABCDABCEABC😝🙄试试sssABC" // 文本串
        let pattern = "ABCE" // 模式串
        print("BruteForce.firstIndex ", BruteForce.firstIndex(pattern: pattern, inText: text))
        print("BruteForce.firstIndex1", BruteForce.firstIndex1(pattern: pattern, inText: text))
        print("BruteForce.firstIndex2", BruteForce.firstIndex2(pattern: pattern, inText: text))
        print("------------------------------------------")
    }
    do {
        let text = "ABCDABCEABC😝🙄试试sssABC" // 文本串
        let pattern = "😝🙄试试" // 模式串
        print("BruteForce.firstIndex ", BruteForce.firstIndex(pattern: pattern, inText: text))
        print("BruteForce.firstIndex1", BruteForce.firstIndex1(pattern: pattern, inText: text))
        print("BruteForce.firstIndex2", BruteForce.firstIndex2(pattern: pattern, inText: text))
        print("------------------------------------------")
    }
}



// MARK: - KMP (KMP算法)
class KMP {
    
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
    
//    print(s)
//    print(next(s))
}

