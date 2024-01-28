---
title: "Прог. Лабораторная работа №2"
summary: Циклические алгоритмы
description: Циклические алгоритмы
draft: false
math: true
weight: 20
robotsNoIndex: true
showToc: false
---

### Задания для самостоятельного выполнения

Сложность:
: *Rare*

1. Напишите программу по варианту, используя оператор цикла `while` (нечётные варианты) или `do while` (чётные варианты).
2. Напишите программу, используя оператор цикла `for`.
3. Постройте график с использованием `gnuplot`.
4. Составьте блок-схемы.
5. Оформите отчёт в `README.md`. Отчёт должен содержать:
    * Задание
    * Описание проделанной работы
    * Скриншоты результатов
    * Блок-схемы
    * График функции
    * Ссылки на используемые материалы

---

Сложность:
: *Medium*  

1. Используйте `gnuplot` напрямую из вашей программы, минуя файлы и перенаправление вывода.
2. Реализуйте анимацию построения графика.
3. Сохраните анимированный график в формате `gif`.

---

Сложность:
: *Well-done*  

* Самостоятельно реализуйте построение графика с использованием любой графической библиотеки (sdl, raylib, opengl и т.д.)

### Требования и ограничения

Программа должна выводить на экран таблицу вида:
```text
0.000000    0.123456
0.100000    1.234567
0.200000    2.345678
...
1.000000    3.456789
```
Шаг \\( h \\) изменения аргумента \\( x \\) необходимо ввести с клавиатуры. Программа должна корректно выводить точки для любого положительного значения \\( h \\).


### Указания по выполнению работы

Для использования математических функций в программу необходимо включить заголовочный файл `<math.h>`, содержащий прототипы математических функций и макроопределения констант. Кроме того, при компиляции программы нужно указать ключ `-lm` для подключения соответствующей библиотеки.


| Математическая функция | Функция в C |
|     :-----------:      | :---------: |
| \\( \sin x \\)         |  `sin(x)`   |
| \\( \cos x \\)         |  `cos(x)`   |
| \\( \tg x \\)          |  `tan(x)`   |
| \\( \arcsin x \\)      |  `asin(x)`  |
| \\( \arccos x \\)      |  `acos(x)`  |
| \\( \arctg x \\)       |  `atan(x)`  |
| \\( \ln x \\)          |  `log(x)`   |
| \\( \lg x \\)          |  `log10(x)` |
| \\( \|x\| \\)          |  `fabs(x)`  |
| \\( \sqrt x \\)        |  `sqrt(x)`  |
| \\( x^y \\)            | `pow(x, y)` |
| \\( e^x \\)            |  `exp(x)`   |
| \\( \operatorname{sgn} x \\) | отсутствует |


### Работа с `gnuplot`

Когда вы уже написали программу, выводящую на экран таблицу, выполните следующее:

```shell
./prog > my_graph.txt
```
Здесь `prog` - это исполняемый файл вашей программы, `my_graph.txt` - файл, куда она будет осуществлять вывод вместо терминала.

Теперь создайте файл `plot.gpi` со следующим содержимым:
```shell
#!/usr/bin/env -S gnuplot -persist
# set terminal png enhanced
# set output "my_graph.png"
set xlabel "x" 
set ylabel "f(x)"
set grid
set title "График функции f(x)"
plot "my_graph.txt" with lines title "f(x)"
```

Выполните команду `chmod +x plot.gpi`. Теперь строить график можно с помощью команды:
```shell
./plot.gpi
```
Теперь можно сохранить файл с графиком вручную с помощью кнопки в появившемся окне, или автоматически - раскомментировав вторую и третью строку в скрипте.


### Для справки

1. [Статья "Gnuplot и с чем его едят" на Хабре](https://habr.com/ru/companies/ruvds/articles/517450/)
2. [Справка по синтаксису Latex](https://en.wikibooks.org/wiki/LaTeX/Mathematics)
3. [Writing mathematical expressions](https://docs.github.com/en/get-started/writing-on-github/working-with-advanced-formatting/writing-mathematical-expressions)


### Варианты заданий

Вывести таблицу значений и построить график функции с заданным шагом:

1. \\( f(x) = \begin{cases} \cos(x+x^3), & 0 \le x \le 1; \\\  e^{-x^2} - x^2 + 2x, & 1 \lt x \le 2.  \end{cases} \\)
2. \\( f(x) = \begin{cases} e^{\sin x}, & 0 \le x \le \frac{1}{4}; \\\  e^x - \frac{1}{\sqrt{x}}, & \frac{1}{4} \lt x \le \frac{1}{2}.  \end{cases} \\)
3. \\( f(x) = \begin{cases} \cos(x)e^{-x^2}, & 0 \le x \le 1; \\\  \ln(x+1) - \sqrt{4-x^2}, & 1 \lt x \le 2.  \end{cases} \\)
4. \\( f(x) = \begin{cases} \sqrt{x+1} - \sqrt{x} - \frac{1}{2}, & 0 \le x \le 1; \\\  e^{-x-\frac{1}{x}}, & 1 \lt x \le 2.  \end{cases} \\)
5. \\( f(x) = \begin{cases} 2^x - 2 + x^2, & 0 \le x \le 1.5; \\\  \sqrt{x}e^{-x^2}, & 1.5 \lt x \le 3.  \end{cases} \\)
6. \\( f(x) = \begin{cases} 8x^3 \cos x, & 0 \le x \le 1; \\\  \ln (1 + \sqrt{x}) - \cos x, & 1 \lt x \le 2.  \end{cases} \\)
7. \\( f(x) = \begin{cases} e^{-2\sin x}, & -1 \le x \le 1; \\\ x^2 - \ctg x, & 1 \lt x \le 2.  \end{cases} \\)
8. \\( f(x) = \begin{cases} \frac{1}{1+25x^2}, & 0 \le x \le 0,6; \\\  (x + 2x^4) \sin x^2, & 0.6 \lt x \le 1.6.  \end{cases} \\)
9. \\( f(x) = \begin{cases} (x^2 - 2x^3) \cos x^2, & -1.5 \le x \le 0; \\\ e^{\sin 2x}, & 0 \lt x \le 1.5.  \end{cases} \\)
10. \\( f(x) = \begin{cases} -\cos e^x, & 0 \le x \le 1; \\\ \ln (2x + \sin x^2), & 1 \lt x \le 2.  \end{cases} \\)
11. \\( f(x) = \begin{cases} x^2 \arctg x, & 0 \le x \le 1; \\\ \sin \frac{1}{x^2}, & 1 \lt x \le 2.  \end{cases} \\)
12. \\( f(x) = \begin{cases} x^2 \sin (\sqrt[3]{x} - 3), & -2 \le x \le 0; \\\ \sqrt{x} \cos 2x, & 0 \lt x \le 1.  \end{cases} \\)
