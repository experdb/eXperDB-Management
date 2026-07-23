package com.k4m.dx.tcontrol.db2pg.cmmn;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.util.ArrayList;
import java.util.List;

import org.json.simple.JSONObject;

public class DB2PG_STOP {
   
   
   public JSONObject db2pgStop(String wrkName) {
      System.out.println("##### DB2PG_STOP START #####");
      JSONObject result = new JSONObject();

      // 보안: 작업명은 안전한 식별자만 허용(명령어 주입 방지)
      if (wrkName == null || !wrkName.matches("^[A-Za-z0-9._-]+$")) {
         result.put("RESULT_MSG", "invalid work name");
         result.put("RESULT_CODE", 1);
         result.put("RESULT", "FAIL");
         return result;
      }

      String pattern = "config/" + wrkName + ".config";
      try {
         // 보안: 셸(/bin/sh -c) 대신 argv로 실행하여 셸 메타문자 해석을 차단한다.
         // (1) 대상 프로세스 PID 조회
         List<String> pids = new ArrayList<String>();
         Process pgrep = new ProcessBuilder("pgrep", "-f", pattern).start();
         try (BufferedReader br = new BufferedReader(new InputStreamReader(pgrep.getInputStream()))) {
            String line;
            while ((line = br.readLine()) != null) {
               line = line.trim();
               if (line.matches("^[0-9]+$")) pids.add(line);
            }
         }
         pgrep.waitFor();

         // (2) 조회된 PID를 kill -9 (셸 없이)
         for (String pid : pids) {
            new ProcessBuilder("kill", "-9", pid).start().waitFor();
         }

         result.put("RESULT_CODE", 0);
         result.put("RESULT", "SUCCESS");
         System.out.println("##### DB2PG_STOP END #####");

      } catch (IOException e) {
         result.put("RESULT_MSG", "system error");
         result.put("RESULT_CODE", 1);
         result.put("RESULT", "FAIL2");
      } catch (InterruptedException e) {
         result.put("RESULT_MSG", "system error");
         result.put("RESULT_CODE", 1);
         result.put("RESULT", "FAIL3");
      }

      return result;
   }
   
}