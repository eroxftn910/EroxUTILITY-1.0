:: Disables Windows devices (Devices Manager) Script "1.02".
:: Turn off unused or redundant devices to reduce latency and improve overall system performance.
:: Frees system resources by targeting bloated audio services, virtual network adapters, SMBus controllers,
:: and system enumerators that generate excessive DPC latency and interrupt overhead.
:: Provides optional management of monitor audio, printers, Bluetooth, and Wi-Fi devices based on user needs.
:: All changes are fully reversible via the Device Manager. Advanced users may uncomment additional devices in this script for deeper optimization.

:: ----------------------------------------------------------------------------------------------------------------------------------------------------- ::

:: ► NOTES:
:: • The device names below exactly match the strings used by the DevManView tool.
:: • Includes WAN Miniports, system controllers, and software components (e.g., Realtek services).
:: • Items marked "not included" are listed for reference but are NOT disabled by default.
:: • Bluetooth and Wi-Fi sections include multiple manufacturer variants for broader compatibility.
:: • Printer section targets both physical and virtual print devices.

:: ===================================================================================================================================================== ::

:: ►   GENERAL DEVICE LIST:
:: 1.  Realtek Audio Effects Component             :: Realtek software module managing sound effects and audio optimizations.
:: 2.  Realtek Audio Universal Service             :: Windows service for managing and configuring Realtek audio.
:: 3.  Realtek Hardware Support Application        :: Utility application to enable Realtek hardware functions.
:: 4.  High Precision Event Timer (HPET)           :: High-precision system timer used for synchronization.
:: 5.  Microsoft GS Wavetable Synth                :: Built-in Windows MIDI software synthesizer.
:: 6.  Microsoft RRAS Root Enumerator              :: Root enumerator for the Routing and Remote Access service.
:: 7.  Intel Management Engine                     :: Microcontroller built into Intel chipsets for hardware management.
:: 8.  Intel Management Engine Interface           :: Driver enabling communication with the Intel Management Engine.
:: 9.  Intel SMBus                                 :: SMBus controller for communication between motherboard components.
:: 10. SM Bus Controller                           :: System SMBus controller, often used by hardware sensors.
:: 11. Amdlog                                      :: AMD driver or service related to logging and diagnostics.
:: 12. AMD PSP 1.0 Device                          :: AMD Platform Security Processor 1.0, a hardware security module.
:: 13. AMD PSP 2.0 Device                          :: AMD Platform Security Processor 2.0, a hardware security module.
:: 14. AMD PSP 3.0 Device                          :: AMD Platform Security Processor 3.0, a hardware security module.
:: 15. AMD Crash Defender                          :: AMD service for recovery after a critical system crash.
:: 16. AMD SMBus                                   :: SMBus controller integrated into the AMD chipset.
:: 17. System Speaker                              :: Internal system buzzer for startup beeps.
:: 18. Composite Bus Enumerator                    :: Enumerator for composite devices (USB or others).
:: 19. Microsoft Virtual Drive Enumerator          :: Microsoft driver for emulating or managing virtual drives.
:: 20. Microsoft Hyper-V Virtualization Infrastructure Driver :: Key driver for Hyper-V virtualization.
:: 21. Microsoft Hyper-V Virtual Machine Bus       :: Internal communication bus between host and Hyper-V virtual machines.
:: 22. Microsoft Hyper-V Virtual Machine Bus Network Adapter :: Virtual network card for Hyper-V.
:: 23. Microsoft Device Association Root Enumerator :: Root enumerator for device associations.
:: 24. Microsoft Hypervisor Service                :: Core service for Microsoft Hyper-V hypervisor.
:: 25. UMBus Root Bus Enumerator                   :: Root enumerator for the UMBus.
:: 26. Remote Desktop Device Redirector Bus        :: Bus for Remote Desktop device redirection.
:: 27. NDIS Virtual Network Adapter Enumerator     :: Enumerator for NDIS virtual network adapters.
:: 28. WAN Miniport (IP)                           :: Virtual network driver for the IP protocol.
:: 29. WAN Miniport (IKEv2)                        :: Virtual network driver for IKEv2 VPN.
:: 30. WAN Miniport (IPv6)                         :: Virtual network driver for the IPv6 protocol.
:: 31. WAN Miniport (L2TP)                         :: Virtual network driver for L2TP VPN.
:: 32. WAN Miniport (PPPOE)                        :: Virtual network driver for PPPoE connections.
:: 33. WAN Miniport (PPTP)                         :: Virtual network driver for PPTP VPN.
:: 34. WAN Miniport (SSTP)                         :: Virtual network driver for SSTP VPN.
:: 35. WAN Miniport (Network Monitor)              :: Virtual network driver for packet capture and analysis.

:: ►  MONITOR AUDIO DEVICES (#user's choice Y/N):
:: 36. High Definition Audio Controller            :: Primary HD Audio controller (may include monitor audio).
:: 37. High Definition Audio Bus                   :: HD Audio bus for audio device communication.
:: 38. NVIDIA High Definition Audio                :: NVIDIA GPU audio output for HDMI/DisplayPort monitors.

:: ►  PRINTER DEVICES (#user's choice Y/N):
:: 39. Root Print Queue                            :: Default system print queue.
:: 40. Print Spooler                               :: Windows print spooler service.
:: 41. Microsoft Print to PDF                      :: Microsoft virtual printer for PDF creation.
:: 42. Microsoft XPS Document Writer               :: Microsoft virtual printer for XPS documents.
:: 43. Send to Microsoft OneNote                   :: Microsoft virtual printer for OneNote integration.
:: 44. Generic / Text Only                         :: Generic text-only printer driver.
:: 45. Microsoft Print Services                    :: Microsoft print spooler and related services.
:: 46. Fax Devices                                 :: Windows integrated fax services.

:: ►  BLUETOOTH DEVICES (#user's choice Y/N):
:: 47. Bluetooth Radio                             :: Primary Bluetooth wireless communication adapter.
:: 48. Generic Bluetooth Radio                     :: Generic Bluetooth adapter driver.
:: 49. Generic Bluetooth Adapter                   :: Alternative generic Bluetooth device driver.
:: 50. Bluetooth Device (Personal Area Network)    :: Bluetooth PAN network adapter.
:: 51. Bluetooth Device (RFCOMM Protocol TDI)      :: Bluetooth RFCOMM protocol driver.
:: 52. Bluetooth LE Generic Attribute Service      :: Bluetooth Low Energy GATT service.
:: 53. Microsoft Bluetooth Enumerator              :: Microsoft Bluetooth device enumerator.
:: 54. Microsoft Bluetooth LE Enumerator           :: Microsoft Bluetooth Low Energy enumerator.
:: 55. Bluetooth AVRCP Transport                   :: Bluetooth Audio/Video Remote Control Profile transport.
:: 56. Bluetooth Audio Gateway                     :: Bluetooth audio gateway service.
:: 57. Bluetooth HFP SCO                           :: Bluetooth Hands-Free Profile SCO connection.
:: 58. Bluetooth A2DP Source                       :: Bluetooth Advanced Audio Distribution Profile source.
:: 59. Intel Wireless Bluetooth                    :: Intel-branded Bluetooth adapters.
:: 60. Realtek Bluetooth                           :: Realtek-branded Bluetooth adapters.
:: 61. Qualcomm Atheros Bluetooth                  :: Qualcomm Atheros-branded Bluetooth adapters.
:: 62. Broadcom Bluetooth                          :: Broadcom-branded Bluetooth adapters.

:: ►  WI-FI DEVICES (#user's choice Y/N):
:: 63. Microsoft Wi-Fi Direct Virtual Adapter      :: Microsoft virtual adapter for Wi-Fi Direct connections.
:: 64. Microsoft Hosted Network Virtual Adapter    :: Microsoft virtual adapter for hosted networks.
:: 65. Intel(R) Wireless                           :: Intel-branded wireless network adapters (specific).
:: 66. Intel(R) Wi-Fi                              :: Intel Wi-Fi specific adapters (specific).
:: 67. Realtek RTL8                                :: Realtek wireless adapters (RTL8xxx series).
:: 68. Qualcomm Atheros AR                         :: Qualcomm Atheros wireless adapters (ARxxxx series).
:: 69. Qualcomm Atheros QCA                        :: Qualcomm Atheros wireless adapters (QCAxxxx series).
:: 70. Broadcom 802.11                             :: Broadcom wireless adapters (802.11 series).
:: 71. TP-Link TL-WN                               :: TP-Link USB wireless adapters.
:: 72. D-Link DWA                                  :: D-Link wireless adapters.
:: 73. Netgear A6                                  :: Netgear wireless adapters (A6xxx series).

:: ►  Reference Items (not included by default, not dangerous but need test):
:: ## 74. System Timer                             :: Hardware component ensuring system timekeeping and synchronization. (not included)
:: ## 75. Microsoft System Management BIOS Driver  :: Driver allowing Windows to read BIOS information. (not included)
:: ## 76. Intel(R) SPI (flash) Controller          :: Controller for accessing the motherboard's SPI flash memory. (not included)
:: ## 77. Numeric data processor                   :: Arithmetic processor (FPU) for mathematical calculations. (not included)
:: ## 78. Programmable interrupt controller        :: Programmable controller managing hardware interrupts. (not included)

:: ===================================================================================================================================================== ::

@echo off &title [https://github.com/insovs] Disables Windows devices (Devices Manager) 1.02.
set z=[7m& set i=[1m& set q=[0m & cls &echo.
echo %z% Disables Windows devices (Devices Manager) Script "1.02".%q%
echo. &echo  This script disables unnecessary Windows devices that consume system resources. &echo  It targets redundant/unused virtualization controllers, multiple WAN miniport adapters,
echo  and other superfluous components in the device manager. &echo. &echo  This selection has been rigorously tested on several different systems. &echo  All these devices are generally unused or redundant for performance-focused usage, and safe to disable it.
echo  Good for reducing system latency, improving gaming response times, and freeing up RAM on struggling machines. &echo  By disabling these parasitic devices, you gain fluidity and responsiveness, especially noticeable on tight config. &echo.
echo  # Everything remains reversible if issues arise, just re-enable what's needed in device manager. &echo  # Additional devices are commented in the code for those who want to push optimization further.
echo. &echo  # Support : (https://github.com/insovs) &echo  # Join my Discord server community if you'd like to see more ! &echo. &timeout /t 3 /nobreak >nul 2>&1
set z=[7m& set i=[1m& set q=[0m
set /p "choice= %z%: Do you want to proceed ? [Y/N]: %q%"
if /i not "%choice%"=="Y" if /i not "%choice%"=="Yes" (
    echo. & echo %z%Operation cancelled by user.%q% &echo %z%Press any key to exit%q%.
    pause >nul 2>&1
    exit /b 0
)
set "insoptidmvtemp=%TEMP%\DevManView" & if not exist "%insoptidmvtemp%" mkdir "%insoptidmvtemp%"

:DisableDevicesContinue
REM Download and extract DevManView 64-bit in temp folder.
cls &set z=[7m& set i=[1m& set q=[0m
cls &echo.& echo %z%Info: Download and extract DevManView 64-bit vers via offical link (https://www.nirsoft.net).%q% & echo. &timeout /t 2 /nobreak >nul 2>&1
powershell -Command ^
  "Invoke-WebRequest -Uri 'https://www.nirsoft.net/utils/devmanview-x64.zip' -OutFile '%insoptidmvtemp%\devmanview-x64.zip';" ^
  "Expand-Archive -Path '%insoptidmvtemp%\devmanview-x64.zip' -DestinationPath '%insoptidmvtemp%' -Force;" ^
  "Remove-Item '%insoptidmvtemp%\devmanview-x64.zip'"
:: Check if DevManView exists.
if not exist "%insoptidmvtemp%\DevManView.exe" (echo. & echo %z%Error: DevManView.exe not found. Installation failed or was interrupted.%q% & echo %z%Info: Exiting script.%q% & timeout /t 3 /nobreak >nul 2>&1 & exit /b)
echo %z%Info: Installation confirmed, DevManView downloaded and extracted successfully.%q% &timeout /t 2 /nobreak >nul 2>&1

REM Download and extract DevManView 64-bit in temp folder.
echo. Disables Devices in Devices Manager via DevManView.
echo. &echo %z%Info: Disabling General Devices, Wait..%q% & timeout /t 1 /nobreak >nul 2>&1
"%insoptidmvtemp%\DevManView.exe" /disable "Realtek Audio Effects Component"
"%insoptidmvtemp%\DevManView.exe" /disable "Realtek Audio Universal Service"
"%insoptidmvtemp%\DevManView.exe" /disable "Realtek Hardware Support Application"
"%insoptidmvtemp%\DevManView.exe" /disable "High Precision Event Timer"
"%insoptidmvtemp%\DevManView.exe" /disable "Microsoft GS Wavetable Synth"
"%insoptidmvtemp%\DevManView.exe" /disable "Microsoft RRAS Root Enumerator"
"%insoptidmvtemp%\DevManView.exe" /disable "Intel Management Engine"
"%insoptidmvtemp%\DevManView.exe" /disable "Intel Management Engine Interface"
"%insoptidmvtemp%\DevManView.exe" /disable "Intel SMBus"
"%insoptidmvtemp%\DevManView.exe" /disable "SM Bus Controller"
"%insoptidmvtemp%\DevManView.exe" /disable "Amdlog"
"%insoptidmvtemp%\DevManView.exe" /disable "AMD PSP 1.0 Device"
"%insoptidmvtemp%\DevManView.exe" /disable "AMD PSP 2.0 Device"
"%insoptidmvtemp%\DevManView.exe" /disable "AMD PSP 3.0 Device"
"%insoptidmvtemp%\DevManView.exe" /disable "AMD Crash Defender"
"%insoptidmvtemp%\DevManView.exe" /disable "AMD SMBus"
"%insoptidmvtemp%\DevManView.exe" /disable "System Speaker"
"%insoptidmvtemp%\DevManView.exe" /disable "Composite Bus Enumerator"
"%insoptidmvtemp%\DevManView.exe" /disable "Microsoft Virtual Drive Enumerator"
"%insoptidmvtemp%\DevManView.exe" /disable "Microsoft Hyper-V Virtualization Infrastructure Driver"
"%insoptidmvtemp%\DevManView.exe" /disable "Microsoft Hyper-V Virtual Machine Bus"
"%insoptidmvtemp%\DevManView.exe" /disable "Microsoft Hyper-V Virtual Machine Bus Network Adapter"
"%insoptidmvtemp%\DevManView.exe" /disable "Microsoft Device Association Root Enumerator"
"%insoptidmvtemp%\DevManView.exe" /disable "Microsoft Hypervisor Service"
"%insoptidmvtemp%\DevManView.exe" /disable "UMBus Root Bus Enumerator"
"%insoptidmvtemp%\DevManView.exe" /disable "Remote Desktop Device Redirector Bus"
"%insoptidmvtemp%\DevManView.exe" /disable "NDIS Virtual Network Adapter Enumerator"
"%insoptidmvtemp%\DevManView.exe" /disable "WAN Miniport (IP)"
"%insoptidmvtemp%\DevManView.exe" /disable "WAN Miniport (IKEv2)"
"%insoptidmvtemp%\DevManView.exe" /disable "WAN Miniport (IPv6)"
"%insoptidmvtemp%\DevManView.exe" /disable "WAN Miniport (L2TP)"
"%insoptidmvtemp%\DevManView.exe" /disable "WAN Miniport (PPPOE)"
"%insoptidmvtemp%\DevManView.exe" /disable "WAN Miniport (PPTP)"
"%insoptidmvtemp%\DevManView.exe" /disable "WAN Miniport (SSTP)"
"%insoptidmvtemp%\DevManView.exe" /disable "WAN Miniport (Network Monitor)"

REM Modify this section ONLY if you know what you are doing / not included by default. (not dangerous but need test).
:: "%insoptidmvtemp%\DevManView.exe" /disable "System Timer"
:: "%insoptidmvtemp%\DevManView.exe" /disable "Microsoft System Management BIOS Driver"
:: "%insoptidmvtemp%\DevManView.exe" /disable "Intel(R) SPI (flash) Controller"
:: "%insoptidmvtemp%\DevManView.exe" /disable "Numeric data processor"
:: "%insoptidmvtemp%\DevManView.exe" /disable "Programmable interrupt controller"
echo %z%Info: General devices disabled successfully.%q% & timeout /t 2 /nobreak >nul 2>&1 & cls

:AskChoiceMonitorSound
cls &set z=[7m& set i=[1m& set q=[0m
echo. & echo %z%: Do you use Monitor Sound ? %q% & echo.
echo  Warning/Read: This will disable one or more "High Definition Audio Controller" devices.
echo  If you have multiple devices named "High Definition Audio Controller," be sure to leave at least one enabled,
echo  otherwise you may lose all sound in some cases (headphones, speakers, etc). & echo.
echo  If you lose sound after running this, or after reboot, open Device Manager
echo  and find the disabled "High Definition Audio Controller" device(s) causing this.
echo  Enable at least one to restore sound. If needed, enable them all.
echo. &echo %z% [Yes / Do nothing] = 1 %q%
echo. &echo %z% [No / Disable] = 2 %q% &echo.
set choice=
set /p choice=
if not '%choice%'=='' set choice=%choice:~0,1%
if '%choice%'=='1' goto PrinterDevice
if '%choice%'=='2' goto DisableMonitorSound
echo %z%Info: Invalid choice, please enter [1] or [2].%q% & timeout /t 2 /nobreak >nul 2>&1 & cls & goto AskChoiceMonitorSound

:DisableMonitorSound
cls &set z=[7m& set i=[1m& set q=[0m
cls & echo %z%Info: Disabling Monitor Sound devices..%q% &timeout /t 1 /nobreak >nul 2>&1
"%insoptidmvtemp%\DevManView.exe" /disable "High Definition Audio Controller"
"%insoptidmvtemp%\DevManView.exe" /disable "High Definition Audio Bus"
"%insoptidmvtemp%\DevManView.exe" /disable "NVIDIA High Definition Audio"
echo %z%Info: Monitor audio devices disabled.%q%
timeout /t 2 /nobreak >nul 2>&1

:PrinterDevice
cls &set z=[7m& set i=[1m& set q=[0m
echo. &echo %z%: Do you use a Printer ? %q% &echo.
echo %z% [Yes / Do nothing] = 1 %q% &echo.
echo %z% [No / Disable] = 2 %q% &echo.
set choice=
set /p choice=
if not '%choice%'=='' set choice=%choice:~0,1%
if '%choice%'=='1' goto BluetoothDevice
if '%choice%'=='2' goto DisablePrinterDevice
echo %z%Info: Invalid choice, please enter [1] or [2].%q% & timeout /t 2 /nobreak >nul 2>&1 & cls & goto PrinterDevice

:DisablePrinterDevice
cls &set z=[7m& set i=[1m& set q=[0m
cls & echo %z%Info: Disabling Printer devices..%q% &timeout /t 1 /nobreak >nul 2>&1
"%insoptidmvtemp%\DevManView.exe" /disable "Root Print Queue"
"%insoptidmvtemp%\DevManView.exe" /disable "Print Spooler"
"%insoptidmvtemp%\DevManView.exe" /disable "Generic / Text Only"
"%insoptidmvtemp%\DevManView.exe" /disable "Microsoft Print to PDF"
"%insoptidmvtemp%\DevManView.exe" /disable "Microsoft XPS Document Writer"
"%insoptidmvtemp%\DevManView.exe" /disable "Send to Microsoft OneNote"
"%insoptidmvtemp%\DevManView.exe" /disable "Fax"
"%insoptidmvtemp%\DevManView.exe" /disable "Microsoft Print"
echo %z%Info: Printer devices disabled.%q%
timeout /t 2 /nobreak >nul 2>&1 & goto BluetoothDevice

:BluetoothDevice
cls &set z=[7m& set i=[1m& set q=[0m
cls &echo. &echo %z%: Do you use Bluetooth ? %q% &echo.
echo  Warning/Read: This will disable all Bluetooth functionality including:
echo  - Bluetooth Radio, Bluetooth PAN, RFCOMM Protocol, and related services.
echo  - You will lose all Bluetooth connectivity (headphones, mice, keyboards, etc).
echo  If you need Bluetooth later, re-enable these devices in Device Manager. & echo.
echo %z% [Yes / Do nothing] = 1 %q% &echo.
echo %z% [No / Disable] = 2 %q% &echo.
set choice=
set /p choice=
if not '%choice%'=='' set choice=%choice:~0,1%
if '%choice%'=='1' goto WiFiDevice
if '%choice%'=='2' goto DisableBluetoothDevice
echo %z%Info: Invalid choice, please enter [1] or [2].%q% & timeout /t 2 /nobreak >nul 2>&1 & cls & goto BluetoothDevice

:DisableBluetoothDevice
cls &set z=[7m& set i=[1m& set q=[0m
cls & echo %z%Info: Disabling Bluetooth devices..%q% &timeout /t 1 /nobreak >nul 2>&1
"%insoptidmvtemp%\DevManView.exe" /disable "Bluetooth Radio"
"%insoptidmvtemp%\DevManView.exe" /disable "Generic Bluetooth Radio"
"%insoptidmvtemp%\DevManView.exe" /disable "Generic Bluetooth Adapter"
"%insoptidmvtemp%\DevManView.exe" /disable "Bluetooth Device (Personal Area Network)"
"%insoptidmvtemp%\DevManView.exe" /disable "Bluetooth Device (RFCOMM Protocol TDI)"
"%insoptidmvtemp%\DevManView.exe" /disable "Bluetooth LE Generic Attribute Service"
"%insoptidmvtemp%\DevManView.exe" /disable "Microsoft Bluetooth Enumerator"
"%insoptidmvtemp%\DevManView.exe" /disable "Microsoft Bluetooth LE Enumerator"
"%insoptidmvtemp%\DevManView.exe" /disable "Bluetooth AVRCP Transport"
"%insoptidmvtemp%\DevManView.exe" /disable "Bluetooth Audio Gateway"
"%insoptidmvtemp%\DevManView.exe" /disable "Bluetooth HFP SCO"
"%insoptidmvtemp%\DevManView.exe" /disable "Bluetooth A2DP Source"
"%insoptidmvtemp%\DevManView.exe" /disable "Intel Wireless Bluetooth"
"%insoptidmvtemp%\DevManView.exe" /disable "Realtek Bluetooth"
"%insoptidmvtemp%\DevManView.exe" /disable "Qualcomm Atheros Bluetooth"
"%insoptidmvtemp%\DevManView.exe" /disable "Broadcom Bluetooth"
echo %z%Info: Bluetooth devices disabled.%q%
timeout /t 2 /nobreak >nul 2>&1 & goto WiFiDevice

:WiFiDevice
cls &set z=[7m& set i=[1m& set q=[0m & cls
echo. &echo %z%: Do you use Wi-Fi ? %q% &echo.
echo  Warning/Read: This will disable all Wi-Fi functionality including:
echo  - Wireless Network Adapters, Wi-Fi Direct Virtual Adapter, and related services.
echo  - You will lose all wireless internet connectivity.
echo  - Make sure you have Ethernet connection before disabling Wi-Fi.
echo  If you need Wi-Fi later, re-enable these devices in Device Manager. & echo.
echo %z% [Yes / Do nothing] = 1 %q% &echo.
echo %z% [No / Disable] = 2 %q% &echo.
set choice=
set /p choice=
if not '%choice%'=='' set choice=%choice:~0,1%
if '%choice%'=='1' goto FinishedDevices
if '%choice%'=='2' goto DisableWiFiDevice
echo %z%Info: Invalid choice, please enter [1] or [2].%q% & timeout /t 2 /nobreak >nul 2>&1 & cls & goto WiFiDevice

:DisableWiFiDevice
cls &set z=[7m& set i=[1m& set q=[0m & cls
cls & echo %z%Info: Disabling Wi-Fi devices..%q% &timeout /t 1 /nobreak >nul 2>&1
"%insoptidmvtemp%\DevManView.exe" /disable "Microsoft Wi-Fi Direct Virtual Adapter"
"%insoptidmvtemp%\DevManView.exe" /disable "Microsoft Hosted Network Virtual Adapter"
"%insoptidmvtemp%\DevManView.exe" /disable "Intel(R) Wireless"
"%insoptidmvtemp%\DevManView.exe" /disable "Intel(R) Wi-Fi"
"%insoptidmvtemp%\DevManView.exe" /disable "Realtek RTL8"
"%insoptidmvtemp%\DevManView.exe" /disable "Qualcomm Atheros AR"
"%insoptidmvtemp%\DevManView.exe" /disable "Qualcomm Atheros QCA"
"%insoptidmvtemp%\DevManView.exe" /disable "Broadcom 802.11"
"%insoptidmvtemp%\DevManView.exe" /disable "TP-Link TL-WN"
"%insoptidmvtemp%\DevManView.exe" /disable "D-Link DWA"
"%insoptidmvtemp%\DevManView.exe" /disable "Netgear A6"
echo %z%Info: Wi-Fi devices disabled.%q%
timeout /t 2 /nobreak >nul 2>&1 & goto FinishedDevices

:FinishedDevices
cls &set z=[7m& set i=[1m& set q=[0m & cls
cls & echo %z%Info: Script Completed Successfully. A reboot is required to apply everything.%q%
echo %z%Finished : Disabling Devices Script.%q% &echo. &echo %z%support: https://guns.lol/inso.vs%q%
rd /s /q "%insoptidmvtemp%" & timeout /t 1 /nobreak >nul 2>&1
echo.
echo Press any key to exit.
pause >nul 2>&1
exit /b