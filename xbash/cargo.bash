
xb_cargo_check() {
  # Пока так.
  if [ -e "./Cargo.toml" ]; then
    return 0;
  else
    return 255;
  fi;
}

xb_cargo_commands() {
  xb_subcommands[bench]='cargo bench';
  xb_subcommands[build]='cargo build';
  xb_subcommands[check]='cargo check';
  xb_subcommands[clean]='cargo clean';
  xb_subcommands[config]='cargo config';
  xb_subcommands[doc]='cargo doc';
  xb_subcommands[c-fetch]='cargo fetch';  # А вот тут конфликт разрешаем в пользу Git — там это более употребимая команда.
  xb_subcommands[fix]='cargo fix';
  xb_subcommands[generate-lockfile]='cargo generate-lockfile';
  xb_subcommands[locate-project]='cargo locate-project';
  xb_subcommands[metadata]='cargo metadata';
  xb_subcommands[owner]='cargo owner';
  xb_subcommands[package]='cargo package';
  xb_subcommands[pkgid]='cargo pkgid';
  xb_subcommands[publish]='cargo publish';
  xb_subcommands[read-manifest]='cargo read-manifest';
  xb_subcommands[report]='cargo report';
  xb_subcommands[run]='cargo run';
  xb_subcommands[rustc]='cargo rustc';
  xb_subcommands[rustdoc]='cargo rustdoc';
  xb_subcommands[search]='cargo search';
  xb_subcommands[c-test]='cargo test';
  xb_subcommands[tests]='cargo test';
  xb_subcommands[c-tree]='cargo tree';
  xb_subcommands[update]='cargo update';
  xb_subcommands[vendor]='cargo vendor';
  xb_subcommands[verify-project]='cargo verify-project';
  xb_subcommands[version]='cargo version';
  xb_subcommands[yank]='cargo yank';
  xb_subcommands[clippy]='cargo clippy';
  xb_subcommands[fmt]='cargo fmt';
}

xb_cargo_prompt() {
  xb_prompt_icons+=( '\[\033[00;33m\][cargo]' );
}

xb_checks[cargo]=xb_cargo_check;
xb_commands[cargo]=xb_cargo_commands;
xb_prompts[cargo]=xb_cargo_prompt;
