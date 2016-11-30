package com.xyt.po;

import java.math.BigDecimal;
import java.util.Date;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.FetchType;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.JoinColumn;
import javax.persistence.ManyToOne;
import javax.persistence.SequenceGenerator;
import javax.persistence.Table;

/**
 * 校园通订单信息
 */
@Entity
@Table(name = "XytOrder")
public class XytOrder {

	private Integer rid; //id
	
	//课程
	private XytCourse xytCourse;
	
	//学生
	private XytUserInfo xytuserinfo;
	
	//创建时间
	private Date createDate;
	
	//费用
	private BigDecimal fee;
	
	//是否付款
	private boolean isPaied;
	
	//是否为积分兑换
	private boolean isPayByScore = false;
	
	//教师信息
	private XytTercherInfo xytTercherInfo;
	
	//是否为试听
	private boolean isAudition;
	
	//组团订单（可以为空）
	private XytGroupOrder xytGroupOrder;
	
	@Id
	@GeneratedValue(generator = "XytOrder_seq", strategy = GenerationType.SEQUENCE)
	@SequenceGenerator(name = "XytOrder_seq", sequenceName = "s_xytOrder")
	public Integer getRid() {
		return rid;
	}

	public void setRid(Integer rid) {
		this.rid = rid;
	}

	@ManyToOne(fetch = FetchType.LAZY)
	@JoinColumn(nullable = false)
	public XytCourse getXytCourse() {
		return xytCourse;
	}

	public void setXytCourse(XytCourse xytCourse) {
		this.xytCourse = xytCourse;
	}

	@ManyToOne(fetch = FetchType.LAZY)
	@JoinColumn(nullable = false)
	public XytUserInfo getXytuserinfo() {
		return xytuserinfo;
	}

	public void setXytuserinfo(XytUserInfo xytuserinfo) {
		this.xytuserinfo = xytuserinfo;
	}

	@Column(nullable = false)
	public Date getCreateDate() {
		return createDate;
	}

	public void setCreateDate(Date createDate) {
		this.createDate = createDate;
	}

	@Column(nullable = false)
	public BigDecimal getFee() {
		return fee;
	}

	public void setFee(BigDecimal fee) {
		this.fee = fee;
	}

	@Column(nullable = false)
	public boolean isPaied() {
		return isPaied;
	}

	public void setPaied(boolean isPaied) {
		this.isPaied = isPaied;
	}

	@JoinColumn(nullable = true)
	@ManyToOne(fetch = FetchType.LAZY)
	public XytTercherInfo getXytTercherInfo() {
		return xytTercherInfo;
	}

	public void setXytTercherInfo(XytTercherInfo xytTercherInfo) {
		this.xytTercherInfo = xytTercherInfo;
	}

	@JoinColumn(nullable = true)
	public boolean isAudition() {
		return isAudition;
	}

	public void setAudition(boolean isAudition) {
		this.isAudition = isAudition;
	}

	@JoinColumn(nullable = true)
	@ManyToOne(fetch = FetchType.LAZY)
	public XytGroupOrder getXytGroupOrder() {
		return xytGroupOrder;
	}

	public void setXytGroupOrder(XytGroupOrder xytGroupOrder) {
		this.xytGroupOrder = xytGroupOrder;
	}

	@JoinColumn(nullable = true)
	public boolean isPayByScore() {
		return isPayByScore;
	}

	public void setPayByScore(boolean isPayByScore) {
		this.isPayByScore = isPayByScore;
	}
	
	
}
