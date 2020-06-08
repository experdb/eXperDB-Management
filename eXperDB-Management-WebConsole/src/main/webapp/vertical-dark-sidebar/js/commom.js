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
	
	//alert 기본 js
	showSwal = function(msg, btnText) {
		'use strict';
		swal({
			text: msg,
			button: {
				text: btnText,
				value: true,
				visible: true,
				className: "btn btn-primary"
			}
		})
	}
	
	//title 있는 alert
	showSwalTtl = function(msg, btnText, titleText) {
		'use strict';
		swal({
			title: titleText,
			text: msg,
			button: {
				text: btnText,
				value: true,
				visible: true,
				className: "btn btn-primary"
			}
		})
	}
	
	//alert icon 추가 관련 js
	showSwalIcon = function(msg, btnText, titleText, iconText) {
		'use strict';
		swal({
			title: titleText,
			text: msg,
			icon: iconText,
			button: {
				text: btnText,
				value: true,
				visible: true,
				className: "btn btn-primary"
			}
		})
	}
	
	//confirm 관련 js
	showSwalCfm = function(msg, cBtnText, conBtnText, titleText, iconText) {
		'use strict';
		swal({
			title: titleText,
			text: msg,
			icon: iconText,
			showCancelButton: true,
			confirmButtonColor: '#3f51b5',
			cancelButtonColor: '#ff4081',
			confirmButtonText: 'Great ',
			buttons: {
				cancel: {
					text: cBtnText,
					value: null,
					visible: true,
					className: "btn btn-danger",
					closeModal: true,
				},
				confirm: {
					text: conBtnText,
					value: true,
					visible: true,
					className: "btn btn-primary",
					closeModal: true
				}
			}
		})
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

/* cookie 저장 */
function fn_cookie(url) {
	var cssID = sessionStorage.getItem('cssId');

/* 		$("#"+cssID).css("background-color","");
	$("#"+cssID+"c").css("color","");
	$("#"+cssID).css("border","");	

	if(url != null){
		$("#"+url).css("background-color","#f58220");
		$("#"+url+"c").css("color","white");
		$("#"+url).css("border","2px solid #f58220");	
	} */

	sessionStorage.setItem('cssId',url);
}

/* null 값 변경 */
function nvlPrmSet(val, subVal) {
	var strValue = val;
	if( strValue == null || strValue == '') {
		strValue = subVal;
	}
	
	return strValue;
}