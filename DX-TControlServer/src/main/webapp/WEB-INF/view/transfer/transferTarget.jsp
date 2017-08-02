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
			scrollY : "250px",
			columns : [
			{ data : "", defaultContent : "", targets : 0, orderable : false, checkboxes : {'selectRow' : true}}, 
			{ data : "", className : "dt-center", defaultContent : ""}, 
			{ data : "name", className : "dt-center", defaultContent : ""}, 
			{ data : "hdfs_url", className : "dt-center", defaultContent : ""}, 
			{
				data : "",
				render : function(data, type, full, meta) {
					var html = "<span class='btn btnC_01 btnF_02'><button id='detail'>상세조회</button></span>";
					return html;
				},
				className : "dt-center",
				defaultContent : ""
			}, 
			]
		});
		
		table.on( 'order.dt search.dt', function () {
			table.column(1, {search:'applied', order:'applied'}).nodes().each( function (cell, i) {
	            cell.innerHTML = i+1;
	        } );
	    } ).draw();
		
		//더블 클릭시
		$('#transferTargetTable tbody').on('dblclick','tr',function() {
				var data = table.row(this).data();
				var name = data.name;
				var popUrl = "/popup/transferTargetRegForm.do?act=u&&cnr_id=${cnr_id}&&name="+name; // 서버 url 팝업경로
				var width = 930;
				var height = 630;
				var left = (window.screen.width / 2) - (width / 2);
				var top = (window.screen.height /2) - (height / 2);
				var popOption = "width="+width+", height="+height+", top="+top+", left="+left+", resizable=no, scrollbars=no, status=no, toolbar=no, titlebar=yes, location=no,";
				
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
				
		 			var popUrl = "/popup/transferTargetDetailRegForm.do?&&cnr_id=${cnr_id}&&name="+name; // 서버 url 팝업경로
		 			var width = 930;
		 			var height = 635;
		 			var left = (window.screen.width / 2) - (width / 2);
		 			var top = (window.screen.height /2) - (height / 2);
		 			var popOption = "width="+width+", height="+height+", top="+top+", left="+left+", resizable=no, scrollbars=no, status=no, toolbar=no, titlebar=yes, location=no,";
		 			
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
			error : function(xhr, status, error) {
				alert("실패")
			},
			success : function(result) {
				table.clear().draw();
				if(result.data != null){
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
			error : function(xhr, status, error) {
				alert("실패")
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
		var popOption = "width="+width+", height="+height+", top="+top+", left="+left+", resizable=no, scrollbars=no, status=no, toolbar=no, titlebar=yes, location=no,";
		
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
			var popOption = "width="+width+", height="+height+", top="+top+", left="+left+", resizable=no, scrollbars=no, status=no, toolbar=no, titlebar=yes, location=no,";
			
			window.open(popUrl,"",popOption);
		} else {
			alert("하나의 항목을 선택해주세요.");
			return false;
		}

	}
	
	/*삭제버튼 클릭시*/
	function fn_delete(){
		var datas = table.rows('.selected').data();
		if (datas.length <= 0) {
			alert("하나의 항목을 선택해주세요.");
			return false;
		} else {
			if (!confirm("삭제하시겠습니까?"))return false;
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
				error : function(xhr, status, error) {
					alert("실패")
				},
				success : function(result) {
					if (result) {
						alert("삭제되었습니다.");
						fn_select();
					} else {
						alert("처리 실패");
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
			<h4>전송대상 설정 <a href="#n"><img src="../images/ico_tit.png" alt="" /></a></h4>
			<div class="location">
				<ul>
					<li>Transfer</li>
					<li>${cnr_nm}</li>
					<li class="on">전송대상 설정</li>
				</ul>
			</div>
		</div>
		<div class="contents">
			<div class="cmm_grp">
				<div class="btn_type_01">
					<span class="btn" onclick="fn_insert();"><button>등록</button></span> 
					<span class="btn" onclick="fn_update();"><button>수정</button></span> 
					<span class="btn" onclick="fn_delete();"><button>삭제</button></span>
				</div>
				<div class="sch_form">
					<table class="write">
						<caption>검색 조회</caption>
						<colgroup>
							<col style="width: 75px;" />
							<col />
						</colgroup>
						<tbody>
							<tr>
								<th scope="row" class="t5">연결이름</th>
								<td><input type="text" class="txt t2" name="trf_trg_cnn_nm" id="select"/></td>
							</tr>
						</tbody>
					</table>
				</div>
				<div class="overflow_area">
					<table id="transferTargetTable" class="display" cellspacing="0" width="100%">
						<thead>
							<tr>
								<th></th>
								<th>No</th>
								<th>연결이름</th>
								<th>Target URL</th>
								<th>상세조회</th>
							</tr>
						</thead>
					</table>
				</div>
			</div>
		</div>
	</div>
</div>
<!-- // contents -->