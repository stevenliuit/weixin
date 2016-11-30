package com.xyt.action;

import java.io.UnsupportedEncodingException;
import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;

import javax.annotation.Resource;

import org.apache.log4j.Logger;
import org.apache.log4j.PropertyConfigurator;
import org.marker.config.ConfigTest;
import org.marker.utils.MySecurity;
import org.springframework.context.annotation.Scope;
import org.springframework.stereotype.Component;

import com.xxcb.action.Cjaction;
import com.xxcb.po.BrandWCPayParameter;
import com.xxcb.util.BaseAction;
import com.xxcb.weixin.SignUtilTest;
import com.xyt.dao.XytCourseDao;
import com.xyt.dao.XytOrderDao;
import com.xyt.dao.XytScoreInfoDao;
import com.xyt.dao.XytUserInfoDao;
import com.xyt.po.BrandWCPayParameterVo;
import com.xyt.po.XytCourse;
import com.xyt.po.XytOrder;
import com.xyt.po.XytScoreConfig;
import com.xyt.po.XytScoreInfo;
import com.xyt.po.XytUserInfo;
import com.xyt.util.GsonUtil;
import com.xyt.util.IpAddressUtils;
import com.xyt.util.XytPayUtil;

@Scope("prototype")
@Component("XytOrderAction")
public class XytOrderAction extends BaseAction{

	/**
	 * 
	 */
	private static final long serialVersionUID = -374222400070214667L;

	@Resource
	public XytOrderDao xytOrderDao;
	
	@Resource
	public XytCourseDao xytCourseDao;
	
	@Resource
	public XytUserInfoDao xytUserInfoDao;
	
	@Resource
	public XytScoreInfoDao xytScoreInfoDao;
	/**
	 * 获取已报名课程以及试听课程
	 */
	public String getCourses()
	{
		Integer userid = Integer.valueOf(this.getRequest().getParameter("user"));
		List<XytOrder> listApplideOrders = xytOrderDao.getApplideXytOrdeByRid(userid);
		List<XytOrder> listAuditionOrders = xytOrderDao.getAuditionXytOrdeByRid((userid));
		boolean hasApplideOrders = false;
		boolean hasAuditionOrders = false;
		if(0 < listApplideOrders.size())
		{
			hasApplideOrders = true;
		}
		if(0 < listAuditionOrders.size())
		{
			hasAuditionOrders = true;
		}
		this.getRequest().setAttribute("listApplideOrders", listApplideOrders);
		this.getRequest().setAttribute("listAuditionOrders", listAuditionOrders);
		this.getRequest().setAttribute("hasApplideOrders", hasApplideOrders);
		this.getRequest().setAttribute("hasAuditionOrders", hasAuditionOrders);
		return "mycourse";
		
	}
	
	/**
	 * 根据xytuserinfo查找所有的已报名课程订单
	 */
	public String getApplideXytOrdeByRid()
	{
		Integer userid = Integer.valueOf(this.getRequest().getParameter("userid"));
		List<XytOrder> listOrder = xytOrderDao.getApplideXytOrdeByRid(userid);
		this.showjsondata(GsonUtil.toJson(listOrder));
		return null;
	}
	

	/**
	 * 根据xytuserinfo查找所有的试听课程订单
	 */
	public String getAuditionXytOrdeByRid()
	{
		Integer userid = Integer.valueOf(this.getRequest().getParameter("userid"));
		List<XytOrder > listOrder = xytOrderDao.getAuditionXytOrdeByRid((userid));
		this.showjsondata(GsonUtil.toJson(listOrder));
		return null;
	}
	
	/**
	 * 根据userRid、courseRid,判断是否已报名该课程
	 */
	public String getOrderByUserAndCourse()
	{
		Integer courseRid = Integer.valueOf(this.getRequest().getParameter("courseId"));
		Integer userid = Integer.valueOf(this.getRequest().getParameter("userid"));
		List<XytOrder > listOrder = xytOrderDao.getOrderByUserAndCourse(userid, courseRid);
		this.showjsondata(GsonUtil.toJson(listOrder));
		return null;
	}
	
	/**
	 * 根据userRid、courseRid判断是否已经报名并且付费
	 */
	public String getAppliedOrderByUserAndCourse()
	{
		Integer courseRid = Integer.valueOf(this.getRequest().getParameter("courseId"));
		Integer userid = Integer.valueOf(this.getRequest().getParameter("userid"));
		List<XytOrder > listOrder = xytOrderDao.getAppliedOrderByUserAndCourse(userid, courseRid);
		this.showjsondata(GsonUtil.toJson(listOrder));
		return null;
	}
	
	/**
	 * 获取已报名缴费人员信息
	 */
	public String getAppliedOrderByCourseRid()
	{
		Integer courseRid = Integer.valueOf(this.getRequest().getParameter("courseId"));
		List<XytOrder> listAppliedOrder = xytOrderDao.getAppliedOrderByCourseRid(courseRid);
		System.out.println(GsonUtil.toJson(listAppliedOrder));
		this.showjsondata(GsonUtil.toJson(listAppliedOrder));
		return null;
	}
	
	/**
	 * 获取报名试听人员信息
	 */
	public String getAuditionOrderByCourseRid()
	{
		Integer courseRid = Integer.valueOf(this.getRequest().getParameter("courseId"));
		List<XytOrder> listAuditionOrder = xytOrderDao.getAuditionOrderByCourseRid(courseRid);
		this.showjsondata(GsonUtil.toJson(listAuditionOrder));
		return null;
	}
	
	/**
	 * 团队订单支付
	 */
	public String groupOrderPay()
	{
		//打印日志
		PropertyConfigurator.configure(ConfigTest.logPath);
		final Logger logger  =  Logger.getLogger(XytOrderAction.class );
		Integer userid = Integer.valueOf(this.getRequest().getParameter("userid"));
		String addrip = IpAddressUtils.getIpAddr(this.getRequest());
		logger.error("团队订单addrip ="+addrip);
		Integer xytOrderid = Integer.valueOf(this.getRequest().getParameter("xytOrderRid"));
		
		XytOrder xytOrder = new XytOrder();
		XytUserInfo xytUserInfo = xytUserInfoDao.getXytUserInfoByRid(userid).get(0);
		List<XytOrder> xytOrderList = xytOrderDao.getXytOrderByRid(xytOrderid);
		
		if(0 == xytOrderList.size())
		{
			return null;
		}else{
			xytOrder = xytOrderList.get(0);
		}
		
		BrandWCPayParameterVo brandWCPayParameterVo = new BrandWCPayParameterVo();
		
		//获取安全秘钥
		String key = ConfigTest.key;
		
		String openId = xytUserInfo.getOpenid();
		
		String appId = ConfigTest.APPID;
		
		String timeStamp = String.valueOf(System.currentTimeMillis()/1000);
		
		String nonceStr=String.valueOf(Math.random());
		
		String signType = "MD5";
		
		String prepay_id = new String();
		
		prepay_id = XytPayUtil.getGroupOrderPrepayId(openId, addrip, xytOrder);
		
		String packAge = "prepay_id=" + prepay_id;
		
		String []array = {"appId=".concat(appId), "timeStamp=".concat(timeStamp), "nonceStr=".concat(nonceStr),
				"package=".concat(packAge), "signType=".concat(signType)};
		
		SignUtilTest.sort(array);
		
		String stringA = new String() ;
		
		String stringSignTemp = new String();
		
		String paySign = new String();
		
		for(int i = 0 ; i < array.length ; i++)
		{
			stringA = stringA.concat(array[i].concat("&"));
		}
		
		stringSignTemp = stringA.concat("key=").concat(key);
		
		MySecurity mySecurity = new MySecurity();
		
		paySign = mySecurity.encode(stringSignTemp, "MD5");
		
		paySign = paySign.toUpperCase();
		
		brandWCPayParameterVo.setAppId(appId);
		brandWCPayParameterVo.setNonceStr(nonceStr);
		brandWCPayParameterVo.setPackAge(packAge);
		brandWCPayParameterVo.setPaySign(paySign);
		brandWCPayParameterVo.setSignType(signType);
		brandWCPayParameterVo.setTimeStamp(timeStamp);
		
		this.showjsondata(GsonUtil.toJson(brandWCPayParameterVo));
		
		return null;
	}
	
	/**
	 * 修改订单为已支付状态
	 */
	public String changeOrderPaindStatus()
	{
		Integer xytOrderid = Integer.valueOf(this.getRequest().getParameter("xytOrderRid"));
		xytOrderDao.changeOrderPaindStatus(xytOrderid);
		return null;
	}
	
	/**
	 * 订购支付
	 */
	public String courseOrderPay()
	{
		//打印日志
		PropertyConfigurator.configure(ConfigTest.logPath);
		final Logger logger  =  Logger.getLogger(XytOrderAction.class );
		
		Integer userid = Integer.valueOf(this.getRequest().getParameter("userid"));
		Integer courseRid = Integer.valueOf(this.getRequest().getParameter("courseId"));
		String addrip = IpAddressUtils.getIpAddr(this.getRequest());
		logger.error("new  addrip  ="+addrip);
		XytUserInfo xytUserInfo = xytUserInfoDao.getXytUserInfoByRid(userid).get(0);
		XytCourse xytCourse = xytCourseDao.getXytCourseByRid(courseRid).get(0);
		
		BrandWCPayParameterVo brandWCPayParameterVo = new BrandWCPayParameterVo();
		
		//获取安全秘钥
		String key = ConfigTest.key;
		
		String openId = xytUserInfo.getOpenid();
		
		String appId = ConfigTest.APPID;
		
		String timeStamp = String.valueOf(System.currentTimeMillis()/1000);
		
		String nonceStr=String.valueOf(Math.random());
		
		String signType = "MD5";
		
		String prepay_id = new String();
		
		try {
			prepay_id = XytPayUtil.getPrepayId(openId, addrip, xytCourse);
		} catch (UnsupportedEncodingException e) {
			e.printStackTrace();
		}
		
		String packAge = "prepay_id=" + prepay_id;
		
		String []array = {"appId=".concat(appId), "timeStamp=".concat(timeStamp), "nonceStr=".concat(nonceStr),
				"package=".concat(packAge), "signType=".concat(signType)};
		
		SignUtilTest.sort(array);
		
		String stringA = new String() ;
		
		String stringSignTemp = new String();
		
		String paySign = new String();
		
		for(int i = 0 ; i < array.length ; i++)
		{
			stringA = stringA.concat(array[i].concat("&"));
		}
		
		stringSignTemp = stringA.concat("key=").concat(key);
		
		MySecurity mySecurity = new MySecurity();
		
		paySign = mySecurity.encode(stringSignTemp, "MD5");
		
		paySign = paySign.toUpperCase();
		
		brandWCPayParameterVo.setAppId(appId);
		brandWCPayParameterVo.setNonceStr(nonceStr);
		brandWCPayParameterVo.setPackAge(packAge);
		brandWCPayParameterVo.setPaySign(paySign);
		brandWCPayParameterVo.setSignType(signType);
		brandWCPayParameterVo.setTimeStamp(timeStamp);
		
		this.showjsondata(GsonUtil.toJson(brandWCPayParameterVo));
		
		return null;
	}
	
	/**
	 * 保存购买订单
	 */
	public String saveAppliedOrder()
	{
		Integer userid = Integer.valueOf(this.getRequest().getParameter("userid"));
		Integer courseRid = Integer.valueOf(this.getRequest().getParameter("courseId"));
		XytUserInfo xytUserInfo = xytUserInfoDao.getXytUserInfoByRid(userid).get(0);
		XytCourse xytCourse = xytCourseDao.getXytCourseByRid(courseRid).get(0);
		//查找是否存在该课程的订单
		List<XytOrder> listXytOrder = xytOrderDao.getOrderByUserAndCourse(userid, courseRid);
		if(0 == listXytOrder.size()){
			//不存在课程订单，新建课程订单并保存
			XytOrder xytOrder = new XytOrder();
			xytOrder.setXytCourse(xytCourse);
			xytOrder.setXytuserinfo(xytUserInfo);
			xytOrder.setCreateDate(new Date());
			xytOrder.setFee(xytCourse.getFee());
			xytOrder.setPaied(true);
			xytOrder.setXytTercherInfo(xytCourse.getTeacher());
			xytOrder.setAudition(false);
			
			xytOrderDao.save(xytOrder);
			//课程付费报名人数+1
			xytCourse.setTotalAppliedNumber(xytCourse.getTotalAppliedNumber() + 1);
			//总人数+1
			xytCourse.setAppliedStudentsNumber(xytCourse.getAppliedStudentsNumber() + 1);
			xytCourseDao.update(xytCourse);
			
			
		}else{
			XytOrder xytOrder = listXytOrder.get(0);
			if(xytOrder.isAudition())
			{
				xytOrder.setAudition(false);
			}
			if(!xytOrder.isPaied())
			{
				xytOrder.setAudition(true);
			}
			//试听人数减1；付费人数加1
			xytCourse.setTotalAppliedNumber(xytCourse.getTotalAppliedNumber() + 1);
			xytCourse.setAuditionNumber(xytCourse.getAuditionNumber() - 1);
			xytCourseDao.update(xytCourse);
		}
		return null;
	}
	
	/**
	 * 保存试听订单
	 */
	public String saveAuditionOrder()
	{
		Integer userid = Integer.valueOf(this.getRequest().getParameter("userid"));
		Integer courseRid = Integer.valueOf(this.getRequest().getParameter("courseId"));
		XytUserInfo xytUserInfo = xytUserInfoDao.getXytUserInfoByRid(userid).get(0);
		XytCourse xytCourse = xytCourseDao.getXytCourseByRid(courseRid).get(0);
		
		//判断是否已经报名试听该课程
		List<XytOrder> listXytOrder = xytOrderDao.getOrderByUserAndCourse(userid, courseRid);
		if(0 < listXytOrder.size())
		{
			//说明已经报名试听
			XytOrder order = listXytOrder.get(0);
			if(order.isAudition())
			{
				this.showjsondata(GsonUtil.toJson("您已报名该课程试听！"));
				return null;
			}
		}
		XytOrder xytOrder = new XytOrder();
		xytOrder.setAudition(true);
		xytOrder.setCreateDate(new Date());
		xytOrder.setFee(xytCourse.getFee());
		xytOrder.setPaied(false);
		xytOrder.setXytCourse(xytCourse);
		xytOrder.setXytuserinfo(xytUserInfo);
		xytOrder.setXytTercherInfo(xytCourse.getTeacher());
		
		xytOrderDao.save(xytOrder);
		//课程试听人数+1
		xytCourse.setAuditionNumber(xytCourse.getAuditionNumber() + 1);
		//总人数+1
		xytCourse.setAppliedStudentsNumber(xytCourse.getAppliedStudentsNumber() + 1);
		xytCourseDao.update(xytOrder);
		
		this.showjsondata(GsonUtil.toJson("报名试听成功"));
		return null;
	}
	
	/**
	 * 积分兑换课程
	 * 处理逻辑：
	 * 1，判断是否已购买该课程（页面已做判断）
	 * 2，判断是否存在足够的积分兑换课程
	 * 3，判断是否已经报名试听，如果已报名试听，则将订单状态改为已支付，并且由积分兑换支付
	 * 4，如果未报名试听，则生成新的订单并保存
	 * 5，课程报名人数增加，总人数增加
	 * 6，保存积分记录
	 */
	public String payByScore()
	{
		Integer userid = Integer.valueOf(this.getRequest().getParameter("userid"));
		Integer courseRid = Integer.valueOf(this.getRequest().getParameter("courseId"));
		XytUserInfo xytUserInfo = xytUserInfoDao.getXytUserInfoByRid(userid).get(0);
		XytCourse xytCourse = xytCourseDao.getXytCourseByRid(courseRid).get(0);
		List<XytScoreInfo> listXytScoreInfo = xytScoreInfoDao.getXytScoreInfoByUserId(userid);
		if(0 == listXytScoreInfo.size())
		{
			this.showjsondata(GsonUtil.toJson("您没有足够的积分兑换此课程！请点击《我的主页》查看积分信息！"));
			return null;
		}
		Integer totalScore = 0;
		for(int index = 0 ; index < listXytScoreInfo.size(); index++ )
		{
			XytScoreInfo xytScoreInfo = listXytScoreInfo.get(index);
			totalScore = totalScore + xytScoreInfo.getScoreOption();
		}
		if(totalScore < xytCourse.getScoreApplied())
		{
			this.showjsondata(GsonUtil.toJson("您没有足够的积分兑换此课程！请点击《我的主页》查看积分信息！"));
			return null;
		}
		//判断是否已经存在该课程的订单（存在同一课程重复报名的情况，后续完善）
		List<XytOrder> listXytOrder = xytOrderDao.getOrderByUserAndCourse(userid, courseRid);
		if(0 == listXytOrder.size())
		{
			Date date = new Date();
			XytOrder xytOrder = new XytOrder();
			xytOrder.setAudition(false);
			xytOrder.setCreateDate(date);
			//积分兑换则付费为0
			xytOrder.setFee(new BigDecimal(0));
			xytOrder.setPaied(true);
			xytOrder.setPayByScore(true);
			xytOrder.setXytCourse(xytCourse);
			xytOrder.setXytTercherInfo(xytCourse.getTeacher());
			xytOrder.setXytuserinfo(xytUserInfo);
			xytOrderDao.save(xytOrder);
			
			xytCourse.setTotalAppliedNumber(xytCourse.getTotalAppliedNumber() + 1);
			//总人数+1
			xytCourse.setAppliedStudentsNumber(xytCourse.getAppliedStudentsNumber() + 1);
			xytCourseDao.update(xytCourse);
			
			//未支付学费，不必保存支付记录，改为保存积分记录
			XytScoreInfo xytScoreInfo = new XytScoreInfo();
			xytScoreInfo.setCreateTime(date);
			xytScoreInfo.setDescription(XytScoreConfig.payScoreDiscription);
			xytScoreInfo.setOtherUserInfo(null);
			xytScoreInfo.setPay(true);
			xytScoreInfo.setScoreCode(xytUserInfo.getScoreCode());
			xytScoreInfo.setScoreOption(-xytCourse.getScoreApplied());
			xytScoreInfo.setSelfUserInfo(xytUserInfo);
			xytScoreInfo.setStatus(true);
			xytScoreInfo.setXytCourse(xytCourse);
			xytScoreInfoDao.save(xytScoreInfo);
			
			this.showjsondata(GsonUtil.toJson("积分兑换课程成功"));
			return null;
			
		}else
		{
			XytOrder xytOrder = listXytOrder.get(0);
			xytOrder.setAudition(false);
			xytOrder.setFee(new BigDecimal(0));
			xytOrder.setPaied(true);
			xytOrder.setPayByScore(true);
			xytOrderDao.update(xytOrder);
			
			xytCourse.setTotalAppliedNumber(xytCourse.getTotalAppliedNumber() + 1);
			//总人数+1
			xytCourse.setAppliedStudentsNumber(xytCourse.getAppliedStudentsNumber() + 1);
			xytCourseDao.update(xytCourse);
			
			//未支付学费，不必保存支付记录，改为保存积分记录
			XytScoreInfo xytScoreInfo = new XytScoreInfo();
			xytScoreInfo.setCreateTime(new Date());
			xytScoreInfo.setDescription(XytScoreConfig.payScoreDiscription);
			xytScoreInfo.setOtherUserInfo(null);
			xytScoreInfo.setPay(true);
			xytScoreInfo.setScoreCode(xytUserInfo.getScoreCode());
			xytScoreInfo.setScoreOption(-xytCourse.getScoreApplied());
			xytScoreInfo.setSelfUserInfo(xytUserInfo);
			xytScoreInfo.setStatus(true);
			xytScoreInfo.setXytCourse(xytCourse);
			xytScoreInfoDao.save(xytScoreInfo);
			
			this.showjsondata(GsonUtil.toJson("积分兑换课程成功"));
			return null;
		}
	}
}
