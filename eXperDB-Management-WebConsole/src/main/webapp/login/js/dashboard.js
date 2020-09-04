var obj = {

};

var empty = $('#dashboardEmpty').clone();
var rootDiv;

$(document).ready(function() {
    initBindAction();

    //위젯
    $('.btn-widget-set').click(function(){
        var $btn = $('.btn-widget');
        var $widget = $('#widget');
        var $dashboard = $('#dashboard');

        if(!$(this).hasClass('checked')){
            $dashboard.addClass('widget-set-mode');
            $widget.removeClass('open');
            $btn.removeClass('checked').attr('disabled', true);
        }else{
            $dashboard.removeClass('widget-set-mode');
        }
	});

    $('.btn-widget').click(function(){
		$('#widget').toggleClass('open');
	});

    //테마변경
	$('[name="theme"]').change(function(){
		var $body = $('body');
		$(this).val() === 'dark' ? $body.addClass('dark') : $body.removeClass('dark');
	});

    //풀스크린
    var elem = document.getElementById('dashboard');
    $('.btn-fullscreen').on('click',function(){
        elem.msRequestFullscreen();
    });

    $('body').keydown(function(){
        if(122 === event.keyCode && elem.msRequestFullscreen) event.preventDefault();
    });
});

function initBindAction() {

    $("#widget").find('li').draggable({
        cursor: 'pointer',
        revert: true,
        scroll: false,
        helper: 'clone',
        appendTo: 'body',
    });

    $("#containerBody").droppable({
        drop: function(event, ui) {

            if (0 != Object.keys(obj).length) return false;

            var uuid = getUUID();

            obj[uuid] = {};

            rootDiv = $("<div/>").attr({
                'id': 'root'
            }).data({
                'width': '100%',
                'height': '100%',
                'vlimit': 4,
                'hlimit': 5,
            });

            rootDiv.vlimit = rootDiv.data('vlimit');
            rootDiv.hlimit = rootDiv.data('hlimit');

            var widgetItem = $(ui.draggable);
            var title = widgetItem.html();
            var bodyBg = widgetItem.data('bg');

            var componentDiv = initNewComponent(title, bodyBg);

            componentDiv.data('width', '100%').data('height', '100%');

            $(this).append(rootDiv.append(componentDiv));

            initDroppable(componentDiv);

            initDelete(componentDiv);

            $('#dashboardEmpty').remove();
        }
    });
}

function initDroppable(componentDiv, a) {

    $(componentDiv).find('.componentDroppable').droppable({
        tolerance: 'pointer',
        drop: function(event, ui) {

            var appendDirection = $(this).parent().parent().data('appendDirection');
            var widgetItem = $(ui.draggable);
            var title = widgetItem.html();
            var bodyBg = widgetItem.data('bg');
            var $parents = $(this).parent().parent();
            var childrenList = $parents.children().not('.ui-resizable-handle');;

            if ('left' == $(this).data('type') || 'right' == $(this).data('type')) { // 가로드롭
                if(childrenList.length == $parents.data('hlimit')){
                    return false;
                }

                var componentDiv = initNewComponent(title, bodyBg);

                if (!appendDirection || 'horizontal' == appendDirection) {

                    $parents.data('appendDirection', 'horizontal');

                    var adjustWidth = (Number($parents.data('width').replace(/[^.0-9]/g, "")) / (childrenList.length+1)).toFixed(4);

                    childrenList.each(function(){
                        var parentsW = $parents.width();
                        var addW = parentsW * (adjustWidth*0.01);
                        var changeW = $(this).width() / (parentsW) * (parentsW-addW);

                        $(this).css('width', (changeW/parentsW*100).toFixed(4) + '%').data('width', (changeW/parentsW*100).toFixed(4) + '%');
                    });

                    if ('left' == $(this).data('type')) $(this).parent().before(componentDiv);
                    else $(this).parent().after(componentDiv);

                    componentDiv.css('width', adjustWidth + '%').data('width', adjustWidth + '%');

                    //event bind droppable
                    initDroppable(componentDiv);

                    //event bind resizable
                    initResizableAll($(this).parent());
                    initResizableAll(componentDiv);

                    //event bind delete
                    initDelete(componentDiv);

                } else { // 가로 병합
                    var componentParentDiv = $("<div/>").addClass('component-horizontal').css({
                            'width': $(this).parent().data('width'),
                            'height': $(this).parent().data('height')
                        })
                        .data('appendDirection', 'horizontal')
                        .data('width', $(this).parent().data('width'))
                        .data('height', $(this).parent().data('height'))
                        .data('hlimit', rootDiv.hlimit);

                    //cloneElement
                    var cloneElement = $(this).parent().clone();
                    cloneElement.find('.ui-droppable-active').removeClass('ui-droppable-active');

                    var componentDroppableList = cloneElement.children('.componentDroppable');

                    for (var i = 0; i < componentDroppableList.length; i++) {
                        $(componentDroppableList[i]).data('type', $($(this).parent().children('.componentDroppable')[i]).data('type'));
                    }

                    //append
                    if ('left' == $(this).data('type')) componentParentDiv.append(componentDiv).append(cloneElement);
                    else componentParentDiv.append(cloneElement).append(componentDiv);

                    $(this).parent().before(componentParentDiv);

                    componentParentDiv.parent()[0].id !== 'root' && componentParentDiv.data('hlimit', Math.floor(rootDiv.hlimit/2));

                    //remove
                    $(this).parent().remove();

                    //width height
                    var valObj = {
                        'width': (100 / componentParentDiv.children().length) + '%',
                        'height': '100%'
                    }
                    componentParentDiv.children().css(valObj).data(valObj);

                    //event bind droppable
                    initDroppable(cloneElement, 1);
                    initDroppable(componentDiv, 2);

                    //event bind resizable
                    initResizableAll(componentParentDiv);
                    initResizableAll(cloneElement);
                    initResizableAll(componentDiv);

                    //event bind delete
                    initDelete(cloneElement);
                    initDelete(componentDiv);
                }

            } else { // 세로드롭
                if(childrenList.length == $parents.data('vlimit')){
                    return false;
                }

                var componentDiv = initNewComponent(title, bodyBg);

                if (!appendDirection || 'vertical' == appendDirection) {

                    $parents.data('appendDirection', 'vertical');

                    var adjustHeight = (Number($parents.data('height').replace(/[^.0-9]/g, "")) / (childrenList.length+1)).toFixed(4);

                    childrenList.each(function(){
                        var parentsH = $parents.height();
                        var addH = parentsH * (adjustHeight*0.01);
                        var changeH = $(this).height() / (parentsH) * (parentsH-addH);

                        $(this).css({
                            'height': (changeH/parentsH*100).toFixed(4) + '%'
                        }).data('height', (changeH/parentsH*100).toFixed(4) + '%');
                    });

                    if ('top' == $(this).data('type')) $(this).parent().before(componentDiv);
                    else $(this).parent().after(componentDiv);

                    componentDiv.css('height', adjustHeight + '%').data('height', adjustHeight + '%');

                    //event bind droppable
                    initDroppable(componentDiv);

                    //event bind resizable
                    initResizableAll($(this).parent());
                    initResizableAll(componentDiv);

                    //event bind delete
                    initDelete(componentDiv);

                } else { // 세로 병합
                    var componentParentDiv = $("<div/>").addClass('component-vertical').css({
                            'width': $(this).parent().data('width'),
                            'height': $(this).parent().data('height')
                        })
                        .data('appendDirection', 'vertical')
                        .data('width', $(this).parent().data('width'))
                        .data('height', $(this).parent().data('height'))
                        .data('vlimit', rootDiv.vlimit);

                    //cloneElement
                    var cloneElement = $(this).parent().clone();
                    cloneElement.find('.ui-droppable-active').removeClass('ui-droppable-active');

                    var componentDroppableList = cloneElement.children('.componentDroppable');

                    for (var i = 0; i < componentDroppableList.length; i++) {
                        $(componentDroppableList[i]).data('type', $($(this).parent().children('.componentDroppable')[i]).data('type'));
                    }

                    //append
                    if ('top' == $(this).data('type')) componentParentDiv.append(componentDiv).append(cloneElement);
                    else componentParentDiv.append(cloneElement).append(componentDiv);

                    $(this).parent().before(componentParentDiv);

                    componentParentDiv.parent()[0].id !== 'root' && componentParentDiv.data('vlimit', Math.floor(rootDiv.vlimit/2));

                    //remove
                    $(this).parent().remove();

                    //width height
                    var valObj = {
                        'width': '100%',
                        'height': (100 / componentParentDiv.children().length) + '%'
                    }
                    componentParentDiv.children().css(valObj).data(valObj);

                    //event bind droppable
                    initDroppable(cloneElement);
                    initDroppable(componentDiv);

                    //event bind resizable
                    initResizableAll(componentParentDiv);
                    initResizableAll(cloneElement);
                    initResizableAll(componentDiv);

                    //event bind delete
                    initDelete(cloneElement);
                    initDelete(componentDiv);

                }

            }
        }
    });
}

function initResizableAll(componentDiv) {

    var totalOrgWidth = null;
    var totalOrgHeight = null;

    if ($(componentDiv).resizable()) $(componentDiv).resizable('destroy');

    $(componentDiv).resizable({
        minWidth: rootDiv.width()/rootDiv.hlimit,
        minHeight: rootDiv.height()/rootDiv.vlimit,
        handles: "w, n",
        start: function(event, ui) {
            if (initBeforeResizable($(this))) {
                totalOrgWidth = Number($(this).data('width').replace(/[^.0-9]/g, "")) + Number($(this).prev().data('width').replace(/[^.0-9]/g, ""));
                totalOrgHeight = Number($(this).data('height').replace(/[^.0-9]/g, "")) + Number($(this).prev().data('height').replace(/[^.0-9]/g, ""));
            }
        },
        resize: function(event, ui) {
            if (initBeforeResizable($(this))) {

                var axis = $(this).data('ui-resizable').axis;
                $(ui.element).resizable("option","maxWidth", "");
                $(ui.element).resizable("option","maxHeight", "");

                if ('w' == axis) {

                    var currentWidth = $(this).width();
                    var prevWidth = $(this).prev().width();
                    var totalWidth = currentWidth + prevWidth;

                    var prevWidthPer = (prevWidth * 100) / totalWidth;
                    var prevWidthVal = totalOrgWidth * (prevWidthPer / 100);

                    $(this).prev().css('width', prevWidthVal + '%').data('width', prevWidthVal + '%');

                    $(this).css('width', (totalOrgWidth - prevWidthVal) + '%').data('width', (totalOrgWidth - prevWidthVal) + '%');

                    if(prevWidthVal < (100/rootDiv.hlimit)+0.5){
                        $(ui.element).resizable("option","maxWidth",ui.size.width);
                        return;
                    }

                } else if ('n' == axis) {

                    var currentHeight = $(this).height();
                    var prevHeight = $(this).prev().height();
                    var totalHeight = currentHeight + prevHeight;

                    var prevHeightPer = (prevHeight * 100) / totalHeight;

                    var prevHeightVal = totalOrgHeight * (prevHeightPer / 100);

                    $(this).prev().css('height', prevHeightVal + '%').data('height', prevHeightVal + '%');

                    $(this).css('height', (totalOrgHeight - prevHeightVal) + '%').data('height', (totalOrgHeight - prevHeightVal) + '%');

                    if(prevHeightVal < (100/rootDiv.vlimit)+0.5){
                        $(ui.element).resizable("option","maxHeight",ui.size.height);
                        return;
                    }
                }

            } else {
                $(this).css({
                    'width': $(this).data('width'),
                    'height': $(this).data('height'),
                    'top': 0,
                    'left': 0
                });
            }
        }
    });
}

function initNewComponent(title, bodyBg) {

    var componentDiv = $("<div/>").addClass('component').css({
        'width': '100%',
        'height': '100%',
    }).data({
        'width': '100%',
        'height': '100%',
    });

    var card = $("<section/>").addClass('card');

    var cardHeader = $("<h2/>").addClass('card-header').html(title);

    var cardBody = $("<div/>").addClass('card-body').css({
        'background-image': "url('img/dashboard/"+bodyBg+".svg')"
    });

    componentDiv.append(card);

    card.append(cardHeader, cardBody);

    componentDiv.append($("<div/>").addClass('componentDelete'));

    componentDiv.append($("<div/>").addClass('componentEdit'));

    componentDiv.append($("<div/>").addClass('componentDroppable top').data('type', 'top'));

    componentDiv.append($("<div/>").addClass('componentDroppable bottom').data('type', 'bottom'));

    componentDiv.append($("<div/>").addClass('componentDroppable left').data('type', 'left'));

    componentDiv.append($("<div/>").addClass('componentDroppable right').data('type', 'right'));

    return componentDiv;
}

function initBeforeResizable(componentDiv) {

    var isAbleResize = false;
    var axis = $(componentDiv).data('ui-resizable').axis;
    var appendDirection = $(componentDiv).prev().parent().data('appendDirection');

    if (('n' === axis && 'vertical' === appendDirection) || ('w' === axis && 'horizontal' === appendDirection)) {
        isAbleResize = true;
    }

    return isAbleResize;
}

function initDelete(componentDiv) {

    $(componentDiv).find('.componentDelete').off('click');

    $(componentDiv).find('.componentDelete').on('click', function() {

        var $root = $(this).parent().parent();
        var childrenList = $root.children().not('.ui-resizable-handle');

        if ('root' === $root.attr('id') && 1 === (childrenList.length)) {
            delete obj[Object.keys(obj)[0]];
            $root.before(empty);
            $root.remove();
        }else{
            var appendDirection = $root.data('appendDirection');
            var target = $(this).parent();

            if('root' !== $root.attr('id') && 2 === (childrenList.length)){
                var parents = target.parent();
                var valObj = {
                    'appendDirection' : parents.data('appendDirection'),
                    'width' : parents.data('width'),
                    'height' : parents.data('height'),
                }
                var cloneElement = target.siblings().not('.ui-resizable-handle').clone().css(valObj).data(valObj);

                parents.before(cloneElement);

                var componentDroppableList = cloneElement.children('.componentDroppable');

                for(var i = 0; i < componentDroppableList.length; i++) {
                    $(componentDroppableList[i]).data('type', $(target.children('.componentDroppable')[i]).data('type'));
                }

                initResizableAll(cloneElement);
                initDelete(cloneElement);
                initDroppable(cloneElement);

                target = parents;
                appendDirection = parents.data('appendDirection');
                childrenList = parents.children().not('.ui-resizable-handle');
            }

            var prop = ('horizontal' === appendDirection) ? 'width' : 'height';
            var addVal = Number(target.data(prop).replace(/[^.0-9]/g, "")) / (childrenList.length-1);

            childrenList.each(function(){
                var $t = $(this);

                if($t.data(prop)){
                    var originVal = Number($t.data(prop).replace(/[^.0-9]/g, ""));
                    $t.css(prop, (originVal+addVal).toFixed(4) + '%').data(prop, (originVal+addVal).toFixed(4) + '%');
                }
            });

            target.remove();
        }
    });
}

function getUUID() {
    return 'xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx'.replace(/[xy]/g, function(c) {
        var r = Math.random() * 16 | 0,
            v = c == 'x' ? r : (r & 0x3 | 0x8);
        return v.toString(16);
    });
}
