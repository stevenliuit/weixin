/**
 * jQuery PicCarousel.js 
 * Version 0.1.4
 *
 * https://github.com/javion25/PicCarousel.js
 * MIT licensed
 *
 * Copyright (C) 2015 Javion.com - A project by Javion
 */
;(function($){

               	
	
	//定义PicCarousel类
	var PicCarousel = (function(){
		

		//定义PicCarousel的构造函数
		function PicCarousel(element,options){
			this.settings = $.extend(true,$.fn.PicCarousel.defaults,options||{});
			this.element = element;
			this.init();
		}

		//定义PicCarousel的方法
		PicCarousel.prototype = {
			/*说明：初始化插件*/
			init:function(){
				var me = this;
				me.poster = me.element;
				me.posterItemMain = me.poster.find("ul.poster-list");
				me.nextBtn = me.poster.find("div.poster-next-btn"); 
				me.prevBtn = me.poster.find("div.poster-prev-btn"); 
				me.posterItems = me.poster.find("li.poster-item");

				if(me.posterItems.size()%2 == 0){
					me.posterItemMain.append(me.posterItems.ep(0).clone());
					me.posterItems = me.posterItemMain.children;
				}
				
				me.posterFirstItem = me.posterItems.first();
				me.posterLastItem = me.posterItems.last();
				me.rotateFlag =true;

				//设置配置参数值
				me.setSettingValue();
				me.setPosterPost();

				me.nextBtn.click(function(){
					if(me.rotateFlag){
						me.rotateFlag = false;
						me.carouseRotate("left");
					};
				});

				me.prevBtn.click(function(){
					if(me.rotateFlag){
						me.rotateFlag = false;
						me.carouseRotate("right");
					};
				});

				//是否开启自动播放
				if(me.settings.autoPlay){
					me.autoPlay();
					me.poster.hover(function(){
						window.clearInterval(me.timer);
					},function(){
						me.autoPlay();
					});
				}
			},
			
			/*
			 move: function(event) {
                 event.preventDefault();                      // 阻止触摸事件的默认行为，即阻止滚屏

                 // 当屏幕有多个touch或者页面被缩放过，就不执行move操作
                 if (event.touches.length > 1 || event.scale && event.scale !== 1) return;
                 var touch = event.touches[0];
                 endPos = {
                     x: touch.pageX - startPos.x,
                     y: touch.pageY - startPos.y
                 };

                 // 执行操作，使元素移动
                 this.slider.className = 'cnt';
                 this.slider.style.left = -this.index * 600 + endPos.x + 'px';
             },
			*/
             

			//自动播放方法
			autoPlay:function(){
				var me = this;
				me.timer = window.setInterval(function(){
					me.nextBtn.click();
				},me.settings.delay);
			},

			//旋转方法
			carouseRotate:function(dir){
				var me = this;
				var zIndexArr = [];
				if(dir === "left"){
					me.posterItems.each(function(){
						var self = $(this),
							prev = self.prev().get(0)?self.prev():me.posterLastItem,
							width = prev.width(),
							height = prev.height(),
							zIndex = prev.css("zIndex"),
							opacity = prev.css("opacity"),
							left = prev.css("left"),
							top = prev.css("top");
							zIndexArr.push(zIndex);
							self.animate({
									width:width,
									height:height,
									opacity:opacity,
									left:left,
									top:top
							},me.settings.speed,function(){
								me.rotateFlag = true;
							});
					});
					me.posterItems.each(function(i){
						$(this).css("zIndex",zIndexArr[i]);
					})
				}else if(dir === "right"){
					me.posterItems.each(function(){
						var self = $(this),
							next = self.next().get(0)?self.next():me.posterFirstItem,
							width = next.width(),
							height = next.height(),
							zIndex = next.css("zIndex"),
							opacity = next.css("opacity"),
							left = next.css("left"),
							top = next.css("top");
							zIndexArr.push(zIndex);
							self.animate({
									width:width,
									height:height,
									opacity:opacity,
									left:left,
									top:top
							},me.settings.speed,function(){
								me.rotateFlag = true;
							});
					});
					me.posterItems.each(function(i){
						$(this).css("zIndex",zIndexArr[i]);
					})
				}
			},

			//设置剩余的帧的位置关系
			setPosterPost:function(){
				var me = this;
				var sliceItems = me.posterItems.slice(1),
					sliceSize  = sliceItems.size()/2,
					rightSlice = sliceItems.slice(0,sliceSize),
					level      = Math.floor(me.posterItems.size()/2),
					leftSlice  = sliceItems.slice(sliceSize);

				//设置右边帧的位置关系和宽度、高度、top...
				var rw = me.settings.posterWidth,
					rh = me.settings.posterHeight,
					//((容器宽-帧宽)/2)/层级 190
					gap = ((me.settings.width-me.settings.posterWidth)/2)/level;

				var firstLeft = (me.settings.width-me.settings.posterWidth)/2;
				var fixOffsetLeft = firstLeft + rw;

				//设置右边的位置关系
				rightSlice.each(function(i){
					level--;
					rw = rw*me.settings.scale;
					rh = rh*me.settings.scale;
					var j=i;
					$(this).css({
							zIndex:level,
							width:rw,
							height:rh,
							opacity:1/(++j),
							left:fixOffsetLeft+(++i)*(gap-15)-rw+20,
							top:me.setVertucalAlign(rh+340-(i*120))
					});

				});

				//设置左边的位置关系
				var lw = rightSlice.last().width(),
					lh = rightSlice.last().height(),
					oloop = Math.floor(me.posterItems.size()/2);

				leftSlice.each(function(i){
					$(this).css({
							zIndex:i,
							width:lw,
							height:lh,
							opacity:1/oloop,
							left:i*gap+10,
							top:me.setVertucalAlign(rh+660-(i*60))
					});

					lw = lw/me.settings.scale;
					lh = lh/me.settings.scale;
					oloop--;
				});
			},

			//设置垂直排列对齐
			setVertucalAlign:function(height){
				var me = this;
				var verticalType = me.settings.verticalAlign,
					top = 0;

				if(verticalType === "middle"){
					top = (me.settings.height - height)/2;
				}else if(verticalType === "top"){
					top = 0;
				}else if(verticalType === "bottom"){
					top = me.settings.height - height;
				}else{
					top = (me.settings.height-height)/2;
				};

				return top;
			},

			//配置左右按钮和第一帧位置
			setSettingValue:function(){
				var me = this;
				me.poster.css({
					width:me.settings.width,
					height:me.settings.height
				});

				me.posterItemMain.css({
					width:me.settings.width,
					height:me.settings.height
				});

				//计算左右切换按钮的宽度
				var w = (me.settings.width-me.settings.posterWidth)/2;

				me.nextBtn.css({
					width:70,
					height:70,
					zIndex:Math.ceil(me.posterItems.size()/2)
				});
				me.prevBtn.css({
					width:70,
					height:70,
					zIndex:Math.ceil(me.posterItems.size()/2)
				});
				me.posterFirstItem.css({
					width:me.settings.posterWidth,
					height:me.settings.posterHeight,
					top: me.setVertucalAlign(me.settings.posterHeight+400),
					left:60,
					zIndex:Math.floor(me.posterItems.size()/2)
				});
			}
		};
		return PicCarousel;
	})();

	//单例模式,添加PicCarousel方法
	$.fn.PicCarousel = function(options){
		return this.each(function(){
			var me = $(this),
				instance = me.data("PicCarousel");
			if(!instance){
				instance = new PicCarousel(me,options);
				me.data("PicCarousel",instance);
			}
		});
	};

	//默认配置参数
	$.fn.PicCarousel.defaults = {
		"width":400,		//幻灯片的宽度
		"height":500,		//幻灯片的高度
		"posterWidth":320,	//幻灯片第一帧的宽度
		"posterHeight":340, //幻灯片第一张的高度
		"scale":0.8,		//记录显示比例关系
		"speed":300,		//记录幻灯片滚动速度
		"autoPlay":false,	//是否开启自动播放
		"delay":1000,		//自动播放间隔
		"verticalAlign":"middle"	//图片对齐位置
	}
}(jQuery));

