package com.k4m.dx.tcontrol.cmmn;

/**
* @author 박태혁
* @see
* 
*      <pre>
* == 개정이력(Modification Information) ==
*
*   수정일       수정자           수정내용
*  -------     --------    ---------------------------
*  2018.04.23   박태혁 최초 생성
*      </pre>
*/
public class cmmnExcepHndlr extends RuntimeException {

	private static final long serialVersionUID = 1L;

	public cmmnExcepHndlr() {
		super();
	}

	public cmmnExcepHndlr(String message) {		
		super(message);
	}

}
