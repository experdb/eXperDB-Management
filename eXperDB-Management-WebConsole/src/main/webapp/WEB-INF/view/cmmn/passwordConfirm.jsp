<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>


<script>
function fn_passwordCheck(){
		$.ajax({
			url : "/psswordCheck.do",
			data : {
				password : $("#password").val()
			},
			dataType : "json",
			type : "post",
			beforeSend: function(xhr) {
		        xhr.setRequestHeader("AJAX", true);
		     },
			error : function(xhr, status, error) {
				if(xhr.status == 401) {
					alert('<spring:message code="message.msg02" />');
					top.location.href = "/";
				} else if(xhr.status == 403) {
					alert('<spring:message code="message.msg03" />');
					top.location.href = "/";
				} else {
					alert("ERROR CODE : "+ xhr.status+ "\n\n"+ "ERROR Message : "+ error+ "\n\n"+ "Error Detail : "+ xhr.responseText.replace(/(<([^>]+)>)/gi, ""));
				}
			},
			success : function(result) {				
				if(result == "true"){
					toggleLayer($('#pop_layer_pwConfilm'), 'off');
					//fn_execute();
					fn_pgWalFileSwitch();
				}else{
					alert("비밀번호가 일치하지 않습니다.");
				}				
			}
		}); 
}
</script>


<!--  popup -->
	<div id="pop_layer_pwConfilm" class="pop-layer">
		<div class="pop-container">
			<div class="pop_cts" style="width: 60%; margin: 0 auto; min-height:0; min-width:0;">
					<table class="write" >
						<colgroup>
							<col style="width:125px;" />
							<col />
						</colgroup>
						<tbody>
							<tr>
								<th scope="row" style="background:url(../images/popup/ico_p_1.png) 4px 50% no-repeat;"><strong>비밀번호 확인</strong></th>
								<td><input type="password" class="txt" name="password" id="password" />
								<span class="btn btnC_01"><button type="button" class= "btn_type_02" onclick="fn_passwordCheck()" style="width: 70px; margin-right: -60px; margin-top: 0;">확인</button></span>
								</td>
							</tr>
							</tbody>
					</table>
					
				<div class="btn_type_02">
					<a href="#n" class="btn" onclick="toggleLayer($('#pop_layer_pwConfilm'), 'off');"><span><spring:message code="common.close"/></span></a>
				</div>
			</div>
		</div><!-- //pop-container -->
	</div>
