package com.k4m.dx.tcontrol.db.test;

import org.springframework.context.ApplicationContext;
import org.springframework.context.support.ClassPathXmlApplicationContext;
import org.springframework.stereotype.Service;

@Service
public class DatabaseConnTest {
	
	
	//@Autowired
	//private IMemberConfDao iMemberConfDao;
	
	public static void main(String args[]) {
		
		ApplicationContext context = new ClassPathXmlApplicationContext(new String[] {
				"ksmailgw-context.xml"
			});
		
		
		//DatabaseConnTest test = context.getBean(DatabaseConnTest.class);
		
		DatabaseConnTest testDB = new DatabaseConnTest();
		testDB.testDatabase(context);
	}
	
	private void testDatabase(ApplicationContext context) {
		
		try {
			
		//	MemberConfService test = (MemberConfService) context.getBean("memberConfService");
			String id = "postopia";
			//MemberConf memberConf = (MemberConf) iMemberConfFacade.findIdMemberConf(id);
			//MemberConf memberConf = (MemberConf) test.findIdMemberConf(id);
			
			System.out.println("================ result ================== ");
			//System.out.println("ID : " + memberConf.getId());
			//System.out.println("TOKEN : " + memberConf.getToken());
			
		} catch(Exception e) {
			e.printStackTrace();
		}
	}

}
