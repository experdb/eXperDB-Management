<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>



<script type="text/javascript">
	$(window.document).ready(   		
		function() {	
   			$.ajax({
				async : false,
				url : "/selectSampleTreeList.do",
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
			var i=1;
			
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
				html1+='					<li class="ico3_1"><a href="/backup/rmanList.do?db_svr_id="'+item.db_svr_id+' onClick="javascript:fn_GoLink(/backup/rmanList.do?db_svr_id="'+item.db_svr_id+');>백업설정</a></li>';
				html1+='					<li class="ico3_2"><a href="/backup/rmanLogList.do?db_svr_id="'+item.db_svr_id+' onClick="javascript:fn_GoLink(/backup/rmanLogList.do?db_svr_id="'+item.db_svr_id+');>백업이력</a></li>';
				html1+='				</ul>';
				html1+='			</li>';
				html1+='			<li class="ico2_2"><a href="#n">접근제어관리</a>';
				html1+='				<ul class="depth_3">';
				html1+='					<li class="ico3_3"><a href="/accessControl.do?db_svr_id="'+item.db_svr_id+' onClick="javascript:fn_GoLink(/serverAccessControl?db_svr_id="'+item.db_svr_id+');>서버접근제어</a></li>';
				html1+='					<li class="ico3_5"><a href="#n">감사이력</a></li>';
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
			
			html += '<div class="lnb_tit">Transfer';
			html += '		<div class="all_btn">';
			html += '			<a href="#n" class="all_close">전체 닫기</a>';
			html += '			<a href="#n" class="all_open">전체 열기</a>';
			html += '		</div>';
			html += '</div>'; 
			
			$(data).each(function (index, item) {	
				html += '<ul class="depth_1 lnbMenu">';
				html += '		<li class="t1"><a href="#n">전송설정</a></li>';
				html += '		<li class="t2"><a href="#n">'+item.cnr_nm+'</a>';
				html += '			<ul class="depth_2">';
				html += '				<li class="ico2_3"><a href="#n">전송대상 설정</a></li>';
				html += '				<li class="ico2_4"><a href="#n">전송상세 설정</a></li>';
				html += '			</ul>';
				html += '		</li>';
				html += '	</ul>';			
			})	
			$( "#tree2" ).append(html);
		}	
	
		
	function fn_logout(){
		var frm = document.treeView;
		frm.action = "/logout.do";
		frm.submit();	
	}	
    </script>

<script type="text/javascript" src="../js/jquery.mCustomScrollbar.concat.min.js"></script><!-- mCustomScrollbar -->
<script type="text/javascript" src="../js/common.js"></script>


	<div id="lnb_menu">
		<form name="treeView" id="treeView">
				<div class="logout">
					<button onClick="fn_logout();">LOGOUT</button>
				</div>
				<h3 class="blind">LNB 메뉴</h3>
				<div class="lnb">
					<div class="inr type1" id="tree1">
					</div>
					<div class="inr type2" id=tree2>
					</div>
				</div>
		</form>
		</div>
