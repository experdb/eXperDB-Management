package com.k4m.dx.tcontrol.cmmn;

public class cmmnExcepHndlr extends RuntimeException {

	private static final long serialVersionUID = 1L;

	public cmmnExcepHndlr() {
		super();
	}

	public cmmnExcepHndlr(String message) {		
		super(message);
	}

}
