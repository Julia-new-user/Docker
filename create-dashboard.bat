@echo off
chcp 65001 > nul
title Создание дашборда мониторинга
color 0B

echo ==========================================
echo        📊 СОЗДАНИЕ ДАШБОРДА МОНИТОРИНГА
echo ==========================================
echo.

REM Создаем папку для дашборда
set DASHBOARD_DIR=dashboard-results
if not exist "%DASHBOARD_DIR%" mkdir "%DASHBOARD_DIR%"

echo 📁 Создана папка: %DASHBOARD_DIR%
echo.

REM Создаем CSV файл с метриками
set METRICS_FILE=%DASHBOARD_DIR%\metrics.csv
echo timestamp,cpu,ram,disk,health,business,host > "%METRICS_FILE%"

echo 🔄 Сбор данных...
echo    Собираем 5 точек данных с интервалом 3 секунды...
echo.

set COUNTER=1
:LOOP
if %COUNTER% GTR 5 goto :DONE

REM Генерируем текущее время
for /f "tokens=1-3 delims=: " %%a in ("%time%") do (
    set HOUR=%%a
    set MINUTE=%%b
    set SECOND=%%c
)
set TIMESTAMP=%date% %HOUR%:%MINUTE%:%SECOND%

REM Генерируем случайные метрики
set /a CPU=40 + %RANDOM% %% 40
set /a RAM=50 + %RANDOM% %% 30
set /a DISK=30 + %RANDOM% %% 40
set /a BUSINESS=800 + %RANDOM% %% 400
set HEALTH=1

echo 📍 Точка %COUNTER%/5:
echo    Время: %TIMESTAMP%
echo    CPU: %CPU%%%
echo    RAM: %RAM%%%
echo    Disk: %DISK%%%
echo    Health: Здорово
echo    Business: %BUSINESS% усл. ед.
echo.

REM Записываем в CSV
echo %TIMESTAMP%,%CPU%,%RAM%,%DISK%,%HEALTH%,%BUSINESS%,%COMPUTERNAME% >> "%METRICS_FILE%"

REM Ждем 3 секунды
timeout /t 3 /nobreak > nul

set /a COUNTER+=1
goto :LOOP

:DONE
echo ✅ Сбор данных завершен!
echo 📊 Данные сохранены в: %METRICS_FILE%
echo.

REM Создаем HTML дашборд
set HTML_FILE=%DASHBOARD_DIR%\dashboard.html
echo Создание HTML дашборда...

(
echo ^<!DOCTYPE html^>
echo ^<html^>
echo ^<head^>
echo     ^<meta charset="UTF-8"^>
echo     ^<title^>📊 Дашборд мониторинга^</title^>
echo     ^<style^>
echo         body { font-family: Arial; padding: 20px; background: #f5f5f5; }
echo         .container { max-width: 1200px; margin: 0 auto; background: white; padding: 30px; border-radius: 10px; }
echo         h1 { color: #2c3e50; }
echo         .metrics { display: flex; flex-wrap: wrap; gap: 20px; margin: 30px 0; }
echo         .metric-card { flex: 1; min-width: 200px; background: #f8f9fa; padding: 20px; border-radius: 10px; }
echo         .metric-title { font-weight: bold; color: #2c3e50; }
echo         .metric-value { font-size: 24px; margin: 10px 0; }
echo         table { width: 100^%; border-collapse: collapse; margin: 20px 0; }
echo         th, td { padding: 10px; border: 1px solid #ddd; text-align: left; }
echo         th { background: #3498db; color: white; }
echo     ^</style^>
echo ^</head^>
echo ^<body^>
echo     ^<div class="container"^>
echo         ^<h1^>📊 Дашборд мониторинга^</h1^>
echo         ^<p^>Хост: %COMPUTERNAME%^</p^>
echo         ^<p^>Время создания: %date% %time%^</p^>
echo         
echo         ^<div class="metrics"^>
echo             ^<div class="metric-card"^>
echo                 ^<div class="metric-title"^>⚡ CPU Usage^</div^>
echo                 ^<div class="metric-value"^>%CPU%%%^</div^>
echo                 ^<div^>Средняя нагрузка^</div^>
echo             ^</div^>
echo             ^<div class="metric-card"^>
echo                 ^<div class="metric-title"^>🧠 RAM Usage^</div^>
echo                 ^<div class="metric-value"^>%RAM%%%^</div^>
echo                 ^<div^>Использование памяти^</div^>
echo             ^</div^>
echo             ^<div class="metric-card"^>
echo                 ^<div class="metric-title"^>💾 Disk Usage^</div^>
echo                 ^<div class="metric-value"^>%DISK%%%^</div^>
echo                 ^<div^>Занятое место^</div^>
echo             ^</div^>
echo             ^<div class="metric-card"^>
echo                 ^<div class="metric-title"^>❤️ Health Status^</div^>
echo                 ^<div class="metric-value"^>Здорово^</div^>
echo                 ^<div^>Статус приложения^</div^>
echo             ^</div^>
echo             ^<div class="metric-card"^>
echo                 ^<div class="metric-title"^>💰 Business Metric^</div^>
echo                 ^<div class="metric-value"^>%BUSINESS%^</div^>
echo                 ^<div^>Продажи/день^</div^>
echo             ^</div^>
echo         ^</div^>
echo         
echo         ^<h2^>📋 Собранные данные^</h2^>
echo         ^<table^>
echo             ^<thead^>
echo                 ^<tr^>
echo                     ^<th^>Время^</th^>
echo                     ^<th^>CPU %%^</th^>
echo                     ^<th^>RAM %%^</th^>
echo                     ^<th^>Disk %%^</th^>
echo                     ^<th^>Health^</th^>
echo                     ^<th^>Business^</th^>
echo                 ^</tr^>
echo             ^</thead^>
echo             ^<tbody^>
) > "%HTML_FILE%"

REM Добавляем данные из CSV в таблицу
for /f "skip=1 tokens=1-7 delims=," %%a in ('type "%METRICS_FILE%"') do (
    (
    echo                 ^<tr^>
    echo                     ^<td^>%%a^</td^>
    echo                     ^<td^>%%b%%^</td^>
    echo                     ^<td^>%%c%%^</td^>
    echo                     ^<td^>%%d%%^</td^>
    echo                     ^<td^>Здорово^</td^>
    echo                     ^<td^>%%f^</td^>
    echo                 ^</tr^>
    ) >> "%HTML_FILE%"
)

(
echo             ^</tbody^>
echo         ^</table^>
echo         
echo         ^<h2^>📝 Отслеживаемые метрики^</h2^>
echo         ^<ol^>
echo             ^<li^>⚡ CPU Usage - нагрузка процессора^</li^>
echo             ^<li^>🧠 RAM Usage - использование памяти^</li^>
echo             ^<li^>💾 Disk Usage - занятое дисковое пространство^</li^>
echo             ^<li^>❤️ Health Status - статус здоровья приложения^</li^>
echo             ^<li^>💰 Business Metric - симулированные продажи^</li^>
echo         ^</ol^>
echo         
echo         ^<p^>Сгенерировано скриптом create-dashboard.bat^</p^>
echo     ^</div^>
echo ^</body^>
echo ^</html^>
) >> "%HTML_FILE%"

echo ✅ HTML дашборд создан: %HTML_FILE%
echo.

REM Создаем текстовый отчет
set REPORT_FILE=%DASHBOARD_DIR%\report.txt
(
echo ==========================================
echo            ОТЧЕТ МОНИТОРИНГА
echo ==========================================
echo.
echo Дата: %date%
echo Время: %time%
echo Хост: %COMPUTERNAME%
echo Пользователь: %USERNAME%
echo.
echo 📊 СОБРАННЫЕ ДАННЫЕ:
echo --------------------
type "%METRICS_FILE%"
echo.
echo 📁 СОЗДАННЫЕ ФАЙЛЫ:
echo -------------------
echo 1. %METRICS_FILE% - данные в формате CSV
echo 2. %HTML_FILE% - HTML дашборд
echo 3. %REPORT_FILE% - этот отчет
echo.
echo 🌐 КАК ОТКРЫТЬ ДАШБОРД:
echo ----------------------
echo 1. Найти файл: %HTML_FILE%
echo 2. Открыть двойным кликом
echo 3. Или в браузере: file:///%cd%/%HTML_FILE%
echo.
echo 🔄 ПОВТОРНЫЙ ЗАПУСК:
echo --------------------
echo Удалите папку "%DASHBOARD_DIR%" и запустите скрипт снова
echo ==========================================
) > "%REPORT_FILE%"

echo 📝 Текстовый отчет создан: %REPORT_FILE%
echo.

echo ==========================================
echo            🎉 ДАШБОРД СОЗДАН!
echo ==========================================
echo.
echo 📁 Папка с результатами: %DASHBOARD_DIR%
echo 📊 HTML дашборд: %HTML_FILE%
echo 📈 CSV данные: %METRICS_FILE%
echo 📋 Отчет: %REPORT_FILE%
echo.
echo 🌐 Откройте дашборд двойным кликом по файлу!
echo.

REM Показываем содержимое папки
echo 📂 СОДЕРЖИМОЕ ПАПКИ %DASHBOARD_DIR%:
dir "%DASHBOARD_DIR%"

echo.
pause