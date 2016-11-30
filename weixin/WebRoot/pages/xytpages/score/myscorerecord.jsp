<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@ taglib uri="/tld/c.tld" prefix="c"%>
<%@ taglib uri="/tld/fmt.tld" prefix="fmt"%>
<%
String userid = request.getParameter("user");
%>

<!DOCTYPE HTML>
<html>
  <head>     
    <title>我的积分</title>
    <meta charset="utf-8">   
	<meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
    <meta name="apple-touch-fullscreen" content="yes">
    <meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=0">
    <meta name="apple-mobile-web-app-capable" content="yes">
    <meta name="apple-mobile-web-app-status-bar-style" content="black">
    <meta name="format-detection" content="telephone=no">
 
 <link type="text/css" rel="stylesheet" href="${basePath}pages/xytpages/weui/dist/style/weui.min.css"/> 
 <link type="text/css" rel="stylesheet" href="${basePath}pages/xytpages/weui/dist/style/common.css"/> 
 <link type="text/css" rel="stylesheet" href="${basePath}pages/xytpages/weui/dist/style/scores.css"/>    
 
 
	<script language="javascript" src="${basePath}pages/jquery.js"></script>
<script type="text/javascript">


</script>
  </head>
  <body class="g-classDetail">
  <div class="m-nav2">
     <h2>我的积分</h2>
 </div>
 <div class="scores-main">
     <div class="scores-wrap">
         <p>我的积分值：<span>${totalScore}</span></p>
     </div>
 </div>
 
 <div class="weui_cells weui_cells_access">
     <c:forEach items = "${listXytScoreInfo}" var="xytScoreInfo" varStatus="i">
     <c:if test="${!xytScoreInfo.pay}">
	     <div class="scores-content clearfix">
	        <span class="scores-description">${xytScoreInfo.description}</span>
	 	    <span class="scores-scoreOption">+${xytScoreInfo.scoreOption}</span>
	 	    <a href="${basePath}xyt/userInfo!showHisHome.action?userId=${userid}&hisUserId=${xytScoreInfo.otherUserInfo.rid}"><span class="scores-headimg"><img src="${xytScoreInfo.otherUserInfo.headimgurl}" class="img-circle"/></span></a>
	 	    <span class="scores-nickname">${xytScoreInfo.otherUserInfo.nickname}</span>
	 	    <div class="scores-createTime"><fmt:formatDate value="${xytScoreInfo.createTime}" pattern="yyyy-MM-dd hh:mm:ss"/></div>
	     </div>
     </c:if>
     
     <c:if test="${xytScoreInfo.pay}">
	     <div class="scores-content clearfix">
	        <span class="scores-description">${xytScoreInfo.description}</span>
	 	    <span class="scores-scoreOption">${xytScoreInfo.scoreOption}</span>&nbsp&nbsp
	 	    <span class="scores-scoreOption">《${xytScoreInfo.xytCourse.courseName}》</span>
	 	    <div class="scores-createTime"><fmt:formatDate value="${xytScoreInfo.createTime}" pattern="yyyy-MM-dd hh:mm:ss"/></div>
	     </div>
     </c:if>
     </c:forEach>
 </div>
 
</html>
