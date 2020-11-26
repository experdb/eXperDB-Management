package com.k4m.dx.tcontrol.socket.listener;

import java.util.HashMap;
import java.util.Map;

import org.quartz.Job;
import org.quartz.JobExecutionContext;
import org.quartz.JobExecutionException;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.context.ApplicationContext;
import org.springframework.context.support.ClassPathXmlApplicationContext;

import com.k4m.dx.tcontrol.db.repository.service.ScaleServiceImpl;
import com.k4m.dx.tcontrol.db.repository.service.SystemServiceImpl;
import com.k4m.dx.tcontrol.db.repository.vo.DbServerInfoVO;
import com.k4m.dx.tcontrol.util.FileUtil;
 
public class DXTcontrolScaleChogihwa implements Job {
	private Logger errLogger = LoggerFactory.getLogger("errorToFile");
	private static ApplicationContext context;
	
    @Override
    public void execute(JobExecutionContext arg0) throws JobExecutionException {
		context = new ClassPathXmlApplicationContext(new String[] {"context-tcontrol.xml"});
		SystemServiceImpl service = (SystemServiceImpl) context.getBean("SystemService");
		ScaleServiceImpl serviceScale = (ScaleServiceImpl) context.getBean("ScaleService");

    	Map<String, Object> loadParam = new HashMap<String, Object>();
    	DbServerInfoVO searchDbServerInfoVO = new DbServerInfoVO();
    	DbServerInfoVO dbServerInfo = null;
    	int db_svr_id = 1;
    	long wrk_sn = 1L;
    	long wrk_sn_max = 910000000L * 100000000L * 100L;

		try {
			//기존자료 load 데이터 일주일 전자료 까지 삭제
			String strIpadr = FileUtil.getPropertyValue("context.properties", "agent.install.ip");
	
			//서버정보 조회
			searchDbServerInfoVO.setIPADR(strIpadr);
			dbServerInfo = service.selectDatabaseConnInfo(searchDbServerInfoVO);
			
			if (dbServerInfo != null) {
				db_svr_id = dbServerInfo.getDB_SVR_ID();
			}
			
			loadParam.put("db_svr_id", db_svr_id); //db서버
			serviceScale.deleteScaleLoadLog_G(loadParam);
			
			//시퀀스 값이 max일때 데이터 삭제
			wrk_sn = serviceScale.selectQ_T_SCALELOADLOG_G_01_SEQ();

			//seq 초기화
			if (wrk_sn > wrk_sn_max) {
				serviceScale.deleteScaleLoadSEQ();
			}
		} catch (Exception e) {
			errLogger.error("scale load 데이터 삭제중 오류가 발생했습니다. {}", e.toString());
			e.printStackTrace();
			return;
		}
    }
}