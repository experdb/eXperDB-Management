(function($) {
	/* 알람 호출*/
	showToastPosition = function(position, msg, titleMsg) {
		'use strict';
		resetToastPosition();
		$.toast({
			heading: titleMsg,
			text: msg,
			position: String(position),
			icon: 'info',
			stack: false,
			loaderBg: '#f96868'
		})
	}

	showToastInCustomPosition_login = function() {
		'use strict';
		resetToastPosition();
		$.toast({
			heading: 'Custom positioning',
			text: 'Specify the custom position object or use one of the predefined ones',
			icon: 'info',
			position: {
				left: 120,
				top: 120
			},
			stack: false,
			loaderBg: '#f96868'
		})
	}

	resetToastPosition = function() {
		$('.jq-toast-wrap').removeClass('bottom-left bottom-right top-left top-right mid-center'); // to remove previous position class
		$(".jq-toast-wrap").css({
			"top": "",
			"left": "",
			"bottom": "",
			"right": ""
		}); //to remove previous position style
	}
})(jQuery);


//About eXperDB
function fn_aboutExperdb(version){
	$("#version").html(version);
}


/* 로그아웃 */
function fn_logout(){
	sessionStorage.removeItem('cssId');

	var frm = document.treeView;
	frm.action = "/logout.do";
	frm.submit();
}