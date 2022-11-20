---
title: "СПО ПМ. Лабораторная работа №4"
summary: Создание кроссплатформенного приложения
description: Создание кроссплатформенного приложения
draft: false
math: false
weight: 40
robotsNoIndex: true
showToc: true
TocOpen: true
---

### Задания для самостоятельного выполнения

Написать программу-обёртку для базы данных SQLite. Программа должна обладать следующими функциями:
1. Отображение данных таблиц и запросов
2. Редактирование данных
3. Добавление данных
4. Удаление данных

Программы должны компилироваться на Linux и Windows **без изменения исходного кода**. В данной работе вам придётся устанавливать и настраивать большое количество инструментов разработки, поэтому, чтобы не забивать свою основную систему, можете использовать виртуальные машины.


### Варианты заданий

**1. Преподаватели кафедр**

{{< svg "static/images/python_lab14_1.svg" >}}


**2. Животные**

{{< svg "static/images/python_lab14_2.svg" >}}


**3. Дети и врачи**

{{< svg "static/images/python_lab14_3.svg" >}}


**4. Товары**

{{< svg "static/images/python_lab14_4.svg" >}}


**5. Контент авторов**

{{< svg "static/images/python_lab14_5.svg" >}}


**6. Сотрудники организаций**

{{< svg "static/images/python_lab14_6.svg" >}}


**7. Преподаватели и дисциплины**

{{< svg "static/images/python_lab14_7.svg" >}}


**8. Расписание**

{{< svg "static/images/python_lab14_8.svg" >}}


**9. Кафедры и дисциплины**

{{< svg "static/images/python_lab14_9.svg" >}}


**10. Адреса**

{{< svg "static/images/python_lab14_10.svg" >}}


**11. Автомобили и владельцы**

{{< svg "static/images/python_lab14_11.svg" >}}


**12. Книги**

{{< svg "static/images/python_lab14_12.svg" >}}


### Пример

#### База данных

Создадим и заполним простую базу данных.

{{< figure src="/images/ssw_pm_lab04_db.png" alt="Example DB" >}}

Для этого установите пакет `sqlite3`, в терминале наберите `sqlite3 mydb.db` и выполните следующие запросы:

```sql
CREATE TABLE shops (shop_id INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT NOT NULL);
```
```sql
INSERT INTO shops (name) VALUES ("PNS"),("Второй");
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

#### Gtk+3. Сборка в Linux

Необходимые файлы [находятся тут](/ssw_pm/lab04_gtk.zip). Установите необходимые пакеты.

##### Необходимые пакеты

###### Debian-based

* libsqlite3-dev
* gcc
* make
* libgtk-3-0
* libgtk-3-dev
* glade

###### Arch-based

* pkg-config
* gcc
* make
* gtk3
* glade

Проанализируйте исходный код и прилагающийся makefile, это поможет в написании собственного варианта.
Скомпилируйте программу командой `make`. Примерно так будет выглядеть получившееся приложение:

{{< figure src="/images/ssw_pm_lab04_example.png" alt="Программа с GTK+3 в Linux" >}}

>GUI для этой программы разрабатывался с помощью Glade. Откройте файл lab04.glade и проанализируйте структуру интерфейса.
Чтобы освоить разработку в Glade, вам пригодится cтатья на хабре https://habr.com/ru/post/116268/.
Для разработки с Gtk+ могут быть полезными:
>1. GTK API Reference https://developer.gnome.org/
>2. Дополнительная литература в папке books

#### Gtk+3. Сборка в Windows


1. Скачайте, установите и обновите MSYS2, следуя инструкциям на сайте https://www.msys2.org/
2. В консоли MSYS2 установите необходимые для сборки пакеты:
```bash
pacman -S mingw-w64-x86_64-gtk3 mingw-w64-x86_64-toolchain base-devel sqlite3 libsqlite3-devel
```
3. После установки закройте консоль MSYS2 MSYS и откройте MSYS2 MinGW x64. Нужно удостовериться, что в переменной окружения PKG_CONFIG_PATH есть пути `/mingw64/lib/pkgconfig` и `/mingw64/share/pkgconfig`:
```bash
echo $PKG_CONFIG_PATH
```
4. Создайте каталог для своего проекта и перейдите в него:
```bash
mkdir ~/lab04
cd ~/lab04
```
Для Windows этот каталог имеет путь `C:\msys64\home\%USERNAME%\lab04`, если вы следовали инструкции в п.1.

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
7. Наконец-то можно собрать программу командой `make` и запустить её. Чтобы удостовериться, что программа запускается и работает в Windows правильно, её следует запустить просто даблкликом lab04.exe, т.е. не из консоли MSYS2 - это нужно для того, чтобы программа не видела переменные окружения и настройки MSYS, как будто мы запускаем приложение в роли обычного пользователя. Если всё прошло успешно, программа запустится.

> **Примечание:** Конечно, на данном этапе папка с программой занимает ~130 Мб, но для простоты мы скопировали в неё все иконки и dll файлы, хотя конечно же, она использует только некоторые из них. Вы можете самостоятельно подобрать минимально необходимый набор файлов для поставки вашей программы.
