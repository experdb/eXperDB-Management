package com.experdb.management.backup.policy.service;

import java.io.*;
import java.text.*;
import java.util.*;

import javax.servlet.http.*;
import javax.xml.parsers.*;

import org.json.simple.*;
import org.xml.sax.*;


public interface ExperdbBackupPolicyService {
	
	JSONObject scheduleInsert(HttpServletRequest request, Map<Object, String> param) throws Exception;

	JSONObject getScheduleInfo(HttpServletRequest request) throws SAXException, IOException, ParseException, ParserConfigurationException;

}
