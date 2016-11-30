<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib uri="/tld/c.tld" prefix="c"%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
  <head>
    <title>我的个人中心</title>
    <meta charset="utf-8">   
	<meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
    <meta name="apple-touch-fullscreen" content="yes">
    <meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=0">
    <meta name="apple-mobile-web-app-capable" content="yes">
    <meta name="apple-mobile-web-app-status-bar-style" content="black">
    <meta name="format-detection" content="telephone=no">
    <link type="text/css" rel="stylesheet" href="${basePath}pages/xytpages/weui/dist/style/weui.min.css"/> 
    <link type="text/css" rel="stylesheet" href="${basePath}pages/xytpages/weui/dist/style/common.css"/>
    <link type="text/css" rel="stylesheet" href="${basePath}pages/xytpages/weui/dist/style/home.css"/>   
 	<script language="javascript" src="${basePath}pages/jquery.js"></script>
 	<script type="text/javascript">
 		$().ready(function() {
 			$("#backDiv").click(function() {
 				//location.href = "${basePath}xyt/pmessage!showSendPmessage.action?seuserId=${seuserId}&reuserId=${reuserId}";
 			});
 		});
 	</script>
  </head>
  
  <body class="g-classDetail">
  <div class="m-nav2">
     <h2>我的个人中心</h2>
   </div>
   
  <div class="m-home-main" style="height:auto; min-height:auto;">
      <div class="m-home-wrap">
          <div class="pane pane-personal">
              <div class="pane-wrap">
                  <div>
                      <div class="avatar avatar-lg">
                          <img src="${user.headimgurl}" class="img-circle">
                          <label class="personal_name">
                          	${user.nickname}
                          	<c:if test="${user.sex eq 1 }">
                          		<i class="icon-gi-male color-blue"><img src="${basePath}pages/xytpages/image/male.png"/></i>
                          	</c:if>
                            <c:if test="${user.sex eq 2 }">
                          		<i class="icon-gi-male color-blue"><img src="${basePath}pages/xytpages/image/female.png"/></i>
                          	</c:if>
                          </label>
                      </div>
                  </div>
                  <div class="row buttons">
                      <div class="col-xs-6"><a href="${basePath}xyt/register!showRegister.action?openId=${user.openid }" class="weui_btn weui_btn_plain_primary">设置</a></div>
                      <div class="col-xs-6"><a href="${basePath}xyt/pmessage!showMyPmessage.action?rid=${user.rid }" class="weui_btn weui_btn_plain_primary">消息<c:if test="${unReadCount gt 0 }">(<span style="color:red;">${unReadCount }</span>)</c:if></a></div>
                  </div>
              </div>
          </div>
      </div>
  </div>
  
 <div class="weui_cells weui_cells_access">
   <div class="weui_cell" onClick="javascript:location.href='${basePath}xyt/userAttantion!showMyFriends.action?userId=${user.rid }'">
       <div class="weui_cell_bd weui_cell_primary">
           <p>我的关注 (${friendsCount })</p>
       </div>
       <div class="weui_cell_ft">   
       </div>
   </div>
   <div class="weui_cell" onClick="javascript:location.href='${basePath}xyt/userAttantion!showMyFans.action?userId=${user.rid }'">
       <div class="weui_cell_bd weui_cell_primary">
           <p>我的粉丝 (${fansCount })</p>
       </div>
       <div class="weui_cell_ft">   
       </div>
   </div>
  
   <%-- <div class="weui_cell" onClick="javascript:location.href='${basePath}xyt/XytOrderAction!getCourses.action?user=${user.rid }'">
       <div class="weui_cell_bd weui_cell_primary">
           <p>我的课表</p>
       </div>
       <div class="weui_cell_ft">   
       </div>
   </div>
   
   <c:if test="${(user.college != null)}">
	   <div class="weui_cell" onClick="javascript:location.href='${basePath}xyt/XytCollegeAction!getXytUserInfoByCollegeId.action?user=${user.rid }&collegeId=${user.college.rid }'">
	       <div class="weui_cell_bd weui_cell_primary">
	           <p>我的学校</p>
	       </div>
	       <div class="weui_cell_ft">   
	       </div>
	   </div>
   </c:if>
   <c:if test="${(user.college == null)}">
	   <div class="weui_cell" onClick="javascript:location.href='${basePath}xyt/XytCollegeAction!chooseCampus.action?user=${user.rid }'">
	       <div class="weui_cell_bd weui_cell_primary">
	           <p>我的学校</p>
	       </div>
	       <div class="weui_cell_ft">   
	       </div>
	   </div>
   </c:if>
   
   <div class="weui_cell" onClick="javascript:location.href='${basePath}xyt/XytGroupOrderAction!getUserInGroupByUserId.action?userid=${user.rid }'">
       <div class="weui_cell_bd weui_cell_primary">
           <p>我的组团</p>
       </div>
       <div class="weui_cell_ft">   
       </div>
   </div>
   
   <div class="weui_cell">
       <div class="weui_cell_bd weui_cell_primary">
           <p>我的邀请码&nbsp&nbsp&nbsp&nbsp&nbsp${user.scoreCode}</p>
       </div>
       <div class="weui_cell_ft">   
       </div>
   </div>
   
   <div class="weui_cell" onClick="javascript:location.href='${basePath}xyt/XytScoreInfoAction!getScoreInfoRecord.action?userid=${user.rid }'">
       <div class="weui_cell_bd weui_cell_primary">
           <p>我的积分&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp${score}&nbsp&nbsp&nbsp点击查看积分记录</p>
       </div>
       <div class="weui_cell_ft">   
       </div>
   </div> --%>
</div>
   
  
  </body>
</html>