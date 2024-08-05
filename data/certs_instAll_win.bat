@echo off
setlocal EnableDelayedExpansion

:: Переменные для подсчета
set successCount=0
set failureCount=0

:: Установка сертификатов
call :InstallCertificate "%~dp0guc.crl" "root"
call :InstallCertificate "%~dp0guc_gost12.crl" "root"
call :InstallCertificate "%~dp0guc2021.crl" "root"
call :InstallCertificate "%~dp0guc2022.crl" "root"
call :InstallCertificate "%~dp0ucfk.crl" "ca"
call :InstallCertificate "%~dp0ucfk_2020.crl" "ca"
call :InstallCertificate "%~dp0ucfk_2021.crl" "ca"
call :InstallCertificate "%~dp0ucfk_2021.crt" "ca"
call :InstallCertificate "%~dp0ucfk_2022.crl" "ca"
call :InstallCertificate "%~dp0ucfk_2022.crt" "ca"
call :InstallCertificate "%~dp0ucfk_2022_1.1.crl" "ca"
call :InstallCertificate "%~dp0ucfk_2022_1.1.crt" "ca"
call :InstallCertificate "%~dp0ucfk_2023.crl" "ca"
call :InstallCertificate "%~dp0ucfk_2023.crt" "ca"
call :InstallCertificate "%~dp0ucfk_2024.crl" "ca"
call :InstallCertificate "%~dp0ucfk_2024.crt" "ca"
call :InstallCertificate "%~dp0ucfk_gost12.crl" "ca"
call :InstallCertificate "%~dp0Kornevoj_sertifikat_GUTs.crt" "root"
call :InstallCertificate "%~dp0Kornevoj_sertifikat_GUTs_2021.cer" "root"
call :InstallCertificate "%~dp0Kornevoj_sertifikat_GUTs_2022.cer" "root"
call :InstallCertificate "%~dp0Kornevoj_sertifikat_GUTs_GOST_2012.crt" "root"
call :InstallCertificate "%~dp0Podchinennyj_sertifikat_UTs_FK_GOST_2012.crt" "ca"
call :InstallCertificate "%~dp0Podchinennyj_sertifikat_UTs_FK_ot_04.07.2017.crt" "ca"
call :InstallCertificate "%~dp0Podchinennyj_sertifikat_UTs_FK_ot_05.02.2020.crt" "ca"

:: Отчет о результатах
echo ==================================
echo Установка сертификатов завершена.
echo Успешных установок: %successCount%
echo Неудачных установок: %failureCount%

pause
exit /b

:InstallCertificate
    set "certPath=%~1"
    set "certStore=%~2"

    :: Проверка на пустые аргументы
    if "%certPath%"=="" (
        echo Ошибка: Путь к сертификату не задан.
        set /a failureCount+=1
        exit /b
    )
    
    if "%certStore%"=="" (
        echo Ошибка: Хранилище сертификата не задано.
        set /a failureCount+=1
        exit /b
    )

    echo Установка сертификата: %certPath% в хранилище: %certStore%

    certutil.exe -addstore -enterprise %certStore% "%certPath%" 2>&1
    
    if errorlevel 0 (
        echo Установка сертификата прошла успешно: %certPath%
        set /a successCount+=1
    ) else (
        echo Ошибка установки сертификата: %certPath%
        set /a failureCount+=1
    )
exit /b
