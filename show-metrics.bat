@echo off
chcp 65001 > nul
title Мониторинг 5 метрик
color 0A

echo ==========================================
echo            📊 МОНИТОРИНГ ПРИЛОЖЕНИЯ
echo ==========================================
echo.
echo Хост: %COMPUTERNAME%
echo Пользователь: %USERNAME%
echo Время: %date% %time%
echo.

echo 📌 ПРОВЕРКА DOCKER:
echo -------------------
docker --version
if errorlevel 1 (
    echo ❌ Docker не установлен!
    echo Установите Docker Desktop с docker.com
    pause
    exit /b 1
)

echo.
echo ✅ Docker установлен
echo.

echo 📌 ПОИСК ЗАПУЩЕННЫХ КОНТЕЙНЕРОВ:
echo --------------------------------
docker ps --format "table {{.Names}}\t{{.Status}}\t{{.Ports}}"

echo.
echo ==========================================
echo            5 ОСНОВНЫХ МЕТРИК
echo ==========================================
echo.

echo 1. ⚡ CPU ИСПОЛЬЗОВАНИЕ:
echo    Симуляция: 45.5%%
echo.

echo 2. 🧠 RAM ИСПОЛЬЗОВАНИЕ:
echo    Симуляция: 67.2%%
echo.

echo 3. 💾 DISK ИСПОЛЬЗОВАНИЕ:
for /f "tokens=2 delims=: " %%a in ('wmic logicaldisk where "DeviceID='C:'" get FreeSpace^,Size /value ^| find "="') do (
    set /a "%%a"
)
if defined Size if defined FreeSpace (
    set /a used=Size - FreeSpace
    set /a percent=used*100/Size
    echo    Диск C: %percent%%%
) else (
    echo    Симуляция: 34.8%%
)
echo.

echo 4. ❤️ HEALTH CHECK:
curl -s http://localhost:8080 > nul
if errorlevel 1 (
    echo    ❌ Приложение не отвечает на порту 8080
) else (
    echo    ✅ Приложение отвечает (HTTP 200)
)
echo.

echo 5. 💰 BUSINESS METRIC:
set /a business=850 + %RANDOM% %% 150
echo    Симулированные продажи: %business% усл. ед.
echo.

echo ==========================================
echo            КОМАНДЫ ДЛЯ ПРОВЕРКИ
echo ==========================================
echo.
echo 📦 Проверить все контейнеры:
echo    docker ps -a
echo.
echo 📊 Посмотреть статистику:
echo    docker stats --no-stream
echo.
echo 📝 Посмотреть логи:
echo    docker logs [имя_контейнера]
echo.
echo 🌐 Проверить веб-приложение:
echo    start http://localhost:8080
echo.

echo ==========================================
echo         ИНФОРМАЦИЯ О СИСТЕМЕ
echo ==========================================
echo.
echo 📋 Система: %PROCESSOR_ARCHITECTURE%
echo 🖥️  Процессор: %NUMBER_OF_PROCESSORS% ядер
echo 💻 Пользователь: %USERNAME%
echo 📅 Дата: %date%
echo ⏰ Время: %time%

echo.
pause