---
title: "СПО ПМ. Лабораторная работа №3"
summary: Установка и настройка ОС Linux
description: Установка и настройка ОС Linux
draft: false
math: false
weight: 30
robotsNoIndex: true
showToc: false
---

### Задания для самостоятельного выполнения

Развернуть 3 виртуальные машины в Oracle VM VirtualBox или QEMU со следующими ОС:

1. Debian 10;
2. Arch Linux. На эту ОС необходимо установить любое окружение рабочего стола;
3. Gentoo Linux.

#### VirtualBox
Создайте виртуальную машину с диском на 20-40 Гб, 2-4 ядрами процессора, 2-4 Гб оперативной памяти (в зависимости от вашей аппаратной конфигурации) и 128 Мб видеопамяти.
Последовательнось загрузки: Optical, Hard Disk.

> **Примечание:** Для машин, на которых будет установлен только Linux, EFI несколько усложнит процесс установки, поэтому рекомендуется *не включать* EFI.

В оптический привод смонтируйте iso-образ. Теперь можно запустить машину.

#### QEMU

1. Создаём образ виртуального жёсткого диска
    ```bash
    qemu-img create -f qcow2 vhdd.img 40G
    ```
2. Запускаем машину
    ```bash
    qemu-system-x86_64 -m 4G -boot d -enable-kvm -smp 4 -net nic -net user -hda vhdd.img -cdrom <название_образа>.iso
    ```

    Ключ `-vga vmware` может быть полезен в случае проблем с видеодрайверами.
    Для справки: https://wiki.archlinux.org/title/QEMU

### Установка Debian

Тут можно скачать установочный iso образ Debian https://cdimage.debian.org/debian-cd/current/amd64/iso-dvd/

Инструкции по установке находятся здесь https://www.debian.org/releases/stable/installmanual

### 2. Установка Arch

Установочный iso образ Arch найдёте на этой странице https://www.archlinux.org/download/

Инструкции по установке находятся здесь https://wiki.archlinux.org/index.php/Installation_guide_(%D0%A0%D1%83%D1%81%D1%81%D0%BA%D0%B8%D0%B9)

> **Примечание:** Не используйте archinstall или подобные скрипты автоматизации.


### 3. Установка Gentoo

Установочный iso образ Gentoo найдёте на этой странице https://www.gentoo.org/downloads/

Для того, чтобы собрать и установить Gentoo, вооружитесь Gentoo Handbook https://wiki.gentoo.org/wiki/Handbook:AMD64/ru, запаситесь кофе с печеньем и запритесь в комнате со своим компьютером на пару дней.


### Необходимые пакеты

#### Debian-based

* virtualbox-6.1
* qemu
* qemu-kvm
* ovmf

#### Arch-based

* virtualbox
* virtualbox-host-modules-arch
* qemu
* edk2-ovmf
