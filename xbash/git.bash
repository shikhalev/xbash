xb_git_check() {
  # Пока упрощенная версия
  if [ -d ./.git ]; then
    return 0;
  else
    return 255;
  fi;
}

xb_git_commands() {
  xb_subcommands[status]='git status';
}

xb_checks[git]=xb_git_check;
xb_commands[git]=xb_git_commands;
