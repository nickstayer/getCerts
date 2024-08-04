import requests
from bs4 import BeautifulSoup
import os


certs_dir = os.path.join(os.path.dirname(__file__), 'certs')
if not os.path.exists(certs_dir):
    os.makedirs(certs_dir)

headers = {
    "Accept": "text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.7",
    "User-Agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/126.0.0.0 YaBrowser/24.7.0.0 Safari/537.36"
}

url = "http://crl.roskazna.ru/crl/"

# Делаем GET-запрос к веб-странице
req = requests.get(url, headers=headers)
src = req.text

# Используем BeautifulSoup для парсинга HTML-страницы
soup = BeautifulSoup(src, "lxml")

# Извлекаем все ссылки с расширениями .crl и .crt
file_links = []
for link in soup.find_all("a", href=True):
    href = link["href"]
    if href.endswith(".crl") or href.endswith(".crt") or href.endswith(".cer"):
        file_links.append(href)


# Функция для скачивания файла по URL
def download_file(file_url):
    # Определяем имя файла из URL
    file_name = os.path.join(certs_dir, os.path.basename(file_url))

    # Выполняем GET-запрос на скачивание файла
    with requests.get(file_url, headers=headers, stream=True) as r:
        r.raise_for_status()
        # Открываем файл для записи
        with open(file_name, "wb") as f:
            for chunk in r.iter_content(chunk_size=8192):
                f.write(chunk)
    print(f"Файл {file_name} успешно загружен.")


# Скачиваем каждый файл из списка
for link in file_links:
    # Формируем полный URL, если он относительный
    full_url = url + link if not link.startswith("http") else link
    download_file(full_url)
