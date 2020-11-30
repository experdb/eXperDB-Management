(function($){
	// lnb custome scrollbar
})(jQuery);

$(window).ready(function(){
	var html = '<div id="loading"><img src="/images/spin.gif" alt="" /></div>';
	$("#contents").append(html);
	$("#pop_container").append(html);
	
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

//About eXperDB
function fn_aboutExperdb(version){
	$("#version").html(version);
	toggleLayer($('#pop_layer_aboutExperdb'), 'on');
}

//Open Source
function fn_openSource(){
	toggleLayer($('#pop_layer_openSource'), 'on');
}

// Support
function fn_support() {
	toggleLayer($('#pop_layer_support'), 'on');
}

// 스케줄정보
function fn_scdLayer(scd_id){
	$.ajax({
		url : "/selectScdInfo.do",
		data : {
			scd_id : scd_id
		},
		dataType : "json",
		type : "post",
		error : function(xhr, status, error) {
			if(xhr.status == 401) {
				alert(message_msg02);
				top.location.href = "/";
			} else if(xhr.status == 403) {
				alert(message_msg03);
				top.location.href = "/";
			} else {
				alert("ERROR CODE : "+ xhr.status+ "\n\n"+ "ERROR Message : "+ error+ "\n\n"+ "Error Detail : "+ xhr.responseText.replace(/(<([^>]+)>)/gi, ""));
			}
		},
		beforeSend: function(xhr) {
	        xhr.setRequestHeader("AJAX", true);
	     },
		success : function(result) {
			if(result.length==0){
				alert("스케줄이 삭제되어 스케줄 정보를 확인할 수 없습니다.");
			}else{
				var hms = "";
				
				hms += result[0].exe_hms.substring(4,6)+schedule_our;	
				hms += result[0].exe_hms.substring(2,4)+schedule_minute;	
				hms += result[0].exe_hms.substring(0,2)+schedule_second;		
				
				var day = "";
				if(result[0].exe_perd_cd == "TC001602"){
					day += "(";
					if(result[0].exe_dt.substring(0,1)=="1"){
						day += schedule_sunday+", ";
					}
					if(result[0].exe_dt.substring(1,2)=="1"){
						day += schedule_monday+", ";
					}
					if(result[0].exe_dt.substring(2,3)=="1"){
						day += schedule_thuesday+", ";
					}
					if(result[0].exe_dt.substring(3,4)=="1"){
						day += schedule_wednesday+", ";
					}
					if(result[0].exe_dt.substring(4,5)=="1"){
						day += schedule_thursday+", ";
					}
					if(result[0].exe_dt.substring(5,6)=="1"){
						day += schedule_friday+", ";
					}
					if(result[0].exe_dt.substring(6,7)=="1"){
						day += schedule_saturday;
					}
					day += ")";
				}		

				$("#scd_nm_info").html(result[0].scd_nm);
				$("#scd_exp_info").html(result[0].scd_exp);
				$("#scd_cndt_info").html(result[0].scd_cndt_nm);
				$("#exe_perd_cd_info").html(result[0].exe_perd_cd_nm + " " + day);
				$("#scd_exe_hms").html(hms);
				
				toggleLayer($('#pop_layer'), 'on');
			}
			
		}
	});
	
}


//ERROR 로그 정보 출력
function fn_failLog(exe_sn){
	$.ajax({
		url : "/selectWrkErrorMsg.do",
		data : {
			exe_sn : exe_sn
		},
		dataType : "json",
		type : "post",
		beforeSend: function(xhr) {
	        xhr.setRequestHeader("AJAX", true);
	     },
		error : function(xhr, status, error) {
			if(xhr.status == 401) {
				alert(message_msg02);
				top.location.href = "/";
			} else if(xhr.status == 403) {
				alert(message_msg03);
				top.location.href = "/";
			} else {
				alert("ERROR CODE : "+ xhr.status+ "\n\n"+ "ERROR Message : "+ error+ "\n\n"+ "Error Detail : "+ xhr.responseText.replace(/(<([^>]+)>)/gi, ""));
			}
		},
		success : function(result) {
				$("#wrkLogInfo").html(result[0].rslt_msg);
				toggleLayer($('#pop_layer_wrkLog'), 'on');						
		}
	});	
}



// WORK정보
function fn_workLayer(wrk_id){
	$.ajax({
		url : "/selectWrkInfo.do",
		data : {
			wrk_id : wrk_id
		},
		dataType : "json",
		type : "post",
		beforeSend: function(xhr) {
	        xhr.setRequestHeader("AJAX", true);
	     },
	     error : function(xhr, status, error) {
				if(xhr.status == 401) {
					alert(message_msg02);
					top.location.href = "/";
				} else if(xhr.status == 403) {
					alert(message_msg03);
					top.location.href = "/";
				} else {
					alert("ERROR CODE : "+ xhr.status+ "\n\n"+ "ERROR Message : "+ error+ "\n\n"+ "Error Detail : "+ xhr.responseText.replace(/(<([^>]+)>)/gi, ""));
				}
			},
		success : function(result) {
			if(result.length==0){
				alert("Work가 삭제되어 Work 정보를 확인할 수 없습니다.");
			}else{				
				if(result[0].bsn_dscd == "TC001901"){
					// RMAN
					if(result[0].bck_bsn_dscd == "TC000201"){
						$("#r_bck_bsn_dscd_nm").html(result[0].bck_bsn_dscd_nm);
						$("#bck_opt_cd_nm").html(result[0].bck_opt_cd_nm);
						$("#r_wrk_nm").html(result[0].wrk_nm);
						$("#r_wrk_exp").html(result[0].wrk_exp);
						if(result[0].cps_yn == "N"){
							$("#cps_yn").html(agent_monitoring_no);
						}else{
							$("#cps_yn").html(agent_monitoring_yes);
						}
						//$("#cps_yn").html(result[0].cps_yn);
						$("#log_file_pth").html(result[0].log_file_pth);
						$("#data_pth").html(result[0].data_pth);
						$("#bck_pth").html(result[0].bck_pth);
						$("#r_file_stg_dcnt").html(result[0].file_stg_dcnt);
						$("#r_bck_mtn_ecnt").html(result[0].bck_mtn_ecnt);
						$("#acv_file_stgdt").html(result[0].acv_file_stgdt);
						$("#acv_file_mtncnt").html(result[0].acv_file_mtncnt);
						if(result[0].log_file_bck_yn == "N"){
							$("#log_file_bck_yn").html(agent_monitoring_no);
						}else{
							$("#log_file_bck_yn").html(agent_monitoring_yes);
						}
						//$("#log_file_bck_yn").html(result[0].log_file_bck_yn);
						$("#r_log_file_stg_dcnt").html(result[0].log_file_stg_dcnt);
						$("#r_log_file_mtn_ecnt").html(result[0].log_file_mtn_ecnt);
						
						toggleLayer($('#pop_layer_rman'), 'on');			
					// DUMP
					}else{
						$("#d_bck_bsn_dscd_nm").html(result[0].bck_bsn_dscd_nm);
						$("#d_wrk_nm").html(result[0].wrk_nm);
						$("#d_wrk_exp").html(result[0].wrk_exp);
						$("#db_nm").html(result[0].db_nm);
						$("#save_pth").html(result[0].save_pth);
						$("#file_fmt_cd_nm").html(result[0].file_fmt_cd_nm);
						$("#cprt").html(result[0].cprt);
						$("#encd_mth_nm").html(result[0].encd_mth_nm);
						$("#usr_role_nm").html(result[0].usr_role_nm);
						$("#d_file_stg_dcnt").html(result[0].file_stg_dcnt);
						$("#d_bck_mtn_ecnt").html(result[0].bck_mtn_ecnt);
						fn_workOptionLayer(result[0].bck_wrk_id, result[0].db_svr_id, result[0].db_nm);
						toggleLayer($('#pop_layer_dump'), 'on');		
					}
				}else if(result[0].bsn_dscd == "TC001902"){
					fn_scriptLayer(result[0].wrk_id);
				}
			}
	
		}
	});	
}


//WORK OPTION정보
function fn_workOptionLayer(bck_wrk_id, db_svr_id, db_nm){
	var db_svr_id = db_svr_id;
	$.ajax({
		url : "/workOptionLayer.do",
		data : {
			bck_wrk_id : bck_wrk_id
		},
		dataType : "json",
		type : "post",
		beforeSend: function(xhr) {
	        xhr.setRequestHeader("AJAX", true);
	     },
	     error : function(xhr, status, error) {
				if(xhr.status == 401) {
					alert(message_msg02);
					top.location.href = "/";
				} else if(xhr.status == 403) {
					alert(message_msg03);
					top.location.href = "/";
				} else {
					alert("ERROR CODE : "+ xhr.status+ "\n\n"+ "ERROR Message : "+ error+ "\n\n"+ "Error Detail : "+ xhr.responseText.replace(/(<([^>]+)>)/gi, ""));
				}
			},
		success : function(result) {		
			var sections = "";
			var objectType = "";
			var save_yn = "";
			var query = "";
			var etc = "";

				for(var i=0; i<result.length; i++){
					if(result[i].grp_cd == "TC0006"){
						sections += result[i].opt_cd_nm + "  /  ";
					}else if (result[i].grp_cd == "TC0007"){
						objectType += result[i].opt_cd_nm + "  /  ";
					}else if (result[i].grp_cd == "TC0008"){
						save_yn += result[i].opt_cd_nm + "  /  ";
					}else if (result[i].grp_cd == "TC0009"){
						query += result[i].opt_cd_nm + "  /  ";
					}else{
						etc += result[i].opt_cd_nm + "  /  ";
					}
				}
				$("#sections").html(sections);
				$("#objectType").html(objectType);
				$("#save_yn").html(save_yn);
				$("#query").html(query);
				$("#etc").html(etc);			
				
				
				fn_workObjectListTreeLayer(bck_wrk_id, db_svr_id, db_nm);
			}		
	});
}


function fn_workObjectListTreeLayer(bck_wrk_id, db_svr_id, db_nm){
	$.ajax({
		async : false,
		url : "/workObjectListTreeLayer.do",
	  	data : {
	  		bck_wrk_id : bck_wrk_id
	  	},
		type : "post",
		beforeSend: function(xhr) {
	        xhr.setRequestHeader("AJAX", true);
	     },
	     error : function(xhr, status, error) {
				if(xhr.status == 401) {
					alert(message_msg02);
					top.location.href = "/";
				} else if(xhr.status == 403) {
					alert(message_msg03);
					top.location.href = "/";
				} else {
					alert("ERROR CODE : "+ xhr.status+ "\n\n"+ "ERROR Message : "+ error+ "\n\n"+ "Error Detail : "+ xhr.responseText.replace(/(<([^>]+)>)/gi, ""));
				}
			},
		success : function(result) {
			fn_workObjectTreeLayer(db_svr_id, db_nm, result);
		}
	});	
}


//WORK OPTION정보
function fn_workObjectTreeLayer(db_svr_id, db_nm, workObj){
	$.ajax({
		async : false,
		url : "/getObjectList.do",
	  	data : {
	  		db_svr_id : db_svr_id,
	  		db_nm : db_nm
	  	},
		type : "post",
		beforeSend: function(xhr) {
	        xhr.setRequestHeader("AJAX", true);
	     },
		error : function(xhr, status, error) {
			if(xhr.status == 401) {
				alert(message_msg02);
				top.location.href = "/";
			} else if(xhr.status == 403) {
				alert(message_msg03);
				top.location.href = "/";
			} else {
				alert("ERROR CODE : "+ xhr.status+ "\n\n"+ "ERROR Message : "+ error+ "\n\n"+ "Error Detail : "+ xhr.responseText.replace(/(<([^>]+)>)/gi, ""));
			}
		},
		success : function(data) {
			fn_make_object_list(data, workObj);
		}
	});
}


/* ********************************************************
 * Make Object Tree
 ******************************************************** */
function fn_make_object_list(data, workObj){
	var html = "<ul>";
	var schema = "";
	var schemaCnt = 0;
	$(data.data).each(function (index, item) {
		var inSchema = item.schema;
		
		if(schemaCnt > 0 && schema != inSchema){
			html += "</ul></li>\n";
		}
		if(schema != inSchema){
			var checkStr = "disabled";
			$(workObj).each(function(i,v){
				if(v.scm_nm == item.schema && v.obj_nm == "") checkStr = " checked disabled";
			});
			html += "<li class='active'><a href='#'>"+item.schema+"</a>";
			html += "<div class='inp_chk chk3'>";
			html += "<input type='checkbox' id='schema"+schemaCnt+"' name='tree' value='"+item.schema+"' otype='schema' schema='"+item.schema+"'"+checkStr+"/><label for='schema"+schemaCnt+"'></label>";
			html += "</div>";
			html += "<ul>\n";
		}
		
		var checkStr = "disabled";
		$(workObj).each(function(i,v){
			if(v.scm_nm == item.schema && v.obj_nm == item.name) checkStr = " checked disabled";
		});
		html += "<li><a href='#'>"+item.name+"</a>";
		html += "<div class='inp_chk chk3'>";
		html += "<input type='checkbox' id='table"+index+"' name='tree' value='"+item.name+"' otype='table' schema='"+item.schema+"'"+checkStr+"/><label for='table"+index+"'></label>";
		html += "</div>";
		html += "</li>\n";

		if(schema != inSchema){
			schema = inSchema;
			schemaCnt++;
		}
	});
	if(schemaCnt > 0) html += "</ul></li>";
	html += "</ul>";

	$(".tNav").html("");
	$(".tNav").html(html);
	//$.getScript( "/js/common.js", function() {});
	
	$('#loading').hide();
}




//조치결과 정보 출력
function fn_fixLog(exe_sn){
	$.ajax({
		url : "/selectFixRsltMsg.do",
		data : {
			exe_sn : exe_sn
		},
		dataType : "json",
		type : "post",
		beforeSend: function(xhr) {
	        xhr.setRequestHeader("AJAX", true);
	     },
		error : function(xhr, status, error) {
			if(xhr.status == 401) {
				alert(message_msg02);
				top.location.href = "/";
			} else if(xhr.status == 403) {
				alert(message_msg03);
				top.location.href = "/";
			} else {
				alert("ERROR CODE : "+ xhr.status+ "\n\n"+ "ERROR Message : "+ error+ "\n\n"+ "Error Detail : "+ xhr.responseText.replace(/(<([^>]+)>)/gi, ""));
			}
		},
		success : function(result) {
				document.getElementById("exe_sn").value = result[0].exe_sn;
				$(":radio[name=input:rdo][value="+result[0].fix_rsltcd+"]").attr("checked", true);
				$("#fix_rslt_msg").html(result[0].fix_rslt_msg);
					
				document.getElementById("lst_mdfr_id").value = result[0].lst_mdfr_id;
				document.getElementById("lst_mdf_dtm").value = result[0].lst_mdf_dtm;
				
				toggleLayer($('#pop_layer_fix_rslt_msg'), 'on');						
		}
	});	
}

//글자 수 체크
function fn_checkWord(obj, maxlength) { 
	var str = obj.value; 
	var str_length = str.length;     
	var max_length = maxlength;  
	if (str_length == max_length) {        
		alert(max_length+message_msg211);
	}    
	obj.focus(); 
}

//trim 체크
String.prototype.trim = function()
{
	return this.replace(/\s/g,'');
}



//ScriptWORK정보
function fn_scriptLayer(wrk_id){
	$.ajax({
		url : "/selectSciptExeInfo.do",
		data : {
			wrk_id : wrk_id
		},
		dataType : "json",
		type : "post",
		beforeSend: function(xhr) {
	        xhr.setRequestHeader("AJAX", true);
	     },
	     error : function(xhr, status, error) {
				if(xhr.status == 401) {
					alert(message_msg02);
					top.location.href = "/";
				} else if(xhr.status == 403) {
					alert(message_msg03);
					top.location.href = "/";
				} else {
					alert("ERROR CODE : "+ xhr.status+ "\n\n"+ "ERROR Message : "+ error+ "\n\n"+ "Error Detail : "+ xhr.responseText.replace(/(<([^>]+)>)/gi, ""));
				}
			},
		success : function(result) {
			if(result.length==0){
				alert("Work가 삭제되어 Work 정보를 확인할 수 없습니다.");
			}else{
				$("#exe_cmd").html(result[0].exe_cmd);
				toggleLayer($('#pop_layer_script'), 'on');	
			}
	
		}
	});	
}

//db2pg config정보
function fn_db2pgConfigLayer(config_nm){
	$.ajax({
		url : "/selectDb2pgConfigInfo.do",
		data : {
			config_nm : config_nm
		},
		dataType : "json",
		type : "post",
		beforeSend: function(xhr) {
	        xhr.setRequestHeader("AJAX", true);
	     },
	     error : function(xhr, status, error) {
				if(xhr.status == 401) {
					showSwalIconRst(message_msg02, '<spring:message code="common.close" />', '', 'error', 'top');
				} else if(xhr.status == 403) {
					showSwalIconRst(message_msg03, '<spring:message code="common.close" />', '', 'error', 'top');
				} else {
					showSwalIcon("ERROR CODE : "+ xhr.status+ "\n\n"+ "ERROR Message : "+ error+ "\n\n"+ "Error Detail : "+ xhr.responseText.replace(/(<([^>]+)>)/gi, ""), '<spring:message code="common.close" />', '', 'error');
				}
			},
		success : function(result) {
			if(result==null){
				showSwalIcon('서버에서 config 정보가 삭제 되어 config 정보를 확인할 수 없습니다.', '<spring:message code="common.close" />', '', 'error');
			}else{
				$("#config").html(result);
				$('#pop_layer_db2pgConfig').modal("show");
			}
	
		}
	});
}

//db2pg ddl 결과 정보
function fn_db2pgDDLResultLayer(ddl_save_pth,dtb_nm){
	$.ajax({
		url : "/db2pg/db2pgDdlCall.do",
	  	data : {
	  		ddl_save_pth : ddl_save_pth,
	  		dtb_nm : dtb_nm		  		
	  	},
		type : "post",
		beforeSend: function(xhr) {
	        xhr.setRequestHeader("AJAX", true);
	     },
		error : function(xhr, status, error) {
			if(xhr.status == 401) {
				alert('<spring:message code="message.msg02" />');
				top.location.href = "/";
			} else if(xhr.status == 403) {
				alert('<spring:message code="message.msg03" />');
				top.location.href = "/";
			} else {
				alert("ERROR CODE : "+ xhr.status+ "\n\n"+ "ERROR Message : "+ error+ "\n\n"+ "Error Detail : "+ xhr.responseText.replace(/(<([^>]+)>)/gi, ""));
			}
		},
		success : function(result) {
			$("#table").html(result.data[0].RESULT_MSG);
			$("#constraint").html(result.data[1].RESULT_MSG);
			$("#index").html(result.data[2].RESULT_MSG);
			$("#sequence").html(result.data[3].RESULT_MSG);
		}
	});	
	toggleLayer($('#pop_layer_db2pgDDLResult'), 'on');	
}

//패스워드 확인
function fn_passwordConfilm(flag){
	document.getElementById('password').value = '';
	document.getElementById('flag').value = flag;
	
	toggleLayer($('#pop_layer_pwConfilm'), 'on');	
}