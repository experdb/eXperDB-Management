package com.k4m.dx.tcontrol.socket.listener;

import com.k4m.dx.tcontrol.db.repository.service.SystemServiceImpl;
import com.k4m.dx.tcontrol.db.repository.vo.AgentInfoVO;

public class ServerCheckListener implements Runnable {
	
	private SystemServiceImpl service;


	public ServerCheckListener(SystemServiceImpl service)  throws Exception {
		this.service = service;
	}
	
	@Override
	public void run() {
		int i=0;
		
		while(true) {
			
			try {
				
				AgentInfoVO vo = new AgentInfoVO();
					
				service.selectAgentInfo(vo);
				
				i++;
				
				System.out.println("SSSSSSSSSS" + i);

				Thread.sleep(3000);
				
			} catch(Exception e) {
				
			} finally {
				
			}
		}

	}

}
