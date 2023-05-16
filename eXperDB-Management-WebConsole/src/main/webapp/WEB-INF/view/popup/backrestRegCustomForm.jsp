<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>

<%
	/**
	* @Class Name :backrestRegCustomForm.jsp
	* @Description : backrest 백업 커스텀등록 화면
	* @Modification Information
	*
	*/
%>

<script type="text/javascript">
    var bckr_cst_cnt = 0;
    var bckr_cst_check_array = [];
    var bckr_cst_opt = [];
    var select_box_html= [];
    var custom_map = new Map(); //저장하고 난 뒤
    var custom_map_before = new Map();  //저장하기 전
    var custom_cancle;
    var custom_save_chk;
    var custom_change_chk;

	$(window.document).ready(function() {
        bckr_cst_cnt = 0;
        custom_cancle = false;
        custom_save_chk = false;
        custom_change_chk = false;
        
	});

    //Option 추가할 때
    function fn_backrest_custom_add(cancelcnt) {
        var html = '';
        html += '<div id="bckr_cus_row_" class="d-flex" style="margin-bottom: 15px;">';
        html += '<div class="col-sm-2" style="margin-top: 3px;">';
        html += '<input id="bckr_cus_check_" type="checkbox" class="form-control form-control-xsm" /></div>';
        html += '<div class="col-sm-6" style="margin-left: -10px;" id="aaaaa">';
        html += '<select class="form-control form-control-sm" style="width:230px; color: black;" name="ins_bckr_cst_opt" id="ins_bckr_cst_opt_" tabindex=3 onchange="fn_change_custom_opt(this)">';
        html += '<option><spring:message code="common.choice" /></option>';

        for(var i=0; i < bckr_cst_opt.length; i++){
            html += '<option>' + bckr_cst_opt[i].opt_nm + '</option>';
        }

        html += '</select></div>';
        html += '<div class="col-sm-3">';
        html += '<input type="text" id="ins_bckr_cst_val_" class="form-control form-control-sm" maxlength="100" style="width: 150px;" placeholder="값을 입력해주세요" onchange="fn_change_custom_opt_val(this)"/></div>';

        $('#bckr_cus_div').append(html);

        if(cancelcnt == null){
            $("#bckr_cus_check_").attr('id', "bckr_cus_check_"+bckr_cst_cnt)
            $("#bckr_cus_row_").attr('id', "bckr_cus_row_"+bckr_cst_cnt)
            $("#ins_bckr_cst_opt_").attr('id', "ins_bckr_cst_opt_"+bckr_cst_cnt)
            $("#ins_bckr_cst_val_").attr('id', "ins_bckr_cst_val_"+bckr_cst_cnt)
        }else{
            $("#bckr_cus_check_").attr('id', "bckr_cus_check_"+cancelcnt);
            $("#bckr_cus_row_").attr('id', "bckr_cus_row_"+cancelcnt);
			$("#ins_bckr_cst_opt_").attr('id', "ins_bckr_cst_opt_"+cancelcnt);
        	$("#ins_bckr_cst_val_").attr('id', "ins_bckr_cst_val_"+cancelcnt);
        }

        bckr_cst_cnt++;
        
    }

    //Validation 체크 및 map 저장
    function fn_save_custom_map(){
        var iChkCnt = 0;
        select_box_html = [];

        $('#bckr_cus_div').find('select').each(function(){
            select_box_html.push(this)
        })

        for(var i = 0; i < bckr_cst_cnt; i++){
            for(var j=0; j < select_box_html.length; j++){
                if(select_box_html[j].id == "ins_bckr_cst_opt_" + i){
                    if($("#ins_bckr_cst_val_" + i).val() == null || $("#ins_bckr_cst_val_" + i).val() == ''){
                        showSwalIcon('값을 설정하지 않은 옵션이 있습니다', '<spring:message code="common.close" />', '', 'warning')

                        iChkCnt = iChkCnt + 1;
                    }else if($("#ins_bckr_cst_opt_" + i + " option:selected").text() == undefined || $("#ins_bckr_cst_opt_" + i + " option:selected").text() == "선택"){
                        showSwalIcon('선택하지 않은 옵션이 있습니다', '<spring:message code="common.close" />', '', 'warning')

                        iChkCnt = iChkCnt + 1;
                    }else{
                        custom_map_before.set($("#ins_bckr_cst_opt_" + i + " option:selected").text(), $("#ins_bckr_cst_val_" + i).val()); 
                    }
                }
            }
        }

        if (iChkCnt > 0) {
			return false;
		}

		return true;
    }

    function fn_save_custom(){
        if (!fn_save_custom_map()) return false;

        showSwalIcon('사용자정의 옵션이 저장되었습니다.', '<spring:message code="common.close" />', '', 'success');
        $('#pop_layer_reg_backrest_custom').modal("hide");
        
        bckr_cst_opt = [];

        if(custom_map_before.size == 0){
            custom_map.clear();
        }else{
            custom_map.clear();
            for(key of custom_map_before.keys()){
                custom_map.set(key, custom_map_before.get(key));
            } 
        }

        if(custom_save_chk == false){
            custom_save_chk = true;
        }

        custom_cancle = false;
        custom_change_chk = false;

        fn_check_reset();
    }

    //Option 수정
    function fn_change_custom_opt(obj){
        select_box_html = [];
        var opt_val = obj.id;
        opt_val = opt_val.replace('ins_bckr_cst_opt_', '')

        if(custom_save_chk == true){
            custom_change_chk = true;

            $('#bckr_cus_div').find('select').each(function(){
                select_box_html.push(this)
            })
            
            for(key of custom_map_before.keys()){
                for (var i=0; i < select_box_html.length; i++) {
                    if(key == $("#" + select_box_html[i].id + " option:selected").text()){
                        break;
                    }else{
                        if(i == select_box_html.length-1){
                            custom_map_before.set($("#" + obj.id + " option:selected").text(), $("#ins_bckr_cst_val_" + opt_val).val());
                            custom_map_before.delete(key);
                        }
                    }
                }
            }
        }
    }

    //Option의 Value 수정
    function fn_change_custom_opt_val(obj){
        var opt_val = obj.id;
        opt_val = opt_val.replace('ins_bckr_cst_val_', '')

        if(custom_save_chk == true){
            custom_change_chk = true;
            custom_map_before.set($("#ins_bckr_cst_opt_" + opt_val + " option:selected").text(), $("#" + obj.id).val());
        }
    }

    //Option 선택후 지우기
    function fn_backrest_custom_rmv() {
        custom_change_chk = true;
        
        for(var i=0; i < bckr_cst_cnt; i++){
            if($('#bckr_cus_check_'+i).is(':checked')){
                bckr_cst_check_array.push(i);
            }
        }
        
        if(bckr_cst_check_array.length == 0){
            showSwalIcon('<spring:message code="message.msg35" />', '<spring:message code="common.close" />', '', 'warning');
        }else{
            for(var i=0; i < bckr_cst_check_array.length; i++){
                custom_map_before.delete($("#ins_bckr_cst_opt_"+ bckr_cst_check_array[i] + " option:selected").text());

                $("#bckr_cus_row_"+bckr_cst_check_array[i]).empty();
                $("#bckr_cus_row_"+bckr_cst_check_array[i]).remove();
            }

            bckr_cst_check_array = [];
        }
    }

    //전체 삭제
    function fn_backrest_custom_all_rmv() {
        custom_change_chk = true;

        confile_title = 'PG Backrest 사용자정의 옵션 초기화 요청';
		$('#con_multi_gbn', '#findConfirmMulti').val("bckr_cst_del");
        $('#confirm_multi_tlt').html(confile_title);
		$('#confirm_multi_msg').html('설정한 사용자정의 옵션들을 초기화 하시겠습니까?');
		$('#pop_confirm_multi_md').modal("show");

        bckr_cst_cnt = 0;
    }

    function fn_deleteCustom(){
        select_box_html = [];
        custom_map_before.clear();

        $('#bckr_cus_div').find('select').each(function(){
            select_box_html.push(this)
        })
        
		for(var i=0; i < select_box_html.length; i++){
            var opt_val = select_box_html[i].id;
            opt_val = opt_val.replace('ins_bckr_cst_opt_', '')
            
            $("#bckr_cus_row_"+opt_val).empty();
            $("#bckr_cus_row_"+opt_val).remove();
        }
    }

    function fn_custom_cancel(){
        fn_check_reset();
        if(custom_map.size > 0){
            custom_cancle = true;
            custom_map_before.clear();

            for(key of custom_map.keys()){
                custom_map_before.set(key, custom_map.get(key));
            } 
        }

        bckr_cst_opt = [];
        custom_save_chk = false;
    }

    function fn_check_reset(){
        for(var i=0; i < bckr_cst_cnt; i++){
            $("#bckr_cus_check_" + i).prop("checked", false);
        }
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
                                <button type="button" class="btn btn-primary btn-fw" style="width: 50px; padding: 10px; margin-left: 22px;" onclick="fn_backrest_custom_add(null)"><i class="ti-plus btn-icon-prepend "></i></button>
                            </div>
                        </div>

                        <div class="system-tlb-scroll" style="overflow-y:auto;">
                            <div id="bckr_cus_div" style="height: 400px; margin-top: 30px;">
                            </div>
                        </div>
                        
                        <div class="card-body">
                            <div class="top-modal-footer" style="text-align: center !important; margin: -20px 0 -30px; -20px;" >
                                <input class="btn btn-primary" width="200px;" style="vertical-align:middle;" type="submit" value='저장' onclick="fn_save_custom()" />
                                <button type="button" class="btn btn-primary" width="200px;" onclick="fn_backrest_custom_all_rmv()">초기화</button>
                                <button type="button" class="btn btn-light" data-dismiss="modal" onclick="fn_custom_cancel()"><spring:message code="common.cancel"/></button>
                            </div>
                        </div>
                    </div>
                </div>
                
			</div>
		</div>
	</div>
</div>