@echo off
set CLASSPATH=C:\Progra~1\ibm\sqllib\samples\java\jdbc\db2jcc_license_cisuz.jar;.;C:\progra~1\IBM\sqllib\java\db2java.zip;C:\progra~1\IBM\sqllib\java\db2jcc.jar;C:\progra~1\IBM\sqllib\java\sqlj.zip;C:\progra~1\IBM\sqllib\java\db2jcc_license_cu.jar;C:\progra~1\IBM\sqllib\bin;C:\progra~1\IBM\sqllib\java\common.jar;C:\PROGRA~1\ibm\sqllib\java\db2jcc_license_cu.jar
set DB2INSTANCE=DB2_01
set DB2PATH=C:\progra~1\IBM\sqllib
set INCLUDE=C:\progra~1\IBM\sqllib\INCLUDE
set LIB=C:\progra~1\IBM\sqllib\LIB
set PATH=C:\progra~1\ibm\sqllib\java\jdk\bin;C:\progra~1\IBM\sqllib\BIN;C:\progra~1\IBM\sqllib\FUNCTION;C:\Windows\System32\WindowsPowerShell\v1.0\;C:\Windows\System32\Wbem;C:\WINDOWS\System32\OpenSSH\;C:\WINDOWS\System32\OpenSSH;C:\WINDOWS\System32;C:\WINDOWS;C:\Users\WindowsHelp\AppData\Local\Microsoft\WindowsApps;C:\progra~1\WinZip;C:\progra~1\Intel\WiFi\bin\;C:\progra~1\Intel\Intel(R) Management Engine Components\DAL;C:\progra~1\ibm\gsk8\lib64;C:\progra~1\Common Files\Intel\WirelessCommon\;C:\progra~1\avs\bin32;C:\progra~1\avs\bin;C:\progra~1 (x86)\Intel\Intel(R) Management Engine Components\DAL;C:\progra~1 (x86)\Common Files\Oracle\Java\javapath;C:\progra~1 (x86)\CheckPoint\Endpoint Security\Endpoint Common\bin;D:\py\Scripts\;D:\py\;C:\Users\nkh4msw\AppData\Local\Programs\Python\Launcher\;C:\Users\nkh4msw\AppData\Local\Microsoft\WindowsApps;d:\xp\bin;C:\progra~1\ibm\gsk8\bin;C:\progra~1\ibm\gsk8\lib64;d:\;d:\vs_code\bin;d:\php;d:\openssl\bin

echo server name %1
echo port %2
echo user %3
echo password xxx
echo grp %5
echo member %6
echo file-name %7

java GetZparm %1 %2 %3 %4 %5 %6 %7
if %ERRORLEVEL% GEQ 1 exit 16 

