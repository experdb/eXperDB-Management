$(window).ready(function(){
	// 달력
	useDatepicker();
	$("#datepicker1, #datepicker2").datepicker();
})

// 달력
function useDatepicker(){
$.datepicker.setDefaults({
	dateFormat: 'yy-mm-dd',
	prevText: common_previous_month,
	nextText: common_next_month,
	monthNames: [common_January,common_February,common_March,common_April,common_May,common_June,common_July,common_August,common_September,common_October,common_November,common_December],
	monthNamesShort: [common_January,common_February,common_March,common_April,common_May,common_June,common_July,common_August,common_September,common_October,common_November,common_December],
	dayNames: [schedule_sunday, schedule_monday, schedule_thuesday, schedule_wednesday, schedule_thursday, schedule_friday, schedule_saturday],
	dayNamesShort: [schedule_sunday, schedule_monday, schedule_thuesday, schedule_wednesday, schedule_thursday, schedule_friday, schedule_saturday],
	dayNamesMin: [schedule_sunday, schedule_monday, schedule_thuesday, schedule_wednesday, schedule_thursday, schedule_friday, schedule_saturday],
	showMonthAfterYear: true,
	yearSuffix: etc_etc09
});
}