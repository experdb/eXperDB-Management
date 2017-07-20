package com.k4m.dx.tcontrol.functions.schedule;

import org.springframework.util.StringUtils;

public class ScheduleCronExpression {

	/**
	 * 실행일정을 CRON EXPRESSION 형태로 출력한다
	 * @return String
	 */
	public String getCronExpression(String exe_perd_cd, String exe_dt, String exe_h, String exe_m, String exe_s)
	{
		/*
		 * 실행주기(exe_perd_cd)
		 * exe_perd_cd:	TC001601 = 매일
		 * 				TC001602 = 매주
		 * 				TC001603 = 매월
		 * 				TC001604 = 매년
		 * 				TC001605 = 1회실행
		 */
		String exe_hms = "";
		
		exe_hms = exe_s + " " + exe_m + " " + exe_h;
		
		
		if ("TC001601".equals(exe_perd_cd))
		{
			exe_hms += " * * ?";
		}
		else if ("TC001602".equals(exe_perd_cd))
		{
			exe_hms += " ? * ";
			
			if ('1' == exe_dt.charAt(0))
			{
				exe_hms += "SUN,";
			}
			if ('1' == exe_dt.charAt(1))
			{
				exe_hms += "MON,";
			}
			if ('1' == exe_dt.charAt(2))
			{
				exe_hms += "TUE,";
			}
			if ('1' == exe_dt.charAt(3))
			{
				exe_hms += "WED,";
			}
			if ('1' == exe_dt.charAt(4))
			{
				exe_hms += "THU,";
			}
			if ('1' == exe_dt.charAt(5))
			{
				exe_hms += "FRI,";
			}
			if ('1' == exe_dt.charAt(6))
			{
				exe_hms += "SAT,";
			}
			
			if (StringUtils.hasText(exe_hms) && ',' == exe_hms.charAt(exe_hms.length() - 1))
			{
				exe_hms = exe_hms.substring(0, exe_hms.length() -1);
			}
		}
		else if ("TC001603".equals(exe_perd_cd))
		{
			exe_hms += " " + exe_dt.substring(6) + " * ?";
		}
		else if ("TC001604".equals(exe_perd_cd))
		{
			exe_hms += " " + exe_dt.substring(6) + " " + exe_dt.substring(4, 6) + " ?";
		}
		else if ("TC001605".equals(exe_perd_cd))
		{
			exe_hms += " " + exe_dt.substring(6) + " " + exe_dt.substring(4, 6) + " ? " + exe_dt.substring(0, 4);
		}
		
		initStrExecutCycle(exe_perd_cd, exe_dt, exe_h, exe_m, exe_s);
		
		return exe_hms;
	}
	
	private void initStrExecutCycle(String exe_perd_cd, String exe_dt, String exe_h, String exe_m, String exe_s)
	{
	
		String exe_hms = "";
		
		exe_hms = exe_h + "시 " + exe_m + "분 " + exe_s + "초";
		
		/*
		 * 실행주기(exe_perd_cd)
		 * exe_perd_cd:	TC001601 = 매일
		 * 				TC001602 = 매주
		 * 				TC001603 = 매월
		 * 				TC001604 = 매년
		 * 				TC001605 = 1회실행
		 */
		if ("TC001601".equals(exe_perd_cd))
		{
			exe_hms = "매일 " + exe_hms;
		}
		else if ("TC001602".equals(exe_perd_cd))
		{
			exe_hms += " ? * ";
			
			String strWeek = "";
			
			if ('1' == exe_dt.charAt(0))
			{
				strWeek += "일요일,";
			}
			if ('1' == exe_dt.charAt(1))
			{
				strWeek += "월요일,";
			}
			if ('1' == exe_dt.charAt(2))
			{
				strWeek += "화요일,";
			}
			if ('1' == exe_dt.charAt(3))
			{
				strWeek += "수요일,";
			}
			if ('1' == exe_dt.charAt(4))
			{
				strWeek += "목요일,";
			}
			if ('1' == exe_dt.charAt(5))
			{
				strWeek += "금요일,";
			}
			if ('1' == exe_dt.charAt(6))
			{
				strWeek += "토요일,";
			}
			
			if (StringUtils.hasText(strWeek) && ',' == strWeek.charAt(strWeek.length() - 1))
			{
				strWeek = strWeek.substring(0, strWeek.length() -1);
			}
			
			exe_hms = "매주 " + strWeek + " " + exe_hms;
		}
		else if ("TC001603".equals(exe_perd_cd))
		{
			exe_hms = "매월 " + exe_dt.substring(6) + "일 " + exe_hms;
		}
		else if ("TC001604".equals(exe_perd_cd))
		{
			exe_hms = "매년 " + exe_dt.substring(4, 6) + "월 " + exe_dt.substring(6) + "일 " + exe_hms;
		}
		else if ("TC001605".equals(exe_perd_cd))
		{
			exe_hms = exe_dt.substring(0, 4) + "년 " + exe_dt.substring(4, 6) + "월 " + exe_dt.substring(6) + "일 " + exe_hms;
		}
	}

}
