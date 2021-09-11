# xbash

bash-extensions for prompt and subcommands

## Version

**0.1.1-alpha** — developent only.

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
- [?] Автодополнение (completion) — под вопросом.
