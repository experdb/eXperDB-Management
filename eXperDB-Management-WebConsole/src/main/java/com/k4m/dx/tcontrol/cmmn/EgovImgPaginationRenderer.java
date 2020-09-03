/*
 * Copyright 2008-2009 the original author or authors.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
package com.k4m.dx.tcontrol.cmmn;

import egovframework.rte.ptl.mvc.tags.ui.pagination.AbstractPaginationRenderer;

import javax.servlet.ServletContext;

import org.springframework.web.context.ServletContextAware;

/**
 * @Class Name : ImagePaginationRenderer.java
 * @Description : ImagePaginationRenderer Class
 * @Modification Information
 * @
 * @  수정일      수정자              수정내용
 * @ ---------   ---------   -------------------------------
 * @ 2009.03.16           최초생성
 *
 * @author 개발프레임웍크 실행환경 개발팀
 * @since 2009. 03.16
 * @version 1.0
 * @see
 *
 *  Copyright (C) by MOPAS All right reserved.
 */
public class EgovImgPaginationRenderer extends AbstractPaginationRenderer implements ServletContextAware{

	private ServletContext servletContext;

	public EgovImgPaginationRenderer() {
		// no-op
	}

	/**
	* PaginationRenderer
	*
	* @see 개발프레임웍크 실행환경 개발팀
	*/
	public void initVariables() {

		firstPageLabel = "<li class='page-item'><a href=\"#\" class='page-link' onclick=\"{0}({1}); return false;\"><<</a><li>&#160;";
		previousPageLabel = "<li class='page-item'><a href=\"#\" class='page-link' onclick=\"{0}({1}); return false;\"><<li></a>&#160;";
		currentPageLabel = "<li class='page-item-active'><a href=\"#\" class='page-link'>{0}</a><li>&#160;";
		otherPageLabel = "<li class='page-item'><a href=\"#\" class='page-link' onclick=\"{0}({1}); return false;\">{2}</a><li>&#160;";
		nextPageLabel = "<li class='page-item'><a href=\"#\" class='page-link' onclick=\"{0}({1}); return false;\">></a><li>&#160;";
		lastPageLabel = "<li class='page-item'><a href=\"#\" class='page-link' onclick=\"{0}({1}); return false;\">>></a><li>&#160;";
	}

	@Override
	public void setServletContext(ServletContext servletContext) {
		this.servletContext = servletContext;
		initVariables();
	}
}
