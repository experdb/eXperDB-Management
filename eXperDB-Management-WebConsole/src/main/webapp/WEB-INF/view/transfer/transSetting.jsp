<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>

<%@include file="../cmmn/cs.jsp"%>

<%
	/**
	* @Class Name : transferTarget.jsp
	* @Description : TransferTarget 화면
	* @Modification Information
	*
	*   수정일         수정자                   수정내용
	*  ------------    -----------    ---------------------------
	*  2020.04.07     최초 생성
	*
	* author 변승우 과장
	* since 2017.07.24
	*
	*/
%>
<script>
	var table = null;
	var db_svr_id = "${db_svr_id}";
	
	function fn_init() {
		table = $('#transSettingTable').DataTable({
			scrollY : "425px",
			deferRender : true,
			scrollX: true,
			searching : false,
			columns : [
			{ data : "index", defaultContent : "", targets : 0, orderable : false, checkboxes : {'selectRow' : true}}, 
			{data : "rownum",  className : "dt-center", defaultContent : ""}, 	
			{data : "status", 
				render: function (data, type, full){		
						if(full.exe_status == "TC001501"){
							var html = '<img src="../images/ico_state_04.png"  id="transStop"/>';
								return html;
						}else if(full.exe_status == "TC001502"){
							var html = '<img src="../images/ico_state_06.png" id="transStart" />';
							return html;
						}		
					return data;
				},
				className : "dt-center",
				 defaultContent : "" 	
			},
			{ data : "kc_ip",  className : "dt-center", defaultContent : "",orderable : false}, 
			{ data : "kc_port",  className : "dt-center", defaultContent : "",orderable : false}, 
			{ data : "db_svr_nm",  className : "dt-center", defaultContent : "",orderable : false}, 
			{ data : "connect_nm",  className : "dt-center", defaultContent : "",orderable : false}, 
			{ data : "db_nm",  className : "dt-center", defaultContent : "",orderable : false}, 
			 { data : "snapshot_nm",  className : "dt-center", defaultContent : "",orderable : false}, 			
			/*{
				data : "status",
				render : function(data, type, full, meta) {
					var html="";
					if(full.exe_status == "TC001502"){
						//중지
						html += "<img src='../images/ico_agent_2.png' alt='' /> Stop";
					}else if(full.exe_status == "TC001501"){
						//실행중
						html += "<img src='../images/ico_agent_1.png' alt='' /> Running";	
					}
					return html;
				},
				className : "dt-center",
				defaultContent : ""
			},  */
			{data : "db_svr_id", defaultContent : "", visible: false },
			{data : "db_id", defaultContent : "", visible: false },
			{data : "snapshot_mode", defaultContent : "", visible: false },
			{data : "trans_exrt_trg_tb_id", defaultContent : "", visible: false },
			{data : "trans_id", defaultContent : "", visible: false },
			{data : "exe_status", defaultContent : "", visible: false }
			],'select': {'style': 'multi'}
		});
		
		table.tables().header().to$().find('th:eq(0)').css('min-width', '10px');
		table.tables().header().to$().find('th:eq(1)').css('min-width', '30px');
		table.tables().header().to$().find('th:eq(2)').css('min-width', '75px');
		table.tables().header().to$().find('th:eq(3)').css('min-width', '75px');
		table.tables().header().to$().find('th:eq(4)').css('min-width', '100px');
		table.tables().header().to$().find('th:eq(5)').css('min-width', '100px');
		table.tables().header().to$().find('th:eq(6)').css('min-width', '100px');
		table.tables().header().to$().find('th:eq(7)').css('min-width', '100px');
		table.tables().header().to$().find('th:eq(8)').css('min-width', '100px');
		table.tables().header().to$().find('th:eq(9)').css('min-width', '90px');
		table.tables().header().to$().find('th:eq(10)').css('min-width', '100px');
		//table.tables().header().to$().find('th:eq(11)').css('min-width', '100px');
	    $(window).trigger('resize'); 
	    
		table.on( 'order.dt search.dt', function () {
			table.column(1, {search:'applied', order:'applied'}).nodes().each( function (cell, i) {
	            cell.innerHTML = i+1;
	        } );
	    } ).draw();
		
		
		
		//더블 클릭시
		/* $('#transSettingTable tbody').on('dblclick','tr',function() {
				var data = table.row(this).data();
				var name = data.name;
	 			var popUrl = "/popup/transferTargetDetailRegForm.do?&&cnr_id=${cnr_id}&&name="+name; // 서버 url 팝업경로
	 			var width = 930;
	 			var height = 640;
	 			var left = (window.screen.width / 2) - (width / 2);
	 			var top = (window.screen.height /2) - (height / 2);
	 			var popOption = "width="+width+", height="+height+", top="+top+", left="+left+", resizable=no, scrollbars=yes, status=no, toolbar=no, titlebar=yes, location=no,";
	 			
	 			window.open(popUrl,"",popOption);
			}); */	
		
		
	 	$('#transSettingTable tbody').on('click','#transStart', function () {
	 	    var $this = $(this);
		    var $row = $this.parent().parent();
		    $row.addClass('select-detail');
		    var datas = table.rows('.select-detail').data();

		    if(datas.length==1) {
		       var row = datas[0];
		       $row.removeClass('select-detail');
		       
		        if(confirm('커넥트를 실행 하시겠습니까?')){
			     	$.ajax({
			    		url : "/transStart.do",
			    		data : {
			    			db_svr_id : row.db_svr_id,
			    			trans_exrt_trg_tb_id : row.trans_exrt_trg_tb_id,
			    			trans_id : row.trans_id		
			    		},
			    		dataType : "json",
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
			    			location.reload();
			    		}
			    	});    
		       } 
		    } 
		}); 
	 	
	 	
		$('#transSettingTable tbody').on('click','#transStop', function () {
	 	    var $this = $(this);
		    var $row = $this.parent().parent();
		    $row.addClass('select-detail');
		    var datas = table.rows('.select-detail').data();

		    if(datas.length==1) {
		       var row = datas[0];
		       $row.removeClass('select-detail');
		       
		        if(confirm('커넥트를 정지 하시겠습니까?')){
			     	$.ajax({
			    		url : "/transStop.do",
			    		data : {
			    			db_svr_id : row.db_svr_id,
			    			kc_ip : row.kc_ip,
			    			kc_port : row.kc_port,
			    			connect_nm : row.connect_nm,
			    			trans_id : row.trans_id
			    		},
			    		dataType : "json",
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
			    			location.reload();
			    		}
			    	});    
		       } 
		    } 
		}); 
		
		
		//상세조회 클릭시
		$('#transSettingTable tbody').on('click','#detail',function() {
		 		var $this = $(this);
		    	var $row = $this.parent().parent().parent();
		    	$row.addClass('detail');
		    	var datas = table.rows('.detail').data();
		    	if(datas.length==1) {
		    		var row = datas[0];
			    	$row.removeClass('detail');
		 			var name  = row.name;
		 			var popUrl = "/popup/transferTargetDetailRegForm.do?cnr_id=${cnr_id}&&name="+name; // 서버 url 팝업경로
		 			var width = 930;
		 			var height = 640;
		 			var left = (window.screen.width / 2) - (width / 2);
		 			var top = (window.screen.height /2) - (height / 2);
		 			var popOption = "width="+width+", height="+height+", top="+top+", left="+left+", resizable=no, scrollbars=yes, status=no, toolbar=no, titlebar=yes, location=no,";
		 			
		 			window.open(popUrl,"",popOption);
		 			
		    	}
			});	
		
	    //맵핑설정버튼 클릭시
		 $('#transSettingTable tbody').on('click','#mappingBtn', function () {
		 		var $this = $(this);
		    	var $row = $this.parent().parent().parent();
		    	$row.addClass('detail');
		    	var datas = table.rows('.detail').data();
		    	if(datas.length==1) {
		    		var row = datas[0];
			    	$row.removeClass('detail');
					var popUrl = "/popup/transMappForm.do?db_svr_id=${db_svr_id}" // 서버 url 팝업경로
					var width = 1000;
					var height = 680;
					var left = (window.screen.width / 2) - (width / 2);
					var top = (window.screen.height /2) - (height / 2);
					var popOption = "width="+width+", height="+height+", top="+top+", left="+left+", resizable=no, scrollbars=yes, status=no, toolbar=no, titlebar=yes, location=no,";
					
					window.open(popUrl,"",popOption);
		    	}
			});
		}
	
	$(window.document).ready(function() {
		fn_init();
		fn_select();
	});
	
	/*조회버튼 클릭시*/
	function fn_select(){
		$.ajax({
			url : "/selectTransSetting.do",
			data : {
				db_svr_id : db_svr_id,
				connect_nm : $("#connect_nm").val()
			},
			dataType : "json",
			type : "post",
			beforeSend: function(xhr) {
		        xhr.setRequestHeader("AJAX", true);
		     },
			error : function(xhr, status, error) {
				if(xhr.status == 401) {
					alert("<spring:message code='message.msg02' />");
					top.location.href = "/";
				} else if(xhr.status == 403) {
					alert("<spring:message code='message.msg03' />");
					top.location.href = "/";
				} else {
					alert("ERROR CODE : "+ xhr.status+ "\n\n"+ "ERROR Message : "+ error+ "\n\n"+ "Error Detail : "+ xhr.responseText.replace(/(<([^>]+)>)/gi, ""));
				}
			},
			success : function(result) {
				table.rows({selected: true}).deselect();
				table.clear().draw();
				if(result != null){
					table.rows.add(result).draw();
				}
			}
		});
	}

	/*등록버튼 클릭시*/
	function fn_insert(){
		var popUrl = "/popup/connectRegForm.do?act=i&&db_svr_id=${db_svr_id}"; // 서버 url 팝업경로
		var width = 930;
		var height = 610;
		var left = (window.screen.width / 2) - (width / 2);
		var top = (window.screen.height /2) - (height / 2);
		var popOption = "width="+width+", height="+height+", top="+top+", left="+left+", resizable=no, scrollbars=yes, status=no, toolbar=no, titlebar=yes, location=no,";
		
		window.open(popUrl,"",popOption);
	}
	
	/*수정버튼 클릭시*/
	function fn_update(){
		var datas = table.rows('.selected').data();

		if (datas.length == 1) {

			if(table.row('.selected').data().exe_status == "TC001501"){
				 alert("커넥터가 실행중입니다. 정지 후 수정 바랍니다.");
				 return false;
			}else{
				var trans_id = table.row('.selected').data().trans_id;
				var trans_exrt_trg_tb_id = table.row('.selected').data().trans_exrt_trg_tb_id;
				
				var popUrl = "/popup/connectRegForm.do?act=u&&trans_exrt_trg_tb_id="+trans_exrt_trg_tb_id+"&&trans_id="+trans_id+"&&db_svr_id=${db_svr_id}"; // 서버 url 팝업경로
				var width = 930;
				var height = 610;
				var left = (window.screen.width / 2) - (width / 2);
				var top = (window.screen.height /2) - (height / 2);
				var popOption = "width="+width+", height="+height+", top="+top+", left="+left+", resizable=no, scrollbars=yes, status=no, toolbar=no, titlebar=yes, location=no,";
				
				window.open(popUrl,"",popOption);
			}
		} else {
			alert("<spring:message code='message.msg04' />");
			return false;
		}

	}
	
	/*삭제버튼 클릭시*/
	function fn_delete(){
		var datas = table.rows('.selected').data();
		if (datas.length <= 0) {
			alert("<spring:message code='message.msg04' />");
			return false;
		} else {
			
			if(table.row('.selected').data().exe_status == "TC001501"){
				 alert("커넥터가 실행중입니다. 정지 후 삭제 바랍니다.");
				 return false;
			}else{				
				var trans_id = table.row('.selected').data().trans_id;
				var trans_exrt_trg_tb_id = table.row('.selected').data().trans_exrt_trg_tb_id;
				
				if(confirm('삭제 하시겠습니까?')){
									
					$.ajax({
						url : "/deleteTransSetting.do",
						data : {
							trans_id : trans_id,
							trans_exrt_trg_tb_id : trans_exrt_trg_tb_id
						},
						dataType : "json",
						type : "post",
						beforeSend: function(xhr) {
					        xhr.setRequestHeader("AJAX", true);
					     },
						error : function(xhr, status, error) {
							if(xhr.status == 401) {
								alert("<spring:message code='message.msg02' />");
								top.location.href = "/";
							} else if(xhr.status == 403) {
								alert("<spring:message code='message.msg03' />");
								top.location.href = "/";
							} else {
								alert("ERROR CODE : "+ xhr.status+ "\n\n"+ "ERROR Message : "+ error+ "\n\n"+ "Error Detail : "+ xhr.responseText.replace(/(<([^>]+)>)/gi, ""));
							}
						},
						success : function(result) {						
								if(result == true){
									alert("삭제하였습니다.");
									location.reload();
								}else{
									alert("삭제에 실패 하였습니다.");
								}
							}
						});	
				}
			}
		}
	}
</script>


<!-- contents -->
<div id="contents">
	<div class="contents_wrap">
		<div class="contents_tit">
			<h4>전송설정<a href="#n"><img src="../images/ico_tit.png" class="btn_info"/></a></h4>
			<div class="infobox"> 
				<ul>
					<li><spring:message code="help.connector_settings_01" /></li>
					<li><spring:message code="help.connector_settings_02" /></li>
				</ul>
			</div>
			<div class="location">
				<ul>
					<li><spring:message code="menu.data_transfer" /></li>
					전송관리
				</ul>
			</div>
		</div>
		<div class="contents">
			<div class="cmm_grp">
				<div class="btn_type_01">
					<span class="btn" onclick="fn_select()"><button type="button"><spring:message code="common.search" /></button></span>
					<span class="btn" onclick="fn_insert();"><button type="button"><spring:message code="common.registory" /></button></span> 
					<span class="btn" onclick="fn_update();"><button type="button"><spring:message code="common.modify" /></button></span> 
					<span class="btn" onclick="fn_delete();"><button type="button"><spring:message code="common.delete" /></button></span>
				</div>
				<div class="sch_form">
					<table class="write">
						<caption>검색 조회</caption>
						<colgroup>
							<col style="width: 115px;" />
							<col />
						</colgroup>
						<tbody>
							<tr>
								<th scope="row" class="t9">Connect명</th>
								<td><input type="text" class="txt t3" name="connect_nm" id="connect_nm" maxlength="25"/></td>
							</tr>
						</tbody>
					</table>
				</div>
				<div class="overflow_area">
					<table id="transSettingTable" class="display" cellspacing="0" width="100%">
						<thead>
							<tr>
								<th width="10"></th>
								<th width="30"><spring:message code="common.no" /></th>							
								<th width="30">활성화</th>
								<th width="100">Kafka-Connect 아이피</th>
								<th width="100">Kafka-Connect 포트</th>
								<th width="100">서버명</th>
								<th width="100">Connect 명</th>
								<th width="100"><spring:message code="common.dbms_name" /></th>
								<th width="100">스냅샷 모드</th>
								<!-- <th width="30">구동상태</th> -->
							</tr>
						</thead>
					</table>
				</div>
			</div>
		</div>
	</div>
</div>
<!-- // contents -->