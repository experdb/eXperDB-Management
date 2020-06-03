<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@include file="./cmmn/cs2.jsp"%> 

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">

<title>eXperDB for Management</title>

<script type="text/javascript">
	$(window.document).ready(function() {
		//error 체크
		fn_errorChk('${error}');
		
		$('#usr_id').focus();

		//password 입력
		$("#pwd").keyup(function(e){
			if(e.keyCode == 13) {
				fn_login();
			}
		});
	});
	
	//error 체크
	function fn_errorChk(errorCode) {
		var errorMsg = "";
		var titleMsg = "";

		if (errorCode != null && errorCode != "") {
			if (errorCode == "msg156") {
				errorMsg = '<spring:message code="message.msg156" />';
			} else if (errorCode == "msg157") {
				errorMsg = '<spring:message code="message.msg157" />';
			} else if (errorCode == "msg158") {
				errorMsg = '<spring:message code="message.msg158" />';
			} else if (errorCode == "msg159") {
				errorMsg = '<spring:message code="message.msg159" />';
			} else if (errorCode == "msg176") {
				errorMsg = '<spring:message code="message.msg176" />';
			}
			
			titleMsg = '<spring:message code="common.login" />' + ' ' +'<spring:message code="common.failed" />';
			showToastPosition('mid-center', errorMsg, titleMsg);
		}
	}

	//valid 체크
	function fn_validation(){
		var strid = $('#usr_id').val();
		var strpw = $('#pwd').val();
			
		if (strid == "" || strid == "undefind" || strid == null) {
			alert("<spring:message code='message.msg128' />");
			$('#usr_id').focus();
			return false;
		}

		if (strpw == "" || strpw == "undefind" || strpw == null) {
			alert("<spring:message code='message.msg129' />");
			$('#pwd').focus();
			return false;
		}

		return true;
	}

	//login 버튼 클릭
	function fn_login(){
		if (!fn_validation()) return false;

		$("#loginForm").attr("action", "/loginAction.do");
		$("#loginForm").submit();
	}
</script>
</head>
<body class="sidebar-dark">
	<div class="container-scroller">
		<div class="container-fluid page-body-wrapper full-page-wrapper">

			<div class="content-wrapper-login d-flex align-items-center auth px-0">
				<div class="row w-100 mx-0">
					<div class="col-lg-4 mx-auto">
						<div class="auth-form-light text-left py-5 px-4 px-sm-5">
			
							<!-- title -->
							<div class="brand-logo">
								<img src="../images/login_logo_new.png" alt="eXperDB">
							</div>
							
							<h4><spring:message code="login.title_main_msg" /></h4>
							<h6 class="font-weight-light"><spring:message code="login.title_sub_msg" /></h6>
							
							<form class="pt-3" name="loginForm" id="loginForm" method="post">
 								<div class="form-group">
									<label for="member_id"><spring:message code="user_management.id" /></label>
									<div class="input-group">
										<div class="input-group-prepend bg-transparent">
											<span class="input-group-text bg-transparent border-right-0">
												<i class="ti-user text-primary"></i>
											</span>
										</div>

										<input type="text" class="form-control form-control-lg border-left-0" id="usr_id" name="usr_id"  maxlength="30" placeholder="<spring:message code="message.msg128" />">
									</div>
								</div>
								
								<div class="form-group">
									<label for="member_pwd"><spring:message code="user_management.password" /></label>
									<div class="input-group">
										<div class="input-group-prepend bg-transparent">
											<span class="input-group-text bg-transparent border-right-0">
												<i class="ti-lock text-primary"></i>
											</span>
										</div>
						
										<input type="password" class="form-control form-control-lg border-left-0" id="pwd" name="pwd" maxlength="20" placeholder="<spring:message code="message.msg129" />">
									</div>
								</div>
									
								<div class="mt-3">
									<a class="btn btn-block btn-primary btn-lg font-weight-medium auth-form-btn" href="javascript:void(0)" onclick="javascript:fn_login();">LOGIN</a>
								</div>
								
								<div class="my-2 d-flex justify-content-between align-items-center">
									<div class="form-check">
										<label class="form-check-label text-muted">
											<input type="checkbox" id="login_chk" name ="login_chk" class="form-check-input" />
											<spring:message code="login.title.signed" />
										</label>
									</div>
								</div>
							</form>	
						</div>
					</div>
				</div>
			</div>
		
		</div>
		<!-- page-body-wrapper ends -->
	</div>
	<!-- container-scroller -->
</body>
</html>