package com.xyt.action;

import java.util.ArrayList;
import java.util.Date;
import java.util.List;

import javax.annotation.Resource;

import org.springframework.context.annotation.Scope;
import org.springframework.stereotype.Component;

import com.alibaba.fastjson.JSONObject;
import com.xxcb.util.BaseAction;
import com.xyt.dao.XytCourseDao;
import com.xyt.dao.XytLikePointForCourseDao;
import com.xyt.dao.XytMessageDao;
import com.xyt.dao.XytOrderDao;
import com.xyt.dao.XytUserInfoDao;
import com.xyt.po.CourseNumberRank;
import com.xyt.po.XytCourse;
import com.xyt.po.XytLikePointForCourse;
import com.xyt.po.XytMessage;
import com.xyt.po.XytOrder;
import com.xyt.po.XytUserInfo;
import com.xyt.util.GsonUtil;

/**
 * 课程控制类
 * @author Administrator
 *
 */
@Scope("prototype")
@Component("XytCourseAction")
public class XytCourseAction extends BaseAction{

	/**
	 * 
	 */
	private static final long serialVersionUID = -1463502210644436278L;
	
	@Resource
	public XytCourseDao xytCourseDao;
	
	@Resource
	public XytLikePointForCourseDao xytLikePointForCourseDao;
	
	@Resource
	public XytUserInfoDao xytUserInfoDao;
	
	@Resource
	public XytMessageDao xytMessageDao;
	
	@Resource
	public XytOrderDao xytOrderDao;
	
	public String getXytCourseByButton()
	{
		String button = this.getRequest().getParameter("button");
		List<XytCourse> listXytCourse = xytCourseDao.getXytCourseByButton(button);
		this.showjsondata(GsonUtil.toJson(listXytCourse));
		return null;
	}
	
	public String getXytCourseById()
	{
		Integer courseid = Integer.valueOf(this.getRequest().getParameter("courseId"));
		List<XytCourse> listXytCourse = xytCourseDao.getXytCourseByRid(courseid);
		this.showjsondata(GsonUtil.toJson(listXytCourse));
		return null;
	}
	
	public String getXytCourse()
	{
		Integer userId = Integer.parseInt((this.getRequest().getParameter("user")));
		Integer courseId = Integer.parseInt((this.getRequest().getParameter("courseId")));
		List<XytMessage> listXytMessage = xytMessageDao.getXytMessageByCourse(courseId);
		List<XytCourse> listXytCourse = xytCourseDao.getXytCourseByRid(courseId);
		XytCourse xytCourse = new XytCourse();
		if(0 < listXytCourse.size())
		{
			xytCourse = listXytCourse.get(0);
		}
		List<XytOrder> listAppliedOrder = xytOrderDao.getAppliedOrderByCourseRid(courseId);
		List<XytOrder> listAuditionOrder = xytOrderDao.getAuditionOrderByCourseRid(courseId);
		this.getRequest().setAttribute("listXytMessage", listXytMessage);
		this.getRequest().setAttribute("xytCourse", xytCourse);
		this.getRequest().setAttribute("listAppliedOrder", listAppliedOrder);
		this.getRequest().setAttribute("listAuditionOrder", listAuditionOrder);
		this.getRequest().setAttribute("userId", userId);
		return "course";
	}
	
	/**
	 * 获取所有的旅游线路
	 * @return
	 */
	public String getAlltravelRoute()
	{
		Integer userId = Integer.parseInt((this.getRequest().getParameter("user")));
		List<XytCourse> listXytCourse = xytCourseDao.getAllTravelRoute();
		//获取报名及试听人数之和最多的前5个课程，否则获取所有的排序
		List<XytCourse> listCourseOrder = new ArrayList<XytCourse>();
		int totalNumber = 0;
		if(5 < listXytCourse.size())
		{
			for(int index = 0 ; index < 5 ; index ++)
			{
				listCourseOrder.add(listXytCourse.get(index));
				totalNumber = totalNumber + listXytCourse.get(index).getAppliedStudentsNumber();
			}
		}else
		{
			for(int index = 0 ; index < listXytCourse.size() ; index ++)
			{
				listCourseOrder.add(listXytCourse.get(index));
				totalNumber = totalNumber + listXytCourse.get(index).getAppliedStudentsNumber();
			}
		}
		if(0 < totalNumber)
		{
			List<CourseNumberRank> listCourseNumberRank = new ArrayList<CourseNumberRank>();
			for(int index = 0 ; index < listXytCourse.size(); index ++)
			{
				XytCourse xytCourse = listXytCourse.get(index);
				if(0 < xytCourse.getAppliedStudentsNumber())
				{
					CourseNumberRank courseNumberRank = new CourseNumberRank();
					
					courseNumberRank.setCourseName(xytCourse.getCourseName());
					float appliedNumber = (float)xytCourse.getAppliedStudentsNumber();
					String percentage = String.valueOf((appliedNumber/((float)totalNumber))*100);
					if(5<percentage.length())
					{
						percentage = percentage.substring(0, 5);
					}
					courseNumberRank.setPercentage(Float.valueOf(percentage));
					if(0 == index)
					{
						courseNumberRank.setMax(true);
					}
					courseNumberRank.setCourseCode(xytCourse.getCourseCode());
					listCourseNumberRank.add(courseNumberRank);
				}
			}
			this.getRequest().setAttribute("isShow", true);
			this.getRequest().setAttribute("listCourseNumberRank", listCourseNumberRank);
		}else{
			this.getRequest().setAttribute("isShow", false);
		}
		this.getRequest().setAttribute("listXytCourse", listXytCourse);
		this.getRequest().setAttribute("userId", userId);
		return "totaltravelroute";
	}
	
	
	
	
	public String getAllXytCourse()
	{
		Integer userId = Integer.parseInt((this.getRequest().getParameter("user")));
		List<XytCourse> listXytCourse = xytCourseDao.getAllCourse();
		//获取报名及试听人数之和最多的前5个课程，否则获取所有的排序
		List<XytCourse> listCourseOrder = new ArrayList<XytCourse>();
		int totalNumber = 0;
		if(5 < listXytCourse.size())
		{
			for(int index = 0 ; index < 5 ; index ++)
			{
				listCourseOrder.add(listXytCourse.get(index));
				totalNumber = totalNumber + listXytCourse.get(index).getAppliedStudentsNumber();
			}
		}else
		{
			for(int index = 0 ; index < listXytCourse.size() ; index ++)
			{
				listCourseOrder.add(listXytCourse.get(index));
				totalNumber = totalNumber + listXytCourse.get(index).getAppliedStudentsNumber();
			}
		}
		if(0 < totalNumber)
		{
			List<CourseNumberRank> listCourseNumberRank = new ArrayList<CourseNumberRank>();
			for(int index = 0 ; index < listXytCourse.size(); index ++)
			{
				XytCourse xytCourse = listXytCourse.get(index);
				if(0 < xytCourse.getAppliedStudentsNumber())
				{
					CourseNumberRank courseNumberRank = new CourseNumberRank();
					
					courseNumberRank.setCourseName(xytCourse.getCourseName());
					float appliedNumber = (float)xytCourse.getAppliedStudentsNumber();
					String percentage = String.valueOf((appliedNumber/((float)totalNumber))*100);
					if(5<percentage.length())
					{
						percentage = percentage.substring(0, 5);
					}
					courseNumberRank.setPercentage(Float.valueOf(percentage));
					if(0 == index)
					{
						courseNumberRank.setMax(true);
					}
					courseNumberRank.setCourseCode(xytCourse.getCourseCode());
					listCourseNumberRank.add(courseNumberRank);
				}
			}
			this.getRequest().setAttribute("isShow", true);
			this.getRequest().setAttribute("listCourseNumberRank", listCourseNumberRank);
		}else{
			this.getRequest().setAttribute("isShow", false);
		}
		this.getRequest().setAttribute("listXytCourse", listXytCourse);
		this.getRequest().setAttribute("userId", userId);
		return "totalcourse";
	}
	
	/**
	 * 点赞
	 * @return
	 */
	public String addLikePoint()
	{
		Integer courserid = Integer.valueOf(this.getRequest().getParameter("courseId"));
		Integer userid = Integer.valueOf(this.getRequest().getParameter("userid"));
		
		List<XytLikePointForCourse> listLikePointForCourse = xytLikePointForCourseDao.getLikePointByCourseRidAndUserRid(courserid,userid);
		JSONObject likePointNumber = new JSONObject(); 
		if(0 != listLikePointForCourse.size())
		{
			likePointNumber.put("likePointNumber", -1);
			this.showjsondata(GsonUtil.toJson(likePointNumber));
		}else{
			xytCourseDao.addLikePoint(courserid);
			XytUserInfo xytUserInfo = xytUserInfoDao.getXytUserInfoByRid(userid).get(0);
			XytCourse xytCourse = xytCourseDao.getXytCourseByRid(courserid).get(0);
			likePointNumber.put("likePointNumber", xytCourse.getLikePointNumber());
			XytLikePointForCourse xytLikePointForCourse = new XytLikePointForCourse();
			xytLikePointForCourse.setXytCourse(xytCourse);
			xytLikePointForCourse.setXytUserInfo(xytUserInfo);
			xytLikePointForCourse.setCreateDate(new Date());
			xytLikePointForCourseDao.save(xytLikePointForCourse);
			this.showjsondata(GsonUtil.toJson(likePointNumber));
		}
		return null;
	}
	
	/**
	 * 判断是否已点赞
	 */
	public String isLikePoint()
	{
		String userid = this.getRequest().getParameter("userid");
		String courseId = this.getRequest().getParameter("courseId");
		List<XytLikePointForCourse> listXytLikePointForCourse = xytLikePointForCourseDao.getLikePointByCourseRidAndUserRid(Integer.valueOf(courseId), Integer.valueOf(userid));
		this.showjsondata(GsonUtil.toJson(listXytLikePointForCourse));
		return null;
	}
	
	/**
	 * 根据课程编码查找对应的课程
	 */
	public String getXytCourseByCourseCode()
	{
		String courseCode = this.getRequest().getParameter("courseCode");
		List<XytCourse> listXytCourse = xytCourseDao.getXytCourseByCourseCode(courseCode);
		this.showjsondata(GsonUtil.toJson(listXytCourse));
		return null;
	}
}
