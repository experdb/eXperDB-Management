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

	var proxyServerTable = null; //Proxy Server Table
	var vipInstTable = null; //VIP Instance Table
	var proxyListenTable = null; //Proxy Listener Table
	
	var selPrySvrId = null; //ProxyServerTable에서 선택된 항목의 pry_svr_id
	
	var unregSvrInfo  = null;//미등록된 서버 정보 list
	
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
			            {data : "rownum", className : "dt-center", defaultContent : "", orderable : false,},
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
			            ]
		});
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
			
		$('#proxyServer tbody').on('click','tr',function() {
			$("input[type=checkbox]").prop("checked",false);
	        if ( !$(this).hasClass('selected') ){	        	
	        	 proxyServerTable.$('tr.selected').removeClass('selected');
	            $(this).addClass('selected');	            
	        } 
			var selRowLen = proxyServerTable.rows('.selected').data().length;
			
			if(selRowLen != 0){
				//정보 불러오기
				var selRow = proxyServerTable.row('.selected').data();
				selPrySvrId = selRow.pry_svr_id;
				fn_server_conf_info();	
			}
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
     * Proxy Server List 검색
    ******************************************************** */		
 	function fn_serverList_search(){
		
		var temp_search = $("#serverList_search").val();
		if(temp_search != ""){
			temp_search = "%" + temp_search + "%";
		}
 		$.ajax({
 			url : "/selectPoxyServerTable.do",
 			data : {
 				search : temp_search,
 				svr_use_yn : "Y"
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
 				console.log("fn_serverList_search :: "+result);
 			
 				proxyServerTable.rows({selected: true}).deselect();
				proxyServerTable.clear().draw();
				
				if (result != null) {
					proxyServerTable.rows.add(result).draw();
				}
 			}
 		});
 	} 	
	
	/* ********************************************************
     * 화면 초기 셋팅 
    ******************************************************** */		
	$(window.document).ready(function() {
		fn_init();
		
		fn_serverList_search(); 
	});
		
	/* ********************************************************
     * Proxy Server List 선택 시 상세 정보 불러오기
    ******************************************************** */
    var globalInfo = null; //선택하여 불러온 global 정보
    var vipInstanceList = null; //선택하여 불러온 vip instance 정보
    var proxyListenerList = null; // proxy listener 정보
 	function fn_server_conf_info(){
 		if(selPrySvrId != null){
			$.ajax({
	 			url : "/getPoxyServerConf.do",
	 			data : {
	 				pry_svr_id : selPrySvrId
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
	 				//console.log("fn_server_conf_info result :: "+result);
	 				if(result != null){
	 					//전역변수로 저장
	 					globalInfo = result.global_info;
	 					vipInstanceList = result.vipconfig_list;
	 					proxyListenerList = result.listener_list;
	 					
	 					//Global 설정 불러오기
	 					load_global_info(result.global_info);
	 					
		 				//vip Instance 관리 Table Data set
						vipInstTable.rows({selected: true}).deselect();
						vipInstTable.clear().draw();
						vipInstTable.rows.add(result.vipconfig_list).draw();

						//Listener 관리 Table Data set
						proxyListenTable.rows({selected: true}).deselect();
						proxyListenTable.clear().draw();
						proxyListenTable.rows.add(result.listener_list).draw();
						
	 				}
	 			}
	 		});
 		}
 	} 	
	
 	/* ********************************************************
     * Global 설정 불러오기
    ******************************************************** */		
    function load_global_info(data){
    	$("#glb_obj_ip", "#globalInfoForm").val(data.obj_ip);
    	$("#glb_if_nm", "#globalInfoForm").val(data.if_nm);
    	$("#glb_peer_server_ip", "#globalInfoForm").val(data.peer_server_ip);
    	$("#glb_max_con_cnt", "#globalInfoForm").val(data.max_con_cnt);
    	
    	setTimeOutData("glb_cl_con_max_tm", data.cl_con_max_tm);
    	setTimeOutData("glb_con_del_tm", data.con_del_tm);
    	setTimeOutData("glb_svr_con_max_tm", data.svr_con_max_tm);
    	setTimeOutData("glb_chk_tm", data.chk_tm);
    	
 	}
	//숫자+[m,s] 형태로 데이터 저장 필요
 	function setTimeOutData(id, tVal){
 		var len = tVal.length;
 	 	
 		$("#"+id+"_num", "#globalInfoForm").val(tVal.substr(0, len-1));
    	$("#"+id+"_tm", "#globalInfoForm").val(tVal.substr(-1, 1));
 	}
 	function getTimeOutData(id){
 		
 		return $("#"+id+"_num", "#globalInfoForm").val() + $("#"+id+"_tm", "#globalInfoForm").val();
 		
 	}
 	/* ********************************************************
     * Proxy Server 등록 버튼 클릭 시 이벤트
    ******************************************************** */		
 	function fn_proxy_update(mode){
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
				fn_pop_svr_info(mode);
			}
		});
 	}
 	/* ********************************************************
	 * Proxy 서버 등록 팝업 초기화
	 ******************************************************** */
	function fn_pop_svr_info(gbn) {
		if (gbn == "reg") {
			//등록 모드라면 agent 설치 시 테이블에 등록되어있는 서버 정보 불러오기
			$.ajax({
				url : "/selectPoxyServerTable.do",
	 			data : { svr_use_yn : "N"},
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
	 				unregSvrInfo = result;
	 				if(unregSvrInfo.length ==0){
	 					showSwalIcon("Proxy Agent가 설치된 서버 중 미등록된 서버가 없습니다.", '<spring:message code="common.close" />', '', 'error');
	 					$('#pop_layer_svr_reg').modal("hide");
	 				}else{
	 					//ip select 동적 생성
	 					fn_create_unregSvr_select(gbn);
	 					
	 					$('#pop_layer_svr_reg').modal("show");
	 					
	 					setTimeout(function(){
	 						if(mgmtDbmsTable != null){
	 							mgmtDbmsTable.columns.adjust().draw();
	 						}
	 					},200);  
	 				}
	 			}
	 		});
		}else{
			//수정 모드라면 선택되어있는 Grid 항목의 ID값 갖고 오기
			if(proxyServerTable.rows('.selected').data().length==0){
				showSwalIcon('<spring:message code="message.msg35" />', '<spring:message code="common.close" />', '', 'error');
				return;
			}else{
				var prySvrID = proxyServerTable.row('.selected').data().pry_svr_id;
				$("#svrReg_pry_svr_id", "#svrRegProxyServerForm" ).val(prySvrID);
				$.ajax({
					url : "/selectPoxyServerTable.do",
		 			data : { svr_use_yn : "Y", 
		 					pry_svr_id : prySvrID
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
		 				console.log(result)
		 				fn_changeSvrId(gbn);
	 					
	 					$('#pop_layer_svr_reg').modal("show");
	 					
	 					setTimeout(function(){
	 						if(mgmtDbmsTable != null){
	 							mgmtDbmsTable.columns.adjust().draw();
	 						}
	 					},200);  
		 				
		 			}
		 		});
			}
		}
		
		
	}
	/* ********************************************************
	 * Proxy 미등록 서버 select 생성
	 ******************************************************** */
	function fn_create_unregSvr_select(mode){
		var tempUnregSvrList = unregSvrInfo;
		var unregSvrHtml ="";
		var unregLen = unregSvrInfo.length;
		$( "#svrReg_ipadr > option", "#svrRegProxyServerForm" ).remove();
		
		for(var i=0; i<unregLen; i++){
			var id = tempUnregSvrList[i].pry_svr_id;
			var ip = tempUnregSvrList[i].ipadr;
			unregSvrHtml += '<option value='+id+'>'+ip+'</option>';
		}
		$("#svrReg_ipadr", "#svrRegProxyServerForm" ).append(unregSvrHtml);
		$("#svrReg_pry_svr_id", "#svrRegProxyServerForm" ).val(tempUnregSvrList[0].pry_svr_id);
		$("#svrReg_ipadr", "#svrRegProxyServerForm").val(tempUnregSvrList[0].pry_svr_id);//ipadr
		fn_changeSvrId(mode);
	}
	/* ********************************************************
	 * Proxy IP 주소 변경 시 이벤트
	 ******************************************************** */
	function fn_changeSvrId(mode){
		var prySvrID= $( "#svrReg_pry_svr_id", "#svrRegProxyServerForm" ).val();
		if(mode=="reg") $( "#svrReg_ipadr", "#svrRegProxyServerForm" ).val(prySvrID);
		else $( "#svrMod_ipadr", "#svrRegProxyServerForm" ).val(prySvrID);
		
		$.ajax({
				url : "/createSelPrySvrReg.do",
	 			data : { pry_svr_id : prySvrID},
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
	 				if(mode=="reg"){
	 					var index = null; 
		 			
		 				for(var i=0; i<unregSvrInfo.length; i++){
		 					if(unregSvrInfo[i].pry_svr_id ==prySvrID) index = i;
		 				}
		 				fn_create_mstSvr_select(result.mstSvr_sel_list, unregSvrInfo[index].master_svr_id);
		 				fn_create_dbms_select(result.dbms_sel_list, unregSvrInfo[index].db_svr_id);
		 				
		 				set_svr_info(unregSvrInfo[index], mode);
	 				}else{
	 					var selSvrInfo = proxyServerTable.row('.selected').data();
	 					
	 					fn_create_mstSvr_select(result.mstSvr_sel_list, selSvrInfo.master_svr_id);
		 				fn_create_dbms_select(result.dbms_sel_list, selSvrInfo.db_svr_id);
		 				
		 				set_svr_info(selSvrInfo, mode);
	 				}
	 				
	 			}
	 		});
			
	}
	/* ********************************************************
	 * Proxy 정보 setting
	 ******************************************************** */
	function set_svr_info(listData, mode){
		var tempSetData = listData;
		$("#svrReg_mode", "#svrRegProxyServerForm").val(mode);	
		//hidden 정보
		$("#svrReg_conn_result", "#svrRegProxyServerForm").val("false");				
		$("#svrReg_pry_svr_id", "#svrRegProxyServerForm").val(tempSetData.pry_svr_id);
		$("#svrReg_master_svr_id_val", "#svrRegProxyServerForm").val(tempSetData.master_svr_id);
		$("#svrReg_db_svr_id_val", "#svrRegProxyServerForm").val(tempSetData.db_svr_id);
		$("#svrReg_agt_sn", "#svrRegProxyServerForm").val(tempSetData.agt_sn);
		
		$("#svrReg_ipadr", "#svrRegProxyServerForm").val(tempSetData.pry_svr_id);//ipadr
		$("#svrReg_pry_svr_nm", "#svrRegProxyServerForm").val(tempSetData.pry_svr_nm); //서버명
		
		if(tempSetData.use_yn == "Y"){
			$("#svrReg_use_yn", "#svrRegProxyServerForm").prop("checked", true); 
		}else{
			$("#svrReg_use_yn", "#svrRegProxyServerForm").prop("checked", false); 
		}
		
		if(mode=="reg"){//등록
			$("#svrReg_ipadr", "#svrRegProxyServerForm").val(tempSetData.pry_svr_id);//ipadr
			$("#svrReg_ipadr", "#svrRegProxyServerForm").show();
			$("#svrMod_ipadr", "#svrRegProxyServerForm").hide();//ipadr
			$("#svrMod_ipadr", "#svrRegProxyServerForm").val(tempSetData.ipadr);//ipadr
			
			$("#svrReg_pry_svr_nm", "#svrRegProxyServerForm").removeAttr("disabled");
			$("#svrReg_pry_svr_nm", "#svrRegProxyServerForm").removeAttr("readonly");
			$("#svrMod_ipadr", "#svrRegProxyServerForm").removeAttr("disabled");
			$("#svrMod_ipadr", "#svrRegProxyServerForm").removeAttr("readonly");
		}else{//수정
			$("#svrReg_ipadr", "#svrRegProxyServerForm").val(tempSetData.pry_svr_id);//ipadr
			$("#svrReg_ipadr", "#svrRegProxyServerForm").hide();//ipadr
			$("#svrMod_ipadr", "#svrRegProxyServerForm").val(tempSetData.ipadr);//ipadr
			$("#svrMod_ipadr", "#svrRegProxyServerForm").show();
			
			$("#svrReg_pry_svr_nm", "#svrRegProxyServerForm").attr("disabled",true);
			$("#svrReg_pry_svr_nm", "#svrRegProxyServerForm").attr("readonly",true);
			$("#svrMod_ipadr", "#svrRegProxyServerForm").attr("disabled",true);
			$("#svrMod_ipadr", "#svrRegProxyServerForm").attr("readonly",true);
		}
		
		$("#svrReg_day_data_del_term", "#svrRegProxyServerForm").val(tempSetData.day_data_del_term); //일별 데이터 보관 기간
		$("#svrReg_min_data_del_term", "#svrRegProxyServerForm").val(tempSetData.min_data_del_term); //분별 데이터 보관 기간
		
		$("#svrReg_master_gbn", "#svrRegProxyServerForm").val(tempSetData.master_gbn); //마스터 구분
		fn_changeMasterGbn();
	
		//list 불러오기
		fn_svr_dbms_list_search();
 	}
	/* ********************************************************
	 * confirm modal open
	 ******************************************************** */
	function fn_multiConfirmModal(gbn) {
		if (gbn == "conn_test") {
			confirm_title = 'Proxy Agent 연결 테스트';
			$('#confirm_multi_msg').html(fn_strBrReplcae('<spring:message code="message.msg89" />'));
		}else if (gbn == "pry_svr_reg") {
			confirm_title = 'Proxy Server 등록';
			$('#confirm_multi_msg').html(fn_strBrReplcae('<spring:message code="message.msg143" />'));
		}else if (gbn == "pry_svr_mod") {
			confirm_title = 'Proxy Server 수정';
			$('#confirm_multi_msg').html(fn_strBrReplcae('<spring:message code="message.msg147" />'));
		}
		
		
		$('#con_multi_gbn', '#findConfirmMulti').val(gbn);
		$('#confirm_multi_tlt').html(confirm_title);
		$('#pop_confirm_multi_md').modal("show");
	}
	/* ********************************************************
	 * confirm result
	 ******************************************************** */
	function fnc_confirmMultiRst(gbn){
		if (gbn == "conn_test") {
			fn_prySvrConnTest();
		}else if(gbn=="pry_svr_reg" || gbn=="pry_svr_mod"){
			fn_reg_svr();
		}
	}
	
	/* ********************************************************
	 * confirm cancel result
	 ******************************************************** */
	function fnc_confirmCancelRst(gbn){
		/* if (gbn == "ins_menu") {
			//$('#pop_layer_user_reg').modal('hide');

			//조회
			fn_select();
		} */
	}
	
	
	
	
	
	

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
<%@include file="./../../popup/confirmMultiForm.jsp"%>

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
									<input type="text" class="form-control" style="width:250px;" id="serverList_search">
									&nbsp;&nbsp;
									<button type="button" class="btn btn-inverse-primary btn-icon-text btn-search-disable" onClick="fn_serverList_search()">
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
								<button type="button" class="btn btn-outline-primary btn-icon-text float-right" id="btnUpdate" onClick="fn_proxy_update('mod');" data-toggle="modal">
									<i class="ti-pencil-alt btn-icon-prepend "></i><spring:message code="common.modify" />
								</button>
								<button type="button" class="btn btn-outline-primary btn-icon-text float-right" id="btnInsert" onClick="fn_proxy_update('reg');" data-toggle="modal">
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
						<form class="cmxform" id="globalInfoForm">
							<div class="card-body card-body-border">
								<div class="form-group row">
									<label for="glb_obj_ip" class="col-sm-2_5 col-form-label pop-label-index">
										<i class="item-icon fa fa-angle-double-right"></i>	
										<%-- <spring:message code="user_management.password" /> --%>
										Server IP
									</label>
									<div class="col-sm-2_27">
										<input type="text" class="form-control form-control-sm glb_obj_ip" maxlength="15" id="glb_obj_ip" name="glb_obj_ip" onkeyup="fn_checkWord(this,20)" onblur="this.value=this.value.trim()" placeholder="" />
									</div>
									<label for="glb_if_nm" class="col-sm-2_5 col-form-label pop-label-index">
										<i class="item-icon fa fa-angle-double-right"></i>	
										<%-- <spring:message code="user_management.password" /> --%>
										Interface
									</label>
									<div class="col-sm-2_27">
										<input type="text" class="form-control form-control-sm glb_if_nm" maxlength="20" id="glb_if_nm" name="glb_if_nm" onkeyup="fn_checkWord(this,20)" onblur="this.value=this.value.trim()" placeholder="" />
									</div>
								</div>
								<div class="form-group row">
									<label for="glb_peer_server_ip" class="col-sm-2_5 col-form-label pop-label-index">
										<i class="item-icon fa fa-angle-double-right"></i>	
										<%-- <spring:message code="user_management.password" /> --%>
										Peer IP
									</label>
									<div class="col-sm-2_27">
										<input type="text" class="form-control form-control-sm glb_peer_server_ip" maxlength="15" id="glb_peer_server_ip" name="glb_peer_server_ip" onkeyup="fn_checkWord(this,20)" onblur="this.value=this.value.trim()" placeholder="" />
									</div>
									<div class="col-sm-6">
									</div>
								</div>
								<div class="form-group row">
									<label for="glb_max_con_cnt" class="col-sm-2_5 col-form-label pop-label-index">
										<i class="item-icon fa fa-angle-double-right"></i>	
										동시 접속 최대 수
									</label>
									<div class="col-sm-2">
										<input type="text" class="form-control form-control-sm glb_max_con_cnt" maxlength="10" id="glb_max_con_cnt" name="glb_max_con_cnt" onkeyup="fn_checkWord(this,20)" onblur="this.value=this.value.trim()" placeholder="" />
									</div>
									<div class="col-sm-auto">
									</div>
								</div>
								<div class="form-group row" style="margin-bottom:-5px;">
									<label for="glb_cl_con_max_tm_num" class="col-sm-12 col-form-label pop-label-index">
										<i class="item-icon fa fa-angle-double-right"></i>	
										<%-- <spring:message code="user_management.password" /> --%>
										Timeout 설정
									</label>
								</div>
								<div class="form-group row" style="margin-bottom: 0px !important;">
									<label for="glb_cl_con_max_tm_num" class="col-sm-3 col-form-label pop-label-index">
										클라이언트 연결 최대 시간
									</label>
									<div class="col-sm-1_5">
										<input type="text" class="form-control form-control-sm glb_cl_con_max_tm_num" maxlength="5" id="glb_cl_con_max_tm_num" name="glb_cl_con_max_tm_num" onkeyup="fn_checkWord(this,20)" onblur="this.value=this.value.trim()" placeholder="" />
									</div>
									<div class="col-sm-1_5">
										<select class="form-control form-control-sm" name="glb_cl_con_max_tm_tm" id="glb_cl_con_max_tm_tm">
											<option value="s">초</option>
											<option value="m">분</option>
										</select>
									</div>
									<label for="glb_con_del_tm_num" class="col-sm-3 col-form-label pop-label-index">
										연결 지연 최대 시간
									</label>
									<div class="col-sm-1_5">
										<input type="text" class="form-control form-control-sm glb_con_del_tm_num" maxlength="5" id="glb_con_del_tm_num" name="glb_con_del_tm_num" onkeyup="fn_checkWord(this,20)" onblur="this.value=this.value.trim()" placeholder="" />
									</div>
									<div class="col-sm-1_5">
										<select class="form-control form-control-sm" name="glb_con_del_tm_tm" id="glb_con_del_tm_tm">
											<option value="s">초</option>
											<option value="m">분</option>
										</select>
									</div>
								</div>
								<div class="form-group row" style="margin-bottom:-17px !important;">
									<label for="glb_svr_con_max_tm_num" class="col-sm-3 col-form-label pop-label-index">
										서버 연결 최대 시간
									</label>
									<div class="col-sm-1_5">
										<input type="text" class="form-control form-control-sm glb_svr_con_max_tm_num" maxlength="5" id="glb_svr_con_max_tm_num" name="glb_svr_con_max_tm_num" onkeyup="fn_checkWord(this,20)" onblur="this.value=this.value.trim()" placeholder="" />
									</div>
									<div class="col-sm-1_5">
										<select class="form-control form-control-sm" name="glb_svr_con_max_tm_tm" id="glb_svr_con_max_tm_tm">
											<option value="s">초</option>
											<option value="m">분</option>
										</select>
									</div>
									<label for="glb_chk_tm_num" class="col-sm-3 col-form-label pop-label-index">
										체크 주기
									</label>
									<div class="col-sm-1_5">
										<input type="text" class="form-control form-control-sm glb_chk_tm_num" maxlength="5" id="glb_chk_tm_num" name="glb_chk_tm_num" onkeyup="fn_checkWord(this,20)" onblur="this.value=this.value.trim()" placeholder="" />
									</div>
									<div class="col-sm-1_5">
										<select class="form-control form-control-sm" name="glb_chk_tm_tm" id="glb_chk_tm_tm">
											<option value="s">초</option>
											<option value="m">분</option>
										</select>
									</div>
								</div>
							</div>
						</form>
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