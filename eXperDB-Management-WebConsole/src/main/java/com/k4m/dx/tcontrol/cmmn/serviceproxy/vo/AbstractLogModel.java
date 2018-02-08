/**
 * <pre>
 * Copyright (c) 2015 K4M, Inc.
 * All right reserved.
 *
 * This software is the confidential and proprietary information of K4M, Inc. 
 * You shall not disclose such confidential information and
 * shall use it only in accordance with the terms of the license agreement
 * you entered into with K4M.
 * </pre>
 */
package com.k4m.dx.tcontrol.cmmn.serviceproxy.vo;

import java.io.IOException;
import java.sql.PreparedStatement;
import java.sql.SQLException;

import org.apache.commons.csv.CSVPrinter;

/**
 * @brief
 * 
 *        TODO add description
 * @date 2015. 10. 5.
 * @author Kim, Sunho
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
