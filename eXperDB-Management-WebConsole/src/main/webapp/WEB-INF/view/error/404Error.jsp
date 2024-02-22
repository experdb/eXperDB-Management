<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://tiles.apache.org/tags-tiles" prefix="tiles"%>
<%@ taglib prefix="c"      uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@include file="../cmmn/cs2.jsp"%> 

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" lang="ko" xml:lang="ko">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>eXperDB</title>

   <style>
        /* Style the div container */
        .image-container {
            display: flex;
            justify-content: center;
            align-items: center;
            margin-top: 200px;
        }
        /* Style the image */
        .image-container img {
            max-width: 100%;
            max-height: 100%;
        }
    </style>
   
</head>

<body>
    <div class="image-container"> 
        <img src="images/404.png" >
    </div>
  	<div class="row mt-5">
		<div class="col-12 text-center mt-xl-2">
			<a " href="javascript:void(0);" onclick="history.go(-1)"><spring:message code="common.back"/></a>
		</div>
	</div> 

	 <%-- <div class="container-scroller">
		<div class="container-fluid page-body-wrapper full-page-wrapper">
			<div class="content-wrapper d-flex align-items-center text-center error-page">
				<div class="row flex-grow">
					<div class="col-lg-7 mx-auto text-white">
						<div class="row align-items-center d-flex flex-row">
							<div class="col-lg-7 error-page-divider text-lg-left pl-lg-4">
									<img src="images/404.png" >
							</div>
						</div>
						<div class="row mt-5">
							<div class="col-12 text-center mt-xl-2">
								<a class="font-weight-medium" href="javascript:void(0);" onclick="history.go(-1)"><spring:message code="common.back"/></a>
							</div>
						</div>
					</div>
				</div>
			</div>
		</div>
	</div> --%>
</body>
</html>