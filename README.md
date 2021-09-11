# xbash

Расширение оболочки bash для удобства разработки.

-----

При разработке в Linux зачастую активно используется командная строка, причем значительную часть команд
составляют субкоманды системы управления версиями, такой как `git`, и системы сборки и управления
зависимостями, например `cargo` (для языка Rust), или `gem` (для Ruby).

Это расширение позволяет делать следующее:

* Использовать субкоманды напрямую, т.е. писать `commit` вместо `git commit` и `run` вместо `cargo run`.

  При этом такая подстановка активна, только когда мы находимся внутри каталога проекта. И, соответственно,
  не для всех возможных систем управления версиями и сборки, а для тех, которые задействованы в текущем
  проекте.

* В приглашении командной строки отображать кратко некоторые элементы состояния проекта и репозитория.

## Version

**0.1.2-alpha** — developent only.

## Установка и использование (пререлизной версии)

1. Сохранить куда-то каталог с исходниками (склонировать репозиторий, скачать и распаковать релиз — непринципиально).
   Куда поместить, тоже непринципиально, пусть это будет, скажем — `$HOME/scripts/xbash/`.

2. Добавить загрузку в `$HOME/.bashrc`:

   ```bash
   source $HOME/scripts/xbash/xbash.bash
   ```
3. Создать конфигурационный файл `$HOME/.config/xbash` с одной строчкой:

   ```bash
   xb_user_dir=$HOME/scripts/xbash/xbash
   ```

4. Войти в shell, например, открыв заново любимый эмулятор терминала.

## TODO

### До версии 0.1-alpha

- [x] Сформировать список команд `git` и отладить.
- [x] Сделать prompt для `git`.
- [x] Сделать функцию `xb_info()`.
- [x] Сделать определение репозитория, даже когда мы глубоко внутри.

### До версии 0.9-beta

- [ ] Аналогично предыдущему для
  - [x] `cargo`,
  - [ ] `jekyll`,
  - [ ] `hg`,
  - [ ] `bundle`,
  - [ ] `gem`.
- [ ] Доработать `xb_info()` до визуальной ясности.
- [ ] Сделать инсталлятор (вероятнее всего — через `make install`).
- [ ] Языки и цветовые схемы.
- [ ] Написать полноценное README:
  - [ ] Для чего нужно,
  - [x] Установка,
  - [ ] Коротко о настройке.

### До релиза 1.0

- [ ] Отладить.
- [ ] Документировать.
- [ ] Подумать об опакечивании (под вопросом).
- [ ] Автодополнение (completion) — под вопросом.
