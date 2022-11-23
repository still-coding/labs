---
title: "СПО ПМ. Лабораторная работа №5"
summary: Создание модуля ядра
description: Создание модуля ядра
draft: false
math: false
weight: 50
robotsNoIndex: true
showToc: true
TocOpen: false
---

### Задание

Собрать и протестировать модуль ядра - простой драйвер символьного устройства.


### Ход работы

Приведена последовательость работы для Debian 11. На других дистрибутивах может отличаться.

1. Установите необходимые пакеты

```bash
sudo apt install build-essential kmod linux-headers-`uname -r`
```

2. Скачайте и распакуйте [архив с исходниками](/ssw_pm/lab05_kmods.zip).

3. Зайдите в директорию `hello` и соберите модуль командой:
```bash
make
```

4. Для работы с модулями вам понадобятся следующие команды:

```bash
lsmod
lsmod | grep <название>
sudo modinfo <название>.ko
sudo insmod <название>.ko
sudo rmmod <название>
sudo journalctl --since "5 minutes ago" | grep kernel
```

5. Удостоверьтесь что модуль коректно загружается и выгружается.

6. Переходите к модулю `chardev`.
    * удостоверьтесь что модуль корректно работает
    * разберите код
    * подготовьтесь к защите

> **Материалы**:
>* Книга [The Linux Kernel Module Programming Guide](https://sysprog21.github.io/lkmpg/)
>* Курс СПбГЭТУ "ЛЭТИ" [Разработка модулей ядра Linux](https://stepik.org/course/2051)
