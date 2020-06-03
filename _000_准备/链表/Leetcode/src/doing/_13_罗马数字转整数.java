package doing;

import java.util.HashMap;

public class _13_罗马数字转整数 {
    public static int romanToInt(String s) {
        char[] chars = s.toCharArray();
        HashMap map = new HashMap();
        map.put('I', 1);
        map.put('V', 5);
        map.put('X', 10);
        map.put('L', 50);
        map.put('C', 100);
        map.put('D', 500);
        map.put('M', 1000);

        int sum = 0;
        for (int i = chars.length - 1; i >= 0; i--) {
            int tmp = (Integer) map.get(chars[i]);
            if ((chars[i] == 'V' || chars[i] == 'X') && (i > 0 && chars[i-1] == 'I')) {
                tmp -= (Integer)map.get('I');
                i--;
            } else if ((chars[i] == 'L' || chars[i] == 'C') && (i > 0 && chars[i-1] == 'X')) {
                tmp -= (Integer)map.get('X');
                i--;
            } else if ((chars[i] == 'D' || chars[i] == 'M') && (i > 0 && chars[i-1] == 'C')) {
                tmp -= (Integer)map.get('C');
                i--;
            }
            sum += tmp;
        }
        return sum;
    }

    public static int getValueFromChar(char c) {
        switch (c) {
            case 'I': return 1;
            case 'V': return 5;
            case 'X': return 10;
            case 'L': return 50;
            case 'C': return 100;
            case 'D': return 500;
            case 'M': return 1000;
            default: return 0;
        }
    }
    public static int romanToInt1(String s) {
        char[] chars = s.toCharArray();
        int sum = 0;
        for (int i = chars.length - 1; i >= 0; i--) {
            int tmp = getValueFromChar(chars[i]);
            if ((chars[i] == 'V' || chars[i] == 'X') && (i > 0 && chars[i-1] == 'I')) {
                tmp -= getValueFromChar('I');
                i--;
            } else if ((chars[i] == 'L' || chars[i] == 'C') && (i > 0 && chars[i-1] == 'X')) {
                tmp -= getValueFromChar('X');
                i--;
            } else if ((chars[i] == 'D' || chars[i] == 'M') && (i > 0 && chars[i-1] == 'C')) {
                tmp -= getValueFromChar('C');
                i--;
            }
            sum += tmp;
        }
        return sum;
    }

    public static int romanToInt2(String s) {
        char[] chars = s.toCharArray();
        int sum = 0;
        for (int i = chars.length - 1; i >= 0; i--) {
            int pre = 0;
            if (i > 0) {
                pre = getValueFromChar(chars[i-1]);
            }
            int tmp = getValueFromChar(chars[i]);
            if (tmp > pre) {
                tmp = tmp - pre;
                i--;
            }
            sum += tmp;
        }
        return sum;
    }

    public static int romanToInt3(String s) {
        if (s.length() == 0) {
            return 0;
        }
        char[] chars = s.toCharArray();
        int sum = 0;
        int pre = getValueFromChar(chars[0]);

        // 从第1个开始遍历，检查上一个可否被加入（或者减掉）
        for (int i = 1; i < chars.length; i++) {
            int cur = getValueFromChar(chars[i]);
            if (pre < cur) {
                sum -= pre;
            } else {
                sum += pre;
            }
            pre = cur;
        }
        sum += pre;
        return sum;
    }

    public static void main(String[] args) {
        System.out.println(romanToInt3("III")); // 3
        System.out.println(romanToInt3("IV")); // 4
        System.out.println(romanToInt3("IX")); // 9
        System.out.println(romanToInt3("LVIII")); // 58
        System.out.println(romanToInt3("MCMXCIV")); // 1994

        "".indexOf()
    }
}
