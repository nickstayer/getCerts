from web import download_file
from web import get_links
import os

certs_dir = os.path.join(os.getcwd(), "certs")

if not os.path.exists(certs_dir):
    os.makedirs(certs_dir)


def main():
    try:
        url = "http://crl.roskazna.ru/crl/"
        file_links = get_links(url)
        counter = 0
        for link in file_links:
            full_url = url + link if not link.startswith("http") else link
            download_file(full_url, certs_dir)
            counter += 1
        input(f"Загружено сертификатов: {counter}")
    except Exception as e:
        print(e)


if __name__ == "__main__":
    main()
