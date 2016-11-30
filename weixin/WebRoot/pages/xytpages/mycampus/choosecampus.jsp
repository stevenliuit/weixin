<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@ taglib uri="/tld/c.tld" prefix="c"%>

<%
String userid = request.getParameter("user");
%>

<!DOCTYPE HTML>
<html>
  <head>     
    <title>选择学校</title>
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
function choosecampus()
{
	var userId = $("#userid").val(); 
	var collegeId = document.getElementById("collegeSelect").value;
	$.post('${basePath}xyt/XytCollegeAction!joinCampus.action',{userId:userId,collegeId:collegeId},function(data){
		if("success" == data.result){
			showdialog2("加入学校成功");
			$("#joinMyCampus").css("display","block");
		}else{
			showdialog2("不可重复加入");
			$("#joinMyCampus").css("display","block");
		}
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
}

function joinmycampus()
{
	var userId = $("#userid").val(); 
	var collegeId = document.getElementById("collegeSelect").value;
	window.location.href='${basePath}xyt/XytCollegeAction!getXytUserInfoByCollegeId.action?user='+userId+'&collegeId='+collegeId;
}
</script>
  </head>
  <body class="g-classDetail">
  <div class="m-nav2">
     <h2>选择学校</h2>
 </div>
 <div class="campus-main">
 <div class="campus-wrap">
 <div class="input-group input-bottom campus-select">
  <select id = 'collegeSelect'>
  	<c:forEach items="${listXytCollege }" var="xytCollege" varStatus="i">
  		<option value ="${xytCollege.rid}">${xytCollege.name}</option>  
  	</c:forEach>
  </select>
 </div> 
 <a href="#" id = 'joinMyCampus' class="weui_btn weui_btn_default"  style = "display:none" onClick="joinmycampus()">点击进入我的校园</a>
  <!--<button id = 'joinMyCampus' style = "display:none" onClick="joinmycampus()">点击进入我的校园</button>-->
  
  
	
<input type='hidden' id='userid' value='<%=userid%>'/>

<div class="weui_dialog_alert" id="dialog2" style="display: none;">
   <div class="weui_mask"></div>
   <div class="weui_dialog">
      <div class="weui_dialog_hd"><strong class="weui_dialog_title">温馨提醒</strong></div>
      <div class="weui_dialog_bd" id = "dialogmessage">您已订购了该课程</div>
      <div class="weui_dialog_ft">
          <a id="ok" onClick = "hidedialog2()" class="weui_btn_dialog primary">确定</a>
      </div>
   </div>
</div>
</div>
</div>

<!--底部-->
<div class="m-bottomPanel"	>
    <span class="js-order">
    <a onClick="choosecampus()" href="#">确定</a>
    </span>
</div>
  </body>
  
</html>
