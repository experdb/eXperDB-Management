// Panel Open
function panelOpen(o){
	var $wrap = $('#wrap'),
		a = -$wrap.scrollTop(),
		target = $('#'+o),
		$body = $('body');

	$wrap.css('top', a);
	target.data('backdrop') !== false && target.after('<div class="backdrop"></div>');
	if($body.hasClass('fixed')){
		$body.removeAttr('class');
		$('.panel').hide();
	}
	$body.addClass('fixed');
	setTimeout(function  () {
		target.show(0,function(){
			$body.addClass('panel-open-'+o);
		});
	},200);
}

// Panel Close
function panelClose(o){
	var $wrap = $('#wrap'),
		originScroll = -$wrap.position().top,
		$body = $('body');

	$body.removeClass('panel-open-'+o).find('.backdrop').remove();
	setTimeout(function(){
		$('#'+o).hide();
		$body.removeClass('fixed');
		if (originScroll != -0) {
			$wrap.scrollTop(originScroll);
		}
		$wrap.removeAttr('style');
	},200);
}

$(function(){
    var $body = $('body'),
        $tooltip = $('[data-toggle="tooltip"]');

	$('.menu-toggler').click(function(){
        $(this).hasClass('d-lg-none') ? panelOpen('sidebar') : $body.toggleClass('sidebar-toggled');
    });

	$(document).on('click',function(e){
		var tg = '.panel-content';
		if(!$body.is($("[class*='panel-open']")) || $('[data-backdrop="false"]').is(':visible')){
			return;
		}
		if(!$(e.target).closest(tg).length && !$(e.target).is(tg)) {
			panelClose($(tg+':visible').parents('.panel').attr('id'));
	    }
	});

	$(document).on('click', '[data-toggle="toggle"]', function(){
		var $t = $(this);
		var txt = $t.data('class');
		var target = $t.data('target') || $t.attr('href');
		$(target).toggleClass(txt);
	});

	// tooltip
    $tooltip.length && $tooltip.tooltip();

	// select
	var select = $('.selectpicker');
	select.length && select.selectpicker();
	select.on({
		'show.bs.select' : function(e){
			var label = $(e.target).parents('.form-control-label');
			label.length && label.addClass('active');
		},
		'hide.bs.select' : function(e){
			var label = $(e.target).parents('.form-control-label');
			label.length && label.removeClass('active');
		}
	});
	$('.form-control-label:not(.label-select)').on({
		click: function() {
			$(this).addClass('active');
		},
		focusout: function(){
			$(this).removeClass('active');
		}
	});

	// input
	$('th .custom-control-input').prop('indeterminate', true);
	$('button.custom-switch').click(function(){
		$(this).toggleClass('checked');
	});

	//tab
	$('[data-tab="multi"]').click(function(){
		$('[data-tab-target]').removeClass('active');
		$('[data-tab-target="'+$(this).attr('href')+'"]').addClass('active');
	});
});
