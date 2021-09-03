xb_git_repo='';

xb_git_check() {
  xb_git_repo="$(git rev-parse --show-toplevel 2> /dev/null)";
  if [ -z "${xb_git_repo}" ]; then
    return 255;
  else
    return 0;
  fi;
}

xb_git_commands() {
  xb_subcommands[status]='git status';
}

xb_git_propmpts() {
  xb_prompt_icons+=( '\[\033[01;36m\][git]' );
  xb_prompt_name="$(git config --get user.email 2> /dev/null)";
  if [ -z "$xb_prompt_name" ]; then
    xb_prompt_name="\[\033[01;33m\]unknown!";
  fi;
  local repo_name=$(basename "${xb_git_repo}");
  local subdir=$(git rev-parse --show-prefix 2> /dev/null);
  xb_prompt_path="\[\033[01;37m\]${repo_name} ${xb_prompt_color_reset}@ \[\033[01;36m\]$(git branch --show-current 2> /dev/null)";
  if [ ! -z "${subdir}" ]; then
    xb_prompt_path+=" ${xb_prompt_color_path}${subdir}"
  fi;
  local changed="$(git status --porceline 2> /dev/null)";
  local status_file=$(mktemp);
  git status -b --porcelain > $status_file 2> /dev/null;
  if [ ! -z "$(cat $status_file | grep '^??')" ]; then
    xb_prompt_statuses+=( '\[\033[01;31m\]*' );
  elif (( $(cat $status_file | wc -l) > 1 )); then
    xb_prompt_statuses+=( '\[\033[01;33m\]*' );
  elif [ ! -z "$(cat $status_file | grep '^##' | grep -o '\[.*\]$')" ]; then
    xb_prompt_statuses+=( '\[\033[01;32m\]*' );
  fi;
  rm $status_file;
}

xb_checks[git]=xb_git_check;
xb_commands[git]=xb_git_commands;
xb_prompts[git]=xb_git_propmpts;
