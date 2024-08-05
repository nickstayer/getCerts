from transliterate import translit
import os


def transliterate(filename: str) -> str:
    name, extension = os.path.splitext(filename)
    transliterated_name = translit(name, 'ru', reversed=True).replace(' ', '_')
    return transliterated_name + extension
