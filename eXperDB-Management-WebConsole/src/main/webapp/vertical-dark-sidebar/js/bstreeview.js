/*! @preserve
 * bstreeview.js
 * Version: 1.0.0
 * Authors: Sami CHNITER <sami.chniter@gmail.com>
 * Copyright 2020
 * License: Apache License 2.0
 *
 * Project: https://github.com/chniter/bstreeview
 */
; (function ($, window, document, undefined) {
    "use strict";
    /**
     * Default bstreeview  options.
     */
    var pluginName = "bstreeview",
        defaults = {
            expandIcon: 'menu-arrow',
            collapseIcon: 'menu-arrow',
            indent: 1.25
        };

    /**
     * bstreeview HTML templates.
     */
    var templates = {		
        treeview: '<div class="bstreeview"></div>',
    	treeviewNew : '<li class="nav-item"></li>',
    	treeviewItemLst: '<a class="nav-link" href="#itemid" ></a>',
    	treeviewItem: '<a class="nav-link mainMenu" data-toggle="collapse" class="list-group-item" href="#itemid" aria-expanded="false" aria-controls="ui-basic"></a>',
    	treeviewItemServer: '<a class="nav-link mainMenu" data-toggle="collapse" class="list-group-item" href="#itemid" aria-expanded="false" aria-controls="ui-basic"></a>',
        treeviewGroupItem: '<div class="list-group collapse" id="itemid"></div>',
        treeviewGroupItemLst: '<div id="itemid"></div>',
        treeviewItemStateIcon: '<i class="state-icon menu-icon"></i>',
        treeviewItemIcon: '<i class="item-icon"></i>',
        treeviewItemSertverTooltip: '<span class="menu-title" data-toggle="tooltip" data-placement="top" title=""></span>',
        treeviewSubGroupItem:'<ul class="nav flex-column sub-menu"></ul>'
    };

    /**
     * BsTreeview Plugin constructor.
     * @param {*} element 
     * @param {*} options 
     */
    function bstreeView(element, options) {
        this.element = element;
        this.itemIdPrefix = element.id + "-item-";
        this.settings = $.extend({}, defaults, options);
        this.init();
    }
    /**
     * Avoid plugin conflict.
     */
    $.extend(bstreeView.prototype, {
        /**
         * bstreeview intialize.
         */
        init: function () {
            this.tree = [];
            this.nodes = [];
            // Retrieve bstreeview Json Data.
            if (this.settings.data) {
                this.settings.data = $.parseJSON(this.settings.data);
                this.tree = $.extend(true, [], this.settings.data);
                delete this.settings.data;
            }
            // Set main bstreeview class to element.
            $(this.element).addClass('bstreeview');

            this.initData({ nodes: this.tree });
            var _this = this;
            this.build($(this.element), this.tree, 0);
            // Update angle icon on collapse
            $('.bstreeview').on('click', '.list-group-item', function () {
                $('.state-icon', this)
                    .toggleClass(_this.settings.expandIcon)
                    .toggleClass(_this.settings.collapseIcon);
            });
        },
        /**
         * Initialize treeview Data.
         * @param {*} node 
         */
        initData: function (node) {
            if (!node.nodes) return;
            var parent = node;
            var _this = this;
            $.each(node.nodes, function checkStates(index, node) {

                node.nodeId = _this.nodes.length;
                node.parentId = parent.nodeId;
                _this.nodes.push(node);

                if (node.nodes) {
                    _this.initData(node);
                }
            });
        },
        /**
         * Build treeview.
         * @param {*} parentElement 
         * @param {*} nodes 
         * @param {*} depth 
         */
        build: function (parentElement, nodes, depth) {
            var _this = this;
            // Calculate item padding.
            var leftPadding = "1.25rem;";
            var iCnt = 1;
            if (depth >= 1) {
            	leftPadding = (depth * _this.settings.indent).toString() + "rem;";
            }
            
            var node_tot_url = "";

            depth += 1;
            
            // Add each node and sub-nodes.
            $.each(nodes, function addNodes(id, node) {
                // Main node element. li
            	var treeviewNew = $(templates.treeviewNew);
            	
            	if (depth == 0 || depth == 1) {
	            	//a?쒓렇
	                var treeItem = null;

	                if (iCnt == 1) {
		                treeItem = $(templates.treeviewItemServer)
		                	.attr('aria-controls',  _this.itemIdPrefix+"main-" + iCnt)
	/*                    	.attr('style', 'padding-left:' + leftPadding)*/
		                	.attr('aria-expanded',  "true")
		                	.attr('id',  _this.itemIdPrefix + iCnt)
	            			.attr('onclick', "fn_server_treeMenu_click('"+ _this.itemIdPrefix + "', '"+ _this.itemIdPrefix+"main-" + iCnt + "')")
		                    .attr('href', "#" + _this.itemIdPrefix+"main-" + iCnt);
	                } else {
		                treeItem = $(templates.treeviewItemServer)
		                	.attr('aria-controls',  _this.itemIdPrefix+"main-" + iCnt)
	/*                    	.attr('style', 'padding-left:' + leftPadding)*/
		                	.attr('aria-expanded',  "false")
		                	.attr('id',  _this.itemIdPrefix + iCnt)
	            			.attr('onclick', "fn_server_treeMenu_click('"+ _this.itemIdPrefix + "', '"+ _this.itemIdPrefix+"main-" + iCnt + "')")
		                    .attr('href', "#" + _this.itemIdPrefix+"main-" + iCnt);
	                }
	                
	                //span?쒓렇 - Set node Text.
	                var treeviewItemSertverTooltip = $(templates.treeviewItemSertverTooltip).attr('title', node.tooltiptext);
	                treeviewItemSertverTooltip.append(node.text);
	                treeviewItemSertverTooltip.attr('style', 'color: #68afff !important;');

	                treeItem.append(treeviewItemSertverTooltip);
	
	                // set node icon if exist.
	                if (node.icon) {
	                    var treeItemIcon = $(templates.treeviewItemIcon).addClass(node.icon + " menu-icon");
	                    treeItemIcon.attr('style', 'color: #68afff !important;');
	                    treeItem.append(treeItemIcon);
	                }
	
	                treeItem.append(treeviewItemSertverTooltip);
	           
	                // Set Expand and Collapse icones.
	                if (node.nodes) {
	                    var treeItemStateIcon = $(templates.treeviewItemStateIcon).addClass(_this.settings.collapseIcon);
	                    treeItem.append(treeItemStateIcon);
	                }

	                treeviewNew.append(treeItem);
	
	                // Attach node to parent.
	                parentElement.append(treeviewNew);

	                // Build child nodes.
	                if (node.nodes) {
	                	var treeGroup = null;
	                    // Node group item.
		                if (iCnt == 1) {
		                	treeGroup = $(templates.treeviewGroupItem)
		                					.attr('id', _this.itemIdPrefix+"main-" + iCnt)
		                					.addClass('show')
		                					;
		                } else {
		                	treeGroup = $(templates.treeviewGroupItem).attr('id', _this.itemIdPrefix+"main-" + iCnt);
		                }

	                    treeviewNew.append(treeGroup);
	                    parentElement.append(treeviewNew);
	                    _this.build(treeGroup, node.nodes, depth);
	                }
	               // jQuery("a[aria-controls='" + _this.itemIdPrefix + "0" + "']").click();

	                iCnt = iCnt + 1;
            	} else {
        			// Main node element.
        			var treeviewSubGroupItem = $(templates.treeviewSubGroupItem);
        			var treeviewNew = $(templates.treeviewNew);

        			var treeItem;
        			
        			if (node.menu_gbn == "blnck") {
            			treeviewNew.attr('id', "");
            			treeviewNew.attr('style', "height:3px;");
            			treeviewNew.attr('line-height', "0px");
        			} else {
        				node_tot_url = "";
            			if (node.nodes) {
            				treeItem = $(templates.treeviewItemLst)
            					.attr('style', 'padding-left:' + leftPadding)
            					.attr('id', node.id + "c")
            					.attr('href', "#" + _this.itemIdPrefix + node.nodeId);
            			} else {
            				
            				if (nvlPrmSet(node.url, '') == "" ) {
            					node_tot_url = "javascript:void(0)";
            				} else {
            					node_tot_url = node.url;
            				}

            				treeItem = $(templates.treeviewItemLst)
            					.attr('style', 'padding-left:' + leftPadding)
            					.attr('id', node.id + "c")
            					.attr('href', node_tot_url)
            					.attr('onclick', "fn_GoLink('"+ node.id + "')")
            					treeItem.attr('target', "main");
            			}

            			// set node icon if exist.
            			if (node.icon) {
            				var treeItemIcon = $(templates.treeviewItemIcon).addClass(node.icon);
            				treeItemIcon.attr('id', "i" + node.id);
            				treeItemIcon.attr('name', "iIconChk");
            				treeItem.append(treeItemIcon);
            			}
            			
                        // Set node Text.
                        // treeItem.append("    " + node.text);
                         treeItem.append("&nbsp;" + node.text);
                         
                        if (node.menu_gbn =="server") {
                        	treeItem.attr('style', 'padding-left:' + leftPadding);
                        //	treeItem.attr('style', 'color: #68afff !important; padding-left:' + leftPadding);
                        }
                        
                       // treeItem.attr('style', 'color: #68afff !important;');

            			// Set Expand and Collapse icones.
            			if (node.nodes) {
     /*       				var treeItemStateIcon = $(templates.treeviewItemStateIcon).addClass(_this.settings.collapseIcon);
            				treeItem.append(treeItemStateIcon);*/
            			}

            			treeviewNew.append(treeItem);
            			treeviewNew.attr('id', node.id);
            			treeviewNew.attr('style', "height:23px;");
        			}
        			
        			treeviewSubGroupItem.append(treeviewNew);

        			// Attach node to parent.
        			parentElement.append(treeviewSubGroupItem);
  
        			// Build child nodes.
        			if (node.nodes) {
        				// Node group item.
        				var treeGroup = $(templates.treeviewGroupItemLst).attr('id', _this.itemIdPrefix + node.nodeId);
        				parentElement.append(treeGroup);
        				_this.build(treeGroup, node.nodes, depth);
        	/*			$('#' + node.id + "c").get(0).click();*/
        			}
        			
            	}
            });
        }
    });

    // A really lightweight plugin wrapper around the constructor,
    // preventing against multiple instantiations
    $.fn[pluginName] = function (options) {
        return this.each(function () {
            if (!$.data(this, "plugin_" + pluginName)) {
                $.data(this, "plugin_" +
                    pluginName, new bstreeView(this, options));
            }
        });
    };
})(jQuery, window, document);