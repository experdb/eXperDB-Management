<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>

<%@include file="../../cmmn/cs2.jsp"%>

<%
	/**
	* @Class Name : proxySetting.jsp
	* @Description : proxy 설정 관리  화면
	* @Modification Information
	*
	*   수정일         수정자                   수정내용
	*  ------------    -----------    ---------------------------
	*  2021.02.22     최초 생성
	*
	* author 김민정 책임
	* since 2021.02.22
	*
	*/
%>
<script>
var confirm_title = ""; 

	var proxyServerTable = null;
	var vipInstTable = null;
	var proxyListenTable = null;
	var dbServerTable = null;
	var svr_server = null;
	var db = null;

	function fn_init() {
		proxyServerTable = $('#proxyServer').DataTable({
			scrollY : "330px",
			scrollX: true,	
			bDestroy: true,
			paging : true,
			processing : true,
			searching : false,	
			deferRender : true,
			bSort: false,
			columns : [ 
			            {data : "rownum", className : "dt-center", defaultContent : "", targets : 0, orderable : false, checkboxes : {'selectRow' : true}},
						{data : "exe_status", 
			            	render : function(data, type, full, meta) {
								var html = "";
								//TC001501 실행
								//TC001501 중지
								html += '<div class="onoffswitch">';
								if(full.exe_status == "TC001501"){
									html += '<input type="checkbox" name="source_transActivation" class="onoffswitch-checkbox" id="source_transActivation'+ full.rownum +'" onclick="fn_transActivation_click('+ full.rownum +', 1)" checked>';
								}else{ /* if(full.exe_status == "TC001502"){ */
									html += '<input type="checkbox" name="source_transActivation" class="onoffswitch-checkbox" id="source_transActivation'+ full.rownum +'" onclick="fn_transActivation_click('+ full.rownum +', 1)" >';
								}
								html += '<label class="onoffswitch-label" for="source_transActivation'+ full.rownum +'">';
								html += '<span class="onoffswitch-inner"></span>';
								html += '<span class="onoffswitch-switch"></span></label>';
								html += '</div>';

								return html;
							},
							className : "dt-center",
							defaultContent : ""
							},//서버 상태
			            {data : "pry_svr_nm", defaultContent : ""}, //서버명
			            {data : "ipadr", defaultContent : ""},//서버 IP
			            {data : "use_yn",
		            	render: function (data, type, full){
							var html = "";
							if (full.use_yn == "Y") {
								html += "<div class='badge badge-pill badge-info' style='color: #fff;margin-top:-5px;margin-bottom:-5px;'>";
								html += "<i class='fa fa-spin fa-spinner mr-2'></i>";
								html += "<spring:message code='dbms_information.use' />";
								html += "</div>";
							} else {
								html += "<div class='badge badge-pill badge-danger' style='margin-top:-5px;margin-bottom:-5px;'>";
								html += "<i class='fa fa-times-circle mr-2'></i>";
								html += "<spring:message code='dbms_information.unuse' />";
								html += "</div>";
							}
							return html;
							},
						className : "dt-center",
						defaultContent : "" 	
						},//서버 사용여부
			            {data : "pry_pth", defaultContent : "", visible: false},//haproxy 파일 경로
			            {data : "kal_pth", defaultContent : "", visible: false},//keepalived 파일 경로
			            {data : "master_gbn", defaultContent : "", visible: false},//마스터 구분
			            {data : "master_svr_id", defaultContent : "", visible: false},//마스터 Server ID
						{data : "day_data_del_term", defaultContent : "", visible: false},//일별 데이터 삭제 기간
			            {data : "min_data_del_term", defaultContent : "", visible: false},//분별 데이터 삭제 기간
			            {data : "lst_mdfr_id", defaultContent : "", visible: false},//최종 수정자
			            {data : "lst_mdf_dtm", defaultContent : "", visible: false},//최종 수정일
			            {data : "agt_sn", defaultContent : "", visible: false},//agent 일련번호
			            {data : "pry_svr_id", defaultContent : "", visible: false}//서버 ID
			            ],
			'select': {'style': 'single'}
		});
        /* {data : "cl_con_max_tm", defaultContent : "", visible: false},//클라이언트 연결 최대 시간
        {data : "con_del_tm", defaultContent : "", visible: false},//연결 지연 시간
        {data : "svr_con_max_tm", defaultContent : "", visible: false},//서버 연결 최대 시간
        {data : "chk_tm", defaultContent : "", visible: false},//체크 시간 */
		proxyServerTable.tables().header().to$().find('th:eq(0)').css('min-width', '40px');//checkbox
		proxyServerTable.tables().header().to$().find('th:eq(1)').css('min-width', '60px');//활성화
		proxyServerTable.tables().header().to$().find('th:eq(2)').css('min-width', '100px');//서버명
		proxyServerTable.tables().header().to$().find('th:eq(3)').css('min-width', '100px');//ip
		proxyServerTable.tables().header().to$().find('th:eq(4)').css('min-width', '60px');//사용여부
		proxyServerTable.tables().header().to$().find('th:eq(5)').css('min-width', '0px');//haproxy 파일 경로
		proxyServerTable.tables().header().to$().find('th:eq(6)').css('min-width', '0px');//keepalived 파일 경로
		proxyServerTable.tables().header().to$().find('th:eq(7)').css('min-width', '0px');//마스커 구분
		proxyServerTable.tables().header().to$().find('th:eq(8)').css('min-width', '0px');//마스터 server id 
		proxyServerTable.tables().header().to$().find('th:eq(9)').css('min-width', '0px');//일별데이터삭제기간
		proxyServerTable.tables().header().to$().find('th:eq(10)').css('min-width', '0px');//분별데이터삭제기간
		proxyServerTable.tables().header().to$().find('th:eq(11)').css('min-width', '0px');//최종 수정자
		proxyServerTable.tables().header().to$().find('th:eq(12)').css('min-width', '0px');//최종 수정일
		proxyServerTable.tables().header().to$().find('th:eq(13)').css('min-width', '0px');//agent 일련번호
		proxyServerTable.tables().header().to$().find('th:eq(14)').css('min-width', '0px');//서버 ID
			
		$('#proxyServerTable tbody').on('click','tr',function() {
			//정보 불러오기
		});
		
		
		vipInstTable = $('#vipInstance').DataTable({
			scrollY : "100px",
			scrollX: true,	
			searching : false,
			paging : false,
			deferRender : true,
			bSort: false,
			columns : [ 
			            {data : "rownum", className : "dt-center", defaultContent : ""}, 
			            {data : "state_nm", defaultContent : ""}, //State
			            {data : "obj_ip", defaultContent : ""},//server ip
			            {data : "peer_server_ip", defaultContent : ""},//Peer 서버 IP
			            {data : "v_ip", defaultContent : ""},//가상 IP
			            {data : "if_nm", defaultContent : "", visible: false},//인터페이스명
			            {data : "v_rot_id", defaultContent : "", visible: false},//가상 라우터 id
			            {data : "v_if_nm", defaultContent : "", visible: false},//가상 인터페이스 명
			            {data : "priority", defaultContent : "", visible: false},//우선순위
			            {data : "chk_tm", defaultContent : "", visible: false},//체크 시간
			            {data : "lst_mdfr_id", defaultContent : "", visible: false},//최종 수정자
			            {data : "lst_mdf_dtm", defaultContent : "", visible: false},//최종 수정일
			            {data : "vip_chg_id", defaultContent : "", visible: false},//VIP 설정 ID
			            {data : "proxy_svr_id", defaultContent : "", visible: false},//서버 ID
			            {data : "ipadr", defaultContent : "", visible: false}//서버 IPAddr
			            
			            ]
		});
		
		vipInstTable.tables().header().to$().find('th:eq(0)').css('min-width', '40px');//no
		vipInstTable.tables().header().to$().find('th:eq(1)').css('min-width', '150px');//State
		vipInstTable.tables().header().to$().find('th:eq(2)').css('min-width', '150px');//server ip
		vipInstTable.tables().header().to$().find('th:eq(3)').css('min-width', '60px');//Peer IP
		vipInstTable.tables().header().to$().find('th:eq(4)').css('min-width', '60px');//가상 IP
		vipInstTable.tables().header().to$().find('th:eq(5)').css('min-width', '0px');//인터페이스명
		vipInstTable.tables().header().to$().find('th:eq(6)').css('min-width', '0px');//가상 라우터 id
		vipInstTable.tables().header().to$().find('th:eq(7)').css('min-width', '0px');//가상 인터페이스 명
		vipInstTable.tables().header().to$().find('th:eq(8)').css('min-width', '0px');//우선순위
		vipInstTable.tables().header().to$().find('th:eq(9)').css('min-width', '0px');//체크 시간
		vipInstTable.tables().header().to$().find('th:eq(10)').css('min-width', '0px');//최종 수정자
		vipInstTable.tables().header().to$().find('th:eq(11)').css('min-width', '0px');//최종 수정일
		vipInstTable.tables().header().to$().find('th:eq(12)').css('min-width', '0px');//서버 IPAddr
		
		proxyListenTable = $('#proxyListener').DataTable({
			scrollY : "100px",
			scrollX: true,	
			searching : false,
			paging : false,
			deferRender : true,
			bSort: false,
			columns : [ 
			            {data : "rownum", className : "dt-center", defaultContent : ""}, 
			            {data : "lsn_nm", defaultContent : ""}, //Listen
			            {data : "con_bind_port", defaultContent : ""},//bind
			            {data : "lsn_desc", defaultContent : ""},//설명
			            {data : "db_user_id", defaultContent : "", visible: false},//db 사용자 id
			            {data : "db_id", defaultContent : "", visible: false},//db id
			            {data : "db_nm", defaultContent : "", visible: false},//db 명
			            {data : "con_sim_query", defaultContent : "", visible: false},//전송 쿼리
			            {data : "filed_val", defaultContent : "", visible: false},//필드 값
			            {data : "filed_nm", defaultContent : "", visible: false},//필드 명
			            {data : "lst_mdfr_id", defaultContent : "", visible: false},//최종 수정자
			            {data : "lst_mdf_dtm", defaultContent : "", visible: false},//최종 수정일
			            {data : "ipaddr", defaultContent : "", visible: false},//proxy 서버 ip
			            {data : "proxy_svr_id", defaultContent : "", visible: false},//proxy 서버 ID
			            {data : "lsn_id", defaultContent : "", visible: false}//리스너 ID
			            ]
		});
		
		proxyListenTable.tables().header().to$().find('th:eq(0)').css('min-width', '40px');//no
		proxyListenTable.tables().header().to$().find('th:eq(1)').css('min-width', '150px');//Listen
		proxyListenTable.tables().header().to$().find('th:eq(2)').css('min-width', '150px');//bind
		proxyListenTable.tables().header().to$().find('th:eq(3)').css('min-width', '60px');//설명
		proxyListenTable.tables().header().to$().find('th:eq(4)').css('min-width', '0px');//db 사용자 id
		proxyListenTable.tables().header().to$().find('th:eq(5)').css('min-width', '0px');//db id
		proxyListenTable.tables().header().to$().find('th:eq(6)').css('min-width', '0px');//db 명
		proxyListenTable.tables().header().to$().find('th:eq(7)').css('min-width', '0px');//전송 쿼리
		proxyListenTable.tables().header().to$().find('th:eq(8)').css('min-width', '0px');//필드 값
		proxyListenTable.tables().header().to$().find('th:eq(9)').css('min-width', '0px');//필드 명
		proxyListenTable.tables().header().to$().find('th:eq(10)').css('min-width', '0px');//최종 수정자
		proxyListenTable.tables().header().to$().find('th:eq(11)').css('min-width', '0px');//최종 수정일
		proxyListenTable.tables().header().to$().find('th:eq(12)').css('min-width', '0px');//proxy 서버 ip
		proxyListenTable.tables().header().to$().find('th:eq(13)').css('min-width', '0px');//proxy 서버 id
		proxyListenTable.tables().header().to$().find('th:eq(14)').css('min-width', '0px');//리스너 id
		
		setTimeout(function(){
			if(proxyServerTable != null){
				proxyServerTable.columns.adjust().draw();
			}
			if(vipInstTable != null){
				vipInstTable.columns.adjust().draw();
			}
			if(proxyListenTable != null){
				proxyListenTable.columns.adjust().draw();
			}
		},500);  
	}
	 /* ********************************************************
     * TAB 선택 이벤트 
    ******************************************************** */		
	function selectTab(tab){	
		if(tab == "global"){
			$(".globalSettingDiv").show();
			$(".detailSettingDiv").hide();
			
		}else{
			$(".globalSettingDiv").hide();
			$(".detailSettingDiv").show();
			
			setTimeout(function(){
				if(vipInstTable != null){
					vipInstTable.columns.adjust().draw();
				}
				if(proxyListenTable != null){
					proxyListenTable.columns.adjust().draw();
				}
			},10);  
		}
	}
	
	 /* ********************************************************
     * 화면 초기 셋팅 
    ******************************************************** */		
	$(window.document).ready(function() {
		fn_init();
		
		$.ajax({
			url : "/selectPoxyServerTable.do",
			dataType : "json",
			type : "post",
			beforeSend: function(xhr) {
		        xhr.setRequestHeader("AJAX", true);
		     },
			error : function(xhr, status, error) {
				if(xhr.status == 401) {
					showSwalIconRst('<spring:message code="message.msg02" />', '<spring:message code="common.close" />', '', 'error', 'top');
					top.location.href = "/";
				} else if(xhr.status == 403) {
					showSwalIconRst('<spring:message code="message.msg03" />', '<spring:message code="common.close" />', '', 'error', 'top');
					top.location.href = "/";
				} else {
					showSwalIcon("ERROR CODE : "+ xhr.status+ "\n\n"+ "ERROR Message : "+ error+ "\n\n"+ "Error Detail : "+ xhr.responseText.replace(/(<([^>]+)>)/gi, ""), '<spring:message code="common.close" />', '', 'error');
				}
			},
			success : function(result) {
				proxyServerTable.rows({selected: true}).deselect();
				proxyServerTable.clear().draw();
				
				if (result != null) {
					proxyServerTable.rows.add(result).draw();
				}
			}
		}); 
		/* 
		$.ajax({
			url : "/selectDBSrvAutInfo.do",
			dataType : "json",
			type : "post",
			beforeSend: function(xhr) {
		        xhr.setRequestHeader("AJAX", true);
		     },
			error : function(xhr, status, error) {
				if(xhr.status == 401) {
					showSwalIconRst('<spring:message code="message.msg02" />', '<spring:message code="common.close" />', '', 'error', 'top');
					top.location.href = "/";
				} else if(xhr.status == 403) {
					showSwalIconRst('<spring:message code="message.msg03" />', '<spring:message code="common.close" />', '', 'error', 'top');
					top.location.href = "/";
				} else {
					showSwalIcon("ERROR CODE : "+ xhr.status+ "\n\n"+ "ERROR Message : "+ error+ "\n\n"+ "Error Detail : "+ xhr.responseText.replace(/(<([^>]+)>)/gi, ""), '<spring:message code="common.close" />', '', 'error');
				}
			},
			success : function(result) {	
				svr_server = result;
				fn_dbAutInfo();
			}
		}); */
		
		/* 
		function fn_buttonAut(){
			var db_button = document.getElementById("db_button"); 
			
			if("${wrt_aut_yn}" == "Y"){
				db_button.style.display = '';
			}else{
				db_button.style.display = 'none';
			}
		}
	 */

		function fn_dbAutInfo(){
			$.ajax({
				url : "/selectDBAutInfo.do",
				dataType : "json",
				type : "post",
				beforeSend: function(xhr) {
			        xhr.setRequestHeader("AJAX", true);
			     },
				error : function(xhr, status, error) {
					if(xhr.status == 401) {
						showSwalIconRst('<spring:message code="message.msg02" />', '<spring:message code="common.close" />', '', 'error', 'top');
						top.location.href = "/";
					} else if(xhr.status == 403) {
						showSwalIconRst('<spring:message code="message.msg03" />', '<spring:message code="common.close" />', '', 'error', 'top');
						top.location.href = "/";
					} else {
						showSwalIcon("ERROR CODE : "+ xhr.status+ "\n\n"+ "ERROR Message : "+ error+ "\n\n"+ "Error Detail : "+ xhr.responseText.replace(/(<([^>]+)>)/gi, ""), '<spring:message code="common.close" />', '', 'error');
					}
				},
				success : function(result) {
					db=result;
					fn_dbAut(svr_server, result);
				}
			});
		}

		
 		function fn_dbAut(svr_server, result){
		 	var html2 = "";
		 	html2+='<table class="table">';
			html2+='<colgroup>';
			html2+=	'<col style="width:70%" />';
			html2+=	'<col style="width:30%" />';
			html2+='</colgroup>';
			html2+='<thead>';
			html2+=	'<tr class="bg-info text-white">';
			html2+=		'<th scope="col"><spring:message code="auth_management.db_auth" /> </th>';
			html2+=		'<th scope="col"><spring:message code="auth_management.auth" /></th>';
			html2+=	'</tr>';
			html2+='</thead>';
 			$(svr_server).each(function (index, item) {
				var array = new Array();
				for(var i = 0; i<result.length; i++){
					if(item.db_svr_nm == result[i].db_svr_nm){
						array.push(result[i].db_id);
					}
				}
				
				html2+='<tbody>';
				html2+='<tr class="bg-primary text-white">';
				html2+='		<td>'+item.db_svr_nm+'</td>';
				html2+='		<td><div class="inp_chk"><input type="checkbox" id="'+item.db_svr_id+'" onClick="fn_allCheck(\''+item.db_svr_id+'\', \''+ array+'\');">';
				html2+='		<label for="'+item.db_svr_id+'"></lavel></div></td>';
				html2+='	</tr>';
				
				for(var i = 0; i<result.length; i++){
					if(item.db_svr_nm == result[i].db_svr_nm){
						html2+='	<tr>';
						html2+='		<td class="pl-4">'+result[i].db_nm+'</td>';
						html2+='		<td>';
						html2+='			<div class="inp_chk">';
						html2+='				<input type="checkbox" id="'+result[i].db_svr_id+'_'+result[i].db_id+'" value="'+result[i].db_svr_id+'_'+result[i].db_id+'" name="aut_yn" onClick="fn_userCheck();" />';
						html2+='       		<label for="'+result[i].db_svr_id+'_'+result[i].db_id+'"></label>';
						html2+='			</div>';
						html2+='		</td>';
						html2+='	</tr>';
						html2+='<tr>';
					}
					html2+='<input type="hidden"  name="db_svr_id"  value="'+result[i].db_svr_id+'">';
					html2+='<input type="hidden"  name="db_id"  value="'+result[i].db_id+'">';
				}
				html2+='</tbody>';
	
			})		
			html2+='</table>';
			$( "#dbAutList" ).append(html2);
		}	
	});

	function fn_userCheck(){
		var datas = proxyServerTable.row('.selected').length;
		 if(datas != 1){
			 showSwalIcon('<spring:message code="message.msg165"/>', '<spring:message code="common.close" />', '', 'warning');
			 $("input[type=checkbox]").prop("checked",false);
			 return false;
		 }
	}
	
	function fn_allCheck(db_svr_id,db_id){
		fn_userCheck();
		var strArray = db_id.split(',');
		if ($("#"+db_svr_id).prop("checked")) {
			for(var i=0; i<strArray.length; i++){
				document.getElementById(db_svr_id+'_'+strArray[i]).checked = true;
			}
		}else{
			for(var i=0; i<strArray.length; i++){
				document.getElementById(db_svr_id+'_'+strArray[i]).checked = false;
			}
		}
		
	}
	
	$(function() {
		   $('#user tbody').on( 'click', 'tr', function () {
		         if ( $(this).hasClass('selected') ) {
		        	}
		        else {	        	
		        	proxyServerTable.$('tr.selected').removeClass('selected');
		            $(this).addClass('selected');	            
		        } 

		         var usr_id = proxyServerTable.row('.selected').data().usr_id;
		         
		        
		        /* ********************************************************
		         * 선택된 유저 대한 디비권한 조회
		        ******************************************************** */
 		     	$.ajax({
		    		url : "/selectUsrDBAutInfo.do",
		    		data : {
		    			usr_id: usr_id,			
		    		},
		    		dataType : "json",
		    		type : "post",
					beforeSend: function(xhr) {
				        xhr.setRequestHeader("AJAX", true);
				     },
					error : function(xhr, status, error) {
						if(xhr.status == 401) {
							showSwalIconRst('<spring:message code="message.msg02" />', '<spring:message code="common.close" />', '', 'error', 'top');
						} else if(xhr.status == 403) {
							showSwalIconRst('<spring:message code="message.msg03" />', '<spring:message code="common.close" />', '', 'error', 'top');
						} else {
							showSwalIcon("ERROR CODE : "+ xhr.status+ "\n\n"+ "ERROR Message : "+ error+ "\n\n"+ "Error Detail : "+ xhr.responseText.replace(/(<([^>]+)>)/gi, ""), '<spring:message code="common.close" />', '', 'error');
						}
					},
		    		success : function(result) {
		    			if(result.length != 0){
		       	 		 	for(var i = 0; i<result.length; i++){     	
			  						if(result[i].aut_yn == "Y"){	  									
			  							document.getElementById(result[i].db_svr_id+'_'+result[i].db_id).checked = true;
			  						}else{
			  							document.getElementById(result[i].db_svr_id+'_'+result[i].db_id).checked = false;
			  						}		
		    				}	
		    			}else{
		    				for(var j = 0; j<db.length; j++){ 
		    					document.getElementById(db[j].db_svr_id+'_'+db[j].db_id).checked = false;
		    				}
		    			}	
		    		} 
		    	});	 	 
		    } );   
	} );
	
	/* ********************************************************
	 * confirm result
	 ******************************************************** */
	function fnc_confirmMultiRst(gbn){
		if (gbn == "ins") {
			fn_db_save2();
		}
	}
	
 	function fn_db_save(){
		 var datasArr = new Array();	
		 var datas = proxyServerTable.row('.selected').length;
		 if(datas != 1){
			 showSwalIcon('<spring:message code="message.msg165"/>', '<spring:message code="common.close" />', '', 'warning');
			 return false;
		 }else{
				confile_title = '<spring:message code="menu.database_auth_management" />' + " "+'<spring:message code="common.registory" />' + " " + '<spring:message code="common.request" />';
				$('#con_multi_gbn', '#findConfirmMulti').val("ins");
				$('#confirm_multi_tlt').html(confile_title);
				$('#confirm_multi_msg').html('<spring:message code="message.msg167" />');
				$('#pop_confirm_multi_md').modal("show");
		 }
	}
 	
 	function fn_db_save2(){
		 var datasArr = new Array();	
		 var datas = proxyServerTable.row('.selected').length;
		var usr_id = proxyServerTable.row('.selected').data().usr_id;

			 $('input:checkbox[name=aut_yn]').each(function() {
		         if($(this).is(':checked')){
		        	var value=$(this).val();
	 			    var strArray = value.split('_');
	 			    var datas = new Object();
	 			    datas.usr_id = usr_id;
	 			    datas.db_svr_id = strArray[0];
	 	 			datas.db_id = strArray[1];
	 	 			datas.aut_yn = "Y";
		         }else{
			        var value=$(this).val();
		 			var strArray = value.split('_');
		 			var datas = new Object();
		 			datas.usr_id = usr_id;
		 			datas.db_svr_id = strArray[0];
		 	 		datas.db_id = strArray[1];
		 	 		datas.aut_yn = "N";
		         }
		         datasArr.push(datas);
		     });


				$.ajax({
					url : "/updateUsrDBAutInfo.do",
					data : {
						datasArr : JSON.stringify(datasArr)
					},
					type : "post",
					beforeSend: function(xhr) {
				        xhr.setRequestHeader("AJAX", true);
				     },
					error : function(xhr, status, error) {
						if(xhr.status == 401) {
							showSwalIconRst('<spring:message code="message.msg02" />', '<spring:message code="common.close" />', '', 'error', 'top');
						} else if(xhr.status == 403) {
							showSwalIconRst('<spring:message code="message.msg03" />', '<spring:message code="common.close" />', '', 'error', 'top');
						} else {
							showSwalIcon("ERROR CODE : "+ xhr.status+ "\n\n"+ "ERROR Message : "+ error+ "\n\n"+ "Error Detail : "+ xhr.responseText.replace(/(<([^>]+)>)/gi, ""), '<spring:message code="common.close" />', '', 'error');
						}
					},
					success : function(result) {
						showSwalIcon('<spring:message code="message.msg07"/>', '<spring:message code="common.close" />', '', 'success');
					}
				}); 	
			
	}
	
 	//유저조회버튼 클릭시
 	function fn_search(){
 		$.ajax({
 			url : "/selectMenuAutUserManager.do",
 			data : {
 				type : "usr_id",
 				search : "%" + $("#search").val() + "%",
 			},
 			dataType : "json",
 			type : "post",
			beforeSend: function(xhr) {
		        xhr.setRequestHeader("AJAX", true);
		     },
			error : function(xhr, status, error) {
				if(xhr.status == 401) {
					showSwalIconRst('<spring:message code="message.msg02" />', '<spring:message code="common.close" />', '', 'error', 'top');
				} else if(xhr.status == 403) {
					showSwalIconRst('<spring:message code="message.msg03" />', '<spring:message code="common.close" />', '', 'error', 'top');
				} else {
					showSwalIcon("ERROR CODE : "+ xhr.status+ "\n\n"+ "ERROR Message : "+ error+ "\n\n"+ "Error Detail : "+ xhr.responseText.replace(/(<([^>]+)>)/gi, ""), '<spring:message code="common.close" />', '', 'error');
				}
			},
 			success : function(result) {
 				proxyServerTable.clear().draw();
 				proxyServerTable.rows.add(result).draw();
 			}
 		});
 	} 	
 	
 	function fn_proxy_insert(){
 		var selectDbList = "";
		$.ajax({
			url : "/popup/proxySvrRegForm.do",
			data : {},
			dataType : "json",
			type : "post",
			beforeSend: function(xhr) {
				xhr.setRequestHeader("AJAX", true);
			},
			error : function(xhr, status, error) {
				if(xhr.status == 401) {
					showSwalIconRst('<spring:message code="message.msg02" />', '<spring:message code="common.close" />', '', 'error', 'top');
				} else if(xhr.status == 403) {
					showSwalIconRst('<spring:message code="message.msg03" />', '<spring:message code="common.close" />', '', 'error', 'top');
				} else {
					showSwalIcon("ERROR CODE : "+ xhr.status+ "\n\n"+ "ERROR Message : "+ error+ "\n\n"+ "Error Detail : "+ xhr.responseText.replace(/(<([^>]+)>)/gi, ""), '<spring:message code="common.close" />', '', 'error');
				}
			},
			success : function(result) {
				//초기화
				fn_insert_svr_info("reg");

				if (result != null) {
					//update setting
					fn_update_svr_info("reg", result);
				}
				
				$('#pop_layer_svr_reg').modal("show");
			}
		});
 	}
 	
 	/* ********************************************************
	 * 등록 팝업 초기화
	 ******************************************************** */
	function fn_insert_svr_info(gbn) {
		if (gbn == "reg") {
			
			$("#ins_ipadr", "#insProxyServerForm").val(""); //ipaddr
			$("#ins_proxy_svr_nm", "#insProxyServerForm").val(""); //서버명
			
			$("#ins_root_pwd", "#insProxyServerForm").val(""); //패스워드
			$("#ins_root_pwdChk", "#insProxyServerForm").val(""); //패스워드체크
			
			$("#ins_proxy_pth", "#insProxyServerForm").val("/etc/haproxy/haproxy.cfg"); //haproxy.cfg 파일 경올
			$("#ins_keepalived_pth", "#insProxyServerForm").val("/etc/keepalived/keepalived.conf"); //keepalived.conf 파일 경로
			
			$("#ins_day_data_del_term", "#insProxyServerForm").val("90"); //일별 데이터 보관 기간
			$("#ins_min_data_del_term", "#insProxyServerForm").val("7"); //분별 데이터 보관 기간
			
			$("#ins_master_gbn", "#insProxyServerForm").val("TC001502"); //마스터 구분
			$("#ins_use_yn", "#insProxyServerForm").val("N"); //사용유무
			$("input:checkbox[id='ins_use_yn_chk']").prop("checked", false); 
			
			//$("#pwdCheck_alert-danger", "#insProxyServerForm").hide(); //패스워드 체크
			//$("#idCheck_alert-danger", "#insProxyServerForm").hide(); //id 체크
			//$("#ins_pwd_alert-danger", "#insProxyServerForm").html("");
			//$("#ins_pwd_alert-danger", "#insProxyServerForm").hide();
			//$("#ins_pwd_alert-light", "#insProxyServerForm").html("");
			//$("#ins_pwd_alert-light", "#insProxyServerForm").hide();
						
			$("#ins_save_submit", "#insProxyServerForm").removeAttr("disabled");
			$("#ins_save_submit", "#insProxyServerForm").removeAttr("readonly");
		} else {
			$("#mod_usr_id", "#modUserForm").val(""); //아이디
			$("#mod_usr_nm", "#modUserForm").val(""); //이름
			
			$("#mod_pwdCheck", "#modUserForm").val(""); //패스워드체크
			$("#mod_pwd", "#modUserForm").val(""); //패스워드
			
			$("#mod_pwdCheck_alert-danger", "#modUserForm").hide(); //패스워드 체크
			$("#mod_pwd_alert-danger", "#modUserForm").html("");
			$("#mod_pwd_alert-danger", "#modUserForm").hide();
			$("#mod_pwd_alert-light", "#modUserForm").html("");
			$("#mod_pwd_alert-light", "#modUserForm").hide();
			
			$("#mod_bln_nm", "#modUserForm").val(""); //소속
			$("#mod_dept_nm", "#modUserForm").val(""); //부서
			$("#mod_pst_nm", "#modUserForm").val(""); //직급
			$("#mod_rsp_bsn_nm", "#modUserForm").val(""); //담당업무
			$("#mod_cpn", "#modUserForm").val(""); //휴대폰번호
			
			$("#mod_use_yn", "#modUserForm").val("Y"); //사용여부
			$("input:checkbox[id='mod_use_yn_chk']").prop("checked", true); 
			
			$("#mod_usr_expr_dt", "#modUserForm").val(""); //사용만료일
			
			$("#mod_encp_use_yn", "#modUserForm").val("Y"); //암호화사용여부
			$("input:checkbox[id='mod_encp_use_yn_chk']").prop("checked", true); 
			
			$("#mod_save_submit", "#modUserForm").removeAttr("disabled");
			$("#mod_save_submit", "#modUserForm").removeAttr("readonly");

			$("#mod_passCheck_cho", "#modUserForm").val("");
			$("#mod_passCheck_hid", "#modUserForm").val("0");
		}
	}
	
	/* ********************************************************
	 * 수정 팝업셋팅
	 ******************************************************** */
	function fn_update_svr_info(gbn, result) {
		if (gbn == "mod") {
			$("#mod_usr_id", "#modUserForm").val(nvlPrmSet(result.get_usr_id, "")); //아이디
			$("#mod_usr_nm", "#modUserForm").val(nvlPrmSet(result.get_usr_nm, "")); //이름

			$("#mod_pwd", "#modUserForm").val(nvlPrmSet(result.pwd, ""));
			$("#mod_pwdCheck", "#modUserForm").val(nvlPrmSet(result.pwd, ""));
			$("#mod_passCheck_cho", "#modUserForm").val(nvlPrmSet(result.pwd, ""));
			
			//password 안전성 확인
			$("#mod_pwd_chk_msg_div", "#modUserForm").show();
			$("#mod_pwd_chk_div", "#modUserForm").hide();
			
			$("#mod_bln_nm", "#modUserForm").val(nvlPrmSet(result.bln_nm, "")); //소속
			$("#mod_dept_nm", "#modUserForm").val(nvlPrmSet(result.dept_nm, "")); //부서
			$("#mod_pst_nm", "#modUserForm").val(nvlPrmSet(result.pst_nm, "")); //직급
			$("#mod_rsp_bsn_nm", "#modUserForm").val(nvlPrmSet(result.rsp_bsn_nm, "")); //담당업무
			$("#mod_cpn", "#modUserForm").val(nvlPrmSet(result.cpn, "")); //휴대폰번호
			
			$("#mod_use_yn", "#modUserForm").val(nvlPrmSet(result.use_yn, "")); //사용여부
			if (nvlPrmSet(result.use_yn, "") == "Y") {
				$("input:checkbox[id='mod_use_yn_chk']").prop("checked", true); 
			} else {
				$("input:checkbox[id='mod_use_yn_chk']").prop("checked", false); 
			}
			
			$("#mod_usr_expr_dt", "#modUserForm").val(nvlPrmSet(result.usr_expr_dt, "")); //사용만료일

			//datapicker 설정
			fn_modDateUpdateSetting(nvlPrmSet(result.usr_expr_dt, ""));
			
			$("#mod_encp_use_yn", "#modUserForm").val(nvlPrmSet(result.encp_use_yn, "")); //암호화사용여부

			if (nvlPrmSet(result.encp_use_yn, "") == "Y") {
				$("input:checkbox[id='mod_encp_use_yn_chk']").prop("checked", true); 
			} else {
				$("input:checkbox[id='mod_encp_use_yn_chk']").prop("checked", false); 
			}

			//암호화 여부가 n일때는 check box disabled
			if (nvlPrmSet(result.encp_yn, "") == "Y") {
				$("input:checkbox[id='mod_encp_use_yn_chk']").prop("disabled", false); 
				$("#mod_encp_use_yn_msg", "#modUserForm").html('');
			} else {
				$("input:checkbox[id='mod_encp_use_yn_chk']").prop("disabled", true); 
				$("#mod_encp_use_yn_msg", "#modUserForm").html('<spring:message code="user_management.msg15" />');
			}

			$("#mod_passCheck_hid", "#modUserForm").val("1");
		} else {
			//암호화 여부가 n일때는 check box disabled
			if (nvlPrmSet(result.encp_yn, "") == "Y") {
				$("input:checkbox[id='ins_encp_use_yn_chk']").prop("disabled", false);
				$("#ins_encp_use_yn_msg", "#insProxyServerForm").html('');
				
				$("#ins_encp_use_yn", "#insProxyServerForm").val("Y"); //암호화사용여부
				$("input:checkbox[id='ins_encp_use_yn_chk']").prop("checked", true); 
			} else {
				$("input:checkbox[id='ins_encp_use_yn_chk']").prop("disabled", true); 
				$("#ins_encp_use_yn_msg", "#insProxyServerForm").html('<spring:message code="user_management.msg15" />');

				$("#ins_encp_use_yn", "#insProxyServerForm").val("N"); //암호화사용여부
				$("input:checkbox[id='ins_encp_use_yn_chk']").prop("checked", false); 
				
			}	
		}

	}
 	/* ********************************************************
	 * 상세설정 접기
	 ******************************************************** */
/*	function clickDetailConf(id){
		if($("#titleDetailConf_div").css('display') == 'none'){
			$("#titleDetailConf_div").css('display','block');
			$("#" + id).attr('class', 'menu-arrow_user');
		}else{
			$("#titleDetailConf_div").css('display','none');
			$("#" + id).attr('class', 'menu-arrow_user_af');
		}
	}
	 */
	/* ********************************************************
	 * Vip Instance 관리 팝업
	 ******************************************************** */
	function fn_proxy_instance_insert(){
 		var selectDbList = "";
		$.ajax({
			url : "/popup/vipInstanceRegForm.do",
			data : {},
			dataType : "json",
			type : "post",
			beforeSend: function(xhr) {
				xhr.setRequestHeader("AJAX", true);
			},
			error : function(xhr, status, error) {
				if(xhr.status == 401) {
					showSwalIconRst('<spring:message code="message.msg02" />', '<spring:message code="common.close" />', '', 'error', 'top');
				} else if(xhr.status == 403) {
					showSwalIconRst('<spring:message code="message.msg03" />', '<spring:message code="common.close" />', '', 'error', 'top');
				} else {
					showSwalIcon("ERROR CODE : "+ xhr.status+ "\n\n"+ "ERROR Message : "+ error+ "\n\n"+ "Error Detail : "+ xhr.responseText.replace(/(<([^>]+)>)/gi, ""), '<spring:message code="common.close" />', '', 'error');
				}
			},
			success : function(result) {
				//초기화
				fn_insert_proxy_instance("reg");

				if (result != null) {
					//update setting
					fn_update_svr_info("reg", result);
				}
				
				$('#pop_layer_proxy_inst_reg').modal("show");
			}
		});
 	}
 	
 	/* ********************************************************
	 * Vip Instance 등록 화면
	 ******************************************************** */
	function fn_insert_proxy_instance(gbn) {
		if (gbn == "reg") {
			
			$("#ins_ipadr", "#insVipInstForm").val(""); //ipaddr
			$("#ins_proxy_svr_nm", "#insVipInstForm").val(""); //서버명
			
			$("#ins_root_pwd", "#insVipInstForm").val(""); //패스워드
			$("#ins_root_pwdChk", "#insVipInstForm").val(""); //패스워드체크
			
			$("#ins_proxy_pth", "#insVipInstForm").val("/etc/haproxy/haproxy.cfg"); //haproxy.cfg 파일 경올
			$("#ins_keepalived_pth", "#insVipInstForm").val("/etc/keepalived/keepalived.conf"); //keepalived.conf 파일 경로
			
			$("#ins_day_data_del_term", "#insVipInstForm").val("90"); //일별 데이터 보관 기간
			$("#ins_min_data_del_term", "#insVipInstForm").val("7"); //분별 데이터 보관 기간
			
			$("#ins_master_gbn", "#insVipInstForm").val("TC001502"); //마스터 구분
			$("#ins_use_yn", "#insVipInstForm").val("N"); //사용유무
			$("input:checkbox[id='ins_use_yn_chk']").prop("checked", false); 
			
			//$("#pwdCheck_alert-danger", "#insVipInstForm").hide(); //패스워드 체크
			//$("#idCheck_alert-danger", "#insVipInstForm").hide(); //id 체크
			//$("#ins_pwd_alert-danger", "#insVipInstForm").html("");
			//$("#ins_pwd_alert-danger", "#insVipInstForm").hide();
			//$("#ins_pwd_alert-light", "#insVipInstForm").html("");
			//$("#ins_pwd_alert-light", "#insVipInstForm").hide();
						
			$("#ins_save_submit", "#insVipInstForm").removeAttr("disabled");
			$("#ins_save_submit", "#insVipInstForm").removeAttr("readonly");
		} else {
			$("#mod_usr_id", "#modUserForm").val(""); //아이디
			$("#mod_usr_nm", "#modUserForm").val(""); //이름
			
			$("#mod_pwdCheck", "#modUserForm").val(""); //패스워드체크
			$("#mod_pwd", "#modUserForm").val(""); //패스워드
			
			$("#mod_pwdCheck_alert-danger", "#modUserForm").hide(); //패스워드 체크
			$("#mod_pwd_alert-danger", "#modUserForm").html("");
			$("#mod_pwd_alert-danger", "#modUserForm").hide();
			$("#mod_pwd_alert-light", "#modUserForm").html("");
			$("#mod_pwd_alert-light", "#modUserForm").hide();
			
			$("#mod_bln_nm", "#modUserForm").val(""); //소속
			$("#mod_dept_nm", "#modUserForm").val(""); //부서
			$("#mod_pst_nm", "#modUserForm").val(""); //직급
			$("#mod_rsp_bsn_nm", "#modUserForm").val(""); //담당업무
			$("#mod_cpn", "#modUserForm").val(""); //휴대폰번호
			
			$("#mod_use_yn", "#modUserForm").val("Y"); //사용여부
			$("input:checkbox[id='mod_use_yn_chk']").prop("checked", true); 
			
			$("#mod_usr_expr_dt", "#modUserForm").val(""); //사용만료일
			
			$("#mod_encp_use_yn", "#modUserForm").val("Y"); //암호화사용여부
			$("input:checkbox[id='mod_encp_use_yn_chk']").prop("checked", true); 
			
			$("#mod_save_submit", "#modUserForm").removeAttr("disabled");
			$("#mod_save_submit", "#modUserForm").removeAttr("readonly");

			$("#mod_passCheck_cho", "#modUserForm").val("");
			$("#mod_passCheck_hid", "#modUserForm").val("0");
		}
	}
 	
	/* ********************************************************
	 * Vip Listener 관리 팝업
	 ******************************************************** */
	function fn_proxy_listener_insert(){
 		var selectDbList = "";
		$.ajax({
			url : "/popup/proxyListenRegForm.do",
			data : {},
			dataType : "json",
			type : "post",
			beforeSend: function(xhr) {
				xhr.setRequestHeader("AJAX", true);
			},
			error : function(xhr, status, error) {
				if(xhr.status == 401) {
					showSwalIconRst('<spring:message code="message.msg02" />', '<spring:message code="common.close" />', '', 'error', 'top');
				} else if(xhr.status == 403) {
					showSwalIconRst('<spring:message code="message.msg03" />', '<spring:message code="common.close" />', '', 'error', 'top');
				} else {
					showSwalIcon("ERROR CODE : "+ xhr.status+ "\n\n"+ "ERROR Message : "+ error+ "\n\n"+ "Error Detail : "+ xhr.responseText.replace(/(<([^>]+)>)/gi, ""), '<spring:message code="common.close" />', '', 'error');
				}
			},
			success : function(result) {
				//초기화
				fn_insert_proxy_listen("reg");

				if (result != null) {
					//update setting
					fn_update_svr_info("reg", result);
				}
				
				$('#pop_layer_proxy_listen_reg').modal("show");
			}
		});
 	}
 	
 	/* ********************************************************
	 * Vip Listen 등록 화면 초기화
	 ******************************************************** */
	function fn_insert_proxy_listen(gbn) {
		if (gbn == "reg") {
			
			$("#ins_ipadr", "#insProxyListenForm").val(""); //ipaddr
			$("#ins_proxy_svr_nm", "#insProxyListenForm").val(""); //서버명
			
			$("#ins_root_pwd", "#insProxyListenForm").val(""); //패스워드
			$("#ins_root_pwdChk", "#insProxyListenForm").val(""); //패스워드체크
			
			$("#ins_proxy_pth", "#insProxyListenForm").val("/etc/haproxy/haproxy.cfg"); //haproxy.cfg 파일 경올
			$("#ins_keepalived_pth", "#insProxyListenForm").val("/etc/keepalived/keepalived.conf"); //keepalived.conf 파일 경로
			
			$("#ins_day_data_del_term", "#insProxyListenForm").val("90"); //일별 데이터 보관 기간
			$("#ins_min_data_del_term", "#insProxyListenForm").val("7"); //분별 데이터 보관 기간
			
			$("#ins_master_gbn", "#insProxyListenForm").val("TC001502"); //마스터 구분
			$("#ins_use_yn", "#insProxyListenForm").val("N"); //사용유무
			$("input:checkbox[id='ins_use_yn_chk']").prop("checked", false); 
			
			//$("#pwdCheck_alert-danger", "#insProxyListenForm").hide(); //패스워드 체크
			//$("#idCheck_alert-danger", "#insProxyListenForm").hide(); //id 체크
			//$("#ins_pwd_alert-danger", "#insProxyListenForm").html("");
			//$("#ins_pwd_alert-danger", "#insProxyListenForm").hide();
			//$("#ins_pwd_alert-light", "#insProxyListenForm").html("");
			//$("#ins_pwd_alert-light", "#insProxyListenForm").hide();
						
			$("#ins_save_submit", "#insProxyListenForm").removeAttr("disabled");
			$("#ins_save_submit", "#insProxyListenForm").removeAttr("readonly");
		} else {
			$("#mod_usr_id", "#modUserForm").val(""); //아이디
			$("#mod_usr_nm", "#modUserForm").val(""); //이름
			
			$("#mod_pwdCheck", "#modUserForm").val(""); //패스워드체크
			$("#mod_pwd", "#modUserForm").val(""); //패스워드
			
			$("#mod_pwdCheck_alert-danger", "#modUserForm").hide(); //패스워드 체크
			$("#mod_pwd_alert-danger", "#modUserForm").html("");
			$("#mod_pwd_alert-danger", "#modUserForm").hide();
			$("#mod_pwd_alert-light", "#modUserForm").html("");
			$("#mod_pwd_alert-light", "#modUserForm").hide();
			
			$("#mod_bln_nm", "#modUserForm").val(""); //소속
			$("#mod_dept_nm", "#modUserForm").val(""); //부서
			$("#mod_pst_nm", "#modUserForm").val(""); //직급
			$("#mod_rsp_bsn_nm", "#modUserForm").val(""); //담당업무
			$("#mod_cpn", "#modUserForm").val(""); //휴대폰번호
			
			$("#mod_use_yn", "#modUserForm").val("Y"); //사용여부
			$("input:checkbox[id='mod_use_yn_chk']").prop("checked", true); 
			
			$("#mod_usr_expr_dt", "#modUserForm").val(""); //사용만료일
			
			$("#mod_encp_use_yn", "#modUserForm").val("Y"); //암호화사용여부
			$("input:checkbox[id='mod_encp_use_yn_chk']").prop("checked", true); 
			
			$("#mod_save_submit", "#modUserForm").removeAttr("disabled");
			$("#mod_save_submit", "#modUserForm").removeAttr("readonly");

			$("#mod_passCheck_cho", "#modUserForm").val("");
			$("#mod_passCheck_hid", "#modUserForm").val("0");
		}
	}
	
	
</script>
<body>
<%@include file="./../popup/proxyServerRegForm.jsp"%>
<%@include file="./../popup/vipInstRegForm.jsp"%>
<%@include file="./../popup/proxyListenRegForm.jsp"%>
<div class="content-wrapper main_scroll" id="contentsDiv">
	<div class="row">
		<div class="col-12 div-form-margin-srn stretch-card">
			<div class="card">
				<div class="card-body">
					<!-- title start -->
					<div class="accordion_main accordion-multi-colored" id="accordion" role="tablist">
						<div class="card" style="margin-bottom:0px;">
							<div class="card-header" role="tab" id="page_header_div">
								<div class="row">
									<div class="col-5" style="padding-top:3px;">
										<h6 class="mb-0">
											<a data-toggle="collapse" href="#page_header_sub" aria-expanded="false" aria-controls="page_header_sub" onclick="fn_profileChk('titleText')">
												<i class="ti-desktop menu-icon"></i>
												<span class="menu-title"><spring:message code="menu.proxy_config" /></span>
												<i class="menu-arrow_user" id="titleText" ></i>
											</a>
										</h6>
									</div>
									<div class="col-7">
					 					<ol class="mb-0 breadcrumb_main justify-content-end bg-info" >
					 						<li class="breadcrumb-item_main" style="font-size: 0.875rem;">Proxy</li>
					 						<li class="breadcrumb-item_main" style="font-size: 0.875rem;" aria-current="page"><spring:message code="encrypt_policyOption.Settings" /></li>
											<li class="breadcrumb-item_main active" style="font-size: 0.875rem;" aria-current="page"><spring:message code="menu.proxy_config"/></li>
										</ol>
									</div>
								</div>
							</div>
							<div id="page_header_sub" class="collapse" role="tabpanel" aria-labelledby="page_header_div" data-parent="#accordion">
								<div class="card-body">
									<div class="row">
										<div class="col-12">
											<p class="mb-0">
												<spring:message code="help.proxy_settings" />
											</p>
										</div>
									</div>
								</div>
							</div>
						</div>
					</div>
					<!-- title end -->
				</div>
			</div>
		</div>

		<div class="col-lg-5 grid-margin stretch-card">
			<div class="card">
				<div class="card-body" style=" height: 100%;">
					<h4 class="card-title">
						<i class="item-icon fa fa-dot-circle-o"></i>
						<spring:message code="eXperDB_proxy.server_mgt" />
					</h4>
					
					<div class="row" >
						<div class="col-12">
							<div class="template-demo">	
								<form class="form-inline" style="float: right;">
									<input hidden="hidden" />
									<input type="text" class="form-control" style="width:250px;" id="search">
									&nbsp;&nbsp;
									<button type="button" class="btn btn-inverse-primary btn-icon-text btn-search-disable" onClick="fn_search()">
										<i class="ti-search btn-icon-prepend "></i><spring:message code="button.search" />
									</button>
								</form>
							</div>
						</div>
					</div>
					<div class="row">
						<div class="col-12">
							<div class="template-demo">			
								<button type="button" class="btn btn-outline-primary btn-icon-text float-right" id="btnDelete" onClick="fn_proxy_del_confirm();" >
									<i class="ti-trash btn-icon-prepend "></i><spring:message code="common.delete" />
								</button>
								<button type="button" class="btn btn-outline-primary btn-icon-text float-right" id="btnUpdate" onClick="fn_proxy_update();" data-toggle="modal">
									<i class="ti-pencil-alt btn-icon-prepend "></i><spring:message code="common.modify" />
								</button>
								<button type="button" class="btn btn-outline-primary btn-icon-text float-right" id="btnInsert" onClick="fn_proxy_insert();" data-toggle="modal">
									<i class="ti-pencil btn-icon-prepend "></i><spring:message code="common.registory" />
								</button>
							</div>
						</div>
					</div>
					<table id="proxyServer" class="table table-hover table-striped" style="width:100%;">
						<thead>
							<tr class="bg-info text-white">
								<th width="40"><spring:message code="common.no"/></th>
								<th width="60">활성화</th>
								<th width="100">서버명</th>
								<th width="100">IP주소</th>
								<th width="60">상태</th>
								<th width="0">haproxy 파일 경로</th>
								<th width="0">keepalived 파일 경로</th>
								<th width="0">마스터 구분</th>
								<th width="0">마스터 server id</th>
								<th width="0">일별데이터삭제기간</th>
								<th width="0">분별데이터삭제기간</th>
								<th width="0">최종 수정자</th>
								<th width="0">최종 수정일</th>
								<th width="0">agent 일련번호</th>
								<th width="0">서버 id</th>
							</tr>
						</thead>
					</table>
				</div>
			</div>
		</div>
            
		<div class="col-lg-7 grid-margin stretch-card">
			<div class="card">
				<div class="card-body">
					<div class="table-responsive" style="overflow:hidden;">
						<div id="wrt_button" style="float: right;">
							<button type="button" class="btn btn-inverse-primary btn-icon-text mb-2 btn-search-disable" id="db_button" onClick="fn_db_save()">
								<i class="ti-control-play btn-icon-prepend "></i>적용
							</button>
						</div>
						<h4 class="card-title">
							<i class="item-icon fa fa-dot-circle-o"></i>
							<spring:message code="menu.proxy_config" />
						</h4>
					</div>
				    <ul class="nav nav-pills nav-pills-setting nav-justified" id="server-tab" role="tablist" style="border:none;">
						<li class="nav-item">
							<a class="nav-link active" id="server-tab-1" data-toggle="pill" href="#subTab-1" role="tab" aria-controls="subTab-1" aria-selected="true" onclick="javascript:selectTab('global');" >
								Global 설정
							</a>
						</li>
						<li class="nav-item">
							<a class="nav-link" id="server-tab-2" data-toggle="pill" href="#subTab-2" role="tab" aria-controls="subTab-2" aria-selected="false" onclick="javascript:selectTab('detail');">
								Proxy & VIP 설정
							</a>
						</li>
					</ul>
					<div class="card globalSettingDiv" style="display:block;">
						<div class="card-body card-body-border">
							<div class="form-group row">
								<label for="ins_obj_ip" class="col-sm-2_5 col-form-label pop-label-index">
									<i class="item-icon fa fa-angle-double-right"></i>	
									<%-- <spring:message code="user_management.password" /> --%>
									Server IP
								</label>
								<div class="col-sm-2_27">
									<input type="text" class="form-control form-control-sm ins_obj_ip" maxlength="15" id="ins_obj_ip" name="ins_obj_ip" onkeyup="fn_checkWord(this,20)" onblur="this.value=this.value.trim()" placeholder="" />
								</div>
								<label for="ins_if_nm" class="col-sm-2_5 col-form-label pop-label-index">
									<i class="item-icon fa fa-angle-double-right"></i>	
									<%-- <spring:message code="user_management.password" /> --%>
									Interface
								</label>
								<div class="col-sm-2_27">
									<input type="text" class="form-control form-control-sm ins_if_nm" maxlength="20" id="ins_if_nm" name="ins_if_nm" onkeyup="fn_checkWord(this,20)" onblur="this.value=this.value.trim()" placeholder="" />
								</div>
							</div>
							<div class="form-group row">
								<label for="ins_peer_server_ip" class="col-sm-2_5 col-form-label pop-label-index">
									<i class="item-icon fa fa-angle-double-right"></i>	
									<%-- <spring:message code="user_management.password" /> --%>
									Peer IP
								</label>
								<div class="col-sm-2_27">
									<input type="text" class="form-control form-control-sm ins_peer_server_ip" maxlength="15" id="ins_peer_server_ip" name="ins_peer_server_ip" onkeyup="fn_checkWord(this,20)" onblur="this.value=this.value.trim()" placeholder="" />
								</div>
								<div class="col-sm-6">
								</div>
							</div>
							<div class="form-group row">
								<label for="ins_max_con_cnt" class="col-sm-2_5 col-form-label pop-label-index">
									<i class="item-icon fa fa-angle-double-right"></i>	
									동시 접속 최대 수
								</label>
								<div class="col-sm-2">
									<input type="text" class="form-control form-control-sm ins_max_con_cnt" maxlength="10" id="ins_max_con_cnt" name="ins_max_con_cnt" onkeyup="fn_checkWord(this,20)" onblur="this.value=this.value.trim()" placeholder="" />
								</div>
								<div class="col-sm-auto">
								</div>
							</div>
							<div class="form-group row" style="margin-bottom:-5px;">
								<label for="ins_cl_con_max_tm_num" class="col-sm-12 col-form-label pop-label-index">
									<i class="item-icon fa fa-angle-double-right"></i>	
									<%-- <spring:message code="user_management.password" /> --%>
									Timeout 설정
								</label>
							</div>
							<div class="form-group row" style="margin-bottom: 0px !important;">
								<label for="ins_cl_con_max_tm_num" class="col-sm-3 col-form-label pop-label-index">
									클라이언트 연결 최대 시간
								</label>
								<div class="col-sm-1_5">
									<input type="text" class="form-control form-control-sm ins_cl_con_max_tm_num" maxlength="5" id="ins_cl_con_max_tm_num" name="ins_cl_con_max_tm_num" onkeyup="fn_checkWord(this,20)" onblur="this.value=this.value.trim()" placeholder="" />
								</div>
								<div class="col-sm-1_5">
									<select class="form-control form-control-sm" name="ins_cl_con_max_tm_tm" id="ins_cl_con_max_tm_tm">
										<option value="s">초</option>
										<option value="m">분</option>
									</select>
								</div>
								<label for="ins_con_del_tm_num" class="col-sm-3 col-form-label pop-label-index">
									연결 지연 최대 시간
								</label>
								<div class="col-sm-1_5">
									<input type="text" class="form-control form-control-sm ins_con_del_tm_num" maxlength="5" id="ins_con_del_tm_num" name="ins_con_del_tm_num" onkeyup="fn_checkWord(this,20)" onblur="this.value=this.value.trim()" placeholder="" />
								</div>
								<div class="col-sm-1_5">
									<select class="form-control form-control-sm" name="ins_con_del_tm_tm" id="ins_con_del_tm_tm">
										<option value="s">초</option>
										<option value="m">분</option>
									</select>
								</div>
							</div>
							<div class="form-group row" style="margin-bottom:-17px !important;">
								<label for="ins_svr_con_max_tm_num" class="col-sm-3 col-form-label pop-label-index">
									서버 연결 최대 시간
								</label>
								<div class="col-sm-1_5">
									<input type="text" class="form-control form-control-sm ins_svr_con_max_tm_num" maxlength="5" id="ins_svr_con_max_tm_num" name="ins_svr_con_max_tm_num" onkeyup="fn_checkWord(this,20)" onblur="this.value=this.value.trim()" placeholder="" />
								</div>
								<div class="col-sm-1_5">
									<select class="form-control form-control-sm" name="ins_svr_con_max_tm_tm" id="ins_svr_con_max_tm_tm">
										<option value="s">초</option>
										<option value="m">분</option>
									</select>
								</div>
								<label for="ins_chk_tm_num" class="col-sm-3 col-form-label pop-label-index">
									체크 주기
								</label>
								<div class="col-sm-1_5">
									<input type="text" class="form-control form-control-sm ins_chk_tm_num" maxlength="5" id="ins_chk_tm_num" name="ins_chk_tm_num" onkeyup="fn_checkWord(this,20)" onblur="this.value=this.value.trim()" placeholder="" />
								</div>
								<div class="col-sm-1_5">
									<select class="form-control form-control-sm" name="ins_chk_tm_tm" id="ins_chk_tm_tm">
										<option value="s">초</option>
										<option value="m">분</option>
									</select>
								</div>
							</div>
						</div>
					</div>
					
					<div class="card detailSettingDiv" style="display:none;">
						<div class="card-body card-body-border">
							<div class="table-responsive">
								<button type="button" class="icon_btn btn-outline-primary btn-icon-text float-right" id="btnDelete" onClick="fn_proxy_del_confirm();" >
									<i class="ti-trash btn-icon-prepend "></i>
								</button>
								<button type="button" class="icon_btn btn-outline-primary btn-icon-text float-right" id="btnUpdate" onClick="fn_proxy_update();" data-toggle="modal">
									<i class="ti-pencil-alt btn-icon-prepend "></i>
								</button>
								<button type="button" class="icon_btn btn-outline-primary btn-icon-text float-right" id="btnInsert" onClick="fn_proxy_instance_insert();" data-toggle="modal">
									<i class="ti-pencil btn-icon-prepend "></i>
								</button>
								<h4 class="card-title">
									<i class="item-icon fa fa-dot-circle-o"></i>
									<spring:message code="eXperDB_proxy.instance_mgmt" />
								</h4>
							</div>
							<table id="vipInstance" class="table table-hover table-striped" style="width:100%;">
								<thead>
									<tr class="bg-info text-white">
										<th width="40"><spring:message code="common.no"/></th>
										<th width="90">State</th>
										<th width="150">Server IP</th>
										<th width="150">Peer IP</th>
										<th width="150">가상 IP</th>
										<th width="0">인터페이스</th>
										<th width="0">가상 라우터 id</th>
										<th width="0">가상 인터페이스 명</th>
										<th width="0">우선순위</th>
										<th width="0">체크시간</th>
										<th width="0">최종 수정자</th>
										<th width="0">최종 수정일</th>
									</tr>
								</thead>
							</table>
						</div>
					</div>
					<br/>
					<div class="card detailSettingDiv" style="display:none;">
						<div class="card-body card-body-border">
							<div class="table-responsive">
								<button type="button" class="icon_btn btn-outline-primary btn-icon-text float-right" id="btnDelete" onClick="fn_proxy_del_confirm();" >
									<i class="ti-trash btn-icon-prepend "></i>
								</button>
								<button type="button" class="icon_btn btn-outline-primary btn-icon-text float-right" id="btnUpdate" onClick="fn_proxy_update();" data-toggle="modal">
									<i class="ti-pencil-alt btn-icon-prepend "></i>
								</button>
								<button type="button" class="icon_btn btn-outline-primary btn-icon-text float-right" id="btnInsert" onClick="fn_proxy_listener_insert();" data-toggle="modal">
									<i class="ti-pencil btn-icon-prepend "></i>
								</button>
								<h4 class="card-title">
									<i class="item-icon fa fa-dot-circle-o"></i>
									<%-- <spring:message code="auth_management.db_auth" /> --%>
									Listener 관리
								</h4>
							</div>
							<table id="proxyListener" class="table table-hover table-striped" style="width:100%;">
								<thead>
									<tr class="bg-info text-white">
										<th width="40"><spring:message code="common.no"/></th>
										<th width="90">Listen</th>
										<th width="150">Bind</th>
										<th width="150">설명</th>
										<th width="0">db 사용자 ID</th>
										<th width="0">db id</th>
										<th width="0">db 명</th>
										<th width="0">전송 쿼리</th>
										<th width="0">필드 값</th>
										<th width="0">필드 명</th>
										<th width="0">최종 수정자</th>
										<th width="0">최종 수정일</th>
										<th width="0">proxy ip</th>
										<th width="0">proxy id</th>
										<th width="0">listener id</th>
									</tr>
								</thead>
							</table>
						</div>
					</div>
				</div>
			</div>
		</div>
	</div>
</div>