package org.marker.utils;

import java.security.MessageDigest;

public class MD5util {
	public final static String MD5(String s) {
		char hexDigits[]={'0','1','2','3','4','5','6','7','8','9','A','B','C','D','E','F'};       
		try {
			byte[] btInput = s.getBytes("utf-8");
//			byte[] btInput = s.getBytes();
			// 获得MD5摘要算法的 MessageDigest 对象
			MessageDigest mdInst = MessageDigest.getInstance("MD5");
			// 使用指定的字节更新摘要
			mdInst.update(btInput);
			// 获得密文
			byte[] md = mdInst.digest();
			// 把密文转换成十六进制的字符串形式
			int j = md.length;
			char str[] = new char[j * 2];
			int k = 0;
			for (int i = 0; i < j; i++) {
				byte byte0 = md[i];
				str[k++] = hexDigits[byte0 >>> 4 & 0xf];
				str[k++] = hexDigits[byte0 & 0xf];
			}
			return new String(str);
		} catch (Exception e) {
			e.printStackTrace();
			return null;
		}
	}
	 
	public static void main(String[] args) {
		//System.out.println(MD5util.MD5("appid=wxe5976fada5d432e3&attach=xyt&body=英语&device_info=WEB&fee_type=CNY&goods_tag=XYT&limit_pay=no_credit&mch_id=1365949902&nonce_str=0.7912802150279992&notify_url=www.baidu.com&openid=oo-KAs_n8AL0PSWW4UzaMvagYGjk&out_trade_no=xyt14694305825383256488536142&product_id=math&spbill_create_ip=127.0.0.1&time_expire=20160725151262&time_start=20160725150942&total_fee=10&trade_type=JSAPI&key=05347148538346029poiuytrewqLKJHG"));
		System.out.println(MD5util.MD5("appid=wxf6872c94e403d7a7&attach=50&body=新生“扫盲A计划”之1号路线“经典篇”&device_info=WEB&fee_type=CNY&goods_tag=DXJ&limit_pay=no_credit&mch_id=1365949902&nonce_str=0.21680630807552304&notify_url=http://222.240.171.100/weixin/dxj/DxjNotifyFromWxAction!OrderNotifyFromWx.action&openid=oBPu4v1dO-pXqKtgnWOytE62UT5I&out_trade_no=dxj14739882303811854733914367&product_id=50&spbill_create_ip=113.240.254.2&time_expire=20160916091350&time_start=20160916091030&total_fee=1&trade_type=JSAPI&key=05347148538346029poiuytrewqLKJHG"));
	
	}
}
