# Есть опасность, что после переопределений разных данный файл
# будет загружен сам из себя, что приведет к бесконечной рекурсии.
if [ -z ${xb_flag+anything} ]; then
  xb_flag=loaded;
# Можно было бы проверять реально используемую переменную...
# Но это чревато при дальнейших изменениях.

# Включать для отладки
# set -x;

# Номер версии — для info
xb_version='0.1.2-alpha';

# Предустановленные сообщения.
xb_command_not_found_msg='Command not found: %s\n';

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

# Подготавливаем ассоциативные массивы для быстрого выяснения disable.
unset xb_disabled_commands;
declare -a xb_disabled_commands;
xb_disabled_commands+=( ${xb_disable[*]} );
xb_disabled_commands+=( ${xb_disable_commands[*]});
unset xb_disabled_commands_hash;
declare -A xb_disabled_commands_hash;
for key in ${xb_disabled_commands[*]}; do
  xb_disabled_commands_hash[$key]='true';
done;
unset xb_disabled_prompts;
declare -a xb_disabled_prompts;
xb_disabled_prompts+=( ${xb_disable[*]} );
xb_disabled_prompts+=( ${xb_disable_prompts[*]} )
unset xb_disabled_prompts_hash;
declare -A xb_disabled_prompts_hash;
for key in ${xb_disabled_prompts[*]}; do
  xb_disabled_prompts_hash[$key]='true';
done;

# Подставляем субкоманды.
command_not_found_handle() {
  unset xb_subcommands;
  declare -g -A xb_subcommands;
  for key in ${!xb_commands[*]}; do
    if [ ! -z "${xb_disabled_commands_hash[$key]}" ]; then
      continue;
    fi;
    if ${xb_checks[$key]}; then
      ${xb_commands[$key]};
    fi;
    # По итогу мы должны получить таблицу субкоманд актуальных и не запрещенных.
  done;
  local subcmd=$1;
  if [ ! -z "${xb_subcommands[$subcmd]}" ]; then
    shift;
    ${xb_subcommands[$subcmd]} "$@";
    return $?;
  fi;
  printf "$xb_command_not_found_msg" $1;
  return $xb_command_not_found_num;
}

# TODO: разобраться с цветами — вынести в константы и вообще единообразить.

xb_prompt_color_name='\[\033[01;32m\]';
xb_prompt_color_path='\[\033[01;34m\]';
xb_prompt_color_error='\[\033[01;31m\]';
xb_prompt_color_reset='\[\033[00m\]';

xb_prompt_icons=( );                        # Очень коротко: иконки ПО, возможно с версиями.               # Цвета внутри.
xb_prompt_name='\u@\h';                     # Идентификатор пользователя/хоста/терминала.                  # Цвет конфигурируется.
xb_prompt_path='\w';                        # Репозиторий/проект/путь.                                     # Цвет конфигурируется.
xb_prompt_statuses=( );                     # Статусы. Коротко.                                            # Цвета внутри.
xb_prompt_marker=$xb_prompt_color_path'\$'; # Финальный маркер, желательно не переопределять лишний раз.   # Цвета внутри.

xb_prompt_color() {
  if [ $? -eq 0 ]; then
    echo -e '\e[01;34m';
  else
    echo -e '\e[01;31m';
  fi;
}

xb_prompt() {
  # Сбрасываем элементы.
  xb_prompt_icons=( );
  xb_prompt_name='\u@\h';
  xb_prompt_path='\w';
  xb_prompt_statuses=( );
  xb_prompt_marker='$(xb_prompt_color)\$';

  # Формируем элементы.
  for key in ${!xb_prompts[@]}; do
    if [ ! -z "${xb_disabled_prompts_hash[$key]}" ]; then
      continue;
    fi;
    if ${xb_checks[$key]}; then
      ${xb_prompts[$key]};
    fi;
  done;

  # Собираем строку.
  local prompt='';
  if (( ${#xb_prompt_icons[@]} )); then
    for icon in "${xb_prompt_icons[@]}"; do
      if [ ! -z "${icon}" ]; then
        prompt+="${icon}${xb_prompt_color_reset} ";
      fi;
    done;
  fi;
  if [ ! -z "${xb_prompt_name}" ]; then
    prompt+="${xb_prompt_color_name}${xb_prompt_name}${xb_prompt_color_reset} ";
  fi;
  if [ ! -z "${xb_prompt_path}" ]; then
    prompt+="${xb_prompt_color_path}${xb_prompt_path}${xb_prompt_color_reset} ";
  fi;
  if (( ${#xb_prompt_statuses[@]} )); then
    for status in "${xb_prompt_statuses[@]}"; do
      if [ ! -z "${status}" ]; then
        prompt+="${status}${xb_prompt_color_reset} ";
      fi;
    done;
  fi;
  if [ ! -z "${xb_prompt_marker}" ]; then
    prompt+="${xb_prompt_marker}${xb_prompt_color_reset} "
  fi;
  export PS1="$prompt";
}

if [ -z "${PROMPT_COMMAND}" ]; then
  PROMPT_COMMAND="xb_prompt"
elif [[ ! "$PROMPT_COMMAND" =~ "xb_prompt" ]]; then
  PROMPT_COMMAND="${PROMPT_COMMAND};xb_prompt"
fi;

xb_info() {
  # TODO: раскрасить
  echo "xbash v${xb_version}";
  local global='';
  if [ "$1" == 'version' ]; then
    return;
  elif [ "$1" == 'global' ]; then
    global='true';
  fi;
  for key in ${!xb_checks[@]}; do
    if [ -z "$global" ]; then
      if [ ! -z "${xb_disabled_prompts_hash[$key]}" ]; then
        continue;
      fi;
      if ${xb_checks[$key]}; then
        echo '' > /dev/null;
      else
        continue;
      fi;
    fi;
    echo "[${key}]";
    if [ -z "${xb_prompts[$key]}" ]; then
      echo "prompt: no";
    else
      echo "prompt: yes";
    fi;
    if [ -z "${xb_commands[$key]}" ]; then
      echo "commands: no";
    else
      echo "commands:";
      unset xb_subcommands;
      declare -g -A xb_subcommands;
      ${xb_commands[$key]};
      if (( ${#xb_subcommands[@]} > 0 )); then
        for sub in ${!xb_subcommands[@]}; do
          echo "  ${sub} => ${xb_subcommands[$sub]}";
        done;
      else
        echo '<empty>';
      fi;
    fi;
  done;
}

# См. верх файла.
# Сбрасываем флаг мы тут затем, чтобы разрешить повторную загрузку данного файла,
# оставив запрет только на рекурсивную.
  unset xb_flag;
fi;

# set +x;
