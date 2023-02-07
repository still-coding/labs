---
title: "СПО. Лабораторная работа №2"
summary: Установка и настройка ОС
description: Установка и настройка ОС
draft: false
math: false
weight: 20
robotsNoIndex: true
showToc: true
TocOpen: true
---

### Задание
Развернуть 3 виртуальные машины в Oracle VM VirtualBox или QEMU со следующими ОС:

1. Windows 11 + Debian 11;
2. Arch Linux. На эту ОС необходимо установить любое окружение рабочего стола;
3. Gentoo Linux.

### Требования к отчёту
Отчёт должен содержать скриншоты ***каждого*** шага установки и настройки указанных ОС с комментариями. Для всех ОС в системе должен присутствовать пользователь с вашим именем, в Linux - умеющий выполнять `sudo`. Имя хоста и пользователя должны однозначно идентифицировать ваши виртуальные машины. **В отчёте необходимо объяснить, для чего были нужны выполенные команды и действия.**

### 1. Установка Windows 11 в ручном режиме на виртуальную машину

Скачайте русскоязычный образ Windows 11.

#### VirtualBox
Создайте виртуальную машину с диском на 50-80 Гб, 2-4 ядрами процессора, 2-4 Гб оперативной памяти и 128 Мб видеопамяти.
Последовательнось загрузки: Optical, Hard Disk. *Обязательно установите галочку "Enable EFI" для этой машины.*

> **Примечание:** Для машин, на которых будет установлен только Linux, EFI несколько усложнит процесс установки, поэтому на остальных виртуальных машинах рекомендуется *не включать* EFI.


{{< figure src="/images/ssw_lab1_1.png" alt="Окно настроек виртуальной машины для Windows 11" >}}



В оптический привод смонтируйте iso-образ Windows 11. Выключите сетевой адаптер. Теперь можно запустить машину.

#### QEMU

1. Создаём образ виртуального жёсткого диска
    ```bash
    qemu-img create -f qcow2 vhdd.img 50G
    ```
2. Запускаем машину
    ```bash
    qemu-system-x86_64 -m 4G -boot d -enable-kvm -smp 4 -net nic -net user -hda vhdd.img \
    -cdrom Win10_21H2_Russian_x64.iso -bios /usr/share/ovmf/OVMF.fd
    ```
    > **Примечание:** Обратите внимание, что поддержка EFI осуществлена с помощью открытой реализации TianoCore, и при запуске машины нужно указать где находится firmware-файл `OVMF.fd` или `OVMF_CODE.fd` в некоторых версиях. Этот файл необходимо найти и передать в качестве парамера ключа `-bios`. Как и в случае использования VirtualBox, рекомендую использовать EFI только для этой машины.

    Ключ `-vga vmware` может быть полезен в случае проблем с видеодрайверами.
    
    Ключ `-nic none` поможет отключить сетевой адаптер.
    
    Для справки: https://wiki.archlinux.org/title/QEMU

Когда появится окно установки Windows с выбором языковых настроек, нажмите Shift+F10, чтобы открыть окно командной строки. Теперь необходимо последовательно выполнить следующие команды, дожидаясь их завершения:
```cmd
diskpart
list disk
sel disk 0
convert gpt
create part efi size=100
format fs=fat32 quick
assign letter s
create part primary
format fs=ntfs quick
assign letter c
exit
cd /d D:\sources
dism /get-wiminfo /wimfile:install.wim
dism /apply-image /imagefile:install.wim /index:1 /applydir:C:\
bcdboot C:\Windows /s S:
regedit
```
После запуска редактора реестра, нужно выбрать ветку `HKEY_LOCAL_MACHINE` и загрузить в неё кусты `SYSTEM` и `SOFTWARE` из `C:\Windows\System32\config` под именами `SYS` и `SOFT` соответственно.

В ветке `HKEY_LOCAL_MACHINE\SOFT\Microsoft\Windows\CurrentVersion\Policies\System` поменяйте значение параметра `EnableCursorSuppression` на `0`. Затем создайте новый параметр DWORD (32 bit) с названием `VerboseStatus` и установите его значение в `1`.

{{< figure src="/images/ssw_lab1_2.png" alt="Ветка реестра ...\System" >}}

В ветке `HKEY_LOCAL_MACHINE\SYS\Setup` поменяйте параметр `CmdLine` на `cmd.exe`

{{< figure src="/images/ssw_lab1_3.png" alt="Ветка реестра ...\Setup" >}}

После этого выполните команду `wpeutil reboot` и пропустите загрузку с CD/DVD. Когда появится окно командной строки, выполните команду `oobe\windeploy` и дождитесь надписи о подготовке. Теперь выполните следующие команды, заменив в них <ИмяПользователя> на нужное имя:
```cmd
net user /add <ИмяПользователя>
net localgroup /add пользователи <ИмяПользователя>
net localgroup /add администраторы <ИмяПользователя>
regedit
```
В редакторе реестра откройте ветку `HKEY_LOCAL_MACHINE\SYSTEM\Setup` и установите в ней параметры `OOBEInProgress`, `SetupType` и `SystemSetupInProgress` в `0`.

{{< figure src="/images/ssw_lab1_4.png" alt="Ветка реестра ...\Setup" >}}

Выйдите из командной строки. Через некоторое время система перезагрузится. Нужно будет дождаться завершения установки. На последнем этапе останется выбрать параметры конфиденциальности и система будет готова к работе.

После завершения установки сожмите системный раздел примерно вдвое, чтобы на диске было свободное место для установки Debian.

<p align="center">
  <img src="./1_img_5.png" alt="Рис. 5. Подготовка диска для установки Debian">
</p>
<p align="center">
Рис. 5. Подготовка диска для установки Debian
</p>

> **Примечание:** Не удаляйте эту машину без необходимости, она может понадобиться для следующих лабораторных работ. Если работаете в VirtualBox - для удобства установите на неё VirtualBox Guest Additions.


### Установка Debian

Debian нужно установить на эту же виртуальную машину, чтобы в конце иметь возможность выбора загружаемой ОС. Не забудьте включить сетевой адаптер машины перед установкой Debian.

Тут можно скачать установочный iso образ Debian https://cdimage.debian.org/debian-cd/current/amd64/iso-dvd/

Инструкции по установке находятся здесь https://www.debian.org/releases/stable/installmanual

### 2. Установка Arch

Создайте для Arch новую виртуальную машину.

Установочный iso образ Arch найдёте на этой странице https://www.archlinux.org/download/

Инструкции по установке находятся здесь https://wiki.archlinux.org/index.php/Installation_guide_(%D0%A0%D1%83%D1%81%D1%81%D0%BA%D0%B8%D0%B9)

> **Примечание:** Не используйте `archinstall` или подобные скрипты автоматизации.


### 3. Установка Gentoo

Создайте для Gentoo новую виртуальную машину.

Установочный iso образ Gentoo найдёте на этой странице https://www.gentoo.org/downloads/

Для того, чтобы собрать и установить Gentoo, вооружитесь Gentoo Handbook https://wiki.gentoo.org/wiki/Handbook:AMD64/ru и запритесь в комнате со своим компьютером на пару дней.


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
