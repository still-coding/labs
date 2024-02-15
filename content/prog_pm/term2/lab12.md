---
title: "Прог. Лабораторная работа №12"
summary: Модули и пакеты c GUI
description: Модули и пакеты c GUI
draft: false
math: false
weight: 120
robotsNoIndex: true
showToc: false
---

### Задания для самостоятельного выполнения

Сложность:
: *Rare*


По своему варианту задания и GUI фреймворка создайте **пакет, содержащий 3 модуля**, и подключите его к основной программе. Основная программа должна предоставлять:
* графический пользовательский интерфейс с возможностями ввода требуемых параметров и отображения результатов расчёта,
* возможность сохранить результаты в отчёт формата `.doc` или `.xls` (например, пакеты `python-docx` и `openpyxl`).

---

Сложность:
: *Medium*

* Реализуйте возможность быстрой смены GUI фреймворка. Продемонстрируйте миграцию с одного фреймворка на другой.

---

Сложность:
: *Well-done*

* Реализуйте логику вашего приложения в формате REST API эндпоинтов, сохранив для них GUI обёртку.



### Варианты GUI фреймворков

1. appJar
2. Tkinter
3. Kivy
4. wxPython
5. PySimpleGUI
6. Pyforms
7. Toga
8. PyGObject
9. guizero
10. guietta
11. PySide6
12. Dear PyGui


### Варианты заданий

1. Геометрические фигуры

    * Прямоугольник
    * Треугольник
    * Трапеция

    Расчёт площади, радусов описанной и вписанной окружности.

2. Помещения

    * Комната
    * Квартира
    * Многоэтажный дом

    Расчёт общей площади помещения, тепловой мощности для обогрева помещения.

3. Геометрические тела

    * Параллелепипед
    * Тетраэдр
    * Шар

    Расчёт объема, площади поверхности, массы в зависимости от материала.

4. Автомобили

    * Легковой
    * Грузовой
    * Пассажирский

    Расчёт расхода топлива в зависимости от загрузки, расчёт стоимости и времени поездки.

5. Банковские услуги

    * Кредит
    * Рассрочка
    * Вклад

    Расчёт процентов, графика платежей.

6. Элементарные частицы

    * Электрон
    * Нейтрон
    * Протон

    Расчёт удельного заряда, комптоновской длины волны.

7. Бытовая техника

    * Утюг
    * Телевизор
    * Стиральная машина

    Расчёт потребления электроэнергии и стоимости использования прибора за заданный период.

8. Рецепты

    * Вок
    * Бургер
    * Пицца

    Расчёт энергетической ценности и стоимости рецепта в зависимости от используемых ингридентов.

9. Отделочные материалы

    * Обои
    * Плитка
    * Ламинат

    Расчёт количества и стоимости для закупки материалов в зависимости от площади.

10. Одежда

    * Пиджак
    * Брюки
    * Костюм-тройка

    Расчёт расхода ткани в зависимости от размера, расчёт стоимости пошива, учитывая расход ткани и фурнитуры.

11. Почтовые отправления

    * Письмо
    * Бандероль
    * Посылка

    Расчёт цены в зависимости от расстояния, сроков, веса, объёма и типа доставки.

12. Устройства хранения данных

    * HDD
    * SSD
    * Flash

    Расчёт приблизительного времени чтения/записи заданного объёма данных, расчёт наиболее выгодного устройства по критерию цены за Гб.