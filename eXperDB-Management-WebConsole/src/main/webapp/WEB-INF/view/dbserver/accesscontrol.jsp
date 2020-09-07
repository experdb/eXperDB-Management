<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c"      uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="form"   uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="ui"     uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ include file="../cmmn/cs2.jsp"%>
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
<script type="text/javascript">
	var table = null;
	var editor;

	/* ********************************************************
	 * setting 초기 실행
	 ******************************************************** */
	$(window.document).ready(function() {
		//테이블 설정
		fn_init();

		//agent 확인
		var extName = "${extName}";

		if ($(".selectSearch").length) {
			$(".selectSearch").select2();
		}
		
		//agent 확인
		if (!fn_chkExtName(extName)) {
			$("#btnSave").prop("disabled", "disabled");
			$("#btnDelete").prop("disabled", "disabled");
			$("#btnModify").prop("disabled", "disabled");
			$("#btnInsert").prop("disabled", "disabled");
			return;
		}
		
		table = $('#accessControlTable').DataTable();
		$('#select').on( 'keyup', function () {
			 table.search( this.value ).draw();
		});
		$('.dataTables_filter').hide();
		fn_select(); 	
	});

	/* ********************************************************
	 * agent 상태 확인
	 ******************************************************** */
	function fn_chkExtName(extName) {
		var title = '<spring:message code="menu.access_control"/>' + ' ' + '<spring:message code="access_control_management.msg6" />';

 		if(extName == "adminpack") {
			showDangerToast('top-right', '<spring:message code="message.msg215" />', title);
			return false;
 		} else if(extName == "agent") {
			showDangerToast('top-right', '<spring:message code="message.msg25" />', title);
			return false;
		}else if(extName == "agentfail"){
			showDangerToast('top-right', '<spring:message code="message.msg27" />', title);
			return false;
		}
 		
 		return true;
	}

	/* ********************************************************
	 * 테이블 설정
	 ******************************************************** */
	function fn_init() {
		table = $('#accessControlTable').DataTable({
			scrollY : "500px",
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
	    				if (nvlPrmSet(full.Database, "") == "all") {
 	    					html += "<div class='badge badge-pill badge-success'>";
 	    					html += "	<i class='mdi mdi-check-all mr-2'></i>";
 	    					html += full.Database;
 	    					html += "</div>";
 	    				} else {
 	    					html += '<span title="'+full.Database+'">' + full.Database + '</span>';
 	    				}
 						return html;
 					},
 					defaultContent : ""
 				},
 				{ data : "User",
 					render : function(data, type, full, meta) {	 	
 						var html = '';	
	    				if (nvlPrmSet(full.User, "") == "all") {
 	    					html += "<div class='badge badge-pill badge-success'>";
 	    					html += "	<i class='mdi mdi-check-all mr-2'></i>";
 	    					html += full.User;
 	    					html += "</div>";
 	    				} else {
 	 						html += '<span title="'+full.User+'">' + full.User + '</span>';
 	    				}

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
							$('<a class="dtMoveUp"><div class="badge badge-pill badge-success"><i class="fa fa-angle-double-up" style="font-size: 18px;cursor:pointer;"></i></div></a>').appendTo($exe_order);					
							$('<a class="dtMoveDown"><div class="badge badge-pill badge-warning"><i class="fa fa-angle-double-down" style="font-size: 18px;cursor:pointer;"></i></div></a></a>').appendTo($exe_order);	
	
							$('</div>').appendTo($exe_order);
							return $exe_order.html();
						}
					}
				}
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
	  		var totDatas = table.rows().data();
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

 			if (data1.Seq == 0 && direction === 'up') {
 				return;
 			}
 
  			if (data1.Seq == (totDatas.length -1) && direction === 'down') {
 				return;
 			}
 			
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
	    }).draw();

		//더블 클릭시
		$('#accessControlTable tbody').on('dblclick','tr',function() {
			fn_ddClickupdate(this);
		});		
	}

	/* ********************************************************
	 * 메인 조회
	 ******************************************************** */
	function fn_select() {
		$('#nowpwd_alert-danger').hide();

		 $.ajax({
			url : "/selectAccessControl.do",
			data : {
				db_svr_id : $("#db_svr_id", "#findList").val()
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
				table.rows({selected: true}).deselect();
				table.clear().draw();

				if (nvlPrmSet(result, '') != '') {
					table.rows.add(result.data).draw();
				}
			}
		});
	}

	/* ********************************************************
	 * 등록 추가셋팅
	 ******************************************************** */
 	function fn_isnertSave(result){
		var data = table.rows().data();
        for (var i = 0; i < data.length; i++) {
        	if(result.ctf_tp_nm==(table.rows().data()[i].Type==undefined?'':table.rows().data()[i].Type)
        		&& 	result.dtb==(table.rows().data()[i].Database==undefined?'':table.rows().data()[i].Database)
        		&& 	result.prms_usr_id==(table.rows().data()[i].User==undefined?'':table.rows().data()[i].User)
        		&& 	result.prms_ipadr==(table.rows().data()[i].Ipadr==undefined?'':table.rows().data()[i].Ipadr)
        		&& 	result.prms_ipmaskadr==(table.rows().data()[i].Ipmask==undefined?'':table.rows().data()[i].Ipmask)
        		&& 	result.ctf_mth_nm==(table.rows().data()[i].Method==undefined?'':table.rows().data()[i].Method)
        		&& 	result.opt_nm==(table.rows().data()[i].Option==undefined?'':table.rows().data()[i].Option))
        	{
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

	/* ********************************************************
	 * 수정 추가셋팅
	 ******************************************************** */
 	function fn_updateSave(result){
		var data = table.rows().data();
		var tblIdx = $("#idx", "#findList").val();
        for (var i = 0; i < data.length; i++) {
        	if(result.ctf_tp_nm==(table.rows().data()[i].Type==undefined?'':table.rows().data()[i].Type)
        		&& 	result.dtb==(table.rows().data()[i].Database==undefined?'':table.rows().data()[i].Database)
        		&& 	result.prms_usr_id==(table.rows().data()[i].User==undefined?'':table.rows().data()[i].User)
        		&& 	result.prms_ipadr==(table.rows().data()[i].Ipadr==undefined?'':table.rows().data()[i].Ipadr)
        		&& 	result.prms_ipmaskadr==(table.rows().data()[i].Ipmask==undefined?'':table.rows().data()[i].Ipmask)
        		&& 	result.ctf_mth_nm==(table.rows().data()[i].Method==undefined?'':table.rows().data()[i].Method)
        		&& 	result.opt_nm==(table.rows().data()[i].Option==undefined?'':table.rows().data()[i].Option))
        	{
        		return false;
        	}
        }    
        
		table.cell(tblIdx, 2).data(result.ctf_tp_nm).draw();
		table.cell(tblIdx, 3).data(result.dtb).draw();
		table.cell(tblIdx, 4).data(result.prms_usr_id).draw();
		table.cell(tblIdx, 5).data(result.prms_ipadr).draw();
		table.cell(tblIdx, 6).data(result.prms_ipmaskadr).draw();
		table.cell(tblIdx, 7).data(result.ctf_mth_nm).draw();
		table.cell(tblIdx, 8).data(result.opt_nm).draw();
	}

	/* ********************************************************
	 * 추가버튼 클릭시
	 ******************************************************** */
	function fn_insert(){
		accessUpdateRow = new Object();
		
		$.ajax({
			url : "/popup/accessControlRegForm.do",
			data : {
				db_svr_id : $("#db_svr_id", "#findList").val(),
				act : "i"
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
				fn_insert_chogihwa("reg", result);

				$('#pop_layer_access_reg').modal("show");
			}
		});
	}
	
	/* ********************************************************
	 * 등록 팝업 초기화
	 ******************************************************** */
	function fn_insert_chogihwa(gbn, result) {
		$("#ins_db_svr_nm", "#accessRegForm").val(nvlPrmSet(result.db_svr_nm, "")); //dbms명
		$("#ins_dtb", "#accessRegForm").val("all").trigger('change');				//Database
		$("#ins_ctf_tp_nm option:eq(0)", "#accessRegForm").prop("selected", true).trigger('change');	//Type
		$("#ins_ip", "#accessRegForm").val("");										//IP
		$("#ins_prefix", "#accessRegForm").val("");									//prefix
		$("#ins_usr_id", "#accessRegForm").val("all").trigger('change');			//User
		$("#ins_ipmaskadr", "#accessRegForm").val("");							//Ipmask
		$("#ins_ctf_mth_nm option:eq(0)", "#accessRegForm").prop("selected", true).trigger('change');	//Method
		$("#ins_opt_nm", "#accessRegForm").val("");									//Option

		if (gbn == "reg") {
			$("#ModalLabel_ins").show();
			$("#ModalLabel_udt").hide();

			$("#act", "#findList").val("i");
		} else {
			$("#ModalLabel_ins").hide();
			$("#ModalLabel_udt").show();
			
			$("#act", "#findList").val("u");

 			var prms_dtb = nvlPrmSet(accessUpdateRow.database, "all"); 		//데이터베이스
			var prms_ctf_tp_nm = nvlPrmSet(accessUpdateRow.type, "");		//type
			var prms_ipadr = nvlPrmSet(accessUpdateRow.ipadr, "");			//ip / prefix
			var prms_usr_id = nvlPrmSet(accessUpdateRow.user, "all");		//user
			var prms_ipmask = nvlPrmSet(accessUpdateRow.ipmask, "");		//ipmask
			var prms_ctf_mth_nm = nvlPrmSet(accessUpdateRow.method, "");	//method
			var prms_opt_nm = nvlPrmSet(accessUpdateRow.option, "");		//option
			var prms_idx = nvlPrmSet(accessUpdateRow.idx, "");				//idx

			$("#ins_dtb", "#accessRegForm").val(prms_dtb).prop("selected",true).trigger('change'); //데이터베이스
			if (nvlPrmSet($("#ins_dtb", "#accessRegForm").val(),"") == "") {
				$("#ins_dtb", "#accessRegForm").val("all").prop("selected",true).trigger('change');
			}
			
			$("#ins_ctf_tp_nm", "#accessRegForm").val(prms_ctf_tp_nm).prop("selected",true).trigger('change'); //type
			if (nvlPrmSet($("#ins_ctf_tp_nm", "#accessRegForm").val(),"") == "") {
				$("#ins_ctf_tp_nm option:eq(0)", "#accessRegForm").prop("selected", true).trigger('change');
			}
	
			if (prms_ipadr != "") {											//ip / prefix
				var str_prms_ipdr = prms_ipadr.split("/");
				$("#ins_ip", "#accessRegForm").val(str_prms_ipdr[0]);
				
				if (str_prms_ipdr[1]==null) {
					$("#ins_prefix", "#accessRegForm").attr('disabled', 'true');
				} else {
					$("#ins_ipmaskadr", "#accessRegForm").attr('disabled', 'true');
					$("#ins_prefix", "#accessRegForm").val(str_prms_ipdr[1]);
				}
			}

			$("#ins_usr_id", "#accessRegForm").val(prms_usr_id).prop("selected",true).trigger('change'); //user
			if (nvlPrmSet($("#ins_usr_id", "#accessRegForm").val(),"") == "") {
				$("#ins_usr_id", "#accessRegForm").val("all").trigger('change');
			}
			
			$("#ins_ipmaskadr", "#accessRegForm").val(prms_ipmask);										//mask
			
			$("#ins_ctf_mth_nm", "#accessRegForm").val(prms_ctf_mth_nm).prop("selected",true).trigger('change'); //type
			if (nvlPrmSet($("#ins_ctf_mth_nm", "#accessRegForm").val(),"") == "") {
				$("#ins_ctf_mth_nm option:eq(0)", "#accessRegForm").prop("selected", true).trigger('change');
			}
			
			$("#ins_opt_nm", "#accessRegForm").val(prms_opt_nm);										//option

			$("#idx", "#findList").val(prms_idx);
		}

		//셋팅
		fn_initInputSet();

	}

	/* ********************************************************
	 * 수정 버튼 클릭시
	 ******************************************************** */
 	function fn_update(){
		var idx = table.row('.selected').index();
		var rowCnt = table.rows('.selected').data().length;
		
		if (rowCnt <= 0) {
			showSwalIcon('<spring:message code="message.msg35" />', '<spring:message code="common.close" />', '', 'error');
			return;
		}else if(rowCnt > 1){
			showSwalIcon('<spring:message code="message.msg04" />', '<spring:message code="common.close" />', '', 'error');
			return;
		}

		accessUpdateRow = new Object();
		accessUpdateRow.user= table.row('.selected').data().User;
		accessUpdateRow.seq = table.row('.selected').data().Seq;
		accessUpdateRow.method = table.row('.selected').data().Method;
		accessUpdateRow.database = table.row('.selected').data().Database;
		accessUpdateRow.type = table.row('.selected').data().Type;
		accessUpdateRow.ipadr = table.row('.selected').data().Ipadr;
		accessUpdateRow.ipmask = table.row('.selected').data().Ipmask;
		accessUpdateRow.option = table.row('.selected').data().Option;
		accessUpdateRow.idx = idx;

		$.ajax({
			url : "/popup/accessControlRegForm.do",
			data : {
				db_svr_id : $("#db_svr_id", "#findList").val(),
				act : "u"
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
				fn_insert_chogihwa("udt", result, accessUpdateRow);

				$('#pop_layer_access_reg').modal("show");
			}
		});	
	}

	/* ********************************************************
	 * 삭제 버튼 클릭 실행
	 ******************************************************** */
	function fn_delete_confirm() {
		var datas = table.rows('.selected').data();
		
		if (datas.length <= 0) {
			showSwalIcon('<spring:message code="message.msg35"/>', '<spring:message code="common.close" />', '', 'error');
			return;
		}
		
		confile_title = '<spring:message code="menu.access_control" />' + " " + '<spring:message code="button.delete" />' + " " + '<spring:message code="common.request" />';

		$('#con_multi_gbn', '#findConfirmMulti').val("del");
		
		$('#confirm_multi_tlt').html(confile_title);
		$('#confirm_multi_msg').html('<spring:message code="message.msg17" />');
		$('#pop_confirm_multi_md').modal("show");
	}

	/* ********************************************************
	 * 삭제 기능 실행
	 ******************************************************** */
	function fn_delete() {
		table.rows( '.selected' ).remove().draw();
		$('#nowpwd_alert-danger').show();
		
		showDangerToast('top-right', '<spring:message code="access_control_management.msg2" />', '<spring:message code="access_control_management.msg3" />');
	}

	/* ********************************************************
	 * 적용 버튼 클릭 실행
	 ******************************************************** */
	function fn_save_confirm(){
		var datas = table.rows().data();
		
		if (datas.length <= 0) {
			showSwalIcon('<spring:message code="info.nodata.msg"/>', '<spring:message code="common.close" />', '', 'error');
			return;
		}
		
		$('#con_multi_gbn', '#findConfirmMulti').val("save_confirm");
		
		confile_title = '<spring:message code="menu.access_control" />' + " " + '<spring:message code="common.apply" />' + " " + '<spring:message code="common.request" />';
		$('#confirm_multi_tlt').html(confile_title);
		$('#confirm_multi_msg').html('<spring:message code="message.msg137" />');
		$('#pop_confirm_multi_md').modal("show");
	}

	/* ********************************************************
	 * confirm result
	 ******************************************************** */
	function fnc_confirmMultiRst(gbn){
		if (gbn == "save_confirm") {
			fn_save();
		} else if (gbn == "del") {
			fn_delete();
		}
	}

	/* ********************************************************
	 * 적용 기능 실행
	 ******************************************************** */
 	function fn_save(){
		var rowList = [];
		var data = table.rows().data();

        for (var i = 0; i < data.length; i++) {
           rowList.push(table.rows().data()[i]);
        }

 		 $.ajax({
 			url : "/applyAccessControl.do",
 			data : {
 				rowList : JSON.stringify(rowList),
				db_svr_id : $("#db_svr_id", "#findList").val()
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
 				showSwalIcon('<spring:message code="message.msg29"/>', '<spring:message code="common.close" />', '', 'success');
 				fn_select();
 			}
 		});

	}
	
	/* ********************************************************
	 * row 클릭 수정 버튼 클릭시
	 ******************************************************** */
 	function fn_ddClickupdate(obj){
 		var idx = table.row(obj).index();
 		
		accessUpdateRow = new Object();
		accessUpdateRow.user= table.row(obj).data().User;
		accessUpdateRow.seq = table.row(obj).data().Seq;
		accessUpdateRow.method = table.row(obj).data().Method;
		accessUpdateRow.database = table.row(obj).data().Database;
		accessUpdateRow.type = table.row(obj).data().Type;
		accessUpdateRow.ipadr = table.row(obj).data().Ipadr;
		accessUpdateRow.ipmask = table.row(obj).data().Ipmask;
		accessUpdateRow.option = table.row(obj).data().Option;
		accessUpdateRow.idx = idx;
 		
		$.ajax({
			url : "/popup/accessControlRegForm.do",
			data : {
				db_svr_id : $("#db_svr_id", "#findList").val(),
				act : "u"
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
				fn_insert_chogihwa("udt", result, accessUpdateRow);

				$('#pop_layer_access_reg').modal("show");
			}
		});	
	}
</script>

<%@include file="./../popup/confirmMultiForm.jsp"%>
<%@include file="./../popup/accessControlRegForm.jsp"%>

<form name="findList" id="findList" method="post">
	<input type="hidden" name="db_svr_id" id="db_svr_id" value="${db_svr_id}"/>
	<input type="hidden" name="act" id="act" value=""/>
	<input type="hidden" name="idx" id="idx" value=""/>
</form>

<div class="content-wrapper main_scroll"  style="min-height: calc(100vh);" id="contentsDiv">
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
												<i class="fa fa-lock"></i>
												<span class="menu-title"><spring:message code="menu.access_control"/></span>
												<i class="menu-arrow_user" id="titleText" ></i>
											</a>
										</h6>
									</div>
									<div class="col-7">
					 					<ol class="mb-0 breadcrumb_main justify-content-end bg-info" >
					 						<li class="breadcrumb-item_main" style="font-size: 0.875rem;">
					 							<a class="nav-link_title" href="/property.do?db_svr_id=${db_svr_id}" style="padding-right: 0rem;">${db_svr_nm}</a>
					 						</li>
					 						<li class="breadcrumb-item_main" style="font-size: 0.875rem;" aria-current="page"><spring:message code="menu.access_control_management"/></li>
											<li class="breadcrumb-item_main active" style="font-size: 0.875rem;" aria-current="page"><spring:message code="menu.access_control"/></li>
										</ol>
									</div>
								</div>
							</div>
							
							<div id="page_header_sub" class="collapse" role="tabpanel" aria-labelledby="page_header_div" data-parent="#accordion">
								<div class="card-body">
									<div class="row">
										<div class="col-12">
											<p class="mb-0"><spring:message code="help.access_control"/></p>
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

		<div class="col-12 stretch-card div-form-margin-table">
			<div class="card">
				<div class="card-body">
					<div class="row" style="margin-top:-20px;">
						<div class="col-6">
							<div class="alert alert-fill-danger" style="margin-top: 1.5rem !important;display:none;" id="nowpwd_alert-danger">
								<i class="ti-info-alt"></i>
								<spring:message code="access_control_management.msg1" />
							</div>
						</div>

						<div class="col-6">
							<div class="template-demo">	
								<button type="button" class="btn btn-outline-primary btn-icon-text float-right" id="btnSave" onClick="fn_save_confirm();" >
									<i class="fa fa-check btn-icon-prepend "></i><spring:message code="common.apply" />
								</button>
													
								<button type="button" class="btn btn-outline-primary btn-icon-text float-right" id="btnDelete" onClick="fn_delete_confirm();" >
									<i class="ti-trash btn-icon-prepend "></i><spring:message code="common.delete" />
								</button>
								<button type="button" class="btn btn-outline-primary btn-icon-text float-right" id="btnModify" onClick="fn_update();" data-toggle="modal">
									<i class="ti-pencil-alt btn-icon-prepend "></i><spring:message code="common.modify" />
								</button>
								<button type="button" class="btn btn-outline-primary btn-icon-text float-right" id="btnInsert" onClick="fn_insert();" data-toggle="modal">
									<i class="ti-pencil btn-icon-prepend "></i><spring:message code="common.add" />
								</button>
							</div>
						</div>
					</div>

					<div class="card my-sm-2" >
						<div class="card-body" >
							<div class="row">
								<div class="col-12">
 									<div class="table-responsive">
										<div id="order-listing_wrapper"
											class="dataTables_wrapper dt-bootstrap4 no-footer">
											<div class="row">
												<div class="col-sm-12 col-md-6">
													<div class="dataTables_length" id="order-listing_length">
													</div>
												</div>
											</div>
										</div>
									</div>

	 								<table id="accessControlTable" class="table table-hover table-striped system-tlb-scroll" style="width:100%;">
										<thead>
											<tr class="bg-info text-white">
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
					<!-- content-wrapper ends -->
				</div>
			</div>
		</div>
	</div>
</div>