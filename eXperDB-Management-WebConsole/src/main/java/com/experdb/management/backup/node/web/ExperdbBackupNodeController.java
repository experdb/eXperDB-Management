package com.experdb.management.backup.node.web;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import com.experdb.management.backup.node.service.ExperdbBackupNodeService;
import com.experdb.management.backup.node.service.TargetMachineVO;

@Controller
public class ExperdbBackupNodeController {
	
	@Autowired
	private ExperdbBackupNodeService experdbBackupNodeService;
	
	
	
	/**
	 * 노드 리스트를 조회한다.
	 * 
	 * @param request
	 * @return resultSet
	 * @throws Exception
	 */
	@RequestMapping(value = "/experdb/getNodeList.do")
	public @ResponseBody List<TargetMachineVO> getNodeList(HttpServletRequest request, HttpServletResponse response) {
			
		List<TargetMachineVO> resultSet = null;
		//Map<String, Object> param = new HashMap<String, Object>();
		try {	
					resultSet = experdbBackupNodeService.getNodeList();	
					
					System.out.println(resultSet.get(0).getOperatingSystem());
		} catch (Exception e) {
			e.printStackTrace();
		}
		return resultSet;

	}
}
