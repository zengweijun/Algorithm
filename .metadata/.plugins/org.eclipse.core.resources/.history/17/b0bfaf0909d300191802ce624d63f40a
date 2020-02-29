package com.nius.IO.normal;

import java.io.File;
import java.io.IOException;

public class 文件创建与删除 {
	public static void main(String[] args) throws IOException, InterruptedException {
		listFile();
	}
	
	// 创建文件1
	public static void createFile1() throws IOException, InterruptedException {
		String path = "./src/com/nius/IO/test";
		File f1 = new File(path, "t1.rtf");
		
		System.out.println(f1.getAbsolutePath());
		System.out.println(f1.length()); // 文件长度(大小)
		
		if (!f1.exists()) {
			f1.createNewFile();
		} else {
			System.err.println(f1.getAbsolutePath() + "创建失败");
		}
		
		Thread.sleep(1000 * 3);
		f1.delete();
	}
	
	// 创建临时文件2
	public static void createFile2() throws IOException, InterruptedException {
		String path = "./src/com/nius/IO/test";
		
		// 这里我们至少给三个字符前缀，系统会自动加长文件名，避免重复
		File f1 =  File.createTempFile("t--", ".rtf", new File(path));
		
		System.out.println(f1.getAbsolutePath());
		Thread.sleep(1000 * 3);
		
		f1.delete();
	}
	
	public static void createDir() {
		String path = "./src/com/nius/IO/test";
		File f1 = new File(path, "abc/dddd/eee");
//		f1.mkdir(); // 中间目录不存在时候创建失败
		f1.mkdirs(); // 中间目录不存在时候会自动创建
	}
	
	// 遍历文件
	public static void listFile() {
		String path = "./src/com/nius/IO/";
		File f1 = new File(path);
		if (f1.isDirectory()) {
			for (File f : f1.listFiles()) {
				System.out.println(f.getAbsolutePath());
			}
		}
	}
	

}
