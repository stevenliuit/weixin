<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@ taglib uri="/tld/c.tld" prefix="c"%>
<%@ taglib uri="/tld/fmt.tld" prefix="fmt"%>

<!DOCTYPE HTML>
<html>
  <head>     
    <title>校园社团</title>
    <meta charset="utf-8">   
	<meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
    <meta name="apple-touch-fullscreen" content="yes">
    <meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=0">
    <meta name="apple-mobile-web-app-capable" content="yes">
    <meta name="apple-mobile-web-app-status-bar-style" content="black">
    <meta name="format-detection" content="telephone=no">
 
 <link type="text/css" rel="stylesheet" href="${basePath}pages/xytpages/weui/dist/style/weui.min.css"/> 
<link type="text/css" rel="stylesheet" href="${basePath}pages/xytpages/weui/dist/style/common.css"/>
 <link type="text/css" rel="stylesheet" href="${basePath}pages/xytpages/weui/dist/style/campus.css"/>
 
	<script language="javascript" src="${basePath}pages/jquery.js"></script>
<script type="text/javascript">
function choosetravelroute()
{
	var userId = ${userId};
	window.location.href='${basePath}dxj/DxjTravelRouteAction!shooseTravelRoute.action?userId='+userId;
}

function leaveMessage(){
	//留言
	$('#loadingToast').show();
	var userId = ${userId};
	var routeId = ${routeId};
	var content = document.getElementById("messageText").value 
	$.post('${basePath}xyt/XytMessageAction!saveDxjRouteMessage.action',{userId:userId,content:content,routeId:routeId},function(data){
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
	var userId = ${userId};
	var routeId = ${routeId};
	var content = document.getElementById("messageText").value 
	$.post('${basePath}xyt/XytMessageAction!saveDxjRouteMessageAnonymity.action',{userId:userId,content:content,routeId:routeId},function(data){
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

function showdialog1(message)
{
	$('#dialogmessage1').html(message);
	$('#dialog1').show();
}

function hidedialog1()
{
	var userId = $("#userId").val();
	$('#dialog1').hide();
	window.location.href='${basePath}xyt/XytCollegeAction!chooseCampus.action?user='+userId;
}

function showdialog2(message)
{
	$('#dialogmessage2').html(message);
	$('#dialog2').show();
}

function hidedialog2()
{
	$('#dialog2').hide();
	window.location.reload();
}
</script>
  </head>
  <body class="g-classDetail">
  <div class="m-nav2">
     <h2> ${dxjTravelRoute.travelRouteName}</h2>
 </div>
 
 <div class="mycampus-main">
   <div class="mycampus-wrap">
     <div class="mycampus-pic">
     <img id = 'collegeimg' src="${basePath}${dxjTravelRoute.pictureUrl}" >
     </div>
     <p class="mycampus-summary">${dxjTravelRoute.introduction}</p>
     <p class="weui_cell">当前人数： ${dxjTravelRoute.appliedNumber}</p>
     <p class="weui_cell memberpic">
     <c:forEach items="${listDxjTravelRouteOrder}" var="travelRouteOrder" varStatus="i">
     	 
     	 <c:if test="${userId != travelRouteOrder.xytuserinfo.rid}">
           <a href="${basePath}xyt/userInfo!showHisHome.action?userId=${userId}&hisUserId=${travelRouteOrder.xytuserinfo.rid}"><img id = 'headimgaudition' src="${xytUserInfo.headimgurl}" class="img-circle" style="display:block; visibility: visible;"></a>
        </c:if>
        <c:if test="${userId == travelRouteOrder.xytuserinfo.rid}">
            <a href="${basePath}xyt/userInfo!showMyHome.action?userId=${userId}"><img id = 'headimgaudition' src="${travelRouteOrder.xytuserinfo.headimgurl}" class="img-circle" style="display:block; visibility: visible;"></a>
        </c:if> 
   
    </c:forEach>
     </p>
   </div>
 </div>
  
<div class="g-box-warp">
    <div class="m-box">
        <p class="course-messagetext">
            <textarea name="" cols="" rows="" id = 'messageText' placeholder="请输入您的评论内容"></textarea>
        </p>
        <a href="#" class="weui_btn weui_btn_plain_primary" onclick="leaveMessage()">我要发言</a>  
        <a href="#" class="weui_btn weui_btn_plain_primary" onclick="leaveMessageAnonymity()">匿名发言</a> 
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
  

	<div style="position:fixed; bottom:0;width:100%" class="weui_btn weui_btn_primary" onClick="choosetravelroute()">返回活动列表</div>	


<div class="weui_dialog_alert" id="dialog1" style="display: none;">
   <div class="weui_mask"></div>
   <div class="weui_dialog">
      <div class="weui_dialog_hd" id = "dialogtitle1"><strong class="weui_dialog_title">温馨提醒</strong></div>
      <div class="weui_dialog_bd" id = "dialogmessage1">您已订购了该课程</div>
      <div class="weui_dialog_ft">
          <a id="ok" onClick = "hidedialog1()" class="weui_btn_dialog primary">确定</a>
      </div>
   </div>
</div>


<div class="weui_dialog_alert" id="dialog2" style="display: none;">
   <div class="weui_mask"></div>
   <div class="weui_dialog">
      <div class="weui_dialog_hd" id = "dialogtitle2"><strong class="weui_dialog_title">温馨提醒</strong></div>
      <div class="weui_dialog_bd" id = "dialogmessage2"></div>
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
