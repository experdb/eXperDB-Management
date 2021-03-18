

SET CURRENT_DIR=C:\k4m\DxTcontrolWorkspace\DX-TControl\DX-TcontrolAgent\build\DX-TcontrolAgent
SET MAIN_CLASS=com.k4m.dx.tcontrol.DaemonStart
SET JAVA_CLASSPATH="%JAVA_HOME%/jre/lib/tools.jar;%CURRENT_DIR%/classes;%CURRENT_DIR%/lib/;%CURRENT_DIR%/lib/*"

"%JAVA_HOME%\bin\java" -Du=DX-TcontrolAgent -Dlog.base=%CURRENT_DIR%/logs -classpath %JAVA_CLASSPATH% %MAIN_CLASS%
