$(window).ready(function(){
	// 달력
	useDatepicker();
})

// 달력
function useDatepicker(){
	if ($(".totDatepicker").length) {
	    $('.totDatepicker').datepicker({
	    	format : 'yyyy-mm-dd' /* 선택 날짜 포멧 */
	    	, language : "kr" /* 한국어 */
	    	, weekStart : 0  //달력 시작 요일 선택하는 것 기본값은 0인 일요일 
	    	, autoclose : true /* 사용자가 날짜를 클릭하면 자동 캘린더가 닫히는 옵션 */
	    	, todayHighlight : true /* 오늘날짜 */
	    	, showWeekDays : true  // 위에 요일 보여주는 옵션 기본값 : true
		    , templates : {
		        leftArrow: '&laquo;',
		        rightArrow: '&raquo;'
		    } //다음달 이전달로 넘어가는 화살표 모양 커스텀 마이징 
	   		, clearBtn : false //날짜 선택한 값 초기화 해주는 버튼 보여주는 옵션 기본값 false 보여주려면 true
	    	, multidate : false //여러 날짜 선택할 수 있게 하는 옵션 기본값 :false 
	    	, multidateSeparator :"," //여러 날짜를 선택했을 때 사이에 나타나는 글짜 2019-05-01,2019-06-01
	    	, calendarWeeks : false //캘린더 옆에 몇 주차인지 보여주는 옵션 기본값 false 보여주려면 
	    	, daysOfWeekHighlighted : [6, 0] //강조 되어야 하는 요일 설정
	   		, enableOnReadonly: true
	   		, endDate: new Date()	//달력에서 선택 할 수 있는 가장 느린 날짜. 이후로 선택 불가 ( d : 일 m : 달 y : 년 w : 주)
/*	    
	   		, startDate: '-10d'	//달력에서 선택 할 수 있는 가장 빠른 날짜. 이전으로는 선택 불가능 ( d : 일 m : 달 y : 년 w : 주)
 			, datesDisabled : ['2019-06-24','2019-06-26'] //선택 불가능한 일 설정 하는 배열 위에 있는 format 과 형식이 같아야함.
	    	, title: "테스트"	//캘린더 상단에 보여주는 타이틀
		    , toggleActive : true	//이미 선택된 날짜 선택하면 기본값 : false인경우 그대로 유지 true인 경우 날짜 삭제
		    , daysOfWeekDisabled : [0,6]	//선택 불가능한 요일 설정 0 : 일요일 ~ 6 : 토요일
		    , daysOfWeekHighlighted : [3] //강조 되어야 하는 요일 설정
		    , immediateUpdates: false	//사용자가 보는 화면으로 바로바로 날짜를 변경할지 여부 기본값 :false 
		    , templates : {
		        leftArrow: common_previous_month,
		        rightArrow: common_next_month
		    } //다음달 이전달로 넘어가는 화살표 모양 커스텀 마이징 
		    */
	    });
	}
}