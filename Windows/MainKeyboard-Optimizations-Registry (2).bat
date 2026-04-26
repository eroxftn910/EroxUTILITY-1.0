@echo off
title Keyboard regedit settings by [https://guns.lol/inso.vs]
set "w=[97m" & set "g=[92m" & set "z=[91m" & set "i=[94m"

:MainConfirmMenu
echo.
echo   For personal use only. Modifying, copying, or redistributing this script is prohibited. &echo   This script must be downloaded only from the official source: [https://guns.lol/inso.vs]&echo.
echo   [INFO] &echo   This optimization batch configures Windows keyboard settings to minimize input delay and maximize &echo   responsiveness. It modifies registry values at user level (Control Panel settings) and system
echo   level (keyboard driver parameters). By eliminating delays, disabling accessibility filters, &echo   and optimizing repeat rates, it ensures instant key registration with no artificial latency &echo   between keypress and system response.&echo.
echo   Reduces keyboard input latency by removing initial key delays, setting maximum repeat speed, &echo   disabling bounce-key filtering, and optimizing driver port handling. Eliminates the delay before &echo   key repeat activation and maximizes character input rate. Ideal for competitive gaming, fast typing,
echo   or any scenario requiring immediate keyboard response without Windows-imposed timing constraints.&echo.
pause
cls
echo %w%Adding values to the Registry...%q%

:: Sets keyboard driver thread priority to 31 (real-time maximum) for instant input processing.
reg add "HKLM\SYSTEM\CurrentControlSet\Services\kbdclass\Parameters" /v ThreadPriority /t REG_DWORD /d 31 /f

:: Reduces the time it takes for keystrokes to be transmitted to the Windows driver (KeyboardTransmitTimeout) for more immediate input processing.
reg add "HKLM\SYSTEM\CurrentControlSet\Services\kbdclass\Parameters" /v KeyboardTransmitTimeout /t REG_DWORD /d 0 /f

:: Sets initial key repeat delay to 0ms (instant key repeat)
reg add "HKCU\Control Panel\Keyboard" /v KeyboardDelay /t REG_SZ /d 0 /f

:: Sets key repeat rate to maximum (31 = fastest possible)
reg add "HKCU\Control Panel\Keyboard" /v KeyboardSpeed /t REG_SZ /d 31 /f

:: Removes keyboard delay for accessibility features (instant response).
reg add "HKCU\Control Panel\Accessibility\Keyboard Response" /v KeyboardDelay /t REG_DWORD /d 0 /f

:: Disables auto-repeat delay in accessibility settings (0ms = instant).
reg add "HKCU\Control Panel\Accessibility\Keyboard Response" /v AutoRepeatDelay /t REG_SZ /d 0 /f

:: Sets auto-repeat rate to fastest in accessibility settings.
reg add "HKCU\Control Panel\Accessibility\Keyboard Response" /v AutoRepeatRate /t REG_SZ /d 0 /f

:: Disables all accessibility keyboard flags (no filter keys, sticky keys interference).
reg add "HKCU\Control Panel\Accessibility\Keyboard Response" /v Flags /t REG_SZ /d 0 /f

:: Removes delay before key acceptance (instant key recognition).
reg add "HKCU\Control Panel\Accessibility\Keyboard Response" /v DelayBeforeAcceptance /t REG_SZ /d 0 /f

:: Disables bounce key time (prevents accidental double presses from being filtered).
reg add "HKCU\Control Panel\Accessibility\Keyboard Response" /v BounceTime /t REG_SZ /d 0 /f

:: Resets last bounce key setting to default (ensures no legacy delays).
reg add "HKCU\Control Panel\Accessibility\Keyboard Response" /v "Last BounceKey Setting" /t REG_DWORD /d 0 /f

:: Clears last valid delay setting (removes any cached delay values).
reg add "HKCU\Control Panel\Accessibility\Keyboard Response" /v "Last Valid Delay" /t REG_DWORD /d 0 /f

:: Clears last valid repeat setting (removes any cached repeat values).
reg add "HKCU\Control Panel\Accessibility\Keyboard Response" /v "Last Valid Repeat" /t REG_DWORD /d 0 /f

:: Clears last valid wait setting (removes any cached wait values).
reg add "HKCU\Control Panel\Accessibility\Keyboard Response" /v "Last Valid Wait" /t REG_DWORD /d 0 /f

:: Sets initial keyboard indicators state (NumLock configuration).
reg add "HKCU\Control Panel\Keyboard" /v InitialKeyboardIndicators /t REG_SZ /d 0 /f

:: Sets typematic delay to 0ms (additional delay parameter for key repeat).
reg add "HKCU\Control Panel\Keyboard" /v TypematicDelay /t REG_SZ /d 0 /f

:: Optimizes keyboard port servicing (limits to single port for better performance).
reg add "HKLM\SYSTEM\CurrentControlSet\Services\kbdclass\Parameters" /v MaximumPortsServiced /t REG_DWORD /d 1 /f

:: Disables output to all ports (focuses on single active keyboard port).
reg add "HKLM\SYSTEM\CurrentControlSet\Services\kbdclass\Parameters" /v SendOutputToAllPorts /t REG_DWORD /d 0 /f

:: Disables WPP recorder timestamp (reduces driver overhead).
reg add "HKLM\SYSTEM\CurrentControlSet\Services\kbdclass\Parameters" /v WppRecorder_UseTimeStamp /t REG_DWORD /d 0 /f

set "w=[97m" & set "g=[92m" & set "z=[91m" & set "i=[94m" &echo %g%Done%w%.

taskkill /f /im explorer.exe >nul
start explorer.exe >nul

echo.
echo Choose an option :
echo [1] %z%Exit.%w%
echo [2] %i%Discord.%w%

set /p "choice="
if "%choice%"=="1" (
    timeout /t 1 /nobreak >nul
    exit /b
) else if "%choice%"=="2" (
    start https://guns.lol/inso.vs
    pause >nul
) else (
    pause >nul
)
