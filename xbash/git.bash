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
  # Основные команды.
  # Проигнорированы clone и init, поскольку их почти нет смысла вызывать в git-контексте.
  xb_subcommands[add]='git add';
  xb_subcommands[am]='git am';
  xb_subcommands[archive]='git archive';
  xb_subcommands[bisect]='git bisect';
  xb_subcommands[branch]='git branch';
  xb_subcommands[checkout]='git checkout';
  xb_subcommands[cherry-pick]='git cherry-pick';
  xb_subcommands[g-clean]='git clean';              # Тут у нас конфликт с системами сборки, и приоритет отдается им.
  xb_subcommands[commit]='git commit';
  xb_subcommands[describe]='git describe';
  xb_subcommands[g-diff]='git diff';                # Конфликт со стандартным diff.
  xb_subcommands[fetch]='git fetch';
  xb_subcommands[format-patch]='git format-patch';
  xb_subcommands[g-gc]='git gc';                    # Конфликтует с GraphViz.
  xb_subcommands[gc]='git gc';                      # Но оставим для тех, у кого GraphViz не установлен.
  xb_subcommands[g-grep]='git grep';                # Понятно, с чем конфиликтует.
  xb_subcommands[log]='git log';
  xb_subcommands[maintenance]='git maintenance';
  xb_subcommands[merge]='git merge';
  xb_subcommands[g-mv]='git mv';
  xb_subcommands[notes]='git notes';
  xb_subcommands[pull]='git pull';
  xb_subcommands[push]='git push';
  xb_subcommands[range-diff]='git range-diff';
  xb_subcommands[rebase]='git rebase';
  xb_subcommands[g-reset]='git reset';
  xb_subcommands[restore]='git restore';
  xb_subcommands[revert]='git revert';
  xb_subcommands[g-rm]='git rm';
  xb_subcommands[shortlog]='git shortlog';
  xb_subcommands[show]='git show';
  xb_subcommands[sparse-checkout]='git sparse-checkout';
  xb_subcommands[stash]='git stash';
  xb_subcommands[submodule]='git submodule';
  xb_subcommands[status]='git status';
  xb_subcommands[switch]='git switch';
  xb_subcommands[tag]='git tag';
  xb_subcommands[worktree]='git worktree';

  # Вспомогательные команды
  xb_subcommands[g-annotate]='git annotate';          # Конфликтуем с чем-то графическим.
  xb_subcommands[annotate]='git annotate';
  xb_subcommands[blame]='git blame';
  xb_subcommands[bugreport]='git bugreport';
  xb_subcommands[config]='git config';
  xb_subcommands[count-objects]='git count-objects';
  xb_subcommands[difftool]='git difftool';
  xb_subcommands[fast-export]='git fast-export';
  xb_subcommands[fast-import]='git fast-import';
  xb_subcommands[filter-branch]='git filter-branch';
  xb_subcommands[g-fsck]='git fsck';
  xb_subcommands[mergetool]='git mergetool';
  xb_subcommands[merge-tree]='git merge-tree';
  xb_subcommands[pack-refs]='git pack-refs';
  xb_subcommands[g-prune]='git prune';                # Снова наш любимый GraphViz...
  xb_subcommands[prune]='git prune';
  xb_subcommands[reflog]='git reflog';
  xb_subcommands[remote]='git remote';
  xb_subcommands[repack]='git repack';
  xb_subcommands[rerere]='git rerere';
  xb_subcommands[g-replace]='git replace';
  xb_subcommands[show-branch]='git show-branch';
  xb_subcommands[verify-commit]='git verify-commit';
  xb_subcommands[verify-tag]='git verify-tag';
  xb_subcommands[whatchanged]='git whatchanged';
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
