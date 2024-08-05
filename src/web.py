from src.transliterator import transliterate
import requests
from bs4 import BeautifulSoup
import os

headers = {
        "Accept": "text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.7",
        "User-Agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/126.0.0.0 YaBrowser/24.7.0.0 Safari/537.36"
    }


def download_file(file_url: str, dir_path: str):
    trans_file_name = transliterate(os.path.basename(file_url))
    file_name = os.path.join(dir_path, trans_file_name)
    with requests.get(file_url, headers=headers, stream=True) as r:
        r.raise_for_status()
        with open(file_name, "wb") as f:
            for chunk in r.iter_content(chunk_size=8192):
                f.write(chunk)
    print(f"Файл {file_name} успешно загружен.")


def get_links(url: str):
    req = requests.get(url, headers=headers)
    src = req.text
    soup = BeautifulSoup(src, "lxml")
    file_links = []
    for link in soup.find_all("a", href=True):
        href = link["href"]
        if href.endswith(".crl") or href.endswith(".crt") or href.endswith(".cer"):
            file_links.append(href)
    return file_links
