#!/bin/bash

# Определение директории, где находится скрипт
SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

# Переменные для подсчета
success_count=0
failure_count=0
failed_certificates=()

echo "Установка корневых сертификатов:"

# Функция для установки сертификатов и подсчета успешных и неудачных попыток
install_certificate() {
    local file=$1
    local store=$2
    local type=$3

    if [[ "$type" == "CRL" ]]; then
        cmd="/opt/cprocsp/bin/amd64/certmgr -inst -crl -store $store -file $file"
    else
        cmd="/opt/cprocsp/bin/amd64/certmgr -inst -store $store -file $file"
    fi

    if $cmd; then
        ((success_count++))
    else
        ((failure_count++))
        failed_certificates+=("$file")
    fi
}

# Установка корневых сертификатов
install_certificate "$SCRIPT_DIR/Kornevoj_sertifikat_GUTs.crt" mRoot "корневой"
install_certificate "$SCRIPT_DIR/Kornevoj_sertifikat_GUTs_2021.cer" mRoot "корневой"
install_certificate "$SCRIPT_DIR/Kornevoj_sertifikat_GUTs_2022.cer" mRoot "корневой"
install_certificate "$SCRIPT_DIR/Kornevoj_sertifikat_GUTs_GOST_2012.crt" mRoot "корневой"

echo ""
echo "Установка подчиненных сертификатов:"

# Установка подчиненных сертификатов
install_certificate "$SCRIPT_DIR/ucfk_2021.crt" mca "подчиненный"
install_certificate "$SCRIPT_DIR/ucfk_2022.crt" mca "подчиненный"
install_certificate "$SCRIPT_DIR/ucfk_2022_1.1.crt" mca "подчиненный"
install_certificate "$SCRIPT_DIR/ucfk_2023.crt" mca "подчиненный"
install_certificate "$SCRIPT_DIR/ucfk_2024.crt" mca "подчиненный"
install_certificate "$SCRIPT_DIR/Podchinennyj_sertifikat_UTs_FK_GOST_2012.crt" mca "подчиненный"
install_certificate "$SCRIPT_DIR/Podchinennyj_sertifikat_UTs_FK_ot_04.07.2017.crt" mca "подчиненный"
install_certificate "$SCRIPT_DIR/Podchinennyj_sertifikat_UTs_FK_ot_05.02.2020.crt" mca "подчиненный"

echo ""
echo "Установка списка отзывов:"

# Установка CRL (списка отзыва сертификатов)
install_certificate "$SCRIPT_DIR/guc.crl" mca "CRL"
install_certificate "$SCRIPT_DIR/guc_gost12.crl" mca "CRL"
install_certificate "$SCRIPT_DIR/guc2021.crl" mca "CRL"
install_certificate "$SCRIPT_DIR/guc2022.crl" mca "CRL"
install_certificate "$SCRIPT_DIR/ucfk.crl" mca "CRL"
install_certificate "$SCRIPT_DIR/ucfk_2020.crl" mca "CRL"
install_certificate "$SCRIPT_DIR/ucfk_2021.crl" mca "CRL"
install_certificate "$SCRIPT_DIR/ucfk_2022.crl" mca "CRL"
install_certificate "$SCRIPT_DIR/ucfk_2024.crl" mca "CRL"
install_certificate "$SCRIPT_DIR/ucfk_2022_1.1.crl" mca "CRL"
install_certificate "$SCRIPT_DIR/ucfk_2023.crl" mca "CRL"
install_certificate "$SCRIPT_DIR/ucfk_gost12.crl" mca "CRL"

echo ""
echo "Установка завершена."

# Итоговая информация об успешных и неудачных установках
echo "Успешно установлено сертификатов: $success_count"
echo "Не удалось установить сертификатов: $failure_count"

if (( failure_count > 0 )); then
    echo "Список неустановленных сертификатов:"
    for cert in "${failed_certificates[@]}"; do
        echo "- $cert"
    done
fi
