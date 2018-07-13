<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@include file="../cmmn/cs.jsp"%>
<%
	/**
	* @Class Name : accesscontrol.jsp
	* @Description : accesscontrol 화면
	* @Modification Information
	*
	*   수정일         수정자                   수정내용
	*  ------------    -----------    ---------------------------
	*  2017.06.26     최초 생성
	*
	* author 김주영 사원
	* since 2017.06.26 
	*
	*/
%>
<script>
	var table = null;
	
	function fn_init() {
		table = $('#accessControlTable').DataTable({
			scrollY : "350px",
			bSort: false,
			paging: false,
			scrollX: true,
			columns : [
				{ data : "Seq", defaultContent : "", targets : 0, orderable : false, checkboxes : {'selectRow' : true}}, 
				{ data : "", className : "dt-center", defaultContent : ""}, 
				{ data : "Type", defaultContent : ""},
				{ data : "Database",
 					render : function(data, type, full, meta) {	 	
 						var html = '';					
 						html += '<span title="'+full.Database+'">' + full.Database + '</span>';
 						return html;
 					},
 					defaultContent : ""
 				},
 				{ data : "User",
 					render : function(data, type, full, meta) {	 	
 						var html = '';					
 						html += '<span title="'+full.User+'">' + full.User + '</span>';
 						return html;
 					},
 					defaultContent : ""
 				}, 
				{ data : "Ipadr", defaultContent : ""}, 
				{ data : "Ipmask", defaultContent : ""}, 
				{ data : "Method", defaultContent : ""}, 
				{ data : "Option", defaultContent : ""}, 
				{ data : "",	
					className: "dt-center",							
					defaultContent : "",
					render: function (data, type, full, meta,row) {
						if (type === 'display') {
							var $exe_order = $('<div class="order_exc">');
							$('<a class="dtMoveUp"><img src="../images/ico_order_up.png" alt="" /></a>').appendTo($exe_order);					
							$('<a class="dtMoveDown"><img src="../images/ico_order_down.png" alt="" /></a>').appendTo($exe_order);																												
							$('</div>').appendTo($exe_order);
							return $exe_order.html();
						}
					}
			},
			 ],'drawCallback': function (settings) {
					// Remove previous binding before adding it
					$('.dtMoveUp').unbind('click');
					$('.dtMoveDown').unbind('click');
					// Bind clicks to functions
					$('.dtMoveUp').click(moveUp);
					$('.dtMoveDown').click(moveDown);
				},'select': {'style': 'multi'}
		});
		
		table.tables().header().to$().find('th:eq(0)').css('min-width', '20px');
		table.tables().header().to$().find('th:eq(1)').css('min-width', '40px');
		table.tables().header().to$().find('th:eq(2)').css('min-width', '40px');
		table.tables().header().to$().find('th:eq(3)').css('min-width', '100px');
		table.tables().header().to$().find('th:eq(4)').css('min-width', '100px');
		table.tables().header().to$().find('th:eq(5)').css('min-width', '100px');
		table.tables().header().to$().find('th:eq(6)').css('min-width', '100px');
		table.tables().header().to$().find('th:eq(7)').css('min-width', '80px');
		table.tables().header().to$().find('th:eq(8)').css('min-width', '100px');
		table.tables().header().to$().find('th:eq(9)').css('min-width', '60px');
	    $(window).trigger('resize');
	    
	    
		// Move the row up
		function moveUp() {
			var tr = $(this).parents('tr');
			moveRow(tr, 'up');
		}

		// Move the row down
		function moveDown() {
			var tr = $(this).parents('tr');
			moveRow(tr, 'down');
		}

	  	// Move up or down (depending...)
	  	function moveRow(row, direction) {
	  		var check= document.getElementsByName("check");
			for (var i=0; i<check.length; i++){
				if(check[i].checked ==true){
					var db_id = check[i].value;
				}
			}
			var index = table.row(row).index();
 			var rownum = -1;
 			if (direction === 'down') {
 			    	rownum = 1;
 			}
	  		var data1 = table.row(index).data();
	  		var data2 = table.row(index + rownum).data();
			data1.Seq =  Number(data1.Seq)+rownum; 
 			data2.Seq =  Number(data2.Seq)-rownum;
 			table.row(index).data(data2);
 			table.row(index + rownum).data(data1);
 			table.draw(true);
 			 		 
		}
	  
		table.on( 'order.dt search.dt', function () {
			table.column(1, {search:'applied', order:'applied'}).nodes().each( function (cell, i) {
	            cell.innerHTML = i+1;
	        } );
	    } ).draw();
		

	    
		//더블 클릭시
		$('#accessControlTable tbody').on('dblclick','tr',function() {
			var idx = table.row(this).index();
			var User = table.row(this).data().User;
			var Seq = table.row(this).data().Seq;
			var Method = table.row(this).data().Method;
			var Database = table.row(this).data().Database;
			var Type = table.row(this).data().Type;
			var Ipadr = table.row(this).data().Ipadr;
			var Ipmask = table.row(this).data().Ipmask;
			var Option = table.row(this).data().Option;
			
			var popUrl = "/popup/accessControlRegForm.do?act=u&&db_svr_id=${db_svr_id}&&User="+User+"&&Seq="+Seq+"&&Method="+Method+"&&Database="+Database+"&&Type="+Type+"&&Ipadr="+Ipadr+"&&Ipmask="+Ipmask+"&&Option="+Option+"&&idx="+idx; // 서버 url 팝업경로
			var width = 1000;
			var height = 480;
			var left = (window.screen.width / 2) - (width / 2);
			var top = (window.screen.height /2) - (height / 2);
			var popOption = "width="+width+", height="+height+", top="+top+", left="+left+", resizable=no, scrollbars=no, status=no, toolbar=no, titlebar=yes, location=no,";
					
			window.open(popUrl,"",popOption);
		});		
	}


	$(window.document).ready(function() {
		var extName = "${extName}";
		if(extName == "agent") {
			alert("<spring:message code='message.msg25' />");
			top.location.href = "/";
		}else if(extName == "adminpack"){
			alert("<spring:message code='message.msg215' />");
			top.location.href = "/";
		}else if(extName == "agentfail"){
			alert("<spring:message code='message.msg27' />");
			top.location.href = "/";
		}else{
			fn_init();
			var table = $('#accessControlTable').DataTable();
			$('#select').on( 'keyup', function () {
				 table.search( this.value ).draw();
			});	
			$('.dataTables_filter').hide();
	 		 $.ajax({
	 			url : "/selectAccessControl.do",
	 			data : {
	 				db_svr_id : "${db_svr_id}",
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
	 				table.clear().draw();
	 				table.rows.add(result.data).draw();
	 			}
	 		});  			
		}	
	});

	/* 조회 버튼 클릭시*/
	function fn_select() {
		 $.ajax({
			url : "/selectAccessControl.do",
			data : {
				db_svr_id : "${db_svr_id}",
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
				table.rows.add(result.data).draw();
			}
		}); 
		 
	}

	function fn_isnertSave(result){
		var data = table.rows().data();
        for (var i = 0; i < data.length; i++) {
        	if(result.ctf_tp_nm==(table.rows().data()[i].Type==undefined?'':table.rows().data()[i].Type)
        		&& 	result.dtb==(table.rows().data()[i].Database==undefined?'':table.rows().data()[i].Database)
        		&& 	result.prms_usr_id==(table.rows().data()[i].User==undefined?'':table.rows().data()[i].User)
        		&& 	result.prms_ipadr==(table.rows().data()[i].Ipadr==undefined?'':table.rows().data()[i].Ipadr)
        		&& 	result.prms_ipmaskadr==(table.rows().data()[i].Ipmask==undefined?'':table.rows().data()[i].Ipmask)
        		&& 	result.ctf_mth_nm==(table.rows().data()[i].Method==undefined?'':table.rows().data()[i].Method)
        		&& 	result.opt_nm==(table.rows().data()[i].Option==undefined?'':table.rows().data()[i].Option)
        	){
        		alert("<spring:message code='message.msg28' />");
        		return false;
        	}
        }    
		
		table.row.add( {
			        "Type":		result.ctf_tp_nm,
			        "Database":	result.dtb,
			        "User":		result.prms_usr_id,
			        "Ipadr":	result.prms_ipadr,
			        "Ipmask":	result.prms_ipmaskadr,
			        "Method":	result.ctf_mth_nm,
			        "Option":	result.opt_nm
			    } ).draw();	
		
	}
	
	function fn_updateSave(result){
		var data = table.rows().data();
        for (var i = 0; i < data.length; i++) {
        	if(result.ctf_tp_nm==(table.rows().data()[i].Type==undefined?'':table.rows().data()[i].Type)
        		&& 	result.dtb==(table.rows().data()[i].Database==undefined?'':table.rows().data()[i].Database)
        		&& 	result.prms_usr_id==(table.rows().data()[i].User==undefined?'':table.rows().data()[i].User)
        		&& 	result.prms_ipadr==(table.rows().data()[i].Ipadr==undefined?'':table.rows().data()[i].Ipadr)
        		&& 	result.prms_ipmaskadr==(table.rows().data()[i].Ipmask==undefined?'':table.rows().data()[i].Ipmask)
        		&& 	result.ctf_mth_nm==(table.rows().data()[i].Method==undefined?'':table.rows().data()[i].Method)
        		&& 	result.opt_nm==(table.rows().data()[i].Option==undefined?'':table.rows().data()[i].Option)
        	){
        		alert("<spring:message code='message.msg136'/>");
        		return false;
        	}
        }    
        
		table.cell(result.idx, 2).data(result.ctf_tp_nm).draw();
		table.cell(result.idx, 3).data(result.dtb).draw();
		table.cell(result.idx, 4).data(result.prms_usr_id).draw();
		table.cell(result.idx, 5).data(result.prms_ipadr).draw();
		table.cell(result.idx, 6).data(result.prms_ipmaskadr).draw();
		table.cell(result.idx, 7).data(result.ctf_mth_nm).draw();
		table.cell(result.idx, 8).data(result.opt_nm).draw();
	}
	
	
	/* 등록 버튼 클릭시*/
	function fn_insert(){
		var popUrl = "/popup/accessControlRegForm.do?act=i&&db_svr_id=${db_svr_id}"; // 서버 url 팝업경로
		var width = 1000;
		var height = 480;
		var left = (window.screen.width / 2) - (width / 2);
		var top = (window.screen.height /2) - (height / 2);
		var popOption = "width="+width+", height="+height+", top="+top+", left="+left+", resizable=no, scrollbars=yes, status=no, toolbar=no, titlebar=yes, location=no,";
			
		window.open(popUrl,"",popOption);		
	
	}
	
	/* 수정 버튼 클릭시*/
	function fn_update(){
		var idx = table.row('.selected').index();
		var rowCnt = table.rows('.selected').data().length;
		if (rowCnt == 1) {
			var User = table.row('.selected').data().User;
			var Seq = table.row('.selected').data().Seq;
			var Method = table.row('.selected').data().Method;
			var Database = table.row('.selected').data().Database;
			var Type = table.row('.selected').data().Type;
			var Ipadr = table.row('.selected').data().Ipadr;
			var Ipmask = table.row('.selected').data().Ipmask;
			var Option = table.row('.selected').data().Option;
			
			var popUrl = "/popup/accessControlRegForm.do?act=u&&db_svr_id=${db_svr_id}&&User="+User+"&&Seq="+Seq+"&&Method="+Method+"&&Database="+Database+"&&Type="+Type+"&&Ipadr="+Ipadr+"&&Ipmask="+Ipmask+"&&Option="+Option+"&&idx="+idx; // 서버 url 팝업경로
			var width = 1000;
			var height = 480;
			var left = (window.screen.width / 2) - (width / 2);
			var top = (window.screen.height /2) - (height / 2);
			var popOption = "width="+width+", height="+height+", top="+top+", left="+left+", resizable=no, scrollbars=yes, status=no, toolbar=no, titlebar=yes, location=no,";
				
			window.open(popUrl,"",popOption);
		}else{
			alert("<spring:message code='message.msg04' />");
			return false;
		}			
	}

	/* 삭제 버튼 클릭시*/
	function fn_delete() {
		var datas = table.rows('.selected').data();
		if (datas.length <= 0) {
			alert("<spring:message code='message.msg04' />");
			return false;
		} else {
			if (!confirm("<spring:message code='message.msg17' />")) return false;
			var rows = table.rows( '.selected' ).remove().draw();
		}
	}
	
	/* 적용 버튼 클릭시 */
	function fn_save(){
		if (!confirm('<spring:message code="message.msg137"/>')) return false;
		var rowList = [];
		var data = table.rows().data();
        for (var i = 0; i < data.length; i++) {
           rowList.push(table.rows().data()[i]);
        }    
 		 $.ajax({
 			url : "/applyAccessControl.do",
 			data : {
 				rowList : JSON.stringify(rowList),
 				db_svr_id : "${db_svr_id}",
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
 				alert("<spring:message code='message.msg29' />");
 			}
 		});

	}
	

</script>

<!-- contents -->
<div id="contents">
	<div class="contents_wrap">
		<div class="contents_tit">
			<h4><spring:message code="menu.access_control" /><a href="#n"><img src="../images/ico_tit.png" class="btn_info" /></a></h4>
			<div class="infobox">
				<ul>
					<li><spring:message code="help.access_control" /></li>
				</ul>
			</div>
			<div class="location">
				<ul>
					<li class="bold">${db_svr_nm}</li>
					<li><spring:message code="menu.access_control_management" /></li>
					<li class="on"><spring:message code="menu.access_control" /></li>
				</ul>
			</div>
		</div>
		<div class="contents">
			<div class="cmm_grp">
				<div class="btn_type_01">
					<span class="btn" onclick="fn_insert();"><button type="button"><spring:message code="common.add" /></button></span>
					<span class="btn" onclick="fn_update();"><button type="button"><spring:message code="button.modify" /></button></span>
					<span class="btn" onclick="fn_delete();"><button type="button"><spring:message code="button.delete" /></button></span>
					<span class="btn" onclick="fn_save();"><button type="button"><spring:message code="common.apply" /></button></span>
				</div>
				<div class="overflow_area">
					<table id="accessControlTable" class="display" cellspacing="0" width="100%">
						<thead>
							<tr>
								<th width="20"></th>
								<th width="40"><spring:message code="common.no" /></th>
								<th width="40"><spring:message code="access_control_management.type" /></th>
								<th width="100"><spring:message code="access_control_management.database" /></th>
								<th width="100"><spring:message code="access_control_management.user" /></th>
								<th width="100"><spring:message code="access_control_management.ip_address" /></th>
								<th width="100"><spring:message code="access_control_management.ip_mask" /></th>
								<th width="80"><spring:message code="access_control_management.method" /></th>
								<th width="100"><spring:message code="access_control_management.option" /></th>
								<th width="60"><spring:message code="access_control_management.order" /></th>
							</tr>
						</thead>
					</table>
				</div>
			</div>
		</div>
	</div>
</div>
<!-- // contents -->
