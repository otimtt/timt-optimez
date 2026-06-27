@echo off
:: ============================================================
::  TIMT-OPTIMEZ - by Timoteo (Timt)
::  Limpeza e otimizacao completa do Windows 10
::  github.com/otimtt/timt-optimez
:: ============================================================

:: Verifica privilegios de administrador
net session >nul 2>&1
if %errorLevel% neq 0 (
    echo.
    echo  [ERRO] Só funciona se executar como Administrador!
    echo  Clique com botao direito no arquivo e selecione:
    echo  "Executar como administrador"
    echo.
    pause
    exit /b 1
)

:: Configuracoes
title TIMT-OPTIMEZ
color 0A
mode con: cols=70 lines=50

:MENU
cls
echo.
echo  ========================================================
echo       TIMT-OPTIMEZ - Limpeza e Desempenho
echo  ========================================================
echo.
echo   [1]  Executar OTIMIZACAO COMPLETA (recomendado)
echo   [2]  Apenas Limpeza de Arquivos Temporarios
echo   [3]  Apenas Otimizacao do Sistema
echo   [4]  Apenas Servicos e Startup
echo   [5]  Apenas Rede e Internet
echo   [6]  Relatorio do Sistema
echo   [0]  Sair
echo.
echo  ========================================================
echo.
set /p opcao="  Escolha uma opcao: "

if "%opcao%"=="1" goto COMPLETO
if "%opcao%"=="2" goto LIMPEZA
if "%opcao%"=="3" goto OTIMIZACAO
if "%opcao%"=="4" goto SERVICOS
if "%opcao%"=="5" goto REDE
if "%opcao%"=="6" goto RELATORIO
if "%opcao%"=="0" goto SAIR

echo  Opcao invalida!
timeout /t 2 >nul
goto MENU

:: ============================================================
:: OTIMIZACAO COMPLETA
:: ============================================================
:COMPLETO
cls
echo.
echo  ========================================================
echo       OTIMIZACAO COMPLETA EM ANDAMENTO...
echo  ========================================================
echo.
echo  Isso pode levar alguns minutos. Por favor, aguarde.
echo.

call :LIMPEZA_FUNC
call :OTIMIZACAO_FUNC
call :SERVICOS_FUNC
call :REDE_FUNC

echo.
echo  ========================================================
echo   [OK] OTIMIZACAO COMPLETA FINALIZADA COM SUCESSO!
echo  ========================================================
echo.
echo  Recomendamos REINICIAR o computador agora.
echo.
set /p reiniciar="  Deseja reiniciar agora? (S/N): "
if /i "%reiniciar%"=="S" shutdown /r /t 10 /c "Reiniciando apos otimizacao..."
goto MENU

:: ============================================================
:: LIMPEZA DE ARQUIVOS
:: ============================================================
:LIMPEZA
cls
call :LIMPEZA_FUNC
echo.
echo  [OK] Limpeza concluida!
pause
goto MENU

:LIMPEZA_FUNC
echo.
echo  --------------------------------------------------------
echo   ETAPA 1/4 - LIMPEZA DE ARQUIVOS TEMPORARIOS
echo  --------------------------------------------------------
echo.

echo  [..] Limpando pasta Temp do sistema...
del /q /f /s "%SystemRoot%\Temp\*" >nul 2>&1
rd /s /q "%SystemRoot%\Temp" >nul 2>&1
md "%SystemRoot%\Temp" >nul 2>&1
echo  [OK] Temp do sistema

echo  [..] Limpando pasta Temp do usuario...
del /q /f /s "%TEMP%\*" >nul 2>&1
echo  [OK] Temp do usuario

echo  [..] Limpando Prefetch...
del /q /f /s "%SystemRoot%\Prefetch\*" >nul 2>&1
echo  [OK] Prefetch

echo  [..] Limpando cache do Windows Update...
net stop wuauserv >nul 2>&1
net stop bits >nul 2>&1
del /q /f /s "%SystemRoot%\SoftwareDistribution\Download\*" >nul 2>&1
net start wuauserv >nul 2>&1
net start bits >nul 2>&1
echo  [OK] Cache do Windows Update

echo  [..] Limpando Lixeira...
rd /s /q "C:\$Recycle.Bin" >nul 2>&1
echo  [OK] Lixeira

echo  [..] Limpando cache do navegador Edge...
set EdgeCache=%LOCALAPPDATA%\Microsoft\Edge\User Data\Default\Cache
if exist "%EdgeCache%" del /q /f /s "%EdgeCache%\*" >nul 2>&1
echo  [OK] Cache do Edge

echo  [..] Limpando cache do Chrome (se instalado)...
set ChromeCache=%LOCALAPPDATA%\Google\Chrome\User Data\Default\Cache
if exist "%ChromeCache%" del /q /f /s "%ChromeCache%\*" >nul 2>&1
echo  [OK] Cache do Chrome

echo  [..] Limpando thumbnails do Windows...
del /q /f /s "%LOCALAPPDATA%\Microsoft\Windows\Explorer\thumbcache_*" >nul 2>&1
echo  [OK] Thumbnails

echo  [..] Limpando logs antigos do sistema...
del /q /f /s "%SystemRoot%\Logs\*" >nul 2>&1
echo  [OK] Logs do sistema

echo  [..] Limpando arquivos de crash dump...
del /q /f /s "%SystemRoot%\Minidump\*" >nul 2>&1
del /q /f "%SystemRoot%\MEMORY.DMP" >nul 2>&1
echo  [OK] Crash dumps

echo  [..] Executando limpeza nativa do Windows (cleanmgr)...
cleanmgr /sagerun:1 >nul 2>&1
echo  [OK] Disk Cleanup

echo  [..] Esvaziando shadow copies antigas (mantem ultima)...
vssadmin delete shadows /for=c: /oldest /quiet >nul 2>&1
echo  [OK] Shadow copies

echo.
echo  [OK] === Limpeza de arquivos concluida ===
echo.
goto :EOF

:: ============================================================
:: OTIMIZACAO DO SISTEMA
:: ============================================================
:OTIMIZACAO
cls
call :OTIMIZACAO_FUNC
echo.
echo  [OK] Otimizacao do sistema concluida!
pause
goto MENU

:OTIMIZACAO_FUNC
echo.
echo  --------------------------------------------------------
echo   ETAPA 2/4 - OTIMIZACAO DO SISTEMA
echo  --------------------------------------------------------
echo.

echo  [..] Ajustando prioridade de processos para desempenho...
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\userinit.exe\PerfOptions" /v CpuPriorityClass /t REG_DWORD /d 3 /f >nul 2>&1
echo  [OK] Prioridade de CPU

echo  [..] Desativando efeitos visuais desnecessarios...
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\VisualEffects" /v VisualFXSetting /t REG_DWORD /d 2 /f >nul 2>&1
reg add "HKCU\Control Panel\Desktop" /v UserPreferencesMask /t REG_BINARY /d 9012038010000000 /f >nul 2>&1
echo  [OK] Efeitos visuais

echo  [..] Otimizando plano de energia para Alto Desempenho...
powercfg /setactive 8c5e7fda-e8bf-4a96-9a85-a6e23a8c635c >nul 2>&1
echo  [OK] Plano de energia

echo  [..] Desativando hibernacao (libera espaco em disco)...
powercfg /hibernate off >nul 2>&1
echo  [OK] Hibernacao desativada

echo  [..] Otimizando gerenciamento de memoria...
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management" /v ClearPageFileAtShutdown /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management" /v LargeSystemCache /t REG_DWORD /d 0 /f >nul 2>&1
echo  [OK] Gerenciamento de memoria

echo  [..] Desativando Cortana (melhora RAM e CPU)...
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\Windows Search" /v AllowCortana /t REG_DWORD /d 0 /f >nul 2>&1
echo  [OK] Cortana desativada

echo  [..] Desativando telemetria e coleta de dados...
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\DataCollection" /v AllowTelemetry /t REG_DWORD /d 0 /f >nul 2>&1
sc config DiagTrack start= disabled >nul 2>&1
sc stop DiagTrack >nul 2>&1
echo  [OK] Telemetria

echo  [..] Desativando indexacao de busca (menos uso de disco)...
sc config WSearch start= disabled >nul 2>&1
sc stop WSearch >nul 2>&1
echo  [OK] Indexacao de busca

echo  [..] Otimizando tempo de resposta do menu Iniciar...
reg add "HKCU\Control Panel\Desktop" /v MenuShowDelay /t REG_SZ /d 0 /f >nul 2>&1
echo  [OK] Resposta do menu Iniciar

echo  [..] Desativando animacoes de janela...
reg add "HKCU\Control Panel\Desktop\WindowMetrics" /v MinAnimate /t REG_SZ /d 0 /f >nul 2>&1
echo  [OK] Animacoes de janela

echo  [..] Verificando integridade dos arquivos do sistema (SFC)...
sfc /scannow >nul 2>&1
echo  [OK] SFC concluido

echo  [..] Verificando e reparando imagem do Windows (DISM)...
DISM /Online /Cleanup-Image /RestoreHealth >nul 2>&1
echo  [OK] DISM concluido

echo  [..] Otimizando disco (desfragmentacao / TRIM para SSD)...
defrag C: /U /V >nul 2>&1
echo  [OK] Otimizacao de disco

echo.
echo  [OK] === Otimizacao do sistema concluida ===
echo.
goto :EOF

:: ============================================================
:: SERVICOS E STARTUP
:: ============================================================
:SERVICOS
cls
call :SERVICOS_FUNC
echo.
echo  [OK] Servicos e Startup otimizados!
pause
goto MENU

:SERVICOS_FUNC
echo.
echo  --------------------------------------------------------
echo   ETAPA 3/4 - SERVICOS E PROGRAMAS NA INICIALIZACAO
echo  --------------------------------------------------------
echo.

echo  [..] Desativando servicos desnecessarios...

sc config "SysMain" start= auto >nul 2>&1
sc start "SysMain" >nul 2>&1
echo  [OK] SuperFetch (SysMain) - ativado

sc config "Fax" start= disabled >nul 2>&1
sc stop "Fax" >nul 2>&1
echo  [OK] Fax - desativado

sc config "XblAuthManager" start= disabled >nul 2>&1
sc stop "XblAuthManager" >nul 2>&1
echo  [OK] Xbox Auth - desativado

sc config "XblGameSave" start= disabled >nul 2>&1
sc stop "XblGameSave" >nul 2>&1
echo  [OK] Xbox Game Save - desativado

sc config "XboxNetApiSvc" start= disabled >nul 2>&1
sc stop "XboxNetApiSvc" >nul 2>&1
echo  [OK] Xbox Net API - desativado

sc config "WMPNetworkSvc" start= disabled >nul 2>&1
sc stop "WMPNetworkSvc" >nul 2>&1
echo  [OK] Windows Media Player Network - desativado

sc config "lfsvc" start= disabled >nul 2>&1
sc stop "lfsvc" >nul 2>&1
echo  [OK] Geolocation Service - desativado

sc config "RetailDemo" start= disabled >nul 2>&1
sc stop "RetailDemo" >nul 2>&1
echo  [OK] Retail Demo - desativado

sc config "RemoteRegistry" start= disabled >nul 2>&1
sc stop "RemoteRegistry" >nul 2>&1
echo  [OK] Remote Registry - desativado (seguranca)

echo  [..] Limpando entradas de startup do registro...
reg delete "HKCU\Software\Microsoft\Windows\CurrentVersion\Run" /v "OneDrive" /f >nul 2>&1
reg delete "HKCU\Software\Microsoft\Windows\CurrentVersion\Run" /v "Skype" /f >nul 2>&1
echo  [OK] Startup do registro limpo

echo  [..] Desativando apps que iniciam automaticamente...
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\StartupApproved\Run" /v "OneDrive" /t REG_BINARY /d 0300000000000000 /f >nul 2>&1
echo  [OK] Apps de startup

echo.
echo  [OK] === Servicos e Startup otimizados ===
echo.
goto :EOF

:: ============================================================
:: REDE E INTERNET
:: ============================================================
:REDE
cls
call :REDE_FUNC
echo.
echo  [OK] Rede otimizada!
pause
goto MENU

:REDE_FUNC
echo.
echo  --------------------------------------------------------
echo   ETAPA 4/4 - OTIMIZACAO DE REDE E INTERNET
echo  --------------------------------------------------------
echo.

echo  [..] Limpando cache DNS...
ipconfig /flushdns >nul 2>&1
echo  [OK] Cache DNS limpo

echo  [..] Redefinindo configuracoes de rede (Winsock)...
netsh winsock reset >nul 2>&1
echo  [OK] Winsock redefinido

echo  [..] Redefinindo pilha TCP/IP...
netsh int ip reset >nul 2>&1
echo  [OK] TCP/IP redefinido

echo  [..] Limpando cache ARP...
arp -d * >nul 2>&1
echo  [OK] Cache ARP limpo

echo  [..] Configurando DNS para Google (8.8.8.8)...
for /f "tokens=*" %%i in ('netsh interface show interface ^| findstr "Connected"') do (
    for /f "tokens=4" %%j in ("%%i") do (
        netsh interface ip set dns "%%j" static 8.8.8.8 >nul 2>&1
        netsh interface ip add dns "%%j" 8.8.8.8 index=2 >nul 2>&1
    )
)
echo  [OK] DNS configurado (Google 8.8.8.8)

echo  [..] Otimizando auto-ajuste de janela TCP...
netsh int tcp set global autotuninglevel=normal >nul 2>&1
echo  [OK] TCP Auto-tuning

echo.
echo  [OK] === Rede otimizada ===
echo.
goto :EOF

:: ============================================================
:: RELATORIO DO SISTEMA
:: ============================================================
:RELATORIO
cls
echo.
echo  ========================================================
echo       RELATORIO DO SISTEMA
echo  ========================================================
echo.

echo  === INFORMACOES DO COMPUTADOR ===
systeminfo | findstr /c:"Nome do Host" /c:"Sistema Operacional" /c:"Versao" /c:"Fabricante" /c:"Modelo" /c:"Memoria Fisica" /c:"Host Name" /c:"OS Name" /c:"OS Version" /c:"System Manufacturer" /c:"System Model" /c:"Total Physical Memory"
echo.

echo  === USO DE DISCO ===
wmic logicaldisk get name,size,freespace,description 2>nul | findstr /v "^$"
echo.

echo  === CPU ===
wmic cpu get name,numberofcores,maxclockspeed /format:list 2>nul | findstr /v "^$"
echo.

echo  === TOP PROCESSOS (uso de memoria) ===
tasklist /fo table /nh | sort /r /+64 | head -15 >nul 2>&1
tasklist /fo csv /nh | sort /r 2>nul | head -10 >nul 2>&1
wmic process get name,workingsetsize /format:table 2>nul | sort /r /+40 | findstr /v "^$" | head -15

echo.
echo  ========================================================
pause
goto MENU

:: ============================================================
:: SAIR
:: ============================================================
:SAIR
cls
echo.
echo  Obrigado por usar o TIMT-OPTIMEZ!
echo  Sistema otimizado com sucesso.
echo.
timeout /t 3 >nul
exit /b 0