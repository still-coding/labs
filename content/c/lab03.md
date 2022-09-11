---
title: "C. Лабораторная работа №3"
summary: Циклические алгоритмы
description: Циклические алгоритмы
draft: false
math: true
weight: 3
robotsNoIndex: true
---

### Задания для самостоятельного выполнения

1. Написать программу, используя оператор цикла `while` (нечётные варианты) или `do while` (чётные варианты).
2. Написать программу, используя оператор цикла `for`.
3. Составить блок-схемы.


### Требования и ограничения

Программа должна выводить на экран таблицу вида:
```text
   x          f(x)
--------------------
0.000000    0.123456
0.100000    1.234567
0.200000    2.345678
...
1.000000    3.456789
```
Шаг \\( h \\) изменения аргумента \\( x \\) необходимо ввести с клавиатуры.


### Варианты заданий

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
