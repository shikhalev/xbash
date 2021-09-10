
xb_project_root='.';

xb_local_checks() {
  xb_project_root=${PWD};
  if [ ! -z ${xb_checks[git]} ]; then
    if ${xb_checks[git]}; then
      xb_project_root=${xb_git_repo};
    fi;
  fi;
  if [ -d "$xb_project_root/bin" ]; then
    return 0;
  else
    return 255;
  fi;
}

xb_local_commands() {
  local bins=$(find "${xb_project_root}/bin" -executable -type f);
  if [ ! -z "$bins" ]; then
    for bin in $bins; do
      xb_subcommands[$(basename $bin)]=$bin;
    done;
  fi;
}

xb_checks[local]=xb_local_checks;
xb_commands[local]=xb_local_commands;
