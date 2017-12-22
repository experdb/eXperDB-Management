<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>

<%
	/**
	* @Class Name : dbTree.jsp
	* @Description : dbTree 화면
	* @Modification Information
	*
	*   수정일         수정자                   수정내용
	*  ------------    -----------    ---------------------------
	*  2017.05.31     최초 생성
	*
	* author 변승우 대리
	* since 2017.05.31
	*
	*/
%>

<script>
//연결테스트 확인여부
var connCheck = "fail";

var table_dbServer = null;
var table_db = null;

function fn_init() {
	
	/* ********************************************************
	 * 서버 (데이터테이블)
	 ******************************************************** */
	table_dbServer = $('#dbServerList').DataTable({
		scrollY : "279px",
		scrollX: true,	
		searching : false,
		paging : false,
		deferRender : true,
		columns : [
		{data : "rownum", defaultContent : "", className : "dt-center", 
			targets: 0,
	        searchable: false,
	        orderable: false,
	        render: function(data, type, full, meta){
	           if(type === 'display'){
	              data = '<input type="radio" name="radio" value="' + data + '">';      
	           }
	           return data;
	        }}, 
		{data : "ipadr", className : "dt-center", defaultContent : ""},
		{data : "db_svr_nm", className : "dt-center", defaultContent : ""},		
		{data : "agt_cndt_cd", defaultContent : "", className : "dt-center", 
			targets: 0,
	        searchable: false,
	        orderable: false,
	        render: function(data, type, full, meta){
	           if(full.agt_cndt_cd == 'TC001101'){
	              data = '<img src="../images/ico_agent_1.png" alt="" />';      
	           }else{
	        	  data = '<img src="../images/ico_agent_2.png" alt="" />';    
	           }
	           return data;
	        }}, 
        {data : "useyn", defaultContent : "", className : "dt-center", 
			targets: 0,
	        searchable: false,
	        orderable: false,
	        render: function(data, type, full, meta){
	           if(full.useyn == 'Y'){
	              data = '<spring:message code="dbms_information.use" />';      
	           }else{
	        	  data ='<spring:message code="dbms_information.unuse" />';
	           }
	           return data;
	        }}, 
/* 		{data : "dft_db_nm", className : "dt-center", defaultContent : "", visible: false},
		{data : "portno", className : "dt-center", defaultContent : "", visible: false},
		{data : "svr_spr_usr_id", className : "dt-center", defaultContent : "", visible: false},
		{data : "frst_regr_id", className : "dt-center", defaultContent : "", visible: false},
		{data : "frst_reg_dtm", className : "dt-center", defaultContent : "", visible: false},
		{data : "lst_mdfr_id", className : "dt-center", defaultContent : "", visible: false},
		{data : "lst_mdf_dtm", className : "dt-center", defaultContent : "", visible: false},
		{data : "idx", className : "dt-center", defaultContent : "" ,visible: false},
		{data : "db_svr_id", className : "dt-center", defaultContent : "", visible: false} */
		]
	});

	/* ********************************************************
	 * 디비 (데이터테이블)
	 ******************************************************** */
	table_db = $('#dbList').DataTable({
		scrollY : "278px",
		scrollX: true,	
		searching : false,
		paging : false,		
		deferRender : true,
		columns : [
		{data : "dft_db_nm", className : "dt-center", defaultContent : ""}, 
		{data : "db_exp", defaultContent : "", className : "dt-center", 
			targets: 0,
	        searchable: false,
	        orderable: false,
	        render: function(data, type, full, meta){
	           if(type === 'display'){
	              data = '<input type="text" class="txt" name="db_exp" value="' +full.db_exp + '" style="width: 350px; height: 25px;" id="db_exp">';      
	           }
	           
	           return data;
	        }}, 
		{data : "rownum", defaultContent : "", targets : 0, orderable : false, checkboxes : {'selectRow' : false}}, 		
		]
	});
	
	
	table_dbServer.tables().header().to$().find('th:eq(0)').css('min-width', '50px');
	table_dbServer.tables().header().to$().find('th:eq(1)').css('min-width', '200px');
	table_dbServer.tables().header().to$().find('th:eq(2)').css('min-width', '232px');
	table_dbServer.tables().header().to$().find('th:eq(3)').css('min-width', '70px');
	table_dbServer.tables().header().to$().find('th:eq(4)').css('min-width', '50px');
/* 	table_dbServer.tables().header().to$().find('th:eq(5)').css('min-width', '0px');
	table_dbServer.tables().header().to$().find('th:eq(6)').css('min-width', '0px');
	table_dbServer.tables().header().to$().find('th:eq(7)').css('min-width', '0px');  
	table_dbServer.tables().header().to$().find('th:eq(8)').css('min-width', '0px');
	table_dbServer.tables().header().to$().find('th:eq(9)').css('min-width', '0px');
    table_dbServer.tables().header().to$().find('th:eq(10)').css('min-width', '0px');
    table_dbServer.tables().header().to$().find('th:eq(11)').css('min-width', '0px');
    table_dbServer.tables().header().to$().find('th:eq(12)').css('min-width', '0px');  
    table_dbServer.tables().header().to$().find('th:eq(13)').css('min-width', '0px'); */
    
    table_db.tables().header().to$().find('th:eq(0)').css('min-width', '80px');
    table_db.tables().header().to$().find('th:eq(1)').css('min-width', '150px');
    table_db.tables().header().to$().find('th:eq(2)').css('min-width', '10px');
    
    
    $(window).trigger('resize'); 
	
}


/* ********************************************************
 * 페이지 시작시(서버 조회)
 ******************************************************* */
$(window.document).ready(function() {	
	fn_buttonAut();	
	fn_init();
	
  	$.ajax({
		url : "/selectTreeDbServerList.do",
		data : {},
		//dataType : "json",
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
			table_dbServer.clear().draw();
			table_dbServer.rows.add(result).draw();
		}
	});
});

function fn_buttonAut(){
	var wrt_button = document.getElementById("wrt_button"); 
	var save_button = document.getElementById("save_button"); 
	
	if("${wrt_aut_yn}" == "Y"){
		wrt_button.style.display = '';
		save_button.style.display = '';
	}else{
		wrt_button.style.display = 'none';
		save_button.style.display = 'none';
	}
}

$(function() {		
	
	/* ********************************************************
	 * 서버 테이블 (선택영역 표시)
	 ******************************************************** */
    $('#dbServerList tbody').on( 'click', 'tr', function () {
    	var check = table_dbServer.row( this ).index()+1
    	$(":radio[name=input:radio][value="+check+"]").attr("checked", true);
         if ( $(this).hasClass('selected') ) {
        }
        else {
        	table_dbServer.$('tr.selected').removeClass('selected');
            $(this).addClass('selected');
        } 
         var db_svr_nm = table_dbServer.row('.selected').data().db_svr_nm;
         var ipadr = table_dbServer.row('.selected').data().ipadr;
        /* ********************************************************
         * 선택된 서버에 대한 디비 조회
        ******************************************************** */
       	$.ajax({
    		url : "/selectTreeServerDBList.do",
    		data : {
    			db_svr_nm: db_svr_nm
    		},
    		//dataType : "json",
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
    				alert("ERROR CODE : "
    						+ xhr.status
    						+ "\n\n"
    						+ "ERROR Message : "
    						+ error
    						+ "\n\n"
    						+ "Error Detail : "
    						+ xhr.responseText.replace(
    								/(<([^>]+)>)/gi, ""));
    			}
    		},
    		success : function(result) {    	
    			if(result.data == null){
    				alert('<spring:message code="message.msg05" />');
    			}else{
    				table_db.clear().draw();
	    			table_db.rows.add(result.data).draw();
	    			fn_dataCompareChcek(result);
    			}
    		}
    	});
        
    } );
})


/* ********************************************************
 * 서버 등록 팝업페이지 호출
 ******************************************************** */
function fn_reg_popup(){
	var popUrl = "/popup/dbServerRegForm.do?flag=tree"; // 서버 url 팝업경로
	var width = 1000;
	var height = 630;
	var left = (window.screen.width / 2) - (width / 2);
	var top = (window.screen.height /2) - (height / 2);
	var popOption = "width="+width+", height="+height+", top="+top+", left="+left+", resizable=no, scrollbars=yes, status=no, toolbar=no, titlebar=yes, location=no,";
		
	window.open(popUrl,"",popOption);	
	
// 	window.open("/popup/dbServerRegForm.do?flag=tree","dbServerRegPop","location=no,menubar=no,scrollbars=yes,status=no,width=1050,height=638");
}


/* ********************************************************
 * 서버 수정 팝업페이지 호출
 ******************************************************** */
function fn_regRe_popup(){
	var datas = table_dbServer.rows('.selected').data();
	if (datas.length == 1) {
		var db_svr_id = table_dbServer.row('.selected').data().db_svr_id;
		var popUrl = "/popup/dbServerRegReForm.do?db_svr_id="+db_svr_id+"&flag=tree"; // 서버 url 팝업경로
		var width = 1000;
		var height = 660;
		var left = (window.screen.width / 2) - (width / 2);
		var top = (window.screen.height /2) - (height / 2);
		var popOption = "width="+width+", height="+height+", top="+top+", left="+left+", resizable=no, scrollbars=yes, status=no, toolbar=no, titlebar=yes, location=no,";
			
		window.open(popUrl,"",popOption);
// 		window.open("/popup/dbServerRegReForm.do?db_svr_id="+db_svr_id+"&flag=tree","dbServerRegRePop","location=no,menubar=no,resizable=yes,scrollbars=yes,status=no,width=1050,height=638");
	} else {
		alert('<spring:message code="message.msg04" />');
	}	
}


/* ********************************************************
 * 디비 등록
 ******************************************************** */
function fn_insertDB(){
	var list = $("input[name='db_exp']");
	var datasArr = new Array();	
	var db_svr_id = table_dbServer.row('.selected').data().db_svr_id;
	var ipadr = table_dbServer.row('.selected').data().ipadr;
	var datas = table_db.rows().data();

	//체크된갯수
	var checkCnt = table_db.rows('.selected').data().length;
	var rows = [];
    	for (var i = 0; i<datas.length; i++) {
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
    	if (confirm('<spring:message code="message.msg160"/>')){
			$.ajax({
				url : "/insertTreeDB.do",
				data : {
					db_svr_id : db_svr_id,
					ipadr : ipadr,
					rows : JSON.stringify(datasArr)
				},
				async:true,
				//dataType : "json",
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
					alert('<spring:message code="message.msg07" />');
					location.reload();
				}
			});	
    	}else{
    		return false;
    	}

}


/* ********************************************************
 * 서버에 등록된 디비,  <=>  Repository에 등록된 디비 비교
 ******************************************************** */
function fn_dataCompareChcek(svrDbList){
	var db_svr_id =  table_dbServer.row('.selected').data().db_svr_id;
	$.ajax({
		url : "/selectTreeDBList.do",
		data : {db_svr_id : db_svr_id},
		async:true,
		//dataType : "json",
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
			//DB목록 그리드의 설명 부분을 리스트로 가지고옴
			var list = $("input[name='db_exp']");
			
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
			
			
/* 			var list = $("input[name='db_exp']");
			//var db_svr_id =  table_dbServer.row('.selected').data().db_svr_id
			if(svrDbList.data.length>0){
				for(var k=0; k<list.length; k++){
					list[k].value = result[k].db_exp;
				}		
 				for(var i = 0; i<svrDbList.data.length; i++){
					for(var j = 0; j<result.length; j++){						
							 $('input', table_db.rows(i).nodes()).prop('checked', false); 	
							 table_db.rows(i).nodes().to$().removeClass('selected');	
					}
				}	 	
 				for(var i = 0; i<svrDbList.data.length; i++){
					//var list = $("input[name='db_exp']");	
					for(var j = 0; j<result.length; j++){
						//list[j].value = result[j].db_exp;
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

</script>
<div id="contents">
	<div class="contents_wrap">
		<div class="contents_tit">
			<h4><spring:message code="menu.dbms_registration" /><a href="#n"><img src="../images/ico_tit.png" class="btn_info"/></a></h4>
			<div class="infobox"> 
				<ul>
					<li><spring:message code="help.dbms_registration_01" /></li>
					<li><spring:message code="help.dbms_registration_02" /></li>						
				</ul>
			</div>
			<div class="location">
				<ul>
					<li>Admin</li>
					<li><spring:message code="menu.dbms_information" /></li>
					<li class="on"><spring:message code="menu.dbms_registration" /></li>
				</ul>
			</div>
		</div>
		<div class="contents">
			<div class="tree_grp">
				<div class="tree_lt">
					<div class="btn_type_01">
					<div id="wrt_button">
						<span class="btn"><button onclick="fn_reg_popup();"><spring:message code="common.registory" /></button></span>
						<span class="btn"><button onClick="fn_regRe_popup();"><spring:message code="common.modify" /></button></span>		
					</div>
					</div>
					<div class="inner">
						<p class="tit"><spring:message code="dbms_information.dbms_list" /></p>
						<div class="tree_server">
							<table id="dbServerList" class="cell-border display" cellspacing="0" align="left">
								<thead>
									<tr>
										<th width="10"><spring:message code="schedule.total" /></th>									
										<th width="200"><spring:message code="dbms_information.dbms_ip" /></th>
										<th width="130"><spring:message code="common.dbms_name" /></th>
										<th width="50"><spring:message code="dbms_information.agent_status" /></th>
										<th width="50"><spring:message code="dbms_information.use_yn" /></th>
										<!-- <th width="0"></th>
										<th width="0"></th>
										<th width="0"></th>
										<th width="0"></th>
										<th width="0"></th>
										<th width="0"></th>
										<th width="0"></th>
										<th width="0"></th>
										<th width="0"></th> -->
									</tr>
								</thead>
							</table>
						</div>
					</div>
				</div>
				<div class="tree_rt"  style="width: 44%; margin-left: 2%;">
					<div class="btn_type_01">
						<div id="save_button">
						<span class="btn"><button onClick="fn_insertDB()"><spring:message code="common.save"/></button></span>
						</div>
					</div>
					<div class="inner">
						<p class="tit"><spring:message code="dbms_information.databaseList"/></p>
						<div class="tree_list">
							<table id="dbList" class="cell-border display" cellspacing="0" align="left">
								<thead>
									<tr>
										<th width="90"><spring:message code="common.database" /></th>
										<th width="150"><spring:message code="common.desc" /></th>
										<th width="10"><input name="select" value="1" type="checkbox"></th>
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

