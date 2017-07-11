$(window).ready(function(){
	$(window).on("load",function(){
		if($("#lnb_menu").length > 0){
			$("#lnb_menu").mCustomScrollbar();
		}
	});

	if( $('#lnb_menu').length ) { lnb_fix(); } 

	function lnb_fix(){
		var nav = $("#header");
		var lnb = $("#lnb_menu");
		var hdH = nav.height();

		$(window).scroll(function () {
			var winTop = $(this).scrollTop();
			if (winTop >= hdH) {
				nav.css('top','-77px');
				lnb.css('top','0');
			}else{
				nav.css('top','0');
				lnb.css('top','77px');
			}
		});
	};

	function lnbMenu(){
		$(".lnbMenu li > a").click(function(){
			var li = $(this).parent();
			var ul = li.parent()
			if( li.children('ul').is(':visible') || li.has('ul')) {
				li.children('ul').toggle();
				li.toggleClass('on');
			}
		});
	}lnbMenu();

	// Lnb 전체 열/닫기
	$(".all_close").click(function(){
		$(this).parents('.inr').children('.lnbMenu').find("ul").move("close");
	});
	$(".all_open").click(function(){
		$(this).parents('.inr').children('.lnbMenu').find("ul").move("open");
	});

})
