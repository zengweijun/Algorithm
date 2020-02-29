package com.nius.IO.BytesStream;

import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.IOException;
import java.io.InputStream;

public class Reader {
	public static void main(String[] args) {
		readFile();
	}
	
	// 读取文件内容
	// 输入流（输入到程序）
	public static void readFile() {

		// 1.建立联系
		String path = "./src/com/nius/IO/test";
		File f1 = new File(path, "test123456.txt");
		
		InputStream is = null;
		try {
			// 2.建立管道
			is = new FileInputStream(f1);
			
			// 目的地(文件)，这里使用字符串
			StringBuilder sb = new StringBuilder();
			
			// 3.读取（循环）
			// 每次读取1kb
			byte[] bytes = new byte[1024];
			int len = 0; // 每次读取到的长度
			// 读取到的长度 read(存放读取到的数据)
			// -1表示读取到没有读取到信息
			while (-1 != (len = is.read(bytes))) {
				// 读取到文件
				String s = new String(bytes, "UTF-8");
				sb.append(s);
			}
			// 读取完成、打印
			// 注意：rtf格式需要专门转码处理，这里不做处理
			System.out.println(sb.toString());
			
		} catch (FileNotFoundException e) {
			e.printStackTrace();
		} catch (IOException e) {
			e.printStackTrace();
		} finally {
			// 4.释放资源
			if (null != is) {
				try {
					is.close();
				} catch (IOException e) {
					e.printStackTrace();
				}
			}
		}
	}
	
}
