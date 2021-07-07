<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>


<div class="modal fade" id="pop_layer_openSource" tabindex="-1" role="dialog" aria-labelledby="ModalLabel" aria-hidden="true">
	<div class="modal-dialog  modal-xl-top" role="document">
		<div class="modal-content">
			<div class="top-modal-header" style="padding-bottom: 10px;">
				<img src="../../login/img/help.png" alt="eXperDB" style="width :350px; margin: 0 0px 0 auto; display: block; "> 
				<button type="button" class="close" data-dismiss="modal" aria-label="Close">
					<span aria-hidden="true">&times;</span>
				</button>
			</div>
			<div class="modal-body" style="padding-top: 0px; padding-bottom: 10px;">
				<h3 class="modal-title" id="ModalLabel" style="padding-left:25px;background:url(../../images/popup/ico_p_1.png) 4px 50% no-repeat;">Open Source License</h3>
				<form>
					<div class="top-form-group">
						<p>This eXperDB is Copyright eXperDB-Management Development Team. All rights reserved.<br>
						This eXperDB use Open Source Software (OSS). You can find the source code of these open source projects,<br>
						along with applicable license information, below.<br>
						We are deeply grateful to these developers for their work and contributions.<p>
					</div>
					<div class="top-deadLine"></div>
					<div class="form-group">
						<p class="col-form-label" style="background: url(../../images/popup/ico_p_2.png) 8px 48% no-repeat; font-weight: bold;padding-left:25px;">Egovframe License</p>
						<p style="padding-left:25px;">	Version 2.0, January 2004 <br />
						http://www.apache.org/licenses/<br /> 
						Apache License</p>
	                </div>
					<div class="top-deadLine"></div>
					<div class="form-group">
						<p class="col-form-label" style="background: url(../../images/popup/ico_p_2.png) 8px 48% no-repeat; font-weight: bold;padding-left:25px;">Datatables</p>
						<p style="padding-left:25px;">	https://datatables.net <br />
						Copyright (C) 2008-2018, SpryMedia Ltd.<br /> 
						MIT license</p>
	                </div>
	                <div id="encryptLicenseInfo">	                
						
	                </div>
				</form>
			</div>
			
			<div class="top-modal-footer" style="text-align: center !important;">
				<button type="button" class="btn btn-light" data-dismiss="modal"><spring:message code="common.close"/></button>
			</div>
		</div>
	</div>
</div>