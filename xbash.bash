# Есть опасность, что после переопределений разных данный файл
# будет загружен сам из себя, что приведет к бесконечной рекурсии.
if [ -z ${xb_flag+anything} ]; then
  xb_flag=loaded;
# Можно было бы проверять реально используемую переменную...
# Но это чревато при дальнейших изменениях.

# Предустановленные сообщения.
xb_command_not_found_msg='Команда не найдена: %s\n';

# Возыращаемое значение, когда команда не найдена.
xb_command_not_found_num=255;

# Задаем предустановки по умолчанию
xb_vendor_dir=/usr/share/xbash;
xb_system_dir=/etc/xbash.d;
xb_user_dir=$HOME/.local/xbash;
xb_project_file=./.xbash.bash;
xb_system_config=/etc/xbash;
xb_user_config=$HOME/.config/xbash;

# Инициализация основных переменных.
# unset нужен для возможности повторной загрузки данного файла.

unset xb_disable;
declare -a xb_disable;
unset xb_disable_prompt;
declare -a xb_disable_prompt;
unset xb_disable_commands;
declare -a xb_disable_commands;
unset xb_disable_completion;
declare -a xb_disable_completion;

unset xb_checks;
declare -A xb_checks;
unset xb_prompts;
declare -A xb_prompts;
unset xb_commands;
declare -A xb_commands;
unset xb_completions;
declare -A xb_completions;

# Считываем заданные конфигурацией установки:
#   1. системные
#   2. пользовательские
# В итоге могут быть изменены пути поиска функциональных файлов,
# а системные установки могут также поменять путь к файлу пользовательских.
# Также именно здесь должны располагаться добавления в disable-списки.
if [ -f $xb_system_config ]; then
  source $xb_system_config;
fi;
if [ -f $xb_user_config ]; then
  source $xb_user_config;
fi;

# Загружаем функционал.
# Крайне нежелательно в этих файлах как-либо изменять поведение в других,
# менять пути или disable-списки.
if [ -d $xb_vendor_dir ]; then
  xb_vendor=$(find $xb_vendor_dir -name '*.bash');
fi;
if [ -d $xb_system_dir ]; then
  xb_system=$(find $xb_system_dir -name '*.bash');
fi;
if [ -d $xb_user_dir ]; then
  xb_user=$(find $xb_user_dir -name '*.bash');
fi;
if [ ! -z "$xb_vendor" ]; then
  for src in $xb_vendor; do
    source "$src";
  done;
fi;
if [ ! -z "$xb_system" ]; then
  for src in $xb_system; do
    source "$src";
  done;
fi;
if [ ! -z "$xb_user" ]; then
  for src in $xb_user; do
    source "$src";
  done;
fi;

# Подготавливаем ассоциативный массив для быстрого выяснения disable.
unset xb_disabled_commands;
declare -a xb_disabled_commands;
xb_disabled_commands+=( ${xb_disable[*]} );
xb_disabled_commands+=( ${xb_disable_commands[*]});
unset xb_disabled_commands_hash;
declare -A xb_disabled_commands_hash;
for key in ${xb_disabled_commands[*]}; do
  xb_disabled_commands_hash[$key]='true';
done;

# Подставляем субкоманды.
command_not_found_handle() {
  unset xb_subcommands;
  declare -g -A xb_subcommands;
  for key in ${!xb_commands[*]}; do
    echo ${xb_disabled_commands_hash[$key]};
    if [ ${xb_disabled_commands_hash[$key]} = 'true' ]; then
      continue;
    fi;
    if ${xb_checks[$key]}; then
      ${xb_commands[$key]};
    fi;
    # По итогу мы должны получить таблицу субкоманд актуальных и не запрещенных.
  done;
  local subcmd=$1;
  if [ -n "${xb_subcommands[$subcmd]}" ]; then
    shift;
    ${xb_subcommands[$subcmd]} $@;
    return $?;
  fi;
  printf "$xb_command_not_found_msg" $1;
  return $xb_command_not_found_num;
}

echo ${BASH_SOURCE[*]};

# См. верх файла.
# Сбрасываем флаг мы тут затем, чтобы разрешить повторную загрузку данного файла,
# оставив запрет только на рекурсивную.
  unset xb_flag;
fi;
