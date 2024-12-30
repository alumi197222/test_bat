@echo off
:menu
cls
echo ==================================
echo          BAT 工具選單
echo ==================================
echo [1] 顯示本機 IP 位址
echo [2] Ping Google DNS (8.8.8.8)
echo [3] 退出
echo ==================================
set /p choice=請輸入選項（1-3）： 

if "%choice%"=="1" goto show_ip
if "%choice%"=="2" goto ping_google
if "%choice%"=="3" goto exit
echo 無效的選項，請重新輸入！
pause
goto menu

:show_ip
cls
echo 你的本機 IP 位址如下：
ipconfig | findstr "IPv4"
pause
goto menu

:ping_google
cls
echo 正在 Ping Google DNS (8.8.8.8)...
ping 8.8.8.8
pause
goto menu

:exit
cls
echo 感謝使用本工具！再見！
pause
exit