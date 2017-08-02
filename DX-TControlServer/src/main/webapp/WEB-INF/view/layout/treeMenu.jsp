<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>



<script type="text/javascript">
	$(window.document).ready(   		
		function() {	
   			$.ajax({
				async : false,
				url : "/selectSvrList.do",
			  	data : {},
				dataType : "json",
				type : "post",
				error : function(xhr, status, error) {
					alert("실패");
				},
				success : function(result) {
					GetJsonData(result)
				}
			});   
   			
   			/*Tree Connector 조회*/
   			$.ajax({
				async : false,
				url : "/selectTreeConnectorRegister.do",
			  	data : {},
				dataType : "json",
				type : "post",
				error : function(xhr, status, error) {
					alert("실패");
				},
				success : function(result) {
					GetJsonDataConnector(result)
				}
			});  
   			
        });
        

		function GetJsonData(data) {
			var parseData = $.parseJSON(data);
		 	var html1 = "";
 			html1 += '<div class="lnb_tit">DB 서버';
			html1 += '<div class="all_btn">';
			html1 += '<a href="#" class="all_close">전체 닫기</a>';
			html1 += '<a href="#" class="all_open">전체 열기</a>';
			html1 += '</div>'; 
			html1 += '</div>'; 
			
 			$(data).each(function (index, item) {
				//var html = "";
				html1+='<ul class="depth_1 lnbMenu">';
				html1+='	<li><a href="#n">'+item.db_svr_nm+'</a>';
				html1+='		<ul class="depth_2">';
				html1+='			<li class="ico2_1"><a href="#n">백업관리</a>';
				html1+='				<ul class="depth_3">';
				html1+='					<li class="ico3_1"><a href=/backup/workList.do?db_svr_id='+item.db_svr_id+'>백업설정</a></li>';
				html1+='					<li class="ico3_2"><a href=/backup/workLogList.do?db_svr_id='+item.db_svr_id+'>백업이력</a></li>';
				html1+='				</ul>';
				html1+='			</li>';
				html1+='			<li class="ico2_2"><a href="#n">접근제어관리</a>';
				html1+='				<ul class="depth_3">';
				html1+='					<li class="ico3_3"><a href=/accessControl.do?db_svr_id='+item.db_svr_id+'>서버접근제어</a></li>';
				html1+='					<li class="ico3_4"><a href=/audit/auditManagement.do?db_svr_id='+item.db_svr_id+'>감사설정</a></li>';
				html1+='					<li class="ico3_5"><a href=/audit/auditLogList.do?db_svr_id='+item.db_svr_id+'>감사이력</a></li>';
				html1+='				</ul>';
				html1+='			</li>';
				html1+='		</ul>';
				html1+='	</li>';
				html1+='</ul>';							
			})		
			$( "#tree1" ).append(html1);
		}
		
	
	
		function GetJsonDataConnector(data) {						
			var parseData = $.parseJSON(data);
			var html = "";		
	
			$(data).each(function (index, item) {
			html += '		<li class="t2"><a href="#n">'+item.cnr_nm+'</a>';
			html += '			<ul class="depth_2">';
			html += '		     	<li class="ico2_3"><a href="/transferTarget.do?cnr_id='+item.cnr_id+'&&cnr_nm='+item.cnr_nm+'">전송대상 설정</a></li>';
			html += '				<li class="ico2_4"><a href="/transferDetail.do?cnr_id='+item.cnr_id+'&&cnr_nm='+item.cnr_nm+'">전송상세 설정</a></li>';
			html += '			</ul>';	
			})		
			$( "#tree2" ).append(html);
		}	

		
	function fn_logout(){
		var frm = document.treeView;
		frm.action = "/logout.do";
		frm.submit();	
	}	
    </script>

<script type="text/javascript" src="/js/jquery.mCustomScrollbar.concat.min.js"></script><!-- mCustomScrollbar -->
<script type="text/javascript" src="/js/common.js"></script>
<script type="text/javascript" src="/js/common_lnb.js"></script>

	<div id="lnb_menu">
		<form name="treeView" id="treeView">
				<div class="logout">
					<a href="#"><button onClick="fn_logout();">LOGOUT</button></a>
				</div>
				<h3 class="blind">LNB 메뉴</h3>
				<div class="lnb">
					<div class="inr" id="tree1">
					</div>
					<div class="inr type2">
						<div class="lnb_tit">Transfer
							<div class="all_btn">
								<a href="#n" class="all_open">전체 열기</a>
								<a href="#n" class="all_close">전체 닫기</a>
							</div>
						</div>
						<ul class="depth_1 lnbMenu" id="tree2">
							<li class="t1"><a href="/treeTransferSetting.do">전송설정</a></li>
						</ul>
					</div>
				</div>
		</form>
		</div>
