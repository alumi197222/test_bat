@echo off
:menu
cls
echo ==================================
echo          BAT �u����
echo ==================================
echo [1] ��ܥ��� IP ��}
echo [2] Ping Google DNS (8.8.8.8)
echo [3] �h�X
echo ==================================
set /p choice=�п�J�ﶵ�]1-3�^�G 

if "%choice%"=="1" goto show_ip
if "%choice%"=="2" goto ping_google
if "%choice%"=="3" goto exit
echo �L�Ī��ﶵ�A�Э��s��J�I
pause
goto menu

:show_ip
cls
echo �A������ IP ��}�p�U�G
ipconfig | findstr "IPv4"
pause
goto menu

:ping_google
cls
echo ���b Ping Google DNS (8.8.8.8)...
ping 8.8.8.8
pause
goto menu

:exit
cls
echo �P�¨ϥΥ��u��I�A���I
pause
exit