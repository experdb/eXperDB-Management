<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%
	/**
	* @Class Name : transferTarget.jsp
	* @Description : TransferTarget 화면
	* @Modification Information
	*
	*   수정일         수정자                   수정내용
	*  ------------    -----------    ---------------------------
	*  2017.07.24     최초 생성
	*
	* author 김주영 사원
	* since 2017.07.24
	*
	*/
%>
<script type="text/javascript">
	var cnr_id="${cnr_id}";
	var table = null;
	
	function fn_init() {
		table = $('#transferTargetTable').DataTable({
			scrollY : "230px",
			deferRender : true,
			scrollX: true,
// 			bSort: false,
			columns : [
			{ data : "", defaultContent : "", targets : 0, orderable : false, checkboxes : {'selectRow' : true}}, 
			{ data : "", className : "dt-center", defaultContent : "",orderable : false}, 
			{ data : "name", className : "dt-center", defaultContent : "",orderable : false}, 
			{ data : "hdfs_url", className : "dt-center", defaultContent : "",orderable : false}, 
			{ data : "tasks_max", className : "dt-center", defaultContent : "",orderable : false}, 
			{ data : "flush_size", className : "dt-center", defaultContent : "",orderable : false}, 
			{ data : "rotate_interval_ms", className : "dt-center", defaultContent : "",orderable : false}, 
			{ data : "db_svr_nm", className : "dt-center", defaultContent : "",orderable : false}, 
			{ data : "db_nm", className : "dt-center", defaultContent : "",orderable : false}, 
			{
				data : "",
				render : function(data, type, full, meta) {
					var html = "<span class='btn btnC_01 btnF_02'><button id='detail'><spring:message code='data_transfer.detail_search' /> </button></span>";
					return html;
				},
				className : "dt-center",
				defaultContent : "",
				orderable : false
			}, 
			{ data : "", className : "dt-center", orderable : false, defaultContent : "<span class='btn btnC_01 btnF_02'><button id='mappingBtn'><spring:message code='data_transfer.table_mapping' /></button></span>"},
			]
		});
		
		table.tables().header().to$().find('th:eq(0)').css('min-width', '10px');
		table.tables().header().to$().find('th:eq(1)').css('min-width', '20px');
		table.tables().header().to$().find('th:eq(2)').css('min-width', '100px');
		table.tables().header().to$().find('th:eq(3)').css('min-width', '350px');
		table.tables().header().to$().find('th:eq(4)').css('min-width', '60px');
		table.tables().header().to$().find('th:eq(5)').css('min-width', '60px');
		table.tables().header().to$().find('th:eq(6)').css('min-width', '100px');
		table.tables().header().to$().find('th:eq(7)').css('min-width', '100px');
		table.tables().header().to$().find('th:eq(8)').css('min-width', '100px');
		table.tables().header().to$().find('th:eq(9)').css('min-width', '100px');
		table.tables().header().to$().find('th:eq(10)').css('min-width', '90px');
	    $(window).trigger('resize'); 
	    
		table.on( 'order.dt search.dt', function () {
			table.column(1, {search:'applied', order:'applied'}).nodes().each( function (cell, i) {
	            cell.innerHTML = i+1;
	        } );
	    } ).draw();
		
		//더블 클릭시
		$('#transferTargetTable tbody').on('dblclick','tr',function() {
				var data = table.row(this).data();
				var name = data.name;
	 			var popUrl = "/popup/transferTargetDetailRegForm.do?&&cnr_id=${cnr_id}&&name="+name; // 서버 url 팝업경로
	 			var width = 930;
	 			var height = 640;
	 			var left = (window.screen.width / 2) - (width / 2);
	 			var top = (window.screen.height /2) - (height / 2);
	 			var popOption = "width="+width+", height="+height+", top="+top+", left="+left+", resizable=no, scrollbars=yes, status=no, toolbar=no, titlebar=yes, location=no,";
	 			
	 			window.open(popUrl,"",popOption);
			});	
		
		//상세조회 클릭시
		$('#transferTargetTable tbody').on('click','#detail',function() {
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
		 $('#transferTargetTable tbody').on('click','#mappingBtn', function () {
		 		var $this = $(this);
		    	var $row = $this.parent().parent().parent();
		    	$row.addClass('detail');
		    	var datas = table.rows('.detail').data();
		    	if(datas.length==1) {
		    		var row = datas[0];
			    	$row.removeClass('detail');
					var popUrl = "/popup/transferMappingRegForm.do?cnr_id=${cnr_id}&&trf_trg_cnn_nm="+row.name; // 서버 url 팝업경로
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
		var table = $('#transferTargetTable').DataTable();
		$('#select').on( 'keyup', function () {
			table.columns(2).search( this.value ).draw();
		});	
		$('.dataTables_filter').hide();
		$.ajax({
			url : "/selectTransferTarget.do",
			data : {
				trf_trg_cnn_nm : '%'+$("#trf_trg_cnn_nm").val()+'%',
				cnr_id : cnr_id
			},
			dataType : "json",
			type : "post",
			beforeSend: function(xhr) {
		        xhr.setRequestHeader("AJAX", true);
		     },
			error : function(xhr, status, error) {
				if(xhr.status == 401) {
					alert('<spring:message code="message.msg02" />');
					 location.href = "/";
				} else if(xhr.status == 403) {
					alert('<spring:message code="message.msg03" />');
		             location.href = "/";
				} else {
					alert("ERROR CODE : "+ xhr.status+ "\n\n"+ "ERROR Message : "+ error+ "\n\n"+ "Error Detail : "+ xhr.responseText.replace(/(<([^>]+)>)/gi, ""));
				}
			},
			success : function(result) {
				table.clear().draw();
				if(result.error != null){
					alert('<spring:message code="message.msg173"/>');
				}else if(result.data != null){
					table.rows.add(result.data).draw();
				}
			}
		});
	
	});
	
	/*조회버튼 클릭시*/
	function fn_select(){
		$.ajax({
			url : "/selectTransferTarget.do",
			data : {
				trf_trg_cnn_nm : '%'+$("#trf_trg_cnn_nm").val()+'%',
				cnr_id : cnr_id
			},
			dataType : "json",
			type : "post",
			beforeSend: function(xhr) {
		        xhr.setRequestHeader("AJAX", true);
		     },
			error : function(xhr, status, error) {
				if(xhr.status == 401) {
					alert('<spring:message code="message.msg02" />');
					 location.href = "/";
				} else if(xhr.status == 403) {
					alert('<spring:message code="message.msg03" />');
		             location.href = "/";
				} else {
					alert("ERROR CODE : "+ xhr.status+ "\n\n"+ "ERROR Message : "+ error+ "\n\n"+ "Error Detail : "+ xhr.responseText.replace(/(<([^>]+)>)/gi, ""));
				}
			},
			success : function(result) {
				table.clear().draw();
				if(result.data != null){
					table.rows.add(result.data).draw();
				}
			}
		});
	}

	/*등록버튼 클릭시*/
	function fn_insert(){
		var popUrl = "/popup/transferTargetRegForm.do?act=i&&cnr_id="+cnr_id; // 서버 url 팝업경로
		var width = 930;
		var height = 630;
		var left = (window.screen.width / 2) - (width / 2);
		var top = (window.screen.height /2) - (height / 2);
		var popOption = "width="+width+", height="+height+", top="+top+", left="+left+", resizable=no, scrollbars=yes, status=no, toolbar=no, titlebar=yes, location=no,";
		
		window.open(popUrl,"",popOption);
	}
	
	/*수정버튼 클릭시*/
	function fn_update(){
		var datas = table.rows('.selected').data();
		if (datas.length == 1) {
			var name = table.row('.selected').data().name;
			var popUrl = "/popup/transferTargetRegForm.do?act=u&&cnr_id=${cnr_id}&&name="+name; // 서버 url 팝업경로
			var width = 930;
			var height = 630;
			var left = (window.screen.width / 2) - (width / 2);
			var top = (window.screen.height /2) - (height / 2);
			var popOption = "width="+width+", height="+height+", top="+top+", left="+left+", resizable=no, scrollbars=yes, status=no, toolbar=no, titlebar=yes, location=no,";
			
			window.open(popUrl,"",popOption);
		} else {
			alert('<spring:message code="message.msg04" />');
			return false;
		}

	}
	
	/*삭제버튼 클릭시*/
	function fn_delete(){
		var datas = table.rows('.selected').data();
		if (datas.length <= 0) {
			alert('<spring:message code="message.msg04" />');
			return false;
		} else {
			if (!confirm('<spring:message code="message.msg162"/>'))return false;
			var rowList = [];
			for (var i = 0; i < datas.length; i++) {
				rowList += datas[i].name + ',';
			}
			
			$.ajax({
				url : "/deleteTransferTarget.do",
				data : {
					name : rowList,
					cnr_id : cnr_id
				},
				dataType : "json",
				type : "post",
				beforeSend: function(xhr) {
			        xhr.setRequestHeader("AJAX", true);
			     },
				error : function(xhr, status, error) {
					if(xhr.status == 401) {
						alert('<spring:message code="message.msg02" />');
						 location.href = "/";
					} else if(xhr.status == 403) {
						alert('<spring:message code="message.msg03" />');
			             location.href = "/";
					} else {
						alert("ERROR CODE : "+ xhr.status+ "\n\n"+ "ERROR Message : "+ error+ "\n\n"+ "Error Detail : "+ xhr.responseText.replace(/(<([^>]+)>)/gi, ""));
					}
				},
				success : function(result) {
					if (result) {
						alert('<spring:message code="message.msg60" />');
						fn_select();
					} else {
						alert('<spring:message code="message.msg168"/>');
					}
				}
			});
		}
	}
</script>
<!-- contents -->
<div id="contents">
	<div class="contents_wrap">
		<div class="contents_tit">
			<h4><spring:message code="menu.connector_settings" /><a href="#n"><img src="../images/ico_tit.png" class="btn_info"/></a></h4>
			<div class="infobox"> 
				<ul>
					<li><spring:message code="help.connector_settings_01" /></li>
					<li><spring:message code="help.connector_settings_02" /></li>
				</ul>
			</div>
			<div class="location">
				<ul>
					<li><spring:message code="menu.data_transfer" /></li>
					<li>${cnr_nm}</li>
					<li class="on"><spring:message code="menu.connector_settings" /></li>
				</ul>
			</div>
		</div>
		<div class="contents">
			<div class="cmm_grp">
				<div class="btn_type_01">
					<span class="btn" onclick="fn_insert();"><button><spring:message code="common.registory" /></button></span> 
					<span class="btn" onclick="fn_update();"><button><spring:message code="common.modify" /></button></span> 
					<span class="btn" onclick="fn_delete();"><button><spring:message code="common.delete" /></button></span>
				</div>
				<div class="sch_form">
					<table class="write">
						<caption>검색 조회</caption>
						<colgroup>
							<col style="width: 100px;" />
							<col />
						</colgroup>
						<tbody>
							<tr>
								<th scope="row" class="t5"><spring:message code="data_transfer.connect_name" /></th>
								<td><input type="text" class="txt t2" name="trf_trg_cnn_nm" id="select"/></td>
							</tr>
						</tbody>
					</table>
				</div>
				<div class="overflow_area">
					<table id="transferTargetTable" class="display" cellspacing="0" width="100%">
						<thead>
							<tr>
								<th width="10"></th>
								<th width="20"><spring:message code="common.no" /></th>
								<th width="100"><spring:message code="data_transfer.connect_name" /></th>
								<th width="350"><spring:message code="data_transfer.hdfs_url" /> </th>
								<th width="60"><spring:message code="data_transfer.tasks_max" />  </th>
								<th width="60"><spring:message code="data_transfer.flush_size" /> </th>
								<th width="100"><spring:message code="data_transfer.rotate_interval_ms" /></th>
								<th width="100"><spring:message code="common.dbms_name" /> </th>
								<th width="100"><spring:message code="common.database" /> </th>
								<th width="100"><spring:message code="data_transfer.detail_search" />  </th>
								<th width="90"><spring:message code="data_transfer.mapping_settings" /></th>
							</tr>
						</thead>
					</table>
				</div>
			</div>
		</div>
	</div>
</div>
<!-- // contents -->