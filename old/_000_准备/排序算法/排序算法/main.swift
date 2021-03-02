//
//  main.swift
//  排序算法
//
//  Created by nius on 2020/5/18.
//  Copyright © 2020 nius. All rights reserved.
//

import Foundation

let nums = [1, 20, 3, 4, 6, 7, 8, 9, 11, 10]

print("================================================冒泡================================================")
class BubbleSort {
    // O(n^2)，稳定排序
    // 算法思路，从后往前排，两两相比，每一轮都把最后的一个数排到最后，然后下一轮可以减少一个需要比较的数，直到结束
    static func sort1(_ nums: [Int]) -> [Int] {
        if nums.count < 2 { return nums }
        var nums = nums
        
        var cycleCount = 0 // 记录比较轮数
        // 外层控制比较轮数(控制结尾标志)
        // 内层控制具体比较(相邻比较)
        for end in (1..<nums.count).reversed() {
            for begin in 0..<end {
                if nums[begin] > nums[begin + 1] {
                    let tmp = nums[begin]
                    nums[begin] = nums[begin + 1]
                    nums[begin + 1] = tmp
                }
            }
            cycleCount += 1
        }
        print("比较轮数 ", cycleCount)
        return nums
    }
    
    // 减少比较次数（查看是否某一轮没有发生交换）
    static func sort2(_ nums: [Int]) -> [Int] {
        if nums.count < 2 { return nums }
        var nums = nums
        
        var cycleCount = 0 // 记录比较轮数
        for end in (1..<nums.count).reversed() {
            // 假设在某一轮比较中已经没有发生交换行为，就说明已经排序完成
            var sorted = true
            for begin in 0..<end {
                if nums[begin] > nums[begin + 1] {
                    let tmp = nums[begin]
                    nums[begin] = nums[begin + 1]
                    nums[begin + 1] = tmp
                    sorted = false // 发生了交换行为
                }
            }
            cycleCount += 1
            if sorted {
                // 这一轮没有发生交换行为，直接结束
                break
            }
        }
        print("比较轮数 ", cycleCount)
        return nums
    }
    
    // 减少比较次数（查看最后一次发生交换的位置）
    static func sort3(_ nums: [Int]) -> [Int] {
        if nums.count < 2 { return nums }
        var nums = nums
        
        var cycleCount = 0 // 记录比较轮数
        // swift中，for循环的参数不能修改，无法动态控制for循环次数，这里使用while控制
        var end = nums.count - 1
        while end > 0 {
            // 记录如果这一轮中最后发生交换的位置，下次就以此处为排序结尾位置
            // 默认最后一次发生交换的位置为1，之后如果发生交换则修改
            var endSwapIndex = 0
            for begin in 0..<end {
                if nums[begin] > nums[begin + 1] {
                    let tmp = nums[begin]
                    nums[begin] = nums[begin + 1]
                    nums[begin + 1] = tmp
                    endSwapIndex = begin // 发生了交换行为
                }
            }
            cycleCount += 1
            end = endSwapIndex
        }
        print("比较轮数 ", cycleCount)
        return nums
    }
}

do {
    do {
        let sortedNums = BubbleSort.sort1(nums)
        print("排序前：", nums, "\n排序后：", sortedNums)
        print("---------------------------------------")
    }
    do {
        let sortedNums = BubbleSort.sort2(nums)
        print("排序前：", nums, "\n排序后：", sortedNums)
        print("---------------------------------------")
    }
    do {
        let sortedNums = BubbleSort.sort3(nums)
        print("排序前：", nums, "\n排序后：", sortedNums)
        print("---------------------------------------")
    }
}



print("================================================选择================================================")
struct SelectionSort {
    // O(n^2)，该算法时间复杂度和冒泡排序一样，不过交换次数更少，理论上说比冒泡排序更优，是不稳定排序
    // 算法思路，从后往前排，每次都挑选出序列中最大的一个和最后一个元素交换，这样一轮结束后最后一个一定能保证最大，之后排除最后一个，将之前的序列重复该逻辑
    static func sort(_ nums: [Int]) -> [Int] {
        if nums.count < 2 { return nums }
        var nums = nums
        
        for end in (1..<nums.count).reversed() {
            // 选出最大一个元素的位置
            var maxIndex = 0
            for begin in 1...end { // 注意，这里需要包含最后一个，因为最大一个值可能是最后一个
                if nums[begin] > nums[maxIndex] {
                    maxIndex = begin
                }
            }
            
            // 将最大值与最后一个元素交换位置
            let tmp = nums[maxIndex]
            nums[maxIndex] = nums[end]
            nums[end] = tmp
        }
        return nums
    }
}

do {
    do {
        let sortedNums = SelectionSort.sort(nums)
        print("排序前：", nums, "\n排序后：", sortedNums)
        print("---------------------------------------")
    }
}


print("================================================插入================================================")
struct InsertionSort {
    // O(n^2)，稳定排序
    // 算法思路，假设数组被分为两个部分，前半部分是拍好序的（起初只有1个元素），遍历后半部分，将遍历到的每一个元素都插入到前半部分排好序的合适位置
    static func sort1(_ nums: [Int]) -> [Int] {
        if nums.count < 2 { return nums }
        var nums = nums
        
        // 初始状态，两部分 nums[0],nums[1..]
        for i in 1..<nums.count {
            // 拿到当前遍历到的元素，插入到前半部分（已排好序）的合适位置
            // 插入过程：将比它大的都后挪一个位置，然后再将它插入到空出来的位置
            let cur = nums[i]
            var j = i
            /*
            while j > 0 {
                if nums[j-1] > cur {
                    nums[j] = nums[j-1]
                } else {
                    break
                }
                j -= 1
            }
            */
            while j > 0 && nums[j-1] > cur {
                nums[j] = nums[j-1]
                j -= 1
            }
            nums[j] = cur
        }
        return nums
    }
    
    // sort1是每次比较，发现较大则后挪动，最后插入目标值，事实上可以使用二分搜索将比较次数减少（注意，只是减少了比较此时，挪动仍然没变，因此时间复杂度仍然为O(n^2)）
    static func sort2(_ nums: [Int]) -> [Int] {
        if nums.count < 2 { return nums } // 递归基
        var nums = nums
        
        // 初始状态，两部分 nums[0],nums[1..]
        for i in 1..<nums.count {
            // 拿到当前遍历到的元素，插入到前半部分（已排好序）的合适位置
            // 插入过程：将比它大的都后挪一个位置，然后再将它插入到空出来的位置
            let cur = nums[i]
            
            // 1.这里使用二分搜索找到合适位置，然后将位置之后的部分后挪
            // 左闭右开区间 [begin, end)
            var begin = 0
            var end = i
            while begin < end {
                let mid = (end + begin) / 2
                if cur > nums[mid] {
                    // 在右半部分搜索
                    begin = mid + 1
                } else {
                    // 在左半部分搜索
                    end = mid
                }
            } // 来到这里，begin == end，就是我们要找的目标位置
            
            // 2.挪出位置并插入
            var j = i
            while j > begin {
                nums[j] = nums[j-1]
                j -= 1
            }
            nums[j] = cur
        }
        return nums
    }
}

do {
    do {
        let sortedNums = InsertionSort.sort1(nums)
        print("排序前：", nums, "\n排序后：", sortedNums)
        print("---------------------------------------")
    }
    
    do {
        let sortedNums = InsertionSort.sort2(nums)
        print("排序前：", nums, "\n排序后：", sortedNums)
        print("---------------------------------------")
    }
}


print("================================================快速================================================")
struct QuickSort {
    // O(n* logn)，比较排序中，该算法是目前比较好的一种
    // 算法思路，从后往前排，每次都挑选出序列中最大的一个和最后一个元素交换，这样一轮结束后最后一个一定能保证最大，之后排除最后一个，将之前的序列重复该逻辑
    static func sort(_ nums: [Int]) -> [Int] {
        if nums.count < 2 { return nums }
        var nums = nums
        
        // 1.快速排序 O(n * logn)
        // 排序范围左闭右开：[begin, end)
        func quickSort(_ nums: inout [Int], _ begin: Int, _ end: Int) -> Void {
            guard end - begin >= 2 else { return }
            
            // 选取轴点(轴点可有优化，每次在[begin, end)范围内随机选择一个和begin位置交换，然后再使用begin为轴点，可以起到优化效果，如已排序的范围可以降低一些没有必要的交换，不过这里就不做此处理)
            // 由于swift中函数参数是let不可更改，这里使用left、right框选范围
            var left = begin
            var right = end - 1
            let pivotValue = nums[left]
            
            // 轴点选择范围内第一个元素
            // ①先从后往前扫描，发现比轴点元素大，right-1，发现比该元素小，right与left交换，left++
            // ②发生交换后，使用left从前往后扫描，发现比轴点元素小，left+1，发现比轴点元素大，left与right交换，right--
            // ③递归上述过程
            while left < right {
                // ①从后往前扫描
                while left < right {
                    if nums[right] >= pivotValue {
                        right -= 1
                    } else {
                        // 来到这里，说明扫描到的right位置元素已经小于轴点元素，则将right位置的元素拷贝到left位置，右移left并改为从前向后扫描
                        nums[left] = nums[right]
                        left += 1
                        break // 右移left改为从前向后扫描（即进入下面while）
                    }
                }
                
                // ②从前往后扫描
                while left < right {
                    if nums[left] <= pivotValue {
                        left += 1
                    } else {
                        // 来到这里，说明扫描到的left位置元素已经大于轴点元素，则将left位置的元素拷贝到right位置，左移right并改为从后向前扫描
                        nums[right] = nums[left]
                        right -= 1
                        break // 左移right并改为从后向前扫描（即经过外层while重新进入上面while）
                    }
                }
            }
            
            // 来到这里，left == right，说明已经将元素分割为两部分，而left位置即为轴点位置
            nums[left] = pivotValue
            
            // ③对左半部分和右半部分进行递归
            // 左闭右开，轴点已经找到合适位置，无需再参与递归
            quickSort(&nums, begin, left)   // 轴点左半部分
            quickSort(&nums, left + 1, end) // 轴点右半部分
        }
        
        quickSort(&nums, 0, nums.count)
        return nums
    }
}

do {
    do {
        let nums = [1, 20, 3, 4, 6, 7, 8, 9, 11, 10]
        let sortedNums = QuickSort.sort(nums)
        print("排序前：", nums, "\n排序后：", sortedNums)
        print("---------------------------------------")
    }
}



print("================================================归并================================================")
print("================================================希尔================================================")
print("================================================堆================================================")
print("================================================计数================================================")
print("================================================基数================================================")
print("================================================桶================================================")
