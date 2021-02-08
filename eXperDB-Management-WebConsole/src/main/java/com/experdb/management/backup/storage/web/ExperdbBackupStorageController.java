package com.experdb.management.backup.storage.web;

import javax.servlet.http.*;

import org.json.simple.*;
import org.springframework.stereotype.*;
import org.springframework.web.bind.annotation.*;

import com.experdb.management.backup.cmmn.*;
import com.experdb.management.backup.service.*;
import com.k4m.dx.tcontrol.common.service.*;

@Controller
public class ExperdbBackupStorageController {
	

    @RequestMapping(value = "/experdb/backupStorageReg.do")
    public @ResponseBody JSONObject backupStorageReg(@ModelAttribute("historyVO") HistoryVO historyVO, HttpServletRequest request) {
        JSONObject result = new JSONObject();
        BackupLocationInfoVO locationVO = new BackupLocationInfoVO();
        System.out.println("////////////// backup storage reg CONTROLLER CALLED!!!! /////////////");
        
        locationVO.setType(Integer.parseInt(request.getParameter("type")));
        System.out.println("///11/// type : " + Integer.parseInt(request.getParameter("type")));
        locationVO.setBackupDestLocation(request.getParameter("path"));
        System.out.println("///22/// path : " +request.getParameter("path"));
        locationVO.setBackupDestPasswd(request.getParameter("passWord"));
        System.out.println("///33/// passWord : " +request.getParameter("passWord"));
        locationVO.setBackupDestUser(request.getParameter("userName"));
        System.out.println("///44/// userName : " +request.getParameter("userName"));
        locationVO.setJobLimit(Integer.parseInt(request.getParameter("jobLimit")));
        System.out.println("///55/// jobLimit : " +Integer.parseInt(request.getParameter("jobLimit")));
        locationVO.setFreeSizeAlert(Long.parseLong(request.getParameter("freeSizeAlert")));
        System.out.println("///66/// freeSizeAlert : " +Long.parseLong(request.getParameter("freeSizeAlert")));
        locationVO.setFreeSizeAlertUnit(Integer.parseInt(request.getParameter("freeSizeAlertUnit")));
        System.out.println("///77/// freeSizeAlertUnit : " +Integer.parseInt(request.getParameter("freeSizeAlertUnit")));

        System.out.println(locationVO.toString());

        String [] pth = locationVO.getBackupDestLocation().split("/", 4);
        String path = "/"+pth[3];
        System.out.println("path : " + path);
        
        // CmmnUtil.encPassword(request.getParameter("passWord"));
        CmmnUtil cmmnUtil = new CmmnUtil();
        
        cmmnUtil.encPassword("root0225!!");
        
        System.out.println("////////////////////////////////");
        return result;
    }

}
