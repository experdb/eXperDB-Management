<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">

<style>
.addOption_grp .tab > li {
    width: 20%;
    height: 34px;
    margin-left: 0.5%;
}
</style>

<script type="text/javascript">
/* ********************************************************
 * Tab Click
 ******************************************************** */
function selectDDL(tab){	
	if(tab == "table"){
		$("#tableTab").show();
		$("#constraintTab").hide();
		$("#indexTab").hide();
		$("#sequenceTab").hide();
	}else if (tab == "constraint"){
		$("#tableTab").hide();
		$("#constraintTab").show();
		$("#indexTab").hide();
		$("#sequenceTab").hide();
	}else if (tab == "index"){
		$("#tableTab").hide();
		$("#constraintTab").hide();
		$("#indexTab").show();
		$("#sequenceTab").hide();
	}else {
		$("#tableTab").hide();
		$("#constraintTab").hide();
		$("#indexTab").hide();
		$("#sequenceTab").show();
	}
}

</script>


<div id="pop_layer_db2pgDDLResult" class="pop-layer">
		<div class="pop-container" style="padding: 0px;">
			<div class="pop_cts" style="width: 55%; height: 600px; overflow: auto; padding: 20px; margin: 0 auto; min-height:0; min-width:0; margin-top: 10%" id="db2pgDDLResult">
				<p class="tit" style="margin-bottom: 15px;"><spring:message code="migration.ddl_execution_result"/>
					<a href="#n" class="btn" onclick="toggleLayer($('#pop_layer_db2pgDDLResult'), 'off');" style="float: right;"><img src="/images/ico_state_01.png" style="margin-left: 235px;"/></a>
				</p>
				<div class="pop_cmm c2 mt25">
					<div class="addOption_grp">
						<ul class="tab">
							<li class="on"><a href="javascript:selectDDL('table')">TABLE</a></li>
							<li><a href="javascript:selectDDL'constraint')">CONSTRAINT</a></li>
							<li><a href="javascript:selectDDL('index')">INDEX</a></li>
							<li><a href="javascript:selectDDL('sequence')">SEQUENCE</a></li>
						</ul>
						<div class="tab_view">
							<div class="view on addOption_inr" id="tableTab">
								<textarea name="table" id="table" style="height: 440px;" maxlength="100"  readonly></textarea>
							</div>
							<div class="view addOption_inr" id="constraintTab">
								<textarea name="constraint" id="constraint" style="height: 440px;" maxlength="100"  readonly></textarea>
							</div>
							<div class="view addOption_inr" id="indexTab">
								<textarea name="index" id="index" style="height: 440px;" maxlength="100"  readonly></textarea>
							</div>
							<div class="view addOption_inr" id="sequenceTab">
								<textarea name="sequence" id="sequence" style="height: 440px;" maxlength="100"  readonly></textarea>
							</div>
						</div>
					</div>
				</div>
				<div class="btn_type_02">
					<a href="#n" class="btn" onclick="toggleLayer($('#pop_layer_db2pgDDLResult'), 'off');"><span><spring:message code="common.close"/></span></a>
				</div>
				
			</div>
		</div><!-- //pop-container -->
	</div>