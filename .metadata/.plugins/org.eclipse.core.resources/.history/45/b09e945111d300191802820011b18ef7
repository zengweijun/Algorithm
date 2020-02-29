package com.nius.IO.BytesStream;

import java.io.File;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.OutputStream;

public class Writer {
	public static void main(String[] args) {
		writerToFile();
	}
	
	// 输出到文件(程序->文件)
	public static void writerToFile() {
		
		// 1.建立联系
		String path = "./src/com/nius/IO/test";
		File f1 = new File(path, "test123456.txt");
		if (!f1.exists()) {
			try {
				f1.createNewFile();
			} catch (IOException e) {
				e.printStackTrace();
			}
		}
		
		
		FileOutputStream os = null;
		try {
			// 2.创建流管道
			// append传入参数true，拼接到文件末尾
			os = new FileOutputStream(f1, true);
			String src = "\r\n 444.哈哈哈哈哈 \r\n 555.真的吗";
			byte[] bytes = src.getBytes();
			
			os.write(bytes);
			//os.write(bytes, 0, bytes.length);
			
			// 强制冲刷管道
			// 写入管道并不一定会直接写入到文件，在适当时机盒子close的时候
			// 才执行写入文件操作，这里直接使用flush强制将当前管道的数据冲入
			// 文件
			os.flush(); 
			System.out.println("========");
			
		} catch (FileNotFoundException e) {
			e.printStackTrace();
		} catch (IOException e) {
			e.printStackTrace();
		} finally {
			// 4.释放资源
			if (null != os) {
				try {
					os.close();
				} catch (IOException e) {
					e.printStackTrace();
				}
			}
		}
		
		
	}
}
