SET CURRENT_DIR=C:\k4m\DxTcontrolWorkspace\eXperDB-Management\eXperDB-Proxy-Agent\build\experDB-Proxy-Agent
SET MAIN_CLASS=com.experdb.proxy.DaemonStart
SET JAVA_CLASSPATH="%JAVA_HOME%/jre/lib/tools.jar;%CURRENT_DIR%/classes;%CURRENT_DIR%/lib/;%CURRENT_DIR%/lib/*"

"%JAVA_HOME%\bin\java" -Du=experDB-Proxy-Agent -Dlog.base=%CURRENT_DIR%/log -classpath %JAVA_CLASSPATH% %MAIN_CLASS% -shutdown
