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