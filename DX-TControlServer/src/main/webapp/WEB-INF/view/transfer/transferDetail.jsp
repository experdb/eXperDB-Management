<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%
	/**
	* @Class Name : transferDetail.jsp
	* @Description : TransferDetail 화면
	* @Modification Information
	*
	*   수정일         수정자                   수정내용
	*  ------------    -----------    ---------------------------
	*  2017.07.21     최초 생성
	*
	* author 김주영 사원
	* since 2017.07.21
	*
	*/
%>
<script type="text/javascript">

	var table = null;
	var cnr_id="${cnr_id}";

	function fn_init() {
		table = $('#transferDetailTable').DataTable({
			scrollY : "250px",
			searching : false,
			columns : [
			{ data : "trf_trg_cnn_nm", className : "dt-center", defaultContent : ""}, 
			{ data : "db_svr_nm", className : "dt-center", defaultContent : ""}, 
			{ data : "db_nm", className : "dt-center", defaultContent : ""}, 
			{
				data : "",
				render : function(data, type, full, meta) {
					var html = "<a href='#n'><img src='../images/ico_start.png' alt='실행중' /></a>";	
					return html;
				},
				className : "dt-center",
				defaultContent : ""
			}, 
			{ data : "", className : "dt-center", defaultContent : "<a href='#n'><img src='../images/mappin_btn.png' alt='맵핑설정버튼' id='mappingBtn'/></a>"}
			]
		});
		
	    //맵핑설정버튼 클릭시
		 $('#transferDetailTable tbody').on('click','#mappingBtn', function () {
		 		var $this = $(this);
		    	var $row = $this.parent().parent().parent();
		    	$row.addClass('select-detail');
		    	var datas = table.rows('.select-detail').data();
		    	if(datas.length==1) {
		    		var row = datas[0];
			    	$row.removeClass('select-detail');
					var popUrl = "/popup/transferMappingRegForm.do?trf_trg_id="+row.trf_trg_id+"&&cnr_id="+cnr_id+"&&trf_trg_cnn_nm="+row.trf_trg_cnn_nm; // 서버 url 팝업경로
					var width = 920;
					var height = 675;
					var left = (window.screen.width / 2) - (width / 2);
					var top = (window.screen.height /2) - (height / 2);
					var popOption = "width="+width+", height="+height+", top="+top+", left="+left+", resizable=no, scrollbars=no, status=no, toolbar=no, titlebar=yes, location=no,";
					
					window.open(popUrl,"",popOption);
					
		    	}
			});
	    
	}

	$(window.document).ready(function() {
		fn_init();
		$.ajax({
			url : "/selectTransferDetail.do",
			data : {
				trf_trg_cnn_nm : "%"+$("#trf_trg_cnn_nm").val()+"%",
				db_nm : "%"+$("#db_nm").val()+"%",
				cnr_id : cnr_id
			},
			dataType : "json",
			type : "post",
			error : function(xhr, status, error) {
				alert("실패")
			},
			success : function(result) {
				table.clear().draw();
				table.rows.add(result).draw();
			}
		});

	});
	
	/*조회버튼 클릭시*/
	function fn_select(){
		alert("조회버튼!");
	}
	
	/*맵핑설정버튼 클릭시*/
	function windowPopup(trf_trg_id){
		var popUrl = "/popup/transferMappingRegForm.do?trf_trg_id="+trf_trg_id+"&&cnr_id="+cnr_id; // 서버 url 팝업경로
		var width = 920;
		var height = 675;
		var left = (window.screen.width / 2) - (width / 2);
		var top = (window.screen.height /2) - (height / 2);
		var popOption = "width="+width+", height="+height+", top="+top+", left="+left+", resizable=no, scrollbars=no, status=no, toolbar=no, titlebar=yes, location=no,";
		
		window.open(popUrl,"",popOption);
	}
</script>
<!-- contents -->
<div id="contents">
	<div class="contents_wrap">
		<div class="contents_tit">
			<h4>전송상세 설정 화면 <a href="#n"><img src="../images/ico_tit.png" alt="" /></a></h4>
			<div class="location">
				<ul>
					<li>Transfer</li>
					<li>${cnr_nm }</li>
					<li class="on">전송상세 설정</li>
				</ul>
			</div>
		</div>
		<div class="contents">
			<div class="cmm_grp">
				<div class="btn_type_01">
					<span class="btn"><button onclick="fn_select()">조회</button></span> 
				</div>
				<div class="sch_form">
					<table class="write">
						<caption>검색 조회</caption>
						<colgroup>
							<col style="width: 100px;" />
							<col style="width: 225px;" />
							<col style="width: 95px;" />
							<col />
						</colgroup>
						<tbody>
							<tr>
								<th scope="row" class="t7">Connector명</th>
								<td><input type="text" class="txt t3" name="" id="trf_trg_cnn_nm"/></td>
								<th scope="row" class="t4">Database명</th>
								<td><input type="text" class="txt t3" name="" id="db_nm"/></td>
							</tr>
						</tbody>
					</table>
				</div>
				<div class="overflow_area">
					<table id="transferDetailTable" class="display" cellspacing="0" width="100%">
						<thead>
							<tr>
								<th>Connector명</th>
								<th>서버명</th>
								<th>Database명</th>
								<th>상태</th>
								<th>맵핑설정</th>
							</tr>
						</thead>
					</table>
				</div>
			</div>
		</div>
	</div>
</div>
<!-- // contents -->


<!-- 					<table class="list pd_type1">
						<caption>전송 관리 조회 리스트</caption>
						<colgroup>
							<col style="width: 30%;" />
							<col />
							<col style="width: 10%;" />
							<col style="width: 13%;" />
							<col style="width: 10%;" />
						</colgroup>
						<thead>
							<tr>
								<th scope="col">Connector명</th>
								<th scope="col">Database명</th>
								<th scope="col">상태</th>
								<th scope="col">실행</th>
								<th scope="col">맵핑설정</th>
							</tr>
						</thead>
						<tbody>
							<tr>
								<td class="tal">TestConnection 1</td>
								<td class="tal">DB 1</td>
								<td>실행중</td>
								<td><a href="#n"><img src="../images/ico_start.png" alt="실행중" /></a></td>
								<td><a href="#n"><img src="../images/mappin_btn.png" alt="맵핑설정버튼" onclick="windowPopup();" /></a></td>
							</tr>
							<tr>
								<td class="tal">TestConnection 2</td>
								<td class="tal">DB 2</td>
								<td>중지중</td>
								<td><a href="#n"><img src="../images/ico_end.png" alt="중지중" /></a></td>
								<td><a href="#n"><img src="../images/mappin_btn.png" alt="맵핑설정버튼" /></a></td>
							</tr>
						</tbody>
					</table> -->