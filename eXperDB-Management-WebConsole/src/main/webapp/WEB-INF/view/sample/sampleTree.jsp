<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c"      uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="form"   uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="ui"     uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%
	/**
	* @Class Name : sampleTree.jsp
	* @Description : Sample Tree 화면
	* @Modification Information
	*
	*   수정일         수정자                   수정내용
	*  ------------    -----------    ---------------------------
	*  2017.05.22     최초 생성
	*
	* author 변승우 대리
	* since 2017.05.22
	*
	*/
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Tree View 샘플</title>
<link type="text/css" rel="stylesheet" href="<c:url value='/css/egovframework/sample.css'/>"/>
<script type="text/javaScript" language="javascript" defer="defer">
</script>
<link rel="stylesheet" href="<c:url value='/css/treeview/jquery.treeview.css'/>"/>
<link rel="stylesheet" href="<c:url value='/css/treeview/screen.css'/>"/>
<script src="js/treeview/jquery.js" type="text/javascript"></script>
<script src="js/treeview/jquery.cookie.js" type="text/javascript"></script>
<script src="js/treeview/jquery.treeview.js" type="text/javascript"></script>

<script type="text/javascript">
        $(function() {
            $("#tree").treeview({
                collapsed: false,
                animated: "medium",
                control:"#sidetreecontrol",
                persist: "location"
            });
        })
        
        function fn_tree_View() {
		   	document.treeCreate.action = "<c:url value='/insertSampleTree'/>";
		   	document.treeCreate.submit();
		}
    </script>
</head>
<body>
<div id="content_pop">
	<div id="title">
  		<ul>
  			<li><img src="<c:url value='/images/egovframework/example/title_dot.gif'/>" alt=""/>트리 샘플</li>
  		</ul>
  	</div>
  	
  	<form name="treeCreate" id="treeCreate">
  		<div id="table">
  	    	<table width="100%" border="1" cellpadding="0" cellspacing="0" style="bordercolor:#D3E2EC; bordercolordark:#FFFFFF; BORDER-TOP:#C2D0DB 2px solid; BORDER-LEFT:#ffffff 1px solid; BORDER-RIGHT:#ffffff 1px solid; BORDER-BOTTOM:#C2D0DB 1px solid; border-collapse: collapse;">
    		<tr>
    			<td class="tbtd_caption">서버명</td>
    			<td class="tbtd_content">
    				 <input type="text" name="db_svr_nm" id="db_svr_nm"> 
    			</td>
    		</tr>
			<tr>
    			<td class="tbtd_caption">IP</td>
    			<td class="tbtd_content">
    				  <input type="text" name="ipadr" id="ipadr">
    			</td>
    		</tr>
    		<tr>
    			<td class="tbtd_caption">PORT</td>
    			<td class="tbtd_content">
    				<input type="text" name="portno" id="portno">
    			</td>
    		</tr>
    		<tr>
    			<td class="tbtd_caption">USER</td>
    			<td class="tbtd_content">
    				 <input type="text" name="svr_spr_usr_id" id="svr_spr_usr_id"> 
    			</td>
    		</tr>
    		<tr>
    			<td class="tbtd_caption">PASSWORD</td>
    			<td class="tbtd_content">
    				 <input type="password" name="svr_spr_scm_pwd"  id="svr_spr_scm_pwd"> 
    			</td>
    		</tr>
    	</table>
    	</div>  		
	<!-- //등록버튼 -->
	   	<div id="sysbtn">
	   	  <ul>
	   	      <li>
	   	          <span class="btn_blue_l">
	   	              <a href="javascript:fn_tree_View();"><spring:message code="button.create" /></a>
	                     <img src="<c:url value='/images/egovframework/example/btn_bg_r.gif'/>" style="margin-left:6px;" alt=""/>
	                 </span>
	             </li>
	         </ul>
	   	</div>
		
  	</form>

 </div> 	
</body>
</html>