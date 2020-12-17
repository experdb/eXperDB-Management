<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@include file="../cmmn/commonLocale.jsp"%>
<%
	/**
	* @Class Name : dbRegForm.jsp
	* @Description : 디비 등록 화면
	* @Modification Information
	*
	*   수정일         수정자                   수정내용
	*  ------------    -----------    ---------------------------
	*  2017.06.23     최초 생성
	*
	* author 변승우 대리
	* since 2017.06.12
	*
	*/
%>   
<script type="text/javascript">
var table_db = null;

function fn_init2(){
	/* 선택된 서버에 대한 데이터베이스 정보 */
     table_db = $('#dbList').DataTable({
    	 scrollX: true,	
		scrollY : "300px",
		searching : false,
		paging :false,
		bSort: false,
		columns : [
		{data : "rownum", defaultContent : "", targets : 0, orderable : false, checkboxes : {'selectRow' : true}}, 	
		{data : "dft_db_nm",  defaultContent : ""}, 
		{data : "db_exp", defaultContent : "",  
			targets: 0,
	        searchable: false,
	        orderable: false,
	        render: function(data, type, full, meta){
	           if(type === 'display'){
	              data = '<input type="text" class="txt" name="db_exp" maxlength="100" value="' +full.db_exp + '" style="width: 400px; height: 25px;">';      
	           }
	           return data;
	        }}, 			
		]
	});
	
     table_db.tables().header().to$().find('th:eq(0)').css('min-width', '30px');
     table_db.tables().header().to$().find('th:eq(1)').css('min-width', '300px');
     table_db.tables().header().to$().find('th:eq(2)').css('min-width', '550px');
     
	 $(window).trigger('resize');
}

$(window.document).ready(function() {
	fn_init2();

	/* 
	 * Repository DB에 등록되어 있는 DB의 서버명 SelectBox 
	 */
	  	$.ajax({
			url : "/selectSvrList.do",
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
				$("#db_svr_id").children().remove();
				$("#db_svr_nm").children().remove();
				if(result.length > 0){
					for(var i=0; i<result.length; i++){
						$("#db_svr_nm").append("<option value='"+result[i].db_svr_id+"'>"+result[i].db_svr_nm+"</option>");					
					}		
					document.serverList.db_ipadr.value = result[0].ipadr;
					document.serverList.portno.value = result[0].portno;
					fn_svr_db(result[0].db_svr_nm, result[0].db_svr_id);
				}									

			}
		}); 
	
});


/* ********************************************************
 * 서버에 등록된 디비 리스트 조회
 ******************************************************** */
function fn_svr_db(db_svr_nm, db_svr_id){
   	$.ajax({
		url : "/selectServerDBList.do",
		data : {
			db_svr_nm: db_svr_nm,			
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
			table_db.clear().draw();
			if(result.data == null){
				showSwalIcon('<spring:message code="message.msg05" />', '<spring:message code="common.close" />', '', 'error');
			}else{
				table_db.rows.add(result.data).draw();
				fn_dataCompareChcek(result,db_svr_id);
			}
		}
	});	
}


/* ********************************************************
 * 서버에 등록된 디비,  <=>  Repository에 등록된 디비 비교
 ******************************************************** */
function fn_dataCompareChcek(svrDbList,db_svr_id){
	$.ajax({
		url : "/selectDBList.do",
		data : {
			db_svr_id:db_svr_id
		},
		async:true,
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
			//DB목록 그리드의 설명 부분을 리스트로 가지고옴
			var list = $("input[name='db_exp']");
			if(svrDbList.data.length >= result.length){
			//서버디비 갯수
			for(var i = 0; i<svrDbList.data.length; i++){
				//repo디비 갯수
				for(var j = 0; j<result.length; j++){				
					list[j].value = result[j].db_exp;
					if(result[j].useyn == "Y"){
						 if(db_svr_id == result[j].db_svr_id && svrDbList.data[i].dft_db_nm == result[j].db_nm){		
							 $('input', table_db.rows(i).nodes()).prop('checked', true); 
							 table_db.rows(i).nodes().to$().addClass('selected');	
						}
					}
				}
			}	 
		}else{
			for(var i = 0; i<result.length; i++){				
				for(var j = 0; j<svrDbList.data.length; j++){
					if(result[i].db_nm == svrDbList.data[j].dft_db_nm){
						list[j].value = result[i].db_exp;
					}
					if(result[i].useyn == "Y"){
						//alert("["+i+"]"+result[i].db_nm+ "==["+j+"]"+ svrDbList.data[j].dft_db_nm);
						 if(db_svr_id == result[i].db_svr_id && result[i].db_nm == svrDbList.data[j].dft_db_nm){		
							 $('input', table_db.rows(i).nodes()).prop('checked', true); 
							 table_db.rows(i).nodes().to$().addClass('selected');	
						}
					}
				}
			}
		}
			
/* 			if(svrDbList.data.length>0){
 				for(var i = 0; i<svrDbList.data.length; i++){
					for(var j = 0; j<result.length; j++){						
							 $('input', table_db.rows(i).nodes()).prop('checked', false); 	
							 table_db.rows(i).nodes().to$().removeClass('selected');	
					}
				}	 	
				for(var i = 0; i<svrDbList.data.length; i++){
					var list = $("input[name='db_exp']");
					for(var j = 0; j<result.length; j++){	
						list[j].value = result[j].db_exp;
						if(result[j].useyn == "Y"){
						 if(db_svr_id == result[j].db_svr_id && svrDbList.data[i].dft_db_nm == result[j].db_nm){										 
							 $('input', table_db.rows(i).nodes()).prop('checked', true); 
							 table_db.rows(i).nodes().to$().addClass('selected');	
							}
						}
					}
				}		
			}  */
		}
	});	
}
 
 
 /* ********************************************************
  * SelectBox  변경시 해당 디비서버 및 디비 등록상태 조회
  ******************************************************** */
 function fn_dbserverChange(){
		/* 
		 * Repository DB에 등록되어 있는 DB의 서버명 SelectBox 
		 */
		  	$.ajax({
				url : "/selectSvrList.do",
				data : {
					db_svr_id : $("#db_svr_nm").val()		
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
					document.serverList.db_ipadr.value = result[0].ipadr;
					document.serverList.portno.value = result[0].portno;
					fn_svr_db(result[0].db_svr_nm, result[0].db_svr_id);
				}
			}); 	 
 }
 
 
 /* ********************************************************
  * 디비 등록
  ******************************************************** */
 function fn_insertDB(){
	 confile_title = '<spring:message code="common.database" />' + " " + '<spring:message code="common.registory" />' + " " + '<spring:message code="common.request" />';
		$('#con_multi_gbn', '#findConfirmMulti').val("ins");
		$('#confirm_multi_tlt').html(confile_title);
		$('#confirm_multi_msg').html('<spring:message code="message.msg160" />');
		$('#pop_confirm_multi_md').modal("show");
	  
 }
 
 /* ********************************************************
  * 디비 등록
  ******************************************************** */
 function fn_insertDB2(){
	var list = $("input[name='db_exp']");
	var datasArr = new Array();
 	var db_svr_id =  $("#db_svr_nm").val();	
 	var ipadr = $("#db_ipadr").val();	
 	var datas = table_db.rows().data();
 	
 	var checkCnt = table_db.rows('.selected').data().length;
 	if (datas.length > 0) {
 		var rows = [];
     	for (var i = 0;i<datas.length;i++) {
     		var rows = new Object();     		
     		var org_dbName = table_db.rows().data()[i].dft_db_nm;
			var returnValue = false;
     		
     		for(var j=0; j<checkCnt; j++) {    			           	 	
     			var chkDBName = table_db.rows('.selected').data()[j].dft_db_nm;
     			if(org_dbName  == chkDBName) {
     				returnValue = true;
     				break;
     			}
     		}
     		if(returnValue == true){
     	 		rows.db_exp = list[i].value;
     			rows.useyn = "Y";
     			rows.dft_db_nm = table_db.rows().data()[i].dft_db_nm;
     		}else{
     			rows.db_exp = list[i].value;
     			rows.useyn = "N";
     			rows.dft_db_nm = table_db.rows().data()[i].dft_db_nm;
     		}   		 
    		datasArr.push(rows);
 		}
 			$.ajax({
 				url : "/insertDB.do",
 				data : {
 					db_svr_id : db_svr_id,
 					ipadr : ipadr,
 					rows : JSON.stringify(datasArr)
 				},
 				async:true,
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
 					showSwalIconRst('<spring:message code="message.msg07" />', '<spring:message code="common.close" />', '', 'success', "reload");
 				}
 			});	

 	}else{
 		showSwalIcon('<spring:message code="message.msg06" />', '<spring:message code="common.close" />', '', 'error');
 	}
 }
 
</script>
<div class="modal fade" id="pop_layer_dbRegForm" tabindex="-1" role="dialog" aria-labelledby="ModalLabel" aria-hidden="true" data-backdrop="static" data-keyboard="false">
	<div class="modal-dialog  modal-xl-top" role="document" style="margin: 100px 250px;">
		<div class="modal-content" style="width:1100px;">			 
			<div class="modal-body" style="margin-bottom:-30px;">
				<h4 class="modal-title mdi mdi-alert-circle text-info" id="ModalLabel" style="padding-left:5px;">
					Datebase <spring:message code="button.create" />
				</h4>
				<div class="card" style="margin-top:10px;border:0px;">
					<div class="card-body">
							<fieldset>
								<form name="serverList" id="serverList" class="form-group row border-bottom">
									<label for="com_db_svr_nm" class="col-sm-2 col-form-label">
										<i class="item-icon fa fa-dot-circle-o"></i>
										<spring:message code="common.dbms_name" />
									</label>
									<div class="col-sm-9">
										<select class="form-control" style="width:250px; margin-right: 1rem;" id="db_svr_nm" name="db_svr_nm" onChange="fn_dbserverChange();"></select>
									</div>
									<label for="com_max_clusters" class="col-sm-2 col-form-label pop-label-index">
										<i class="item-icon fa fa-dot-circle-o"></i>
										<spring:message code="dbms_information.dbms_ip" />
									</label>
									<div class="col-sm-4">
										<input type="text" class="form-control" id="db_ipadr" name="db_ipadr" readonly>
									</div>
									<label for="com_max_clusters" class="col-sm-2 col-form-label pop-label-index">
										<i class="item-icon fa fa-dot-circle-o"></i>
										<spring:message code="data_transfer.port" />
									</label>
									<div class="col-sm-4">
										<input type="text" class="form-control" name="portno" id="portno"  readonly>
									</div>
								</form>
								<div class="form-group row">
									<div class="col-sm-12">
										<table id="dbList" class="table table-hover table-striped system-tlb-scroll" style="width:100%;">
											<thead>
												<tr class="bg-info text-white">
													<th width="30"><spring:message code="dbms_information.regChoice"/></th>
													<th width="300"><spring:message code="common.database" /></th>
													<th width="550"><spring:message code="common.desc" /> </th>								
												</tr>
											</thead>
										</table>
									</div>
								</div>
								<div class="top-modal-footer" style="text-align: center !important; margin: -20px 0 0 -20px;" >
									<input class="btn btn-primary" width="200px"style="vertical-align:middle;" type="button" onClick="fn_insertDB();" value='<spring:message code="common.save" />' />
									<button type="button" class="btn btn-light" data-dismiss="modal"><spring:message code="common.close"/></button>
								</div>
							</fieldset>
					</div>
				</div>
			</div>
		</div>
	</div>
</div>
