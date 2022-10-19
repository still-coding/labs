---
title: "NASM. Практика №2"
summary: Вещественная арифметика
description: Вещественная арифметика
draft: false
math: true
weight: 1
robotsNoIndex: true
showToc: true
---

### Вещественная арифметика

Вычислим следующие выражения: \\(y = x \sqrt{1 + x^2} + \arcsin x, z = e^{2y} \\). Для начала на C, чтобы иметь возможность проверить себя, или быстро получать промежуточные результаты:

```c
// c_math.c
#include <stdio.h>
#include <math.h>
int main()
{
    double x = 0.99, y = x * sqrt(1.0 + x * x) + asin(x);
    printf("y = %lf\nz = %lf\n", y, exp(2.0 * y));
}
```

Собираем, запускаем:

```bash
$ gcc c_math.c -lm -o c_math && ./c_math
y = 2.822346
z = 282.786168
```

А теперь то же самое на ассемблере с использованием FPU стека. Нужно разобраться что делают команды и почему, иначе будет тяжеловато.

```nasm
; fpu_prog.asm
%define     SYS_EXIT 60

section     .data
    format_y:
        db  "y = %lf", 10, 0
    format_z:
        db  "z = %lf", 10, 0
    x       dq  0.99
    two     dq  2.0

section     .bss
    res     resq 1

global      main
extern      printf

section     .text
main:
    finit
    fld     qword [x]
    fld     qword [x]
    fld     qword [x]
    fmul
    fst     qword [res]
    fld1
    fsubrp
    fsqrt
    fpatan
    fld     qword [res]
    fld1
    fadd
    fsqrt
    fld     qword [x]
    fmul
    fadd
    ; y вычислен
    fst     qword [res]

    mov     rdi, format_y
    movq    xmm0, [res]
    mov     rax, 1
    sub     rsp, 8
    call    printf
    add     rsp, 8

    fld     qword [two]
    fmul
    ; e ^ x = 2 ^ (x * log2(e))
    fldl2e
    fmul
    fld     st0
    frndint
    fxch    st1
    fsub    st0, st1
    f2xm1
    fld1
    faddp
    fscale
    fstp    qword [res]
    fstp    st0
    ; код дублируется, надо что-то с этим сделать
    mov     rdi, format_z
    movq    xmm0, [res]
    mov     rax, 1
    sub     rsp, 8
    call    printf
    add     rsp, 8

    xor     rdi, rdi
    mov     rax, SYS_EXIT
    syscall
```
Собираем тем же мейкфайлом:

```bash
$ make F=fpu_prog C=1
---> running fpu_prog
y = 2.822346
z = 282.786168
```

Результаты расчётов совпадают!
{{< figure src="/images/surprised.png" alt="Как же так вышло?!" >}}

### Функцию для подключения к C коду

Теперь подружим ассемблер с C - напишем код, который вычисляет то же самое, но полученный объектный файл будет содержать функцию, пригоднуя для вызова из C.

Сишный бойлерплейт:
```c
// run_fpu_func.c
#include <stdio.h>
double calc_y(double);
double calc_z(double);

int main()
{
    double x = 0.99, y = calc_y(x), z = calc_z(y);
    printf("y = %lf\nz = %lf\n", y, z);
}
```

И ассемблерные функции для него:
```nasm
; fpu_func.asm
section     .bss
    res     resq 1
    x       resq 1

section     .data
    two     dq  2.0

global      calc_y
global      calc_z

section     .text
calc_y:
    movsd   [x], xmm0
    finit
    fld     qword [x]
    fld     qword [x]
    fld     qword [x]
    fmul
    fst     qword [res]
    fld1
    fsubrp
    fsqrt
    fpatan
    fld     qword [res]
    fld1
    fadd
    fsqrt
    fld     qword [x]
    fmul
    fadd
    fstp    qword [res]
    movsd   xmm0, [res]
    ret

calc_z:
    movsd   [x], xmm0
    finit
    fld     qword [x]
    fld     qword [two]
    fmul
    fldl2e
    fmul
    fld     st0
    frndint
    fxch    st1
    fsub    st0, st1
    f2xm1
    fld1
    faddp
    fscale
    fstp    qword [res]
    fstp    st0
    movsd   xmm0, [res]
    ret
```

Модифицируем наш мейкфайл, чтобы он мог сразу собирать и подключать ассемблерный объектный файл к программе на C:

```makefile
...
endif
# новый кусочек
ifeq ($(shell test -e ./$(C).c && echo -n yes),yes)
BUILD_EXEC += $(C).c
endif
...
```

Он будет проверять наличие файла, указанного в параметре `C`, и если он есть - компилировать его тоже. Если нужно собрать ассемблерный код, использующий Glibc, но не запускаемый из C - используем значение параметра с несуществующим файлом (т.е. старый вариант `C=1` подойдёт, если у вас нет файла 1.c). Собираем:

```bash
$ make F=fpu_func C=run_fpu_func
nasm -f elf64 fpu_func.asm -g -F stabs
gcc -no-pie run_fpu_func.c fpu_func.o -o fpu_func
---> running fpu_func
y = 2.822346
z = 282.786168
```

### Ассемблерные вставки

Следующий способ - это inline assembly или ассемблерные вставки. По умолчанию gcc использует GAS и AT&T синтаксис, но есть возможность приблизиться к привычному нам в NASM Intel синтаксису.

```c
#include <stdio.h>
// inline_assembly.c
int main()
{
    double x = 0.99, y, z = 2.0;
    asm(
        ".intel_syntax noprefix;"
        "finit;"
        "fld %2;"
        "fld %2;"
        "fld %2;"
        "fmulp;"
        "fst %0;"
        "fld1;"
        "fsubrp;"
        "fsqrt;"
        "fpatan;"
        "fld %0;"
        "fld1;"
        "faddp;"
        "fsqrt;"
        "fld %2;"
        "fmulp;"
        "faddp;"
        "fst %0;"
        "fld %1;"
        "fmulp;"
        "fldl2e;"
        "fmulp;"
        "fld st(0);"
        "frndint;"
        "fxch st(1);"
        "fsub st(0), st(1);"
        "f2xm1;"
        "fld1;"
        "faddp;"
        "fscale;"
        "fstp %1;"
        "fstp st(0);"
        : "=m"(y), "=m"(z)
        : "m"(x)
    );
    printf("y = %lf\nz = %lf\n", y, z);
}
```

Собираем, запускаем:

```bash
$ gcc inline_assembly.c -masm=intel -o inline_assembly && ./inline_assembly
y = 2.822346
z = 282.786168
```

### Задание

1. Напишите свой вариант [ЛР №2 по C]({{< relref "../c/lab02/#%d0%b2%d0%b0%d1%80%d0%b8%d0%b0%d0%bd%d1%82%d1%8b-%d0%b7%d0%b0%d0%b4%d0%b0%d0%bd%d0%b8%d0%b9" >}}) на ассемблере в виде отдельного исполняемого файла.
2. Сделайте функции для подключения к коду на C.
3. Напишите вариант с ассемблерными вставками, завернув их в отдельные функции.
4. Перепишите п.3 с использованием AT&T синтаксиса (сборка без ключа `-masm=intel`).
