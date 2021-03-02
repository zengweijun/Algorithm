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

    // MARK: 蛮力算法第一版
    // 时间复杂度：
    //      最好情况，一开始搞定O(m)
    //      最坏情况，比较了n轮，每一轮都匹配到模式串末尾，直到最后一轮才失败 O(nm)
    static func firstIndex1(pattern: String, inText text: String) -> Int {
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
    
    // MARK: 蛮力算法第二版
    // 改进版，减少尾部比较次数
    // 时间复杂度：
    //      最好情况，一开始搞定O(m)
    //      最坏情况，比较了n-m+1轮，每一轮都匹配到模式串末尾，直到最后一轮才失败 O((n-m+1) * m)
    //          O((n-m+1) * m) ==> O(n*m-m*m) ==> O(nm + m^2),如果m远小于n，≈ O(nm)
    static func firstIndex2(pattern: String, inText text: String) -> Int {
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
    
    // MARK: 蛮力算法第三版
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
    static func firstIndex3(pattern: String, inText text: String) -> Int {
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


// MARK: - KMP (KMP算法)
class KMP {
    static let KMPIndexNotFound = -1
    
    // 蛮力算法：每当失配时，ti后移，pi归零，相当于模式串滑块整体后移一个位置
    // KMP算法：每当失配时，ti不变，pi前移部分位子(也可能是归零，取决于next表)，从某种程度上来说，模式串滑块整体移动的距离更大，减少了部分没有必要的比较
    //         KMP算法的核心是构造next表，当失配时，pi前移到next[pi位置]
    
    // 时间复杂度：
    //      最好情况，一开始搞定O(m)
    //      最坏情况，退化为蛮力算法 O(n+m)
    static func firstIndex(pattern: String, inText text: String) -> Int {
        let patternChars = pattern.map{$0}
        let textChars = text.map{$0}
        let pLength = patternChars.count
        let tLength = textChars.count
        if pLength == 0 || tLength == 0 || tLength < pLength { return KMPIndexNotFound }
        
        let next = nextTable1(pattern)
        var ti = 0
        var pi = 0
        let deltaLength = tLength - pLength
        while pi < pLength && ti - pi < deltaLength {
            if pi < 0 || patternChars[pi] == textChars[ti] {
                // pi < 0 (pi == -1)
                pi += 1 // pi == 0
                ti += 1
            } else {
                // 失配，ti不动，查询next表，找到下一个检查位置pi
                pi = next[pi]
            }
        }
        return pi == pLength ?  ti - pi : KMPIndexNotFound
    }
    
    
    // MARK: KMP next 第一版
    // O(m)
    // 求next表(模式串中，每一个字符左边子串的最大公共真前缀和真后缀长度)
    private static func nextTable(_ pattern: String) -> [Int] {
        let chars = pattern.map{$0}
        let count = pattern.count
        var next = [Int](repeating: 0, count: count)
        
        var i = 0   // i为当前字符遍历到的字符位置
        var n = -1  // [0, i]子串含有最大公共真后缀pre和真前缀suf，pre的下一个字符位置。由于0位置左边没有字符，初始默认为-1
        next[0] = n // 默认0位置的next值为-1，因为它左边没有子串
        
        // 由于我们使用[0, i]求next[i+1]，对于最后一个字符count - 1
        // 的值，只需遍历到字符串[0, i-2]即可求出，由于最后一个字符的
        // 最大公共真前缀和真后缀已经求出，而包含最后一个字符的最大公共
        // 真前缀和真后缀没有意义，因此无需再求，这里使用（i < count - 1）
        let iMax = count - 1
        while i < iMax {
            /*
                if n < 0 {
                    // n < 0：[0, i]不存在最大公共真后缀pre和真前缀suf，
                    // 设置 i+1 位置的next值为0，同时将i后移检查下一个字符
                    // 这里的 n<0 情况下，n通常是-1，使用 n++ == 0，方便代码通用
                    i += 1
                    n += 1
                    next[i] = n
                } else {
                    // n > 0：[0, i]有最大公共真后缀pre和真前缀suf，且n是pre子串后一个字符
                    // 此时判断 n 和 i 位置的字符是否相等，如果相等则可推断出 i+1 位置的next值
                    // 所以 i+1 位置的next值 == n+1
                    // n == 0 的时候同样满足该逻辑实现
                    if chars[i] == chars[n] {
                        i += 1
                        n += 1
                        next[i] = n
                    } else {
                        // 不相等，继续寻找上一个next[n]位置的最大公共真前缀和真后缀
                        // i 和 n 位置字符不等，应该继续迭代检查 [0, n]位置的最大公共真后缀pre和真前缀suf，使用该位置的next值继续和 i 位置对比
                        n = next[n] // 直接将n前移到next[n]位置，继续寻找
                    }
                }
             */
            // 以上代码重构为这个
            if n < 0 || chars[i] == chars[n] {
                i += 1
                n += 1
                next[i] = n
            } else {
                n = next[n]
            }
        }
        return next
    }
    
    // MARK: KMP next 第二版
    // O(m)
    // 改进，对于某一个i位置字符失配时，下一个要对比的字符为n
    // 事实上如果发现如果 i 位置和 n 位置是相同的字符是，没有必要再对比 n，而是直接到 n 的next[n]，不断前移
    /**
     比如：AAAAB（next = [-1, 0, 1, 2, 3]）
     文本串：AAAABBD    模式串：AAAAC
       AAAABBD
     ① AAAAC            next[4] = 3
     ②   AAAAC          next[3] = 2
     ③     AAAAC        next[2] = 1
     ④       AAAAC      next[1] = 0
     ⑤          AAAAC    next[1] = -1
     如果第五个B位置字符失配，此时应该直接退回到-1，即直接到第⑤步，因为②③④对比的字符都一样
     因此，更好的做法是直接将相同字符的next值设为一直 比如：AAAAB（next = [-1, -1, -1, -1, 3]）
     这样，当①失败后，直接到第五步
     */
    // 求next表(模式串中，每一个字符左边子串的最大公共真前缀和真后缀长度)
    private static func nextTable1(_ pattern: String) -> [Int] {
        let chars = pattern.map{$0}
        let count = pattern.count
        var next = [Int](repeating: 0, count: count)
        
        var i = 0   // i为当前字符遍历到的字符位置
        var n = -1  // [0, i]子串含有最大公共真后缀pre和真前缀suf，pre的下一个字符位置。由于0位置左边没有字符，初始默认为-1
        next[0] = n // 默认0位置的next值为-1，因为它左边没有子串
        
        // 由于我们使用[0, i]求next[i+1]，对于最后一个字符count - 1
        // 的值，只需遍历到字符串[0, i-2]即可求出，由于最后一个字符的
        // 最大公共真前缀和真后缀已经求出，而包含最后一个字符的最大公共
        // 真前缀和真后缀没有意义，因此无需再求，这里使用（i < count - 1）
        let iMax = count - 1
        while i < iMax {
            /*
                if n < 0 {
                    // n < 0：[0, i]不存在最大公共真后缀pre和真前缀suf，
                    // 设置 i+1 位置的next值为0，同时将i后移检查下一个字符
                    // 这里的 n<0 情况下，n通常是-1，使用 n++ == 0，方便代码通用
                    i += 1
                    n += 1
                    next[i] = n
                } else {
                    // n > 0：[0, i]有最大公共真后缀pre和真前缀suf，且n是pre子串后一个字符
                    // 此时判断 n 和 i 位置的字符是否相等，如果相等则可推断出 i+1 位置的next值
                    // 所以 i+1 位置的next值 == n+1
                    // n == 0 的时候同样满足该逻辑实现
                    if chars[i] == chars[n] {
                        i += 1
                        n += 1
                        next[i] = n
                    } else {
                        // 不相等，继续寻找上一个next[n]位置的最大公共真前缀和真后缀
                        // i 和 n 位置字符不等，应该继续迭代检查 [0, n]位置的最大公共真后缀pre和真前缀suf，使用该位置的next值继续和 i 位置对比
                        n = next[n] // 直接将n前移到next[n]位置，继续寻找
                    }
                }
             */
            // 以上代码重构为这个
            if n < 0 || chars[i] == chars[n] {
                i += 1
                n += 1
                if chars[i] == chars[n] { // chars[i+1] == chars[n+1]，因为上边已经执行了++操作
                    next[i] = next[n] // 字符相同，直接和之前的值保持一直
                } else {
                    next[i] = n // 字符不相同，直接使用n的值（你是公共真前缀的长度）
                }
            } else {
                n = next[n]
            }
        }
        return next
    }
}


do {
    do {
        let text = "ABCDABCEABC😝🙄试试sssABC" // 文本串
        let pattern = "23A" // 模式串
        print("BruteForce1 ", BruteForce.firstIndex2(pattern: pattern, inText: text))
        print("BruteForce2 ", BruteForce.firstIndex2(pattern: pattern, inText: text))
        print("KMP         ", KMP.firstIndex(pattern: pattern, inText: text))
        print("------------------------------------------")
    }
    do {
        let text = "ABCDABCEABC😝🙄试试sssABC" // 文本串
        let pattern = "BCDA" // 模式串
        print("BruteForce1 ", BruteForce.firstIndex2(pattern: pattern, inText: text))
        print("BruteForce2 ", BruteForce.firstIndex2(pattern: pattern, inText: text))
        print("KMP         ", KMP.firstIndex(pattern: pattern, inText: text))
        print("------------------------------------------")
    }
    do {
        let text = "ABCDABCEABC😝🙄试试sssABC" // 文本串
        let pattern = "ABCE" // 模式串
        print("BruteForce1 ", BruteForce.firstIndex2(pattern: pattern, inText: text))
        print("BruteForce2 ", BruteForce.firstIndex2(pattern: pattern, inText: text))
        print("KMP         ", KMP.firstIndex(pattern: pattern, inText: text))
        print("------------------------------------------")
    }
    do {
        let text = "ABCDABCEABC😝🙄试试sssABC" // 文本串
        let pattern = "😝🙄试试" // 模式串
        print("BruteForce1 ", BruteForce.firstIndex2(pattern: pattern, inText: text))
        print("BruteForce2 ", BruteForce.firstIndex2(pattern: pattern, inText: text))
        print("KMP         ", KMP.firstIndex(pattern: pattern, inText: text))
        print("------------------------------------------")
    }
}
