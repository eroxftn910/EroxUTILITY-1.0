@echo off &title Disable USB PowerSavings and Selective Suspend by [https://guns.lol/inso.vs].
set z=[7m& set i=[1m& set q=[0m & cls &echo.
pause &cls &echo %z%Disabling USB PowerSavings and Selective Suspend..%q%

:: Global USB Selective Suspend Disable.
reg add "HKLM\SYSTEM\CurrentControlSet\Services\USB" /v "DisableSelectiveSuspend" /t REG_DWORD /d "1" /f

:: Disable USB PowerSavings per Device via PowerShell CIM.
for /f "delims=" %%i in ('powershell -NoProfile -Command "Get-CimInstance Win32_USBController | Where-Object { $_.PNPDeviceID -like ''PCI\VEN_*'' } | Select-Object -ExpandProperty PNPDeviceID"') do (
    reg add "HKLM\SYSTEM\CurrentControlSet\Enum\%%i\Device Parameters" /v "AllowIdleIrpInD3" /t REG_DWORD /d "0" /f
    reg add "HKLM\SYSTEM\CurrentControlSet\Enum\%%i\Device Parameters" /v "D3ColdSupported" /t REG_DWORD /d "0" /f
    reg add "HKLM\SYSTEM\CurrentControlSet\Enum\%%i\Device Parameters" /v "DeviceSelectiveSuspended" /t REG_DWORD /d "0" /f
    reg add "HKLM\SYSTEM\CurrentControlSet\Enum\%%i\Device Parameters" /v "EnhancedPowerManagementEnabled" /t REG_DWORD /d "0" /f
    reg add "HKLM\SYSTEM\CurrentControlSet\Enum\%%i\Device Parameters" /v "EnableSelectiveSuspend" /t REG_DWORD /d "0" /f
    reg add "HKLM\SYSTEM\CurrentControlSet\Enum\%%i\Device Parameters\WDF" /v "IdleInWorkingState" /t REG_DWORD /d "0" /f
    reg add "HKLM\SYSTEM\CurrentControlSet\Enum\%%i\Device Parameters" /v "SelectiveSuspendEnabled" /t REG_DWORD /d "0" /f
    reg add "HKLM\SYSTEM\CurrentControlSet\Enum\%%i\Device Parameters" /v "SelectiveSuspendOn" /t REG_DWORD /d "0" /f
)

timeout /t 1 /nobreak > nul &echo.
echo %z%Choose an option :%q%
echo [1] %z%Quitter.%q%
echo [2] %z%Discord.%q%

set /p "choice="
if "%choice%"=="1" (
    timeout /t 1 /nobreak >nul &exit /b
) else if "%choice%"=="2" (
    start https://guns.lol/inso.vs &pause >nul
) else (
    pause >nul
)
