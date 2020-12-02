package com.k4m.dx.tcontrol.cmmn;

import java.io.OutputStream;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.poi.hssf.usermodel.HSSFCellStyle;
import org.apache.poi.hssf.util.HSSFColor;
import org.apache.poi.ss.usermodel.CellStyle;
import org.apache.poi.ss.usermodel.Font;
import org.apache.poi.ss.usermodel.IndexedColors;
import org.apache.poi.xssf.streaming.SXSSFCell;
import org.apache.poi.xssf.streaming.SXSSFRow;
import org.apache.poi.xssf.streaming.SXSSFSheet;
import org.apache.poi.xssf.streaming.SXSSFWorkbook;
import org.apache.poi.xssf.usermodel.XSSFWorkbook;
import org.springframework.context.i18n.LocaleContextHolder;
import org.springframework.web.servlet.view.AbstractView;

import com.k4m.dx.tcontrol.common.service.HistoryVO;

public class OverallExcelBuilder extends AbstractView {
    private static final String CONTENT_TYPE = "application/vnd.ms-excel"; // Content Type 설정

    public OverallExcelBuilder() {
        setContentType(CONTENT_TYPE);
    }
   
    @Override
    protected void renderMergedOutputModel(Map<String, Object> model, HttpServletRequest request, HttpServletResponse response) throws Exception {
        try {
        	String locale_type = LocaleContextHolder.getLocale().getLanguage();

        	// flush되기 전까지 메모리에 들고있는 행의 갯수
        	int ROW_ACCESS_WINDOW_SIZE = 500;
        	String strTitle = "";
        	
        	XSSFWorkbook xssfWorkbook = new XSSFWorkbook();
        	SXSSFWorkbook sxssfWorkbook = new SXSSFWorkbook(xssfWorkbook, ROW_ACCESS_WINDOW_SIZE);
        	sxssfWorkbook.setCompressTempFiles (true); // 임시 파일이 압축됩니다

			SXSSFSheet objSheet = null;
			SXSSFRow objRow = null;
			SXSSFCell objCell = null; // 셀 생성

			Font fontHd = sxssfWorkbook.createFont();
			fontHd.setFontHeightInPoints((short) 9);
			fontHd.setBold(Boolean.TRUE);
			fontHd.setFontName("맑은고딕");

			// 제목 스타일에 폰트 적용, 정렬
			CellStyle styleHd = sxssfWorkbook.createCellStyle(); // 제목 스타일
			styleHd.setFont(fontHd);
			styleHd.setAlignment(CellStyle.ALIGN_CENTER);
			styleHd.setVerticalAlignment(CellStyle.VERTICAL_CENTER);
			styleHd.setFillForegroundColor(HSSFColor.AQUA.index);  
			styleHd.setFillPattern(HSSFCellStyle.SOLID_FOREGROUND);
			
			styleHd.setBorderTop(CellStyle.BORDER_THIN);
			styleHd.setBorderBottom(CellStyle.BORDER_THIN);
			styleHd.setBorderRight(CellStyle.BORDER_THIN);
			styleHd.setBorderLeft(CellStyle.BORDER_THIN);
			styleHd.setBottomBorderColor(IndexedColors.BLACK.getIndex());
			styleHd.setTopBorderColor(IndexedColors.BLACK.getIndex());
			styleHd.setRightBorderColor(IndexedColors.BLACK.getIndex());
			styleHd.setLeftBorderColor(IndexedColors.BLACK.getIndex());

			// 폰트
			Font font = sxssfWorkbook.createFont();
			font.setFontHeightInPoints((short) 9);
			font.setFontName("맑은고딕");

			// 스타일에 폰트 적용, 정렬
			CellStyle styleRow = sxssfWorkbook.createCellStyle();
			styleRow.setFont(font);
			styleRow.setVerticalAlignment(CellStyle.VERTICAL_CENTER);
			
			styleRow.setBorderTop(CellStyle.BORDER_THIN);
			styleRow.setBorderBottom(CellStyle.BORDER_THIN);
			styleRow.setBorderRight(CellStyle.BORDER_THIN);
			styleRow.setBorderLeft(CellStyle.BORDER_THIN);
			styleRow.setBottomBorderColor(IndexedColors.BLACK.getIndex());
			styleRow.setTopBorderColor(IndexedColors.BLACK.getIndex());
			styleRow.setRightBorderColor(IndexedColors.BLACK.getIndex());
			styleRow.setLeftBorderColor(IndexedColors.BLACK.getIndex());
			
			objSheet = sxssfWorkbook.createSheet("접근이력"); // 워크시트 생성
			objSheet.setRandomAccessWindowSize(100); // 메모리 행 100개로 제한, 초과 시 Disk로 flush

			// 스타일 미리 적용
			for( int i = 0; i < 1; i++ ) {
				objRow = objSheet.createRow(i);
				for( int j = 0; j < 9; j++ ) {
					objCell = objRow.createCell(j);
					objCell.setCellStyle(styleHd);
					objSheet.setColumnWidth(j, (short) 5000);
				}
			}

	        if(locale_type.equals("en")){
	        	strTitle = "Access Histories";
	        }else{
	        	strTitle = "접근이력";
	        }
	        
	        SXSSFRow header = (SXSSFRow) objSheet.createRow(0);
	        setHeaderCellTitle(header, strTitle); // 헤더 칼럼명 설정
	        setHeaderStyleTitle(header, styleHd); // 헤더 스타일 설정

	        header = (SXSSFRow) objSheet.createRow(2);
	        setHeaderCellValue(header, locale_type); // 헤더 칼럼명 설정
	        setHeaderStyle(header, styleHd); // 헤더 스타일 설정

	        int rowNum = 3;
		
			CellStyle cellStyle = sxssfWorkbook.createCellStyle(); // 제목 스타일
			cellStyle.setFillForegroundColor( HSSFColor.GREY_25_PERCENT.index );
			cellStyle.setFillPattern(CellStyle.SOLID_FOREGROUND);

	        Map<String, Object> map = (Map<String, Object>) model.get("categoryMap");  
	        List<Object> categories = (List<Object>) map.get("category");  
	        
	        for (int i = 0; i < categories.size(); i++) {
	        	HistoryVO category = (HistoryVO) categories.get(i);

		    	// 열
		        objRow = objSheet.createRow(rowNum);
		        objRow.setHeight((short) 0x150);
		        
		        setEachRow(objRow, category);
		        setHeaderStyle(objRow, styleRow); // 헤더 스타일 설정
	        
		        ++rowNum;
	        }
            SimpleDateFormat sdf = new SimpleDateFormat("yyyyMMdd");
            Calendar c1 = Calendar.getInstance();
            String yyyymmdd = sdf.format(c1.getTime());

			response.setContentType("Application/Msexcel");
			response.setHeader("Content-Disposition", "ATTachment; Filename=accessHistory_" + yyyymmdd + ".xls");
			
			OutputStream fileOut = response.getOutputStream();
			sxssfWorkbook.write(fileOut);
			fileOut.close();
			
			response.getOutputStream().flush();
			response.getOutputStream().close();
			
			sxssfWorkbook.dispose();
        } catch (Exception e) {
            throw e;
        }
    }
    
    private void setHeaderCellTitle(SXSSFRow header, String title) {
        header.createCell(0).setCellValue(title);
    }
    
    private void setHeaderStyleTitle(SXSSFRow header, CellStyle style) {
        header.getCell(0).setCellStyle(style);
    }
   
    private void setHeaderCellValue(SXSSFRow header, String locale_type) {
        if(locale_type.equals("en")){
            header.createCell(0).setCellValue("No");
            header.createCell(1).setCellValue("Date");
            header.createCell(2).setCellValue("Time");
            header.createCell(3).setCellValue("Page");
            header.createCell(4).setCellValue("ID");
            header.createCell(5).setCellValue("User Name");
            header.createCell(6).setCellValue("Department");
            header.createCell(7).setCellValue("Position");
            header.createCell(8).setCellValue("IP");
        }else{
            header.createCell(0).setCellValue("No");
            header.createCell(1).setCellValue("일자");
            header.createCell(2).setCellValue("시간");
            header.createCell(3).setCellValue("구분");
            header.createCell(4).setCellValue("아이디");
            header.createCell(5).setCellValue("사용자명");
            header.createCell(6).setCellValue("부서");
            header.createCell(7).setCellValue("직급");
            header.createCell(8).setCellValue("아이피");
        }
    }
   
    private void setHeaderStyle(SXSSFRow header, CellStyle style) {
		for( int i = 0; i < 9; i++ ) {
			header.getCell(i).setCellStyle(style);
		}
    }
   
    private void setEachRow(SXSSFRow aRow, HistoryVO category) {
    	aRow.createCell(0).setCellValue(Integer.toString(category.getRownum()));
    	aRow.createCell(1).setCellValue(category.getExedtm_date());
    	aRow.createCell(2).setCellValue(category.getExedtm_hour());
    	aRow.createCell(3).setCellValue(category.getSys_cd_nm());
    	aRow.createCell(4).setCellValue(category.getUsr_id());
    	aRow.createCell(5).setCellValue(category.getUsr_nm());
    	aRow.createCell(6).setCellValue(category.getDept_nm());
    	aRow.createCell(7).setCellValue(category.getPst_nm());
    	aRow.createCell(8).setCellValue(category.getLgi_ipadr());
    }
}