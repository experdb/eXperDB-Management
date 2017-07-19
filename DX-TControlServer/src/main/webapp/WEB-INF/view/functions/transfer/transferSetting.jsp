<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
	/**
	* @Class Name : transferSetting.jsp
	* @Description : TransferSetting 화면
	* @Modification Information
	*
	*   수정일         수정자                   수정내용
	*  ------------    -----------    ---------------------------
	*  2017.06.19     최초 생성
	*
	* author 김주영 사원
	* since 2017.06.19
	*
	*/
%>
<script>
	/* 숫자체크 */
	function valid_numeric(objValue)
	{
		if (objValue.match(/^[0-9]+$/) == null)
		{	return false;	}
		else
		{	return true;	}
	}

	/* Validation */
	function fn_transferValidation(){
 		var kbipadr = document.getElementById("kbipadr");
		if (kbipadr.value == "") {
			alert("kafka Broker 아이피를 입력하여 주십시오.");
			kbipadr.focus();
			return false;
		}

 		var kbportno = document.getElementById("kbportno");
		if (kbportno.value == "") {
			alert("kafka Broker 포트를 입력하여 주십시오.");
			kbportno.focus();
			return false;
		}
 		if(!valid_numeric(kbportno.value))
	 	{
 			alert("포트는 숫자만 입력가능합니다.");
 			kbportno.focus();
		 	return false;
		}		
 		var sripadr = document.getElementById("sripadr");
		if (sripadr.value == "") {
			alert("schema registry 아이피를 입력하여 주십시오.");
			sripadr.focus();
			return false;
		}	
 		var srportno = document.getElementById("srportno");
		if (srportno.value == "") {
			alert("schema registry 포트를 입력하여 주십시오.");
			srportno.focus();
			return false;
		}
 		if(!valid_numeric(srportno.value))
	 	{
 			alert("포트는 숫자만 입력가능합니다.");
 			srportno.focus();
		 	return false;
		}
 		var zipadr = document.getElementById("zipadr");
		if (zipadr.value == "") {
			alert("zookeeper 아이피를 입력하여 주십시오.");
			zipadr.focus();
			return false;
		}
 		var zportno = document.getElementById("zportno");
		if (zportno.value == "") {
			alert("zookeeper 포트를 입력하여 주십시오.");
			zportno.focus();
			return false;
		}
 		if(!valid_numeric(zportno.value))
	 	{
 			alert("포트는 숫자만 입력가능합니다.");
 			zportno.focus();
		 	return false;
		}	
 		var bipadr = document.getElementById("bipadr");
		if (bipadr.value == "") {
			alert("BottledWater 아이피를 입력하여 주십시오.");
			bipadr.focus();
			return false;
		}
 		var bportno = document.getElementById("bportno");
		if (bportno.value == "") {
			alert("BottledWater 포트를 입력하여 주십시오.");
			bportno.focus();
			return false;
		}
 		if(!valid_numeric(bportno.value))
	 	{
 			alert("포트는 숫자만 입력가능합니다.");
 			bportno.focus();
		 	return false;
		}
	
 		return true;		
	}
	
	
	/* 저장버튼 클릭시(전송설정 값이 없는 경우) */
	function fn_insert() {
		if (!fn_transferValidation()) return false;	
		$.ajax({
			url : '/insertTransferSetting.do',
			type : 'post',
			data : {
 				ipadrs : $("#kbipadr").val()+","+$("#sripadr").val()+","+$("#zipadr").val()+","+$("#bipadr").val(),
 				portnos : $("#kbportno").val()+","+$("#srportno").val()+","+$("#zportno").val()+","+$("#bportno").val(),
			},
			success : function(result) {
				alert("저장하였습니다.");
				window.location.reload();
			},
			error : function(request, status, error) {
				 alert("실패");
			}
		});
	}
	
	/* 저장버튼 클릭시(전송설정 값이 있는 경우) */
	function fn_update() {
		if (!fn_transferValidation()) return false;	
		$.ajax({
			url : '/updateTransferSetting.do',
			type : 'post',
			data : {
 				ipadrs : $("#kbipadr").val()+","+$("#sripadr").val()+","+$("#zipadr").val()+","+$("#bipadr").val(),
 				portnos : $("#kbportno").val()+","+$("#srportno").val()+","+$("#zportno").val()+","+$("#bportno").val(),
			},
			success : function(result) {
				alert("저장하였습니다.");
			},
			error : function(request, status, error) {
				 alert("실패");
			}
		});
	}
	
	$(window.document).ready(function() {
		$.ajax({
			url : "/selectTransferSetting.do",
			data : {},
			dataType : "json",
			type : "post",
			error : function(xhr, status, error) {
				alert("실패")
			},
			success : function(data) {
 				var cnt = data.length;
 				if(cnt==0){
 					$('<button onclick="fn_insert()"></button>').text('저장').appendTo('.btnC_01');
 				}else{
 				   $('<button onclick="fn_update()"></button>').text('저장').appendTo('.btnC_01');
		            for (var i = 0; i < cnt; i++) {
		            	var trf_svr_nm = data[i].trf_svr_nm;
		            	var ipadr = data[i].ipadr;
		            	var portno = data[i].portno;
	 	            	if(trf_svr_nm=='kafka Broker'){
	 	            		 $("#kbipadr").val(ipadr);
	 	            		 $("#kbportno").val(portno);
	 	            	}
	 	            	if(trf_svr_nm=='schema registry'){
		            		 $("#sripadr").val(ipadr);
	 	            		 $("#srportno").val(portno);	            		
	 	            	}
	 	            	if(trf_svr_nm=='zookeeper'){
		            		 $("#zipadr").val(ipadr);
	 	            		 $("#zportno").val(portno);	            		
	 	            	}
	 	            	if(trf_svr_nm=='BottledWater'){
		            		 $("#bipadr").val(ipadr);
	 	            		 $("#bportno").val(portno);	            		
	 	            	}
		            }
 				}
			}
		});
	});
	
</script>
<div id="contents">
	<div class="contents_wrap">
		<div class="contents_tit">
			<h4>
				전송설정 화면 <a href="#n"><img src="../images/ico_tit.png" alt="" /></a>
			</h4>
			<div class="location">
				<ul>
					<li>Function</li>
					<li>Transfer</li>
					<li class="on">전송설정</li>
				</ul>
			</div>
		</div>

		<div class="contents">
			<div class="cmm_center">
				<table class="list">
					<caption>전송설정 화면 리스트</caption>
					<colgroup>
						<col style="width: 165px;" />
						<col style="width: 187px;" />
						<col style="width: 164px;" />
					</colgroup>
					<thead>
						<tr>
							<th scope="col">서버명</th>
							<th scope="col">아이디</th>
							<th scope="col">포트</th>
						</tr>
					</thead>
					<tbody>
						<tr>
							<td>Kafka Broker</td>
							<td><input type="text" class="txt" name="kbipadr"
								id="kbipadr" /></td>
							<td class="type2"><input type="text" class="txt"
								name="kbportno" id="kbportno" /></td>
						</tr>
						<tr>
							<td>Schema registry</td>
							<td><input type="text" class="txt" name="sripadr" id="sripadr" /></td>
							<td class="type2"><input type="text" class="txt" name="srportno" id="srportno" /></td>
						</tr>
						<tr>
							<td>Zookeeper</td>
							<td><input type="text" class="txt" name="zipadr" id="zipadr" /></td>
							<td class="type2"><input type="text" class="txt" name="zportno" id="zportno" /></td>
						</tr>
						<tr>
							<td>Battoed Water</td>
							<td><input type="text" class="txt" name="bipadr" id="bipadr" /></td>
							<td class="type2"><input type="text" class="txt" name="bportno" id="bportno" /></td>
						</tr>
					</tbody>
				</table>
				<div class="btn_type_04">
					<span class="btn btnC_01"></span>
				</div>
			</div>
		</div>
	</div>
</div>