---
title: "СПО. Лабораторная работа №4"
summary: Разработка кроссплатформенных приложений
description: Разработка кроссплатформенных приложений
draft: false
math: false
weight: 40
robotsNoIndex: true
showToc: true
TocOpen: true
---

### Задание

Написать программу-обёртку для базы данных SQLite. Программа должна обладать следующими функциями:
1. Отображение данных таблиц и запросов
2. Редактирование данных
3. Добавление данных
4. Удаление данных

Необходимо создать два варианта программы: с использованием GTK+ и Qt.

Программы должны компилироваться на Linux и Windows **без изменения исходного кода**. В данной работе вам придётся устанавливать и настраивать большое количество инструментов разработки, поэтому рекомендую использовать виртуальные машины, чтобы не забивать свою основную систему.


### Варианты БД

1. **Книги**

{{< svg "static/images/python_lab14_12.svg" >}}

2. **Преподаватели кафедр**

{{< svg "static/images/python_lab14_1.svg" >}}

3. **Животные**

{{< svg "static/images/python_lab14_2.svg" >}}

4. **Дети и врачи**

{{< svg "static/images/python_lab14_3.svg" >}}

5. **Товары**

{{< svg "static/images/python_lab14_4.svg" >}}

6. **Контент авторов**

{{< svg "static/images/python_lab14_5.svg" >}}

7. **Сотрудники фирм**

{{< svg "static/images/python_lab14_6.svg" >}}

8. **Преподаватели и дисциплины**

{{< svg "static/images/python_lab14_7.svg" >}}

9. **Расписание**

{{< svg "static/images/python_lab14_8.svg" >}}

10. **Кафедры и дисциплины**

{{< svg "static/images/python_lab14_9.svg" >}}

11. **Адреса**

{{< svg "static/images/python_lab14_10.svg" >}}

12. **Автомобили и владельцы**

{{< svg "static/images/python_lab14_11.svg" >}}



### Пример

#### База данных

Создадим и заполним простую базу данных:

{{< svg "static/images/ssw_lab04_db.svg" >}}
<br>

Для этого установите sqlite3, в терминале наберите `sqlite3 mydb.db` и выполните следующие запросы:

```sql
CREATE TABLE shops (shop_id INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT NOT NULL);
```
```sql
INSERT INTO shops (name) VALUES ("PNS"), ("Второй");
```
```sql
SELECT * FROM shops;
```
```sql
CREATE TABLE components (
    component_id   INTEGER PRIMARY KEY AUTOINCREMENT,
    name TEXT NOT NULL,
    price REAL NOT NULL,
    shop_id INTEGER NOT NULL,
    FOREIGN KEY (shop_id)
       REFERENCES shops (shop_id)
       ON UPDATE CASCADE
       ON DELETE CASCADE
);
```
```sql
INSERT INTO components (name, price, shop_id)
VALUES ("AMD Ryzen 7 3700X", 25000, 1),
       ("Nvidia RTX 2060 Super", 30000, 2),
       ("Intel Core i7 9700KF", 30000, 2),
       ("AMD RX 5700 XT", 38000, 1);
```
```sql
SELECT
    components.component_id,
    components.name,
    price,
    shops.shop_id,
    shops.name
FROM
    components
INNER JOIN shops ON components.shop_id = shops.shop_id;
```

Теперь можно выйти из консольного интерфейса sqlite3 командой `.exit`.

#### GTK+3. Сборка в Linux

Файлы исходного кода находятся [тут](/ssw/lab04_gtk.zip). Установите необходимые пакеты.

##### Необходимые пакеты

###### Debian-based

* sqlite3
* libsqlite3-dev
* gcc
* make
* libgtk-3-0
* libgtk-3-dev
* glade

###### Arch-based

* sqlite
* pkg-config
* gcc
* make
* gtk3
* glade

Проанализируйте исходный код и прилагающийся `makefile`, это поможет в написании собственного варианта.
Скомпилируйте программу командой `make`. Примерно так будет выглядеть получившееся приложение:

{{< figure src="/images/ssw_lab04_gtk_linux.png" alt="Программа с GTK+3 в Linux" >}}

> GUI для этой программы разрабатывался с помощью Glade. Откройте файл `lab04.glade` и проанализируйте структуру интерфейса. Чтобы освоить разработку в Glade, вам пригодится:
> * [cтатья на хабре](https://habr.com/ru/post/116268/)

> Для разработки с GTK+ могут быть полезными:
> * [GTK Tutorials](https://developer.gnome.org/documentation/tutorials.html)
> * [Tim-Philipp Müller. GTK+ 2.0 Tree View Tutorial](/books/ssw/lab04/muller_treeview_tutorial.pdf)
> * [Andrew Krause. Foundations of GTK+ Development](/books/ssw/lab04/krause_foundations_of_GTK.pdf)


#### GTK+3. Сборка в Windows

1. Скачайте, установите и обновите MSYS2, следуя [инструкциям на сайте](https://www.msys2.org/).
2. В консоли MSYS2 установите необходимые для сборки пакеты:
```bash
pacman -Sy mingw-w64-x86_64-gtk3 mingw-w64-x86_64-toolchain base-devel sqlite3
```
3. После установки закройте консоль MSYS2 MSYS и откройте MSYS2 MINGW64. Нужно удостовериться, что в переменной окружения PKG_CONFIG_PATH есть пути `/mingw64/lib/pkgconfig` и `/mingw64/share/pkgconfig`:
```bash
echo $PKG_CONFIG_PATH
```
4. Создайте каталог для своего проекта и перейдите в него:
```bash
mkdir ~/lab04
cd ~/lab04
```
Для Windows этот каталог имеет путь `C:\msys64\home\%USERNAME%\lab04`, если вы следовали иснтрукции в п.1.

5. В созданный каталог положите файлы исходного кода, файл .glade, makefile и файл базы данных.

6. Cкопируйте в этот каталог ресурсы, нужные для работы собираемой программы:
```bash
cp /mingw64/bin/*dll .
mkdir -p ./lib/gdk-pixbuf-2.0
cp -r /mingw64/lib/gdk-pixbuf-2.0/* ./lib/gdk-pixbuf-2.0/
mkdir -p ./share/glib-2.0/schemas
cp -r /mingw64/share/glib-2.0/schemas/* ./share/glib-2.0/schemas
mkdir -p ./share/icons
cp -r /mingw64/share/icons/* ./share/icons
```
7. Наконец-то можно собрать программу командой `make` и запустить её. Чтобы удостовериться, что программа запускается и работает в Windows правильно, её следует запустить просто даблкликом `lab04.exe`, т.е. не из консоли MSYS2 - это нужно для того, чтобы программа не видела переменные окружения и настройки MSYS, как будто мы запускаем приложение в роли обычного пользователя. Если всё прошло успешно, вы увидите нечто подобное:

{{< figure src="/images/ssw_lab04_gtk_win.png" alt="Программа с GTK+3 в Windows" >}}

> **Примечание:** Конечно, на данном этапе папка с программой занимает ~130 Мб, но для простоты мы скопировали в неё все иконки и dll файлы, хотя конечно же, она использует только некоторые из них. Вы можете самостоятельно подобрать минимально необходимый набор файлов для поставки вашей программы.

#### Qt. Сборка в Linux

Скачайте и установите Qt с помощью онлайн-установщика `qt-unified-linux-x64-online.run` [отсюда](https://download.qt.io/official_releases/online_installers/). Для загрузки и установки понадобится VPN. Если у вас нет аккаунта Qt, его можно будет создать прямо в установщике, но скорее всего потребуется подтвердить email. Если установщик будет жаловаться на отсутствие свободного места для временных файлов, нужно увеличить размер tmpfs, выделенный для директории `/tmp`.

{{< figure src="/images/ssw_lab04_qt_linux_installation.png" alt="Установка Qt в Linux" >}}

Установите необходимые пакеты.

##### Необходимые пакеты

###### Debian-based

* sqlite3
* g++
* make
* libgl1-mesa-dev

###### Arch-based

* sqlite
* gсс
* make
* mesa

Исходники находятся [тут](/ssw/lab04_qt.zip). Откройте Qt Creator и добавьте проект. Нужно будет добавить комплект сборки для вашей системы, скорее всего это будет Desktop. В этом варианте программа написана уже на C++, что позволяет использовать объектно-ориентированный подход и готовые высокоуровневые компоненты.

Соберите проект. Перед запуском не забудьте добавить файл базы данных в папку `build...`, где появится исполняемый файл. Получится что-то такое:

{{< figure src="/images/ssw_lab04_qt_linux.png" alt="Программа с Qt в Linux" >}}

>Для разработки с Qt могут быть полезными:
> * Программа Qt Assistant для просмотра справочной информации
> * [Qt Documentation](https://doc.qt.io/)
> * [Уроки с примерами по Qt](https://evileg.com/ru/knowledge/qt/)


#### Qt. Сборка в Windows

В Windows также нужно установить Qt. Скачайте онлайн-установщик `qt-unified-windows-x86-online.exe` [отсюда](https://download.qt.io/official_releases/online_installers/). Удостоверьтесь, что вместе с устанавливаемой версией Qt будет установлен MinGW, иначе нельзя будет собрать проект.

После установки откройте Qt Creator, добавьте и настройте проект, и снова не забудьте про файл БД. Всё, можно запускать!

{{< figure src="/images/ssw_lab04_qt_win.png" alt="Программа с Qt в Windows" >}}

Слишком просто для Windows, правда? Действительно, если теперь попытаться запустить собранное приложение не из Qt Creator, а просто двойным щелчком по .exe файлу, то оно не заработает. Чтобы это исправить, откройте командную строку Qt для MinGW соответствующей разрядности из меню Пуск и выполните следующее:
```cmd
cd bin
windeployqt <путь>
```

Где вместо `<путь>` укажите папку с исполняемым файлом. Например, у меня эта команда выглядела так: `windeployqt C:\Users\ivan\Desktop\build-lab04-Desktop_Qt_6_4_2_MinGW_64_bit-Release\release`. Конечно, для этого лучше использовать релизную конфигурацию - это можно сделать, указав "Release" или "Выпуск" в Qt Creator по клику на значок монитора рядом с кнопкой запуска. `Windeployqt` поместит все необходимые для работы приложения файлы в указанную директорию, и его можно будет запускать отдельно.

Поздравляю, теперь вы можете разрабатывать кроссплатформенные десктопные приложения!
