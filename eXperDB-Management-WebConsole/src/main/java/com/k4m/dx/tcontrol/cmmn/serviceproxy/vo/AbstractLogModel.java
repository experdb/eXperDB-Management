package com.k4m.dx.tcontrol.cmmn.serviceproxy.vo;

import java.io.IOException;
import java.sql.PreparedStatement;
import java.sql.SQLException;

import org.apache.commons.csv.CSVPrinter;

/**
 * 
 *
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
public abstract class AbstractLogModel extends AbstractPageModel {

	public abstract Object[] getExportHeader();

	public void exportHeader(CSVPrinter printer) throws IOException {
		printer.printRecord(getExportHeader());
	}

	public abstract Iterable<?> getExportRecord();

	public void exportRecord(CSVPrinter printer) throws IOException {
		printer.printRecord(getExportRecord());
	}

	public abstract String getCreateStatement();

	public abstract String getInsertStatement();

	public abstract PreparedStatement setStatementParameters(PreparedStatement insertStmt) throws SQLException;
}
