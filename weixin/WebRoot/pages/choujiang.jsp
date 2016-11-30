<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%
String user = request.getParameter("user");
String xmid = request.getParameter("xmid");
%>

<!DOCTYPE HTML>
<html>
  <head>     
    <title>抽奖</title>   
	<meta charset="utf-8">   
	<meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
    <meta name="apple-touch-fullscreen" content="yes">
    <meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=0">
    <meta name="apple-mobile-web-app-capable" content="yes">
    <meta name="apple-mobile-web-app-status-bar-style" content="black">
    <meta name="format-detection" content="telephone=no">
    
 <link type="text/css" rel="stylesheet" href="file/css/reset.css">
 <link type="text/css" rel="stylesheet" href="file/css/default.css">
 <link type="text/css" rel="stylesheet" href="file/css/content.css">
    
	<script language="javascript" src="/weixin/pages/jquery.js"></script>
	<script type="text/javascript" src="/weixin/pages/file/scripts/MessageBox.js" charset='utf-8'></script>
<script type="text/javascript">
var cjarr = new Array();
var choujiang = true;

$(document).ready(function(){
	setTimeout(function(){ 
			loadkj();  
		 },100); 
});

function loadkj(){
	$div = $("#u6");
	var user = "<%=user%>";
	var xmid = "<%=xmid%>";
	var now = new Date();
	$.post('/weixin/cj/Cjaction!getAllCjxm.action',null,function(data){
		for (var i = 0 ; i<data.length ;i++){
			var cjxm =data[i];
			var kjsj = cjxm.kjsj;  kjsj = kjsj.replace(/-/g,"/"); var sj =  new Date(Date.parse(kjsj)); 
			if(xmid == cjxm.xmid)
			{
				if (sj<now){
					$div.find("div").eq(0).html("<p><span>￥0</span>");
					$div.find("div").eq(1).html("<p><span>已开奖</span>");
				}else{
					$div.find("div").eq(0).html("<p><span>￥0</span>");
					$div.find("div").eq(1).html("<p><span>尚未开奖</span>");
				}
				break;
			}
		}
	},"json");
}


function checkuser(){
	var user = "<%=user%>";
	var xmid = "<%=xmid%>";
	$.post('/weixin/cj/Cjaction!getAllZjjlByUser.action',{userid:user},function(data){
		for (var i = 0 ; i<data.length ;i++)
		{
			if(!cjarr.contains(data[i].xmid))
			{
				cjarr.push(data[i].xmid);
			}
		}
		
		if(!cjarr.contains(xmid)) {
			choujiang = false;
		}
	},"json");
}

function cj()
{
	var user = "<%=user%>";
	var xmid = "<%=xmid%>";
	var now = new Date();
	$.post('/weixin/cj/Cjaction!getAllCjxm.action',null,function(data){
		for (var i = 0 ; i<data.length ;i++){
			var cjxm =data[i];
			if( xmid == cjxm.xmid)
			{
				var kjsj = 	cjxm.kjsj;
				kjsj = kjsj.replace(/-/g,"/"); sj =  new Date(Date.parse(kjsj));
				if(sj < now)
				{
					showAlert("此项抽奖活动已经结束，感谢您的参与！");
				}
				else
				{
					if(choujiang)
					{
						showAlert("您已参加了此项抽奖，请点击屏幕下方按钮查看我的抽奖信息");
					}
					else
					{
						window.location.href='/weixin/pages/inputphonenumber.jsp?user='+user+'&xmid='+xmid;
					}
				}
				break;
			}
		}
	},"json");
}

function myrecord()
{
	var user = "<%=user%>";
	window.location.href='/weixin/pages/choujiangjilu.jsp?user='+user;
}

function mygift()
{
	var user = "<%=user%>";
	window.location.href='/weixin/pages/zhongjiangjilu.jsp?user='+user;
}

function prizelist()
{
	var user = "<%=user%>";
	window.location.href='/weixin/pages/0yuangou.jsp?user='+user;
}

function rule()
{
	var user = "<%=user%>";
	window.location.href='/weixin/pages/rule.jsp?user='+user;
}

Array.prototype.contains = function (element) { 
	for (var i = 0; i < this.length; i++) { 
        if (this[i] == element) { 
            return true; 
        } 
    } 
    return false; 
} 

checkuser();

function showAlert(str)
{
	var messContent="<div style='background:#eee;font-size:14px;line-height:1.5rem;padding:5px 10px 10px 10px;text-align:center;'>"+str+"</div>";  // 弹出提示框  
	messageBox.showMessageBox('',messContent,250); 
}

function showMessage5yuan(zjbm){  
	var messContent="<div style='font-size:20;padding:5px 10px 10px 10px;text-align:center;'>您的抽奖编号：</div>  <div style = 'font-size:22;color:#FF0000;text-align:center;'>"+zjbm+"<\div><div  style = 'font-size:20; color:#000000'>开奖日公布结果</div> <br/> <br/><div style = 'font-size:16;color:#000000'>获三等奖</div><div><img src = '/weixin/pages/file/5yuan_xiao.jpg'/></div> <div style = 'font-size:16;color:#000000'>96360商城代金券5元</div>";  // 弹出提示框  
	messageBox.showMessageBox('',messContent,250); 
}

function showMessage10yuan(zjbm){  
	var messContent="<div style='font-size:20;padding:5px 10px 10px 10px;text-align:center;'>您的抽奖编号：</div>  <div style = 'font-size:22;color:#FF0000;text-align:center;'>"+zjbm+"<\div> <br/><div  style = 'font-size:20; color:#000000'>开奖日公布结果</div> <br/> <br/><div style = 'font-size:16;color:#000000'>获二等奖</div><div><img src = '/weixin/pages/file/10yuan_xiao.jpg'/></div> <div style = 'font-size:16;color:#000000'>96360商城代金券10元</div>";  // 弹出提示框  
	messageBox.showMessageBox('',messContent,250); 
}

function showMessageCJBH(zjbm){  
	var messContent="<div style='font-size:20;padding:5px 10px 10px 10px;text-align:center;'>您的抽奖编号：</div>  <div style = 'font-size:22;color:#FF0000;text-align:center;'>"+zjbm+"<\div> <br/><div  style = 'font-size:20; color:#000000'>开奖日公布结果</div>";  // 弹出提示框  
	messageBox.showMessageBox('',messContent,250); 
}

var messageBox; (function(){ messageBox = new __messageBox(); })(); 


</script>

  </head>
  
  <BODY>
      <nav>奖品详情</nav>
	<DIV class="main_container">
	
	<DIV id=u0_container class="u0_container">
	<DIV id="u0_img" class="u0_original"></DIV>
	<DIV id=u1 class="u1" >
	<DIV id=u1_rtf>&nbsp;</DIV></DIV>
	</DIV>
    
    <div class="big-pic">
        <div class="state" id='u6'>
           <div class="state_l"></div>
           <div class="state_r"></div>
        </div>
	    <IMG id=u0 src="file/chelizi.jpg" class="u0" >
    </div>
	
	<div class="btn">
	<input onClick="cj()"  type="button"  value="立即抽奖"></input>
	</div>
	</DIV>
	<DIV>
	<DIV id=u7 class="u7" >
	<DIV id=u7_rtf>
	
    
     <div class="content">
         <ol>
             <li>
                 <b>奖品名称：</b>
                 <span>大奖：美国进口车厘子一箱（3斤）</span>
             </li>
             
             <li>
                 <b>抽奖时段：</b>
                 <span>2015-6-20~~2015-7-20</span>
             </li>
             
             <li>
                 <b>开奖时间：</b>
                 <span>2015-7-21 15：00</span>
             </li>
         </ol>
     </div>
	
	
	<!--  
	<p style="text-align:left;">
		<span 
			style="font-family:微软雅黑;
			font-size:20px;
			font-weight:normal;
			font-style:normal;
			text-decoration:none;
			color:#333333;">
			本次大奖中奖编码如下：
		</span>
	</p>
	
	<p style="text-align:center;">
		<span 
			style="font-family:微软雅黑;
			font-size:24px;
			font-weight:bolder;
			font-style:normal;
			text-decoration:none;
			color:#333333;">
			123456
		</span>
	</p>
	-->
	
	
			<h1>奖品详情：</h1>
		
	</p>
	</DIV>
	</DIV>
	<DIV>
	<IMG id=u0 src="file/chelizi2.jpg" class="u0"    style="width:98%; height: 236px">
	</DIV>
    <div class="clear h50"></div>
    
    <div class="hytpl-navbar hytpl-navbar-new">
    <ul class="bar-list">
        <li>
            <a href="#" onClick="prizelist()" class="cur">
                <div class="icon">
                    <b class="iconfont list"></b>
                </div>
                <p class="name">奖品列表</p>
            </a>
        </li>
        
         <li>
            <a href="#" onClick="myrecord()" class="cur">
                <div class="icon">
                    <b class="iconfont number"></b>
                </div>
                <p class="name">抽奖编号</p>
            </a>
        </li>
        
         <li>
            <a href="#" onClick="mygift()" class="cur">
                <div class="icon">
                    <b class="iconfont recoder"></b>
                </div>
                <p class="name">中奖记录</p>
            </a>
        </li>
        
        <li>
            <a href="#" onClick="rule()" class="cur">
                <div class="icon">
                    <b class="iconfont rule"></b>
                </div>
                <p class="name">大奖玩法</p>
            </a>
        </li>
    </ul>
</div>
	</BODY>
	
</html>
