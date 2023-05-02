<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>

<%
	/**
	* @Class Name :backrestRegForm.jsp
	* @Description : backrest 백업등록 화면
	* @Modification Information
	*
	*/
%>

<script type="text/javascript">
    var bckr_cst_cnt = 0;
    var bckr_cst_check_array = [];
    var bckr_cst_opt = [];

	$(window.document).ready(function() {
        bckr_cst_cnt = 0;
        
	});

    function fn_backrest_custom_add() {
        var html = '';
        html += '<div id="bckr_cus_row_0" class="d-flex" style="margin-bottom: 15px;">';
        html += '<div class="col-sm-2" style="margin-top: 3px;">';
        html += '<input id="bckr_cus_check_0" type="checkbox" class="form-control form-control-xsm" /></div>';
        html += '<div class="col-sm-6" style="margin-left: -10px;">';
        html += '<select class="form-control form-control-sm" style="width:230px; color: black;" name="ins_bckr_cst_opt" id="ins_bckr_cst_opt" tabindex=3 >';
        html += '<option value=""><spring:message code="common.choice" /></option>';

        for(var i=0; i < bckr_cst_opt.length; i++){
            html += '<option>' + bckr_cst_opt[i].opt_nm + '</option>';
        }

        html += '</select></div>';
        html += '<div class="col-sm-3">';
        html += '<input type="text" class="form-control form-control-sm" maxlength="100" style="width: 150px;" placeholder="값을 입력해주세요"/></div>';

        $("#bckr_cus_check_0").attr('id', "bckr_cus_check_"+bckr_cst_cnt)
        $("#bckr_cus_row_0").attr('id', "bckr_cus_row_"+bckr_cst_cnt)
        $('#bckr_cus_div').append(html);

        // console.log(document.getElementsByTagName('select'));
        
        bckr_cst_cnt++;
    }


    function fn_backrest_custom_rmv() {
        for(var i=0; i < bckr_cst_cnt; i++){
            if($('#bckr_cus_check_'+i).is(':checked')){
                bckr_cst_check_array.push(i, 0);
            }
        }

        if(bckr_cst_check_array.length == 0){
            showSwalIcon('<spring:message code="message.msg35" />', '<spring:message code="common.close" />', '', 'warning');
        }else{
            for(var i=0; i < bckr_cst_check_array.length; i++){
                $("#bckr_cus_row_"+bckr_cst_check_array[i]).empty();
                $("#bckr_cus_row_"+bckr_cst_check_array[i]).remove();
            }
            bckr_cst_check_array = [];
        }
    }

    function fn_backrest_custom_all_rmv() {
        confile_title = 'PG Backrest 사용자정의 옵션 초기화 요청';
		$('#con_multi_gbn', '#findConfirmMulti').val("bckr_cst_del");
        $('#confirm_multi_tlt').html(confile_title);
		$('#confirm_multi_msg').html('설정한 사용자정의 옵션들을 초기화 하시겠습니까?');
		$('#pop_confirm_multi_md').modal("show");
    }

    function fn_deleteCustom(){
		for(var i=0; i < bckr_cst_cnt; i++){
            $("#bckr_cus_row_"+i).empty();
            $("#bckr_cus_row_"+i).remove();
        }
        bckr_cst_cnt = 0;
        bckr_cst_opt = [];
    }
</script>


<div class="modal fade" id="pop_layer_reg_backrest_custom" tabindex="-1" role="dialog" aria-labelledby="ModalLabel" aria-hidden="true" data-backdrop="static" data-keyboard="false" style="display: none; z-index: 1060;">
	<div class="modal-dialog  modal-xl-top" role="document" style="margin: 70px 550px;">
		<div class="modal-content" style="width:600px; ">		 	 
			<div class="modal-body" style="margin-bottom:-30px;">
				<h4 class="modal-title mdi mdi-alert-circle text-info" id="ModalLabel" style="padding-left:5px;">
					사용자정의 옵션
				</h4>

                <div class="card system-tlb-scroll" style="margin-top:10px;border:0px;height:598px;">
                    <div>
                        <div class="card-body card-inverse-primary" style="padding:10px 0 10px 0px; margin-left: 10px;">
                            <div class="d-flex" style="padding: 3px 3px 3px 10px;">
                                <i class="item-icon fa fa-dot-circle-o" style="margin: 7px;"></i>
                                <p class="card-text col-sm-8" style="margin-top: 7px; padding-left: 0;">백업 옵션</p>
                                <button type="button" class="btn btn-primary btn-fw" style="width: 50px; padding: 10px;" onclick="fn_backrest_custom_rmv()"><i class="ti-minus btn-icon-prepend "></i></button>
                                <button type="button" class="btn btn-primary btn-fw" style="width: 50px; padding: 10px; margin-left: 22px;" onclick="fn_backrest_custom_add()"><i class="ti-plus btn-icon-prepend "></i></button>
                            </div>
                        </div>

                        <div class="system-tlb-scroll" style="overflow-y:auto;">
                            <div id="bckr_cus_div" style="height: 400px; margin-top: 30px;">
                            </div>
                        </div>
                        
                        <div class="card-body">
                            <div class="top-modal-footer" style="text-align: center !important; margin: -20px 0 -30px; -20px;" >
                                <input class="btn btn-primary" width="200px;" style="vertical-align:middle;" type="submit" value='저장' />
                                <button type="button" class="btn btn-primary" width="200px;" onclick="fn_backrest_custom_all_rmv()">초기화</button>
                                <button type="button" class="btn btn-light" data-dismiss="modal"><spring:message code="common.cancel"/></button>
                            </div>
                        </div>
                    </div>
                </div>
                
			</div>
		</div>
	</div>
</div>