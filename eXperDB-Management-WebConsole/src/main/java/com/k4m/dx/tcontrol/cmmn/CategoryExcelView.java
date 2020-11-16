package com.k4m.dx.tcontrol.cmmn;

import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.poi.hssf.usermodel.HSSFCell;
import org.apache.poi.hssf.usermodel.HSSFSheet;
import org.apache.poi.hssf.usermodel.HSSFWorkbook;
import org.springframework.context.i18n.LocaleContextHolder;
import org.springframework.web.servlet.view.document.AbstractExcelView;

import com.k4m.dx.tcontrol.common.service.HistoryVO;

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

public class CategoryExcelView extends AbstractExcelView {

	@Override
	protected void buildExcelDocument(Map<String, Object> model, HSSFWorkbook wb, HttpServletRequest req,
			HttpServletResponse res) throws Exception {
        HSSFCell cell = null;  
  
        HSSFSheet sheet = wb.createSheet("접근이력");
        sheet.setDefaultColumnWidth((short) 12);  
        String locale_type = LocaleContextHolder.getLocale().getLanguage();
        
        // put text in first cell
        cell = getCell(sheet, 0, 0);
        
        if(locale_type.equals("en")){
        	setText(cell, "Access Histories");
            
            // set header information
            setText(getCell(sheet, 2, 0), "No");
            setText(getCell(sheet, 2, 1), "Date");
            setText(getCell(sheet, 2, 2), "Time");
            setText(getCell(sheet, 2, 3), "Page");
            setText(getCell(sheet, 2, 4), "ID");
            setText(getCell(sheet, 2, 5), "User Name");
            setText(getCell(sheet, 2, 6), "Department");
            setText(getCell(sheet, 2, 7), "Position");
            setText(getCell(sheet, 2, 8), "IP");
        }else{
        	setText(cell, "접근이력");
            
            // set header information
            setText(getCell(sheet, 2, 0), "No");
            setText(getCell(sheet, 2, 1), "일자");
            setText(getCell(sheet, 2, 2), "시간");
            setText(getCell(sheet, 2, 3), "구분");
            setText(getCell(sheet, 2, 4), "아이디");
            setText(getCell(sheet, 2, 5), "사용자명");
            setText(getCell(sheet, 2, 6), "부서");
            setText(getCell(sheet, 2, 7), "직급");
            setText(getCell(sheet, 2, 8), "아이피");
        }
        
        
        Map<String, Object> map = (Map<String, Object>) model.get("categoryMap");  
        List<Object> categories = (List<Object>) map.get("category");  
     
        for (int i = 0; i < categories.size(); i++) {
        	
        HistoryVO category = (HistoryVO) categories.get(i);
        
         cell = getCell(sheet, 3 + i, 0);
         setText(cell, Integer.toString(category.getRownum()));

         cell = getCell(sheet, 3 + i, 1);
         setText(cell, category.getExedtm_date());

         cell = getCell(sheet, 3 + i, 2);
         setText(cell, category.getExedtm_hour());

         cell = getCell(sheet, 3 + i, 3);
         setText(cell, category.getSys_cd_nm());

         cell = getCell(sheet, 3 + i, 4);
         setText(cell, category.getUsr_id());
         
         cell = getCell(sheet, 3 + i, 5);
         setText(cell, category.getUsr_nm());
         
         cell = getCell(sheet, 3 + i, 6);
         setText(cell, category.getDept_nm());
         
         cell = getCell(sheet, 3 + i, 7);
         setText(cell, category.getPst_nm());
         
         cell = getCell(sheet, 3 + i, 8);
         setText(cell, category.getLgi_ipadr());
         
        }
        //xls확장자로 다운로드  
        res.setContentType("application/x-msdownload");  
        res.setHeader("Content-Disposition", "attachment; filename=\"accessHistory.xls\"");  
	}  

}
