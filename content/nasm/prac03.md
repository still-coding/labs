---
title: "NASM. Практика №3"
summary: SIMD инструкции
description: SIMD инструкции
draft: false
math: true
weight: 30
robotsNoIndex: true
showToc: true
---

### Пример

Дан файл [`vector.bin`](/nasm/vector.bin), содержащий 8 чисел двойной точности. Посмотрим внимательно:

```
$ od -tx1f8 -w8 --endian=little vector.bin
0000000  57 ba 67 e4 bf 2d f3 bf
              -1.198669330795061
0000010  fe 60 e6 18 53 47 c2 3f
             0.14280165401283534
0000020  32 d9 9b bb 10 57 e0 3f
              0.5106280960306206
0000030  2c ca 53 82 93 2a c4 bf
            -0.15754932273519395
0000040  9f ba 46 c4 8d 3a f0 bf
              -1.014295355514754
0000050  c9 90 f5 b7 0a 23 f3 bf
              -1.196055143919738
0000060  e5 d3 cd 56 e0 29 e0 bf
              -0.505111856021014
0000070  6b 49 c0 de 63 0d dc 3f
              0.4383172679237279
```

Вычислим длину вектора: \\( |\vec{v}| = \sqrt{\sum_{i=1}^n v_i^2 } \\) с использованием AVX и SSE инструкций:

```nasm
; simd.asm
%define     SYS_READ    0
%define     SYS_OPEN    2
%define     SYS_CLOSE   3
%define     SYS_EXIT    60
%define     O_RDONLY    0

section     .data
    vec_outp:
        db  "v[%lu] = % lf", 10, 0
    res_outp:
        db  "|v| = %lf", 10, 0
    path:
        db  "./vector.dat", 0
    byte_size:
        db  8

global      main
extern      printf

section     .text
main:
    mov     rax, SYS_OPEN
    mov     rdi, path
    mov     rsi, O_RDONLY
    syscall

    push    rax
    sub     rsp, 64

read_buffer:
    mov     rax, SYS_READ
    mov     rdi, [rsp + 64]
    mov     rsi, rsp
    mov     rdx, 64
    syscall

close:
    mov     rax, SYS_CLOSE
    mov     rdi, [rsp + 64]
    syscall

    xor r15, r15
    xor rdx, rdx

print:
    mov rax, r15
    div byte [byte_size]

    mov     rdi, vec_outp
    mov     rsi, rax
    mov     rax, 1
    movq    xmm0, [rsp + r15]
    call    printf
    add     r15, 8
    cmp     r15, 64
    jne     print

calc:
    vzeroall
    vmovupd ymm0, [rsp]
    vmovupd ymm1, [rsp + 32]

    vmulpd  ymm0, ymm0, ymm0
    vmulpd  ymm1, ymm1, ymm1
    vhaddpd ymm0, ymm1, ymm0
    vxorpd  ymm1, ymm1
    vmovapd xmm1, xmm0
    vextractf128 xmm0, ymm0, 1
    vaddpd  xmm0, xmm1, xmm0
    pxor    xmm1, xmm1
    haddpd  xmm0, xmm0
    sqrtsd  xmm0, xmm0

    mov     rdi, res_outp
    mov     rax, 1
    call    printf

exit:
    xor     rdi, rdi
    mov     rax, SYS_EXIT
    syscall
```

Собираем и запускаем тем же мейкфайлом:

```bash
$ make F=simd C=1
nasm -f elf64 simd.asm -F dwarf
gcc -no-pie -g simd.o -o simd
---> running simd
v[0] = -1.198669
v[1] =  0.142802
v[2] =  0.510628
v[3] = -0.157549
v[4] = -1.014295
v[5] = -1.196055
v[6] = -0.505112
v[7] =  0.438317
|v| = 2.156239
```

Работает всё это примерно так:
{{< svg "static/images/nasm_prac3_1.svg" >}}

Смотреть что и как нужно [тут](https://www.officedaytime.com/simd512e/) и, конечно же, [тут](https://www.felixcloutier.com/x86/). И, самой собой, [тут](https://github.com/eteran/edb-debugger) (обязательно соберите себе edb или установите другой отладчик, поддерживающий x64 архитектуру):

{{< figure src="/images/nasm_prac3.png" alt="edb" >}}


### Задание

Вам дан файл, содержащий матрицу \\( A_{8 \times 8} \\). Вычислить \\( N(A) \\) с использованием векторных инструкций.

### Варианты заданий

1. [Файл](/nasm/m01.bin). \\( N(A) = \max\limits_j \sum_{i=1}^{n} |a_{ij}| \\).

2. [Файл](/nasm/m02.bin). \\( N(A) = \sqrt{ \max\limits_i \ |a_{ii}| } \\).

3. [Файл](/nasm/m03.bin). \\( N(A) = \sqrt{ \sum_{i=1}^n \sum_{j=1}^m a_{ij}^2 } \\).

4. [Файл](/nasm/m04.bin). \\( N(A) = \max\limits_i \sum_{j=1}^{m} a_{ij} \\).

5. [Файл](/nasm/m05.bin). \\( N(A) = \sqrt{nm} \max\limits_{i,j} a_{ij} \\).

6. [Файл](/nasm/m06.bin). \\( N(A) = \sum_{i=1}^n \sum_{j=1}^m \frac{1}{a_{ij}} \\).

7. [Файл](/nasm/m07.bin). \\( N(A) = \sqrt{ \sum_{i=1}^n \sum_{j=1}^m [a_{ij}]^2 } \\).

8. [Файл](/nasm/m08.bin). \\( N(A) = \frac{ \min\limits_{ij} |a_{ij}| + 1 }{ \max\limits_{ij} |a_{ij}| + 1 } - 1 \\).

9. [Файл](/nasm/m09.bin). \\( N(A) = \sqrt{ \min\limits_{ij} |a_{ij}| } \\).

10. [Файл](/nasm/m10.bin). \\( N(A) = \sqrt{ \sum_{i=1}^n |a_{ii}| + |a_{i, n-i}| } \\).

11. [Файл](/nasm/m11.bin).\\( N(A) = \frac{ \sqrt{ \sum_{i=1}^n |a_{i1}| + |a_{im}| +  \sum_{j=2}^{m-1} |a_{1j}| + |a_{nj}| } }{n + m} \\).

12. [Файл](/nasm/m12.bin). \\( N(A) = \frac{1}{nm} \sum_{i=1}^n \sum_{j=1}^m [a_{ij}] \\).
