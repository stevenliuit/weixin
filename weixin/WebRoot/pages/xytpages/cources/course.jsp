
<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>

<%@ taglib uri="/tld/c.tld" prefix="c"%>
<%@ taglib uri="/tld/fmt.tld" prefix="fmt"%>

<%
String user = request.getParameter("user");
String courseId = request.getParameter("courseId");
%>

<!DOCTYPE HTML>
<html>
  <head>     
    <title>课程详情</title>
    <meta charset="utf-8">   
	<meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
    <meta name="apple-touch-fullscreen" content="yes">
    <meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=0">
    <meta name="format-detection" content="telephone=yes" />
    
 <link type="text/css" rel="stylesheet" href="${basePath}pages/xytpages/weui/dist/style/weui.min.css"/> 
 <link type="text/css" rel="stylesheet" href="${basePath}pages/xytpages/weui/dist/style/common.css"/> 
 <link type="text/css" rel="stylesheet" href="${basePath}pages/xytpages/weui/dist/style/course.css"/>    
 
	<script language="javascript" src="${basePath}pages/jquery.js"></script>
	<script language="javascript" src="${basePath}/pages/xytpages/jweixin-1.0.0.js"></script>
<script type="text/javascript">
function reserve(){
	var userid = $("#userid").val(); 
	var courseId = $("#courseId").val();
	//判断是否已经注册，未注册跳转到注册页面
	$('#loadingToast').show();
	$.post('${basePath}xyt/userInfo!getXytUserInfoByRid.action',{userid:userid},function(data){
		var xytUserInfo = data[0];
		//如果电话号码为空，则认为没有注册
		if(null == xytUserInfo.telNumber)
		{
			$('#loadingToast').hide();
			var redirectUrl = "${basePath}xyt/XytCourseAction!getXytCourse.action?user="+userid+"&courseId="+courseId;
			window.location.href="${basePath}xyt/register!showRegister.action?openId=" + xytUserInfo.openid + "&redirectUrl=" + encodeURIComponent(redirectUrl);
		}else{
			//判断是否已经购买该课程
			$.post('${basePath}xyt/XytOrderAction!getAppliedOrderByUserAndCourse.action',{userid:userid,courseId:courseId},function(data){
				if(0 == data.length)
				{
					pay();
				}else{
					$('#loadingToast').hide();
					showdialog2("您已订购该课程，请点击《我的课表》查看！");
				}
				
			},"json");
			
		}
	},"json");
}

function showdetail()
{
	$('#dialogtitle').html("课程详情");
	showdialog2("${xytCourse.courseIntroduction}");
}

function showdialog1()
{
	
}

function showdialog2(message)
{
	$('#dialogmessage').html(message);
	$('#dialog2').show();
}

function hidedialog2()
{
	$('#dialog2').hide();
	window.location.reload();
}

function pay(){
	if (typeof WeixinJSBridge == "undefined"){
	   if( document.addEventListener ){
	       document.addEventListener('WeixinJSBridgeReady', onBridgeReady, false);
	   }else if (document.attachEvent){
	       document.attachEvent('WeixinJSBridgeReady', onBridgeReady); 
	       document.attachEvent('onWeixinJSBridgeReady', onBridgeReady);
	   }
	}else{
	    onBridgeReady();
	} 
}

function onBridgeReady(){	
	//获取appId、timeStamp、nonceStr、package、signType、paySign
	var userid = $("#userid").val(); 
	var courseId = $("#courseId").val();
	var appId;
	var timeStamp;
	var nonceStr;
	var signType;
	var packAge;
	var paySign;
	$.post('${basePath}xyt/XytOrderAction!courseOrderPay.action',{userid:userid,courseId:courseId},function(data)
	{
		$('#loadingToast').hide();
		var brandWCPayParameterVo = data;
		appId = brandWCPayParameterVo.appId;
		timeStamp = brandWCPayParameterVo.timeStamp;
		nonceStr = brandWCPayParameterVo.nonceStr;
		signType = brandWCPayParameterVo.signType;
		packAge = brandWCPayParameterVo.packAge;
		paySign = brandWCPayParameterVo.paySign;
		WeixinJSBridge.invoke(
			'getBrandWCPayRequest', {
				"appId" : appId,     //公众号名称，由商户传入     
				"timeStamp": timeStamp,         //时间戳，自1970年以来的秒数     
				"nonceStr" : nonceStr, //随机串     
				"package" : packAge,     
				"signType" : signType,         //微信签名方式:     
				"paySign" : paySign    //微信签名 
			},
				      
			function(res){     
				if(res.err_msg == "get_brand_wcpay_request:ok" ) {
				    showdialog2("支付成功");
				}     
			}
		); 
	},"json");
}

//积分兑换
function paybyscore()
{
	$('#loadingToast').show();
	var userid = $("#userid").val();
	var courseId = $("#courseId").val();
	//判断是否已经注册，未注册跳转到注册页面
	$.post('${basePath}xyt/userInfo!getXytUserInfoByRid.action',{userid:userid},function(data){
		var xytUserInfo = data[0];
		//如果电话号码为空，则认为没有注册
		if(null == xytUserInfo.telNumber)
		{
			$('#loadingToast').hide();
			var redirectUrl = "${basePath}xyt/XytCourseAction!getXytCourse.action?user="+userid+"&courseId="+courseId;
			window.location.href="${basePath}xyt/register!showRegister.action?openId=" + xytUserInfo.openid + "&redirectUrl=" + encodeURIComponent(redirectUrl);
		}else{
			//判断是否已经购买该课程
			$.post('${basePath}xyt/XytOrderAction!getAppliedOrderByUserAndCourse.action',{userid:userid,courseId:courseId},function(data){
				if(0 == data.length)
				{
					//调用积分兑换方法
					$.post('${basePath}xyt/XytOrderAction!payByScore.action',{userid:userid,courseId:courseId},function(data){
						$('#loadingToast').hide();
						showdialog2(data);
					},"json");
					
				}else{
					$('#loadingToast').hide();
					showdialog2("您已订购该课程，请点击《我的课表》查看！");
				}
				
			},"json");
		}
	},"json");
}

//报名试听
function audition(){
	var userid = $("#userid").val(); 
	var courseId = $("#courseId").val();
	var listenTest = ${xytCourse.listenTest};
	if(!listenTest){
		showdialog2("对不起，该课程不提供试听服务！");
		return;
	}
	$('#loadingToast').show();
	//判断是否已经注册，未注册跳转到注册页面
	$.post('${basePath}xyt/userInfo!getXytUserInfoByRid.action',{userid:userid},function(data){
		var xytUserInfo = data[0];
		//如果电话号码为空，则认为没有注册
		if(null == xytUserInfo.telNumber)
		{
			$('#loadingToast').hide();
			var redirectUrl = "${basePath}xyt/XytCourseAction!getXytCourse.action?user="+userid+"&courseId="+courseId;
			window.location.href="${basePath}xyt/register!showRegister.action?openId=" + xytUserInfo.openid + "&redirectUrl=" + encodeURIComponent(redirectUrl);
		}else{
			$.post('${basePath}xyt/XytOrderAction!getAppliedOrderByUserAndCourse.action',{userid:userid,courseId:courseId},function(data){
				if(0 == data.length)
				{
					//直接保存试听订单
					$.post('${basePath}xyt/XytOrderAction!saveAuditionOrder.action',{userid:userid,courseId:courseId},function(data){
						$('#loadingToast').hide();
						showdialog2(data);
						//window.location.reload();
					},"json");
				}else{
					$('#loadingToast').hide();
					showdialog2("您已订购该课程，请点击《我的课表》查看！");
				}
			},"json");
		}
	},"json");
}


function leaveMessage(){
	$('#loadingToast').show();
	//留言
	var userid = $("#userid").val(); 
	var courseId = $("#courseId").val();
	var content = document.getElementById("messageText").value 
	$.post('${basePath}xyt/XytMessageAction!saveXytMessage.action',{courseId:courseId,userid:userid,content:content},function(data){
		if(data.result == "success")
		{
			$('#loadingToast').hide();
			window.location.reload(); 
		}else{
			$('#loadingToast').hide();
			showdialog2("留言失败，请稍后重试！");
		}
		
	},"json");
}

function leaveMessageAnonymity(){
	$('#loadingToast').show();
	//匿名留言
	var userid = $("#userid").val(); 
	var courseId = $("#courseId").val();
	var content = document.getElementById("messageText").value 
	$.post('${basePath}xyt/XytMessageAction!saveXytMessageAnonymity.action',{courseId:courseId,userid:userid,content:content},function(data){
		if(data.result == "success")
		{
			$('#loadingToast').hide();
			window.location.reload(); 
		}else{
			$('#loadingToast').hide();
			showdialog2("留言失败，请稍后重试！");
		}
	},"json");
	 //刷新页面
}

function likepoint(){
	$('#loadingToast').show();
	var courseId = $("#courseId").val();
	var userid = $("#userid").val();
	$.post('${basePath}xyt/XytCourseAction!addLikePoint.action',{courseId:courseId,userid:userid},function(data){
	    //获取留言信息
	    if(-1 == data.likePointNumber)
	    {
	    	$('#loadingToast').hide();
	    	showdialog2("请勿重复点赞");
	    }else
	    {
	    	$('#loadingToast').hide();
	    	$("#likepoint").html(data.likePointNumber);
	    }
	},"json");
}
</script>
  </head>
  <body class="g-classDetail">
  
 <div class="m-nav2">
     <h2>课程详情</h2>
 </div>
 
 <div class="m-classDetail">
   <p class="m-classDetail-title" id = 'courseName'>${xytCourse.courseName}</p>
   <p class="m-classDetail-num" id = 'courseCode'>课程编码：${xytCourse.courseCode}</p>
   <p class="m-classDetail-money">
     <span class="m-tabpanel-content-money">¥</span>
     <span class="m-tabpanel-content-rednum" id = 'fee'>${xytCourse.fee}</span>
     
     <c:if test="${xytCourse.discount}">
     	<span class="m-tabpanel-content-greennum m-tabpanel-content-3" id = 'discount'>${xytCourse.discountNumber}折优惠</span>
     </c:if>
   
   </p>
   <c:if test="${xytCourse.payByScore}">
   <p class="m-classDetail-cent">${xytCourse.scoreApplied}积分可兑换</p>
   </c:if>
     <p style = "color:#ff7575" id = 'deadDate'>报名截止：<fmt:formatDate value="${xytCourse.deadDate}" pattern="yyyy.MM.dd"/></p>
     <p style = "color:#ff7575" id = 'startDate'>开&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp课：<fmt:formatDate value="${xytCourse.startDate}" pattern="yyyy.MM.dd"/></p>
     <p style = "color:#ff7575" id = 'endDate'>结 &nbsp&nbsp&nbsp&nbsp&nbsp课：<fmt:formatDate value="${xytCourse.endDate}" pattern="yyyy.MM.dd"/></p>
    </br>
   <c:if test="${xytCourse.onLineClass}">
   	 <p id = 'address'>线上地址  ：${xytCourse.onLineUrl}</p>
   </c:if>
   <c:if test="${!xytCourse.onLineClass}">
   	 <p id = 'address'>线下地址  ：${xytCourse.offLineAddress}</p>
   </c:if>
 </div>
 
 <!--课程信息--> 

 <div class="x-list">
 <div class="weui_cells weui_cells_access">

   <a class="weui_cell" onClick = "showdetail()">
       <div class="weui_cell_bd weui_cell_primary">
           <p>课程详情</p>
       </div>
       <div class="weui_cell_ft coursesummary" id = 'courseIntroduction'>
		  ${xytCourse.courseIntroduction}
       </div>
   </a>
   <a class="weui_cell" href="tel:${xytCourse.consultTelNumber}" >
       <div class="weui_cell_bd weui_cell_primary">
           <p>电话咨询</p>
       </div>
       <div class="weui_cell_ft" id = 'consultTelNumber'>${xytCourse.consultTelNumber}</div>
   </a>
   <a class="weui_cell" href="#">
       <div class="weui_cell_bd weui_cell_primary">
           <p>报名人数</p>
       </div>
       <div class="weui_cell_ft">
       </div>
    </a>
        <div class="avatars item ">
              <c:forEach items="${listAppliedOrder}" var="appliedOrder" varStatus="i">
               <div class="avatar avatar-sl" id = 'headimgurl'>
               	  <c:if test="${userId != appliedOrder.xytuserinfo.rid}">
                  	<a href="${basePath}xyt/userInfo!showHisHome.action?userId=${userId}&hisUserId=${appliedOrder.xytuserinfo.rid}"><img id = 'headimg' src="${appliedOrder.xytuserinfo.headimgurl}" class="img-circle" style="display:block; visibility: visible;"></a>
              	  </c:if>
              	  <c:if test="${userId == appliedOrder.xytuserinfo.rid}">
                     <a href="${basePath}xyt/userInfo!showMyHome.action?userId=${userId}"><img id = 'headimgaudition' src="${appliedOrder.xytuserinfo.headimgurl}" class="img-circle" style="display:block; visibility: visible;"></a>
              	  </c:if>
              
               </div>
                </c:forEach>
           </div>    
   <a class="weui_cell" href="#">
       <div class="weui_cell_bd weui_cell_primary">
           <p>试听人数</p>
       </div>
       <div class="weui_cell_ft">
       </div>
   </a>
   
   <div class="avatars item">
               <c:forEach items="${listAuditionOrder}" var="auditionOrder" varStatus="i">
               <div class="avatar avatar-sl" id = 'headimgurlaudition'>  
               	  <c:if test="${userId != auditionOrder.xytuserinfo.rid}">
                     <a href="${basePath}xyt/userInfo!showHisHome.action?userId=${userId}&hisUserId=${auditionOrder.xytuserinfo.rid}"><img id = 'headimgaudition' src="${auditionOrder.xytuserinfo.headimgurl}" class="img-circle" style="display:block; visibility: visible;"></a>
              	  </c:if>
              	  <c:if test="${userId == auditionOrder.xytuserinfo.rid}">
                     <a href="${basePath}xyt/userInfo!showMyHome.action?userId=${userId}"><img id = 'headimgaudition' src="${auditionOrder.xytuserinfo.headimgurl}" class="img-circle" style="display:block; visibility: visible;"></a>
              	  </c:if>
               </div>
                </c:forEach>
           </div>
</div>
        
 </div>
 
 <!--教师列表-->
 <div class="g-box-wrap">
     <div class="m-box">
         <div class="m-teacherDetail">
             <p class="m-teacherDetail-title">
                 <img id = 'teacherimg' src="${basePath}${xytCourse.teacher.photoPath}">
                 <span class="m-teacherDetail-name" id = 'teachername'>${xytCourse.teacher.name}</span>
             </p>
             <p class="m-teacherDetail-summary" id = 'teacherIntroduction'>${xytCourse.teacher.teacherIntroduction}</p>
         </div>
         <p class="m-zan-num">获得<span class="m-zan-num-red" id = 'likepoint'>${xytCourse.likePointNumber}</span>个赞</p>
         <p class="m-zan-img">
             <img src="http://m.xdf.cn/public/assets/Mobile_Classroom/images/zan_female.png">
         </p>
          <a href="#" class="weui_btn weui_btn_warn" onclick="likepoint()">为我点赞</a>
          <p class="course-messagetext"><textarea name="" cols="" rows="" id = 'messageText' placeholder="请输入您的评论内容"></textarea></p>
         <a href="#" class="weui_btn weui_btn_plain_primary" onclick="leaveMessage()">我要评论</a>  
         <a href="#" class="weui_btn weui_btn_plain_primary" onclick="leaveMessageAnonymity()">匿名评论</a> 
     </div>
 </div>
 
<!--留言区域-->
 <div class="weui_cells weui_cells_access m-margin" id = 'leaveMessageArea'>
 	<c:forEach items="${listXytMessage }" var="xytMessage" varStatus="i">
     <div class="m-messages-area" id = 'messageBlock' style = "display:block;">
         <p class="m-messages-title" id = 'messageTitle'>
         	
         	 <c:if test="${!xytMessage.anonymity}">
         	 
             	<c:if test="${userId != xytMessage.xytUserInfo.rid}">
             		<a href="${basePath}xyt/userInfo!showHisHome.action?userId=${userId}&hisUserId=${xytMessage.xytUserInfo.rid}"><img id = 'messageHeadUrl' src="${xytMessage.xytUserInfo.headimgurl}" class="img-circle" style="display: inline; visibility: visible;"></a>
             	</c:if>
             	<c:if test="${userId == xytMessage.xytUserInfo.rid}">
             		<a href="${basePath}xyt/userInfo!showMyHome.action?userId=${userId}"><img id = 'messageHeadUrl' src="${xytMessage.xytUserInfo.headimgurl}" class="img-circle" style="display: inline; visibility: visible;"></a>
             	</c:if>
             </c:if>
             
             <c:if test="${xytMessage.anonymity}">
                <img id = 'messageHeadUrl' src="${basePath}pages/xytpages/image/anonymity/anonymity.png" class="img-circle" style="display: inline; visibility: visible;">
             </c:if>
             <c:if test="${!xytMessage.anonymity}">
             	<span class="m-messages-nickname" id = 'messageUserName'>${xytMessage.xytUserInfo.nickname}</span>
             </c:if>
              <c:if test="${xytMessage.anonymity}">
             	<span class="m-messages-nickname" id = 'messageUserName'>匿名网友</span>
             </c:if>
             <span class="m-messages-nickname m-messages-time" id = 'leaveMessageTime' style = "float:right"><fmt:formatDate value="${xytMessage.createDate}" pattern="yyyy-MM-dd"/></span>
         </p>
         <p class="m-messages-summary" id = 'messageContent'>${xytMessage.content}</p>
     </div>
     </c:forEach>
     
  </div>	
 
 
<!--底部菜单--> 
<c:if test="${!xytCourse.payByScore}">
	<div class="m-bottomPanel"	>
	    <span class="js-order">
	        <input type="button" onclick="audition()" value="免费试听" class="btleft">
	        <span class="m-bottomPanel-line"></span>
	        <input type="button" onclick="reserve()" value="立即报名" class="btright">
	    </span>
	    <span class=""></span>
	</div>
</c:if>
<c:if test="${xytCourse.payByScore}">
	<div class="m-bottomPanel"	>
	    <span class="js-order">
	        <input type="button" style="width:32.5%" onclick="audition()" value="免费试听" class="btleft">
	        <span class="m-bottomPanel-line"></span>
	        <input type="button" style="width:32.5%" onclick="paybyscore()" value="积分兑换" class="btleft">
	        <span class="m-bottomPanel-line"></span>
	        <input type="button" style="width:32.5%" onclick="reserve()" value="支付学费" class="btright">
	    </span>
	    <span class=""></span>
	</div>
</c:if>
<input type='hidden' id='userid' value='<%=user%>'/>
<input type='hidden' id='courseId' value='<%=courseId%>'/>

<div class="weui_dialog_confirm" id="dialog1" style="display: none;">
  <div class="weui_mask"></div>
  <div class="weui_dialog">
     <div class="weui_dialog_hd"><strong class="weui_dialog_title">弹窗标题</strong></div>
     <div class="weui_dialog_bd">自定义弹窗内容，居左对齐显示，告知需要确认的信息等</div>
     <div class="weui_dialog_ft">
       <a id="cancel" href="javascript:;" class="weui_btn_dialog default">取消</a>
       <a id="confirm" href="javascript:;" class="weui_btn_dialog primary">确定</a>
     </div>
  </div>
</div>

<div class="weui_dialog_alert" id="dialog2" style="display: none;">
   <div class="weui_mask"></div>
   <div class="weui_dialog">
      <div class="weui_dialog_hd" id = "dialogtitle"><strong class="weui_dialog_title">温馨提醒</strong></div>
      <div class="weui_dialog_bd" id = "dialogmessage">您已订购了该课程</div>
      <div class="weui_dialog_ft">
          <a id="ok" onClick = "hidedialog2()" class="weui_btn_dialog primary">确定</a>
      </div>
   </div>
</div>

<div id="loadingToast" class="weui_loading_toast" style="display:none;">
   <div class="weui_mask_transparent"></div>
   <div class="weui_toast">
       <div class="weui_loading">
           <!-- :) -->
           <div class="weui_loading_leaf weui_loading_leaf_0"></div>
           <div class="weui_loading_leaf weui_loading_leaf_1"></div>
           <div class="weui_loading_leaf weui_loading_leaf_2"></div>
           <div class="weui_loading_leaf weui_loading_leaf_3"></div>
           <div class="weui_loading_leaf weui_loading_leaf_4"></div>
           <div class="weui_loading_leaf weui_loading_leaf_5"></div>
           <div class="weui_loading_leaf weui_loading_leaf_6"></div>
           <div class="weui_loading_leaf weui_loading_leaf_7"></div>
           <div class="weui_loading_leaf weui_loading_leaf_8"></div>
           <div class="weui_loading_leaf weui_loading_leaf_9"></div>
           <div class="weui_loading_leaf weui_loading_leaf_10"></div>
           <div class="weui_loading_leaf weui_loading_leaf_11"></div>
       </div>
       <p class="weui_toast_content">数据加载中</p>
   </div>
</div>

</body>
  
</html>
