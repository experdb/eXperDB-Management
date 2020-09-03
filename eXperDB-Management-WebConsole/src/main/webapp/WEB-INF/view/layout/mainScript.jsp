<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c"      uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>

<script type="text/javascript">
	//treemenu 강제클릭이벤트
	function fn_treeMenu_move(id) {
		$("#" + id + "c").get(0).click();
	}

	//top 메뉴 클릭
	function fn_topMenuChk() {
 		$('.fa-spin').toggleClass('fa-spin');
 		$('.text-tree-click').toggleClass('text-tree-click');
	}

	//서버메뉴 클릭한 이벤트
	function fn_server_treeMenu_click(id, ingId) {
 		
		var iCnt = 1;
		var idChk = "";

 		if ($('.mainMenu').length > 0) {
			$('.mainMenu').each(function( index, element ) {
				idChk = id+"main-" + iCnt;

				if (ingId != idChk) {
	 				if ($('#' + id+"main-" + iCnt).hasClass('show') == true) {
						jQuery("a[aria-controls='" + id + "main-" + iCnt + "']").attr('aria-expanded',  "false");
						$('#' + id+"main-" + iCnt).removeClass('show');
					}
				}

				iCnt = iCnt + 1;
		    });
		}
	}
	
	/* link move */
	function fn_GoLink(url) {
		$('.fa-spin').toggleClass('fa-spin');
		//선택 spin
		$("#i"+url).toggleClass('fa-spin');

		$('.text-tree-click').toggleClass('text-tree-click');
		$("#"+url + "c").toggleClass('text-tree-click');

		sessionStorage.setItem('cssId',url);
	}
</script>