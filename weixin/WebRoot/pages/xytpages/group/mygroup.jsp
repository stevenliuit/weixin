<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@ taglib uri="/tld/c.tld" prefix="c"%>
<%@ taglib uri="/tld/fmt.tld" prefix="fmt"%>

<%
String userid = request.getParameter("userid");
%>

<!DOCTYPE HTML>
<html>
  <head>     
    <title>我的组团</title>
    <meta charset="utf-8">   
	<meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
    <meta name="apple-touch-fullscreen" content="yes">
    <meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=0">
    <meta name="apple-mobile-web-app-capable" content="yes">
    <meta name="apple-mobile-web-app-status-bar-style" content="black">
    <meta name="format-detection" content="telephone=no">
 
 <link rel="stylesheet" href="${basePath}pages/xytpages/weui/dist/style/weui.min.css"/>
 <link type="text/css" rel="stylesheet" href="${basePath}pages/xytpages/weui/dist/style/common.css"/>
 <link type="text/css" rel="stylesheet" href="${basePath}pages/xytpages/weui/dist/style/mygroup.css"/> 
	<script language="javascript" src="${basePath}pages/jquery.js"></script>
	<script language="javascript" src="${basePath}/pages/xytpages/jweixin-1.0.0.js"></script>
<script type="text/javascript">

function creategroup(){
	var userid = $("#userid").val(); 
	window.location.href='${basePath}xyt/XytGroupOrderAction!createGroup.action?userid='+userid;
}

function pay(xytOrderId)
{
	$('#loadingToast').show();
	if (typeof WeixinJSBridge == "undefined"){
	   if( document.addEventListener ){
	       document.addEventListener('WeixinJSBridgeReady', onBridgeReady, false);
	   }else if (document.attachEvent){
	       document.attachEvent('WeixinJSBridgeReady', onBridgeReady); 
	       document.attachEvent('onWeixinJSBridgeReady', onBridgeReady);
	   }
	}else{
	    onBridgeReady(xytOrderId);
	}
}

function onBridgeReady(xytOrderId){	
	//获取appId、timeStamp、nonceStr、package、signType、paySign
	var userid = $("#userid").val(); 
	var xytOrderRid = xytOrderId;
	var appId;
	var timeStamp;
	var nonceStr;
	var signType;
	var packAge;
	var paySign;
	$.post('${basePath}xyt/XytOrderAction!groupOrderPay.action',{userid:userid,xytOrderRid:xytOrderRid},function(data)
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

function quitGroup(groupid)
{
	var userid = $("#userid").val(); 
	$.post('${basePath}xyt/XytGroupOrderAction!quitGroup.action',{groupid:groupid,userid:userid},function(data)
	{
		showdialog2(data.result);
	},"json");
	
}

function showdetail(detail)
{
	$('#dialogtitle1').html("课程详情");
	showdialog1(detail);
}

function showdialog1(message)
{
	$('#dialogmessage1').html(message);
	$('#dialog1').show();
}

function hidedialog1()
{
	$('#dialog1').hide();
}
</script>
  </head>
  <body class="g-classDetail">
  <div class="m-nav2">
         <h2>我的组团</h2>
  </div>  
  
  <c:forEach items = "${listXytUserInGroup}" var="groups" varStatus="i">
       <div class="mygroup-main">
           <div class="mygroup-wrap">
               <c:if test="${groups.group.groupName != null}">
               <p class="weui_cell">
               <span class="weui_cell_bd weui_cell_primary">团组名称：</span>
               <span class="weui_cell_ft">${groups.group.groupName}</span>
               </p>
               </c:if>
               <p class="weui_cell"><span class="weui_cell_bd weui_cell_primary">团队编码：</span><span class="weui_cell_ft">${groups.group.groupCode}</span></p>
               <p class="weui_cell"><span class="weui_cell_bd weui_cell_primary">团队人数上限：</span><span class="weui_cell_ft">${groups.group.totalMemberNumber}</span></p>
               <p class="weui_cell"><span class="weui_cell_bd weui_cell_primary">现有人数：</span><span class="weui_cell_ft">${groups.group.memberNumber}</span></p>
               <p class="weui_cell"><span class="weui_cell_bd weui_cell_primary">原价格：</span><span class="weui_cell_ft"><s>${groups.group.originalFee}</s></span></p>
               <p class="weui_cell"><span class="weui_cell_bd weui_cell_primary">组团价格：</span><span class="weui_cell_ft"><span class="mygroup-groupfee">￥${groups.group.groupFee}</span></span></p>
               
               <a class="weui_cell" onClick = "showdetail('${groups.group.xytCourse.courseIntroduction}')">
               	<span class="weui_cell_bd weui_cell_primary">课程：</span><span class="weui_cell_ft">${groups.group.xytCourse.courseName}(点击展开)</span>
               </a>
               
               
               <p class="weui_cell"><span class="weui_cell_bd weui_cell_primary">团长：</span><span class="weui_cell_ft">${groups.group.colonel.nickname}</span></p>
               <p class="weui_cell"><span class="weui_cell_bd weui_cell_primary">开团时间：</span><span class="weui_cell_ft"><fmt:formatDate value="${groups.group.createDate}" pattern="yyyy-MM-dd"/></span></p>
               
               <c:if test="${groups.group.endDate != null}">
               	<p class="weui_cell"><span class="weui_cell_bd weui_cell_primary">参团截止时间：</span><span class="weui_cell_ft"><fmt:formatDate value="${groups.group.endDate}" pattern="yyyy-MM-dd"/></span></p>
               </c:if>
               
               <c:if test="${(groups.group.xytTercherInfo != null)}">
	               <p class="imgteacher"><span class="mygroup-teacherpic"><img src="${basePath}${groupOrder.xytTercherInfo.photoPath}${groups.group.xytTercherInfo.photoPath}" class="group-img-circle" style="display: inline; visibility: visible;"/></span></p>
	               <p class="mygroup-teachername">${groups.group.xytTercherInfo.name}</p>
               </c:if>
               <c:if test="${(groups.group.xytTercherInfo == null)}">
	               <p class="imgteacher"><span class="mygroup-teacherpic"><img src="${basePath}pages/xytpages/image/teacherimg/unknowteacher.png" class="group-img-circle" style="display: inline; visibility: visible;"/></span></p>
	               <p class="mygroup-teachername">未指派教师</p>
               </c:if>
               
               <div class="avatars item" style = "display:none">
  	               <c:forEach items = "${listXytUserInGroup}" var="xytUserInGroup" varStatus="i">
                   <div class="avatar avatar-sl" id = 'headimgurlaudition'> 
                   
                   <c:if test="${userId != xytUserInGroup.xytUserInfo.rid}">
                     <a href="${basePath}xyt/userInfo!showHisHome.action?userId=${userId}&hisUserId=${xytUserInGroup.xytUserInfo.rid}"><img id = 'headimgaudition' src="${xytUserInGroup.xytUserInfo.headimgurl}" class="img-circle" style="display:block; visibility: visible;"></a>
              	  </c:if>
              	  <c:if test="${userId == xytUserInGroup.xytUserInfo.rid}">
                     <a href="${basePath}xyt/userInfo!showMyHome.action?userId=${userId}"><img id = 'headimgaudition' src="${xytUserInGroup.xytUserInfo.headimgurl}" class="img-circle" style="display:block; visibility: visible;"></a>
              	  </c:if>

                   </div>
  	               </c:forEach>
               </div>
               
               <c:if test="${!groups.xytOrder.paied}">
               	  <a onClick = "pay('${groups.xytOrder.rid}')" class="weui_btn weui_btn_plain_primary totalcourse-circle">立即支付</a>
              	  <a onClick = "quitGroup('${groups.group.rid}')" class="weui_btn weui_btn_default">我要退团</a>
               </c:if>
               
               <c:if test="${groups.xytOrder.paied}">
                 <p class="mygroup-teachername">已支付学费</p>
               </c:if>
               
           </div>
       </div>   
  </c:forEach>


<!--无组团状态-->
<c:if test="${!hasGroup}">
<div class="nothing-main">
    <div class="nothing-wrap">
        <img src="${basePath}pages/xytpages/image/nogroup.png"/>
        <p>暂无组团信息！</p>
    </div>
</div>	 
</c:if>

</br>  
<div class="mygroup-bottomPanel">
    <p onClick="creategroup()">我要组团</p>
</div>
<input type='hidden' id='userid' value='<%=userid%>'/>
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

<div class="weui_dialog_alert" id="dialog1" style="display: none;">
   <div class="weui_mask"></div>
   <div class="weui_dialog">
      <div class="weui_dialog_hd" id = "dialogtitle1"><strong class="weui_dialog_title">课程详情</strong></div>
      <div class="weui_dialog_bd" id = "dialogmessage1">您已订购了该课程</div>
      <div class="weui_dialog_ft">
          <a id="ok" onClick = "hidedialog1()" class="weui_btn_dialog primary">确定</a>
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
