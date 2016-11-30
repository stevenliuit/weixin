<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib uri="/tld/c.tld" prefix="c"%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
  <head>
    <title>${ta.nickname }的个人中心</title>
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
 	
	 	function showdialog2(message)
		{
			$('#dialogmessage').html(message);
			$('#dialog2').show();
		}
		
		function hidedialog2()
		{
			$('#dialog2').hide();
		}
 	
 		function attantion(userId, attantionUserId) {
 			$.ajax({
				url: "${basePath}xyt/userAttantion!attantion.action",
				type: "POST",
				data: {"userId":userId, "attantionUserId":attantionUserId},
				dataType: "json",
				cache: false,
				success: function(data) {
					if (data.result == "success") {
						if(data.content == "cancelAttantion"){
							$("#attantiona").text("关注");
						}else {
							$("#attantiona").text("取消关注");
						}
					}else {
						showdialog2(data.content);
					}									    
				}
           });
 			
 		}
 	</script>
  </head>
  
  <body class="g-classDetail">
  <div class="m-nav2">
     <h2>${ta.nickname }的个人中心</h2>
   </div>
   
  <div class="m-home-main" style="height:auto; min-height:auto;">
      <div class="m-home-wrap">
          <div class="pane pane-personal">
              <div class="pane-wrap">
                  <div>
                      <div class="avatar avatar-lg">
                          <img src="${ta.headimgurl}" class="img-circle">
                          <label class="personal_name">
                          	${ta.nickname }
                            <c:if test="${ta.sex eq 1 }">
                          		<i class="icon-gi-male color-blue"><img src="${basePath}pages/xytpages/image/male.png"/></i>
                          	</c:if>
                            <c:if test="${ta.sex eq 2 }">
                          		<i class="icon-gi-male color-blue"><img src="${basePath}pages/xytpages/image/female.png"/></i>
                          	</c:if>
                          </label>
                      </div>
                  </div>
                  <div class="row buttons">
                      <div class="col-xs-6"><a href="javascript:attantion('${user.rid}', '${ta.rid}');" class="weui_btn weui_btn_plain_default" id="attantiona"><c:if test="${attantioned }">取消关注</c:if><c:if test="${not attantioned }">关注</c:if></a></div>
                      <div class="col-xs-6"><a href="${basePath}xyt/pmessage!showSendPmessage.action?seuserId=${user.rid}&reuserId=${ta.rid}" class="weui_btn weui_btn_plain_default">私信</a></div>
                  </div>
              </div>
          </div>
      </div>
  </div>
 
 <%-- <c:if test="${ta.college != null}"> 
 <div class="weui_cells weui_cells_access">
   <div class="weui_cell" onClick="javascript:location.href='${basePath}xyt/XytCollegeAction!getXytUserInfoByCollegeId.action?user=${user.rid }&collegeId=${ta.college.rid}'">
       <div class="weui_cell_bd weui_cell_primary">
           <p>他的学校(${ta.college.name})</p>
       </div>
       <div class="weui_cell_ft">   
       </div>
   </div>
</div>
</c:if>

<c:if test="${ta.college == null}"> 
 <div class="weui_cells weui_cells_access">
   <div class="weui_cell">
       <div class="weui_cell_bd weui_cell_primary">
           <p>他的学校(暂未入学)</p>
       </div>
       <div class="weui_cell_ft">   
       </div>
   </div>
</div>
</c:if> --%>
   
   <div class="weui_dialog_alert" id="dialog2" style="display: none;">
	   <div class="weui_mask"></div>
	   <div class="weui_dialog">
	      <div class="weui_dialog_hd"><strong class="weui_dialog_title">温馨提醒</strong></div>
	      <div class="weui_dialog_bd" id = "dialogmessage"></div>
	      <div class="weui_dialog_ft">
	          <a id="ok" onClick = "hidedialog2()" class="weui_btn_dialog primary">确定</a>
	      </div>
	   </div>
	</div>
  
  </body>
</html>