package com.ryx.credit.cms.util;

import com.ryx.credit.cms.controller.DateUtil;

import java.util.Random;
import java.util.UUID;

/**
 * 各种id生成策略
 * <p>Title: IDUtils</p>
 * <p>Description: </p>
 * @author	Liudh
 * @date	2018/4/16 10:03
 * @version 1.0
 */
public class IDUtils {

	/**
	 * 图片名生成
	 */
	public static String genImageName() {
		//取当前时间的长整形值包含毫秒
		long millis = System.currentTimeMillis();
		//long millis = System.nanoTime();
		//加上三位随机数
		Random random = new Random();
		int end3 = random.nextInt(999);
		//如果不足三位前面补0
		String str = millis + String.format("%03d", end3);
		
		return str;
	}
	
	/**
	 * 商品id生成
	 */
	public static long genItemId() {
		//取当前时间的长整形值包含毫秒
		long millis = System.currentTimeMillis();
		//long millis = System.nanoTime();
		//加上两位随机数
		Random random = new Random();
		int end2 = random.nextInt(99);
		//如果不足两位前面补0
		String str = millis + String.format("%02d", end2);
		long id = new Long(str);
		return id;
	}

	/**
	 * 生成批次号
	 * @return
	 */
	public static long genBatchId() {
		String nowDate = DateUtil.timeStamp2Date(DateUtil.timeStamp(), "yyyyMMddHHmmss");
		//加上两位随机数
		Random random = new Random();
		int end2 = random.nextInt(99);
		//如果不足两位前面补0
		String str = nowDate + String.format("%02d", end2);
		long id = new Long(str);
		return id;
	}

	public static String uuid(){
		return UUID.randomUUID().toString();
	}

	public static void main(String[] args) {
		System.out.println(uuid());
	}
}
