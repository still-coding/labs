---
title: "NASM. Практика №1"
summary: Целочисленная арфиметика и условия
description: Целочисленная арфиметика и условия
draft: false
math: false
weight: 1
robotsNoIndex: true
showToc: true
---

### Подготовка 

Для сборки программ нужно установить NASM, а также GCC, если его почему-то нет из коробки в вашем дистрибутиве Linux.

Я приготовил вам стильный-модный-молодёжный универсальный makefile с переменными и выводом возврата программы:

```makefile
EXEC = $(F)
SRC = $(F).asm
OBJ = $(F).o
BUILD_EXEC = ld
ifdef C
BUILD_EXEC = gcc -no-pie
endif


all: $(EXEC)
	@echo "---> running $(EXEC)"
	@./$(EXEC) || echo "---> $(EXEC) exit code: $$?"

$(EXEC): $(OBJ)
	$(BUILD_EXEC) $? -o $@

$(OBJ): $(SRC)
	nasm -f elf64 $?
	
clean:
	rm -f $(EXEC) $(OBJ)
```
Он позволяет собирать произвольные `.asm` файлы двумя способами. Для начала соберём `hello.asm`:

```nasm
section     .data
    message:    db "Hello, World!", 10
    message_len equ $-message

section     .text
global      _start
_start:
    mov     rax, 1
    mov     rdi, 1
    mov     rsi, message
    mov     rdx, message_len
    syscall
    mov     rax, 60
    xor     rdi, rdi
    syscall
```
Это можно сделать так:
```bash
make F=hello
```
Поскольку переменная F в мейкфайле не объявлена, её нужно передавать как параметр make и после знака равенства указывать имя файла без расширения.

А теперь более читаемый вариант:
```nasm
%define     SYS_WRITE 1
%define     STDOUT 1
%define     SYS_EXIT 60

section     .data
    message:    db "Hello, World!", 10
    message_len equ $-message

section     .text
global      _start
_start:
    mov     rax, SYS_WRITE
    mov     rdi, STDOUT
    mov     rsi, message
    mov     rdx, message_len
    ; syscall(SYS_WRITE, STDOUT, message, message_len)
    syscall
    mov     rax, SYS_EXIT
    xor     rdi, rdi
    ; syscall(SYS_EXIT, exit_code)
    syscall
```

### Простые вычисления

Изучите арифметические инструкции из этого примера:

```nasm
%define     SYS_EXIT 60

section     .text

global  _start
_start:
    mov     rbx, 5
    add     rbx, 3
    mov     rax, 2
    sub     rbx, rax
    imul    rbx, 2
   ; Попробуйте выполнить эти операции вместо предыдущей
    ; imul    rbx, rax, 17
    ; mul     rbx
   
    mov     rdx, 0
    mov     rax, 1000
    idiv    rbx
    mov     rdi, rax
    mov     rax, SYS_EXIT
    syscall
```

Результат вычислений возвращается в ОС и будет выведен при запуске собранной программы мейкфайлом:
```
$ make F=calc
nasm -f elf64 calc.asm
ld calc.o -o calc
---> running calc
---> calc exit code: 83
```

Но поскольку код возврата не может быть больше 255, серьёзным этот подход не назовёшь. Используем Glibc:

```nasm
%define     SYS_EXIT 60

global      main
extern      printf

section     .data
format:
        db  "%ld", 10, 0
        
section     .text
main:
    mov     rbx, 5
    add     rbx, 3
    mov     rax, 2
    sub     rbx, rax
    imul    rbx, 2
    mov     rdx, 0
    mov     rax, 1000
    idiv    rbx
    
    mov     rdi, format
    mov     rsi, rax
    xor     rax, rax
    sub     rsp, 8
    call    printf
    add     rsp, 8
    
    xor     rdi, rdi
    mov     rax, SYS_EXIT
    syscall
```

Собрать можно например так:
```bash
make F=calc2 C=1
```
Makefile проверяет только наличие переменной `C`, поэтому в неё можно подавать любое значение.

### Ветвление

Посмотрим как можно сделать простое ветвление:

```nasm
%define     SYS_EXIT 60
%define     SYS_WRITE 1
%define     STDOUT 1

section     .data
    msg_equal:    db "rbx is 42", 10
    msg_equal_len equ $-msg_equal

    msg_unequal:    db "rbx is not 42", 10
    msg_unequal_len equ $-msg_unequal

section     .text

global  _start
_start:
    mov     rbx, 42
    cmp     rbx, 42
    jne     unequal

    mov     rax, SYS_WRITE
    mov     rdi, STDOUT
    mov     rsi, msg_equal
    mov     rdx, msg_equal_len
    syscall
    jmp     done

unequal:
    mov     rax, SYS_WRITE
    mov     rdi, STDOUT
    mov     rsi, msg_unequal
    mov     rdx, msg_unequal_len
    syscall

done:
    xor     rdi, rdi
    mov     rax, SYS_EXIT
    syscall
```

### Задание

Теперь вы можете объединить полученные знания и написать на ассемблере свой вариант [ЛР №1 по C]({{< relref "../c/lab01/#%d0%b2%d0%b0%d1%80%d0%b8%d0%b0%d0%bd%d1%82%d1%8b-%d0%b7%d0%b0%d0%b4%d0%b0%d0%bd%d0%b8%d0%b9" >}}). Используйте  перевёрнутые частные из условий задач и целочисленное деление. Также необходимо организовать ввод параметров с использованием `scanf`.
