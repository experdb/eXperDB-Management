<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<style>
p{
	padding: 0 8px 0 33px; 
	line-height: 24px;"
}
.pop_cts{
	min-width: 750px;
}
</style>
<div id="pop_layer_openSource" class="pop-layer">
	<div class="pop-container">
		<div class="pop_cts" style="width: 20%; padding: 10px; margin: 0 auto;">
			<p class="tit" style="margin-bottom: 30px;">
				Open Source License
				<a href="#n" class="btn" onclick="toggleLayer($('#pop_layer_openSource'), 'off');" style="float: right;"><img src="/images/ico_state_01.png"/></a>
			</p>
				<p>This eXperDB is Copyright eXperDB-Management Development Team. All rights reserved.<br>
				This eXperDB use Open Source Software (OSS). You can find the source code of these open source projects,<br>
				along with applicable license information, below.<br>
				We are deeply grateful to these developers for their work and contributions.<p>
				<div class="pop_cmm2">
					<p style="background: url(../images/popup/ico_p_2.png) 8px 48% no-repeat; font-weight: bold;">전자정부 표준프레임워크 라이선스</p>
					<p>	Version 2.0, January 2004<br> 
					http://www.apache.org/licenses/<br> 
					Apache License</p>
				</div>
				<div class="pop_cmm2">
					<p style="background: url(../images/popup/ico_p_2.png) 8px 48% no-repeat; font-weight: bold;">Datatables</p>
					<p>https://datatables.net<br> 
					Copyright (C) 2008-2018, SpryMedia Ltd.<br> 
					MIT license</p>
				</div>
			<div class="btn_type_02">
				<a href="#n" class="btn"
					onclick="toggleLayer($('#pop_layer_openSource'), 'off');"><span><spring:message code="common.close"/></span></a>
			</div>
		</div>
	</div>
	<!-- //pop-container -->
</div>