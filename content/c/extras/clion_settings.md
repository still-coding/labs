---
title: "C. Настройка оформления кода в CLion"
summary: Как в лекциях
# description: 123
draft: false
math: false
weight: 4
robotsNoIndex: true
showToc: false
---

1. Открыть окно Settings (`File - Settings`, или нажать `Ctrl+Alt+S`), далее выбрать `Editor > Code Style > C/C++`. Открыть вкладку `Wrapping and Braces`.
2. В разделе `Braces placement` выставить всё в `Next Line`.
3. В разделе `'if()' statement` поставить галочку `'else' on new line` и снять галочку `Special 'else if' treatment`.
4. В разделе `'while()' statement` выставить `Force braces` в `When multiline`.
5. В разделе `'do ... while()' statement` выставить `Force braces` в `When multiline` и поставить галочку `'while' on new line`.
6. Нажать кнопку `Apply` и `OK`.

{{< figure src="/images/c_clion_settings.png" alt="Окно настроек CLion" >}}

Готово, приятного программирования!
