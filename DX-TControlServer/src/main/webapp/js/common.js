(function($){
	// lnb custome scrollbar
})(jQuery);

$(window).ready(function(){
	$('.infobox').hide();
	
	$(".btn_info").toggle(			
			function(){
				$(".infobox").css("display","block");
			},
			function(){
				$(".infobox").css("display","none");
			}
		);
	
	$('#loading').hide();
	
	$( document ).ajaxStart(function() {	
	      $('#loading').css('position', 'absolute');
	      $('#loading').css('left', '50%');
	      $('#loading').css('top', '50%');
	      $('#loading').css('transform', 'translate(-50%,-50%)');	  
	      $('#loading').show();	
	});
	
	//AJAX 통신 종료
	$( document ).ajaxStop(function() {
		$('#loading').hide();
	});
	
	// GNB_click function
	/*
	function gnbMenu(){
		$("#gnb ul li:has(ul)").find("a:first").parent().addClass('menu');
		$("#gnb li > a").click(function(){
			var li = $(this).parent();
			var ul = li.parent()
			ul.find('li').removeClass('on');
			ul.find('ul').not(li.find('ul')).hide();
			li.children('ul').toggle();
			if( li.children('ul').is(':visible') || li.has('ul')) {
				li.addClass('on');
			}
		});
	}gnbMenu();
	*/

	// GNB_Hover function
	function gnbMenu(){
		$("#gnb ul li:has(ul)").find("a:first").parent().addClass('menu');
		$("#gnb li").hover(function(){

			if($(this).parent().attr('class') == "depth_1" || $(this).parent().attr('class') == "depth_2"){
				$(this).addClass('on').siblings().removeClass('on');
			}
			$('ul:first',this).show();
		}, function(){
			$(this).removeClass('on');
			$('ul:first',this).hide();
		});
	}gnbMenu();


	// 확장설치 조회 
	$(".install_btn").click(function(){
		$(this).parent().parent().children('ul').move("toggle");
	});

	function tab(){
		$('.tab a').on('click',function(){
			var that = $(this).parent('li');
			var view = that.parents('.tab').next('.tab_view').find('.view');
			var idx = that.index();
			that.addClass('on').siblings().removeClass('on');
			view.eq(idx).addClass('on').siblings().removeClass('on');
		})
	}tab();

	// Tree Navigation
	jQuery(function($){
		var tNav = $('.tNav');
		var tNavPlus = '\<button type=\"button\" class=\"tNavToggle plus\"\>+\<\/button\>';
		var tNavMinus = '\<button type=\"button\" class=\"tNavToggle minus\"\>-\<\/button\>';
		tNav.find('li>ul').css('display','none');
		tNav.find('ul>li:last-child').addClass('last');
		tNav.find('li>ul:hidden').parent('li').prepend(tNavPlus);
		tNav.find('li>ul:visible').parent('li').prepend(tNavMinus);
		tNav.find('li.active').addClass('open').parents('li').addClass('open');
		tNav.find('li.open').parents('li').addClass('open');
		tNav.find('li.open>.tNavToggle').text('-').removeClass('plus').addClass('minus');
		tNav.find('li.open>ul').slideDown(100);
		$('.tNav .tNavToggle').click(function(){
			t = $(this);
			t.parent('li').toggleClass('open');
			if(t.parent('li').hasClass('open')){
				t.text('-').removeClass('plus').addClass('minus');
				t.parent('li').find('>ul').slideDown(100);
			} else {
				t.text('+').removeClass('minus').addClass('plus');
				t.parent('li').find('>ul').slideUp(100);
			}
			return false;
		});
		$('.tNav a[href=#]').click(function(){
			t = $(this);
			t.parent('li').toggleClass('open');
			if(t.parent('li').hasClass('open')){
				t.prev('button.tNavToggle').text('-').removeClass('plus').addClass('minus');
				t.parent('li').find('>ul').slideDown(100);
			} else {
				t.prev('button.tNavToggle').text('+').removeClass('minus').addClass('plus');
				t.parent('li').find('>ul').slideUp(100);
			}
			return false;
		});
	});

	// display none/block function
	(function($){
		$.fn.move = function(type){
			var obj = this;
			var target;
			if(type == 'open'){
				target = obj.css("display","block");
			}else if(type == 'close'){
				target = obj.css("display","none");
			}else if(type == 'slideUp'){
				target = obj.slideUp(100);
			}else if(type == 'slideDown'){
				target = obj.slideDown(100);
			}else if(type == 'toggle'){
				target = obj.toggle();
			}

		}
	})(jQuery);
})


//마스크 띄우기
function wrapWindowByMask() { 

	var mask = $("#lay_mask");

	//화면의 높이와 너비를 구한다. 
	var maskHeight = $(document).height();
	var maskWidth = $(window).width();

	//마스크의 높이와 너비를 화면 것으로 만들어 전체 화면을 채운다. 
	mask.css({'width':maskWidth,'height':maskHeight});
	mask.show();
}
// 사이즈 리사이징
function ResizingLayer() {
	if($(".PopupLayer").css("visibility") == "visible") {
		//화면의 높이와 너비를 구한다. 
		var maskHeight = $(document).height();
		var maskWidth = $(window).width();

		//마스크의 높이와 너비를 화면 것으로 만들어 전체 화면을 채운다. 
		$("#lay_mask").css({'width':maskWidth,'height':maskHeight});
		//$('#header').css({'width':maskWidth}); // 20131119 최창원 수정 헤더의 넓이 값을 우선 빼 봤음.

		$(".PopupLayer").each(function () {
			var left = ( $(window).scrollLeft() + ($(window).width() - $(this).width()) / 2 );
			var top = ( $(window).scrollTop() + ($(window).height() - $(this).height()) / 2 );

			if(top<0) top = 0;
			if(left<0) left = 0;

			$(this).css({"left":left, "top":top});
		});
	}
	// 퀵메뉴 팝업
	if($("#pop_setting1").css("visibility") == "visible") {
		//화면의 높이와 너비를 구한다. 
		var maskHeight = $(document).height();
		var maskWidth = $(window).width();

		//마스크의 높이와 너비를 화면 것으로 만들어 전체 화면을 채운다. 
		$("#lay_mask").css({'width':maskWidth,'height':maskHeight});
		//$('#header').css({'width':maskWidth}); // 20131119 최창원 수정 헤더의 넓이 값을 우선 빼 봤음.

		$("#pop_setting1").each(function () {
			var left = ( $(window).scrollLeft() + ($(window).width() - $(this).width()) / 2 );
			var top = ( $(window).scrollTop() + 20 + "px" );

			if(top<0) top = 0;
			if(left<0) left = 0;

			$(this).css({"left":left, "top":top});
		});
	}
}

window.onresize = ResizingLayer;
//레이어 가운데 띄우고 마스크 띄우기
function toggleLayer( obj, s ) {

	var zidx = $("#lay_mask").css("z-index");
	if(s == "on") {
		//화면중앙에 위치시키기
		var left = ( $(window).scrollLeft() + ($(window).width() - obj.width()) / 2 );
		var top = ( $(window).scrollTop() + ($(window).height() - obj.height()) / 2 );
		
		// 높이가 0이하면 0으로 변경
		if(top<0) top = 0;
		if(left<0) left = 0;

		if($(".PopupLayer").length > 1) {
			var layer_idx = Number(zidx) + 10;
		}

		$("#lay_mask").css("z-index", layer_idx);
		// console.log('on일경우 '+ $("#lay_mask").css('z-index'))
		obj.css({"left":left, "top":top, "z-index":layer_idx}).addClass("PopupLayer");
		$("body").append(obj);

		wrapWindowByMask();//배경 깔기
		//obj.show();//레이어 띄우기
		obj.css('visibility','visible');//레이어 띄우기
		obj.css('overflow','visible');
		obj.css({"left":left, "top":top});
	}

	if(s == "off") {
		if($(".PopupLayer").length > 1) {
			//var layer_idx = zidx - 10;
			//$("#lay_mask").css("z-index", layer_idx);
			// console.log('off일경우 '+ $("#lay_mask").css('z-index'))
		} else {
			$("#lay_mask").hide();
		}

		obj.removeClass("PopupLayer").css('visibility','hidden');
		obj.css('top','-9999px');
	}

	if(s == "off2") { //레이어에서 다른 레이어를 띄울 경우 마스크는 안닫기 위한 처리
		obj.removeClass("PopupLayer").css('visibility','hidden');
	}
}


function fn_scdLayer(scd_nm){
	$.ajax({
		url : "selectScdInfo.do",
		data : {
			scd_nm : scd_nm
		},
		dataType : "json",
		type : "post",
		error : function(request, status, error) {
			alert("ERROR CODE : "+ request.status+ "\n\n"+ "ERROR Message : "+ error+ "\n\n"+ "Error Detail : "+ request.responseText.replace(/(<([^>]+)>)/gi, ""));
		},
		success : function(result) {
			var hms = "";
			
			hms += result[0].exe_hms.substring(4,6)+"시 ";	
			hms += result[0].exe_hms.substring(2,4)+"분 ";	
			hms += result[0].exe_hms.substring(0,2)+"초";		
			
			var day = "";
			if(result[0].exe_perd_cd == "TC001602"){
				day += "(";
				if(result[0].exe_dt.substring(0,1)=="1"){
					day += "일, ";
				}
				if(result[0].exe_dt.substring(1,2)=="1"){
					day += "월, ";
				}
				if(result[0].exe_dt.substring(2,3)=="1"){
					day += "화, ";
				}
				if(result[0].exe_dt.substring(3,4)=="1"){
					day += "수, ";
				}
				if(result[0].exe_dt.substring(4,5)=="1"){
					day += "목, ";
				}
				if(result[0].exe_dt.substring(5,6)=="1"){
					day += "금, ";
				}
				if(result[0].exe_dt.substring(6,7)=="1"){
					day += "토";
				}
				day += ")";
			}		
			document.getElementById('scd_nm_info').value= result[0].scd_nm;
			document.getElementById('scd_exp_info').value= result[0].scd_exp;						
			document.getElementById('scd_cndt_info').value= result[0].scd_cndt_nm;				
			document.getElementById('exe_perd_cd_info').value= result[0].exe_perd_cd_nm + " " + day ;
			document.getElementById('scd_exe_hms').value= hms;			
		}
	});
	toggleLayer($('#pop_layer'), 'on');
}
