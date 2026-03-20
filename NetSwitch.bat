@echo off
chcp 65001 >nul
title Контроль Интернета

:: Включаем поддержку ANSI (Windows 10+)
for /f "tokens=2 delims=: " %%i in ('reg query HKCU\Console /v VirtualTerminalLevel 2^>nul') do set vt=%%i
if not defined vt (
    reg add HKCU\Console /v VirtualTerminalLevel /t REG_DWORD /d 1 /f >nul
)

:: Определяем ESC
for /f %%A in ('echo prompt $E ^| cmd') do set "ESC=%%A"

:: Цветовые коды ANSI
set "RED=%ESC%[31m"
set "GREEN=%ESC%[32m"
set "RESET=%ESC%[0m"

:: Проверка прав администратора
net session >nul 2>&1
if %errorLevel% neq 0 (
    echo.
    echo %RED%============================================%RESET%
    echo %RED%        ОШИБКА: Нет прав администратора%RESET%
    echo %RED%============================================%RESET%
    echo.
    echo %RED%Пожалуйста, запустите от имени администратора.%RESET%
    echo.
    pause
    exit /b 1
)

:MENU
cls
echo ============================================
echo         КОНТРОЛЬ ИНТЕРНЕТ-ТРАФИКА
echo ============================================
echo.

:: Проверка статуса
netsh advfirewall firewall show rule name="Block All Outbound" >nul 2>&1
if %errorLevel% equ 0 (
    echo %RED%[!] СТАТУС: ИНТЕРНЕТ ЗАБЛОКИРОВАН%RESET%
) else (
    echo %GREEN%[+] СТАТУС: ИНТЕРНЕТ АКТИВЕН%RESET%
)
echo.
echo 1. Заблокировать интернет
echo 2. Разблокировать интернет
echo 3. Выход
echo.
set /p choice=Выберите действие (1-3): 

if "%choice%"=="1" goto BLOCK
if "%choice%"=="2" goto UNBLOCK
if "%choice%"=="3" goto EXIT
goto MENU

:BLOCK
cls
echo ============================================
echo         БЛОКИРОВКА ИНТЕРНЕТА
echo ============================================
echo.

netsh advfirewall firewall show rule name="Block All Outbound" >nul 2>&1
if %errorLevel% equ 0 (
    echo [!] Правила уже существуют.
) else (
    echo Создание правил блокировки...
    netsh advfirewall firewall add rule name="Block All Outbound" dir=out action=block enable=yes profile=any
    if %errorLevel% equ 0 (
        echo [+] Исходящие соединения: заблокированы
    ) else (
        echo [-] Ошибка при блокировке исходящих
    )

    netsh advfirewall firewall add rule name="Block All Inbound" dir=in action=block enable=yes profile=any
    if %errorLevel% equ 0 (
        echo [+] Входящие соединения: заблокированы
    ) else (
        echo [-] Ошибка при блокировке входящих
    )
    echo.
    echo Интернет успешно заблокирован.
)
echo.
pause
goto MENU

:UNBLOCK
cls
echo ============================================
echo         ВОССТАНОВЛЕНИЕ ИНТЕРНЕТА
echo ============================================
echo.

set "rules_deleted=0"

netsh advfirewall firewall show rule name="Block All Outbound" >nul 2>&1
if %errorLevel% equ 0 (
    netsh advfirewall firewall delete rule name="Block All Outbound" >nul 2>&1
    if %errorLevel% equ 0 (
        echo [+] Правило "Block All Outbound" удалено
        set /a rules_deleted+=1
    ) else (
        echo [-] Ошибка при удалении "Block All Outbound"
    )
) else (
    echo [!] Правило "Block All Outbound" не найдено
)

netsh advfirewall firewall show rule name="Block All Inbound" >nul 2>&1
if %errorLevel% equ 0 (
    netsh advfirewall firewall delete rule name="Block All Inbound" >nul 2>&1
    if %errorLevel% equ 0 (
        echo [+] Правило "Block All Inbound" удалено
        set /a rules_deleted+=1
    ) else (
        echo [-] Ошибка при удалении "Block All Inbound"
    )
) else (
    echo [!] Правило "Block All Inbound" не найдено
)

echo.
if %rules_deleted% gtr 0 (
    echo Интернет восстановлен (удалено правил: %rules_deleted%).
) else (
    echo Блокирующие правила не найдены.
)
echo.
pause
goto MENU

:EXIT
exit /b 0