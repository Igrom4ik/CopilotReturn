@echo off
chcp 65001 > nul
echo Не закрывайте окно, процесс выполняется...

:: Проверка прав администратора
>nul 2>&1 net session || (
    echo Требуется запуск от имени администратора.
    echo Пожалуйста, запустите скрипт с правами администратора.
    pause
    exit /b
)

rem Проверка наличия файла IntegratedServicesRegionPolicySet.json
set "jsonFile=IntegratedServicesRegionPolicySet.json"
if not exist "%jsonFile%" (
    echo Файл %jsonFile% не найден.
    pause
    exit /b
)

rem Проверка наличия файла UpdatedPolicies.json
set "updatedPoliciesFile=%~dp0IntegratedServicesRegionPolicySet.json"
if not exist "%updatedPoliciesFile%" (
    echo Файл %updatedPoliciesFile% не найден в текущей папке скрипта.
    pause
    exit /b
)

rem Сравнение содержимого файлов
fc /b "%jsonFile%" "%updatedPoliciesFile%" > nul
if %errorlevel% equ 0 (
    echo Содержимое файлов совпадает.
    set /p "choice=Хотите обновить содержимое? (y/n): "
    if /i "%choice%"=="y" (
        copy /y "%updatedPoliciesFile%" "%jsonFile%" > nul
        echo Политики успешно обновлены!
    ) else (
        echo Обновление отменено пользователем.
    )
) else (
    echo В файле имеются несовпадения:
    fc /t "%jsonFile%" "%updatedPoliciesFile%"
    echo.
    echo Политики в файлах отличаются.
    echo Нажмите клавишу Enter, чтобы продолжить...
    pause > nul
    rem Автоматическое обновление содержимого файла
    copy /y "%updatedPoliciesFile%" "%jsonFile%" > nul
    echo Политики успешно обновлены!
)

pause
exit /b
