---
title: "СПО ПМ. Лабораторная работа №1"
summary: Работа в эмуляторе терминала
description: Работа в эмуляторе терминала
draft: false
math: false
weight: 1
robotsNoIndex: true
showToc: false
---

### Задания для самостоятельного выполнения

1. С помощью команды `man man` узнайте, как пользоваться справкой `man`.
2. Изучите справку по команде `date` . Выведите дату на экран в различных форматах.
3. Изучите справку по командам `cd`, `ls`, `cp`, `mv`, `mkdir`, `touch`, `cat`, `ln`.
4. Покажите содержимое текущего каталога. Создайте каталог в домашнем каталоге пользователя. Перейдите в него. Создайте абсолютную символическую ссылку на каталог `/etc` и относительную ссылку на каталог `/tmp`. Создайте любой файл. Выведите на экран список файлов с правами доступа к ним. Поменяйте права доступа к созданному вами файлу.
5. Выведите на экран информацию о процессоре системы из файла `/proc/cpuinfo`. Перенаправьте ту же информацию в текстовый файл. Запустите файловый менеджер Midnight Commander.
6. Откройте созданный текстовый файл во встроенном текстовом редакторе Midnight Commander. Изучите справку редактора Midnight Commander и запомните горячие клавиши для работы с блоками текста. Продемонстрируйте преподавателю редактирование текста, включающее пометку блоков текста; их копирование, перемещение и удаление; вставку текстового блока из другого файла.
7. То же самое для `nano`.
8. Выведите на экран содержимое системной переменной `PATH`. Напишите файл-сценарий (скрипт) shell, выводящий на экран содержимое системной переменной USER_VAR_2021 . Модифицируйте его так, чтобы при его запуске происходило архивирование каталога, хранящегося в указанной переменной, в формате .tar.bz2.
9. Создайте файл-сценарий (скрипт) shell, использующий три команды из списка команд для работы с сетью: `ifconfig`, `ip`, `nslookup`, `traceroute`, `netstat`, `host`, `dig`, `ping`, `ifup`, `ifdown`, `iptables`. Использование выбранных команд изучайте с помощью справочной системы.