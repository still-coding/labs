---
title: "ТП. Лабораторная работа №5"
summary: Сжатие без потерь
description: Сжатие без потерь
draft: false
math: true
weight: 50
robotsNoIndex: true
showToc: false
---
### Задания для самостоятельного выполнения

Реализуйте на любом языке программирования программу-архиватор, выполняющую упаковку и распаковку файла. Программа должна отображать степень сжатия:

$$ SSR = \left( 1 - \frac{S_{comp}}{S_{src}} \right) \cdot 100 \\%, $$
где \\(S_{comp}\\) - размер сжатого файла, \\(S_{src}\\) - размер исходного файла.

Исходный и распакованный файл сравнить с помощью `diff`.

> Бонусные баллы начисляются за:
> 
> * Cамый быстрый алгоритм сжатия в своём классе
>
> * Cамый эффективный алгоритм сжатия в своём классе
> 
> Алгоритмы тестировать на файле из 10000 уникальных строк по 32 символа из всех доступных символов, сгенерированном на [random.org](https://www.random.org/strings/)


#### Варианты заданий

1. **LZ77.** [Война и мир](/tp/war_and_peace.txt).

2. **BWT+RLE.** [Геном домашней кошки](https://ftp.ensembl.org/pub/release-109/fasta/felis_catus/dna/Felis_catus.Felis_catus_9.0.dna.chromosome.A1.fa.gz).

3. **Huffman.** Произвольная книга из [симулятора Вавилонской библиотеки](https://libraryofbabel.info/random.cgi).

4. **Vitter.** [PPM файл](https://filesamples.com/samples/image/ppm/sample_1280%C3%97853.ppm). [Формат PPM](https://ru.wikipedia.org/wiki/Portable_anymap#%D0%9F%D1%80%D0%B8%D0%BC%D0%B5%D1%80_PPM).

5. **BWT+LZ77.** [ASCII STL файл](https://people.sc.fsu.edu/~jburkardt/data/stla/teapot.stl). [Формат STL](https://ru.wikipedia.org/wiki/STL_(%D1%84%D0%BE%D1%80%D0%BC%D0%B0%D1%82_%D1%84%D0%B0%D0%B9%D0%BB%D0%B0)).

6. **MTF+RLE.** Веб-страница. [Пример страницы](https://en.wikipedia.org/wiki/List_of_Hindi_songs_recorded_by_Asha_Bhosle).

7. **BWT+Huffman.** Большой файл из [SecLists](https://github.com/danielmiessler/SecLists) (\\(\ge\\) 100 Мб).

8. **BWT+Vitter.** Блоки `/dev/random`. Файл (\\(\ge\\) 100 Мб).

9. **MTF+LZ77.** Самый большой файл из [репозитория ядра Linux](https://github.com/torvalds/linux).

10. **BWT+MTF+RLE.** [Словарь Ожегова](/tp/ozhegov.txt).

11. **MTF+Huffman.** Любой файл \\(\ge\\) 100 Мб из [COMB](/tp/comb.torrent). Пароль `+w/P3PRqQQoJ6g`.

12. **MTF+Vitter.** `/var/log/Xorg.0.log`.
