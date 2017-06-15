package com.k4m.dx.tcontrol.slf4j_test.src;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

public class HelloWorld {

	private static Logger client= LoggerFactory.getLogger("client");
	private static Logger server = LoggerFactory.getLogger("server");

	public static void main(String[] args) {
		Logger logger = LoggerFactory.getLogger(HelloWorld.class);
		logger.info("{}","Hello World");  // 바뀐 부분
		client.debug("{}", "client");     // 밑에서 추가 설명
		server.debug("{}", "server");     // 밑에서 추가 설명
	}
}