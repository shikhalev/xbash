
xb_cargo_check() {
  # Пока так.
  if [ -e "./Cargo.toml" ]; then
    return 0;
  else
    return 255;
  fi;
}

xb_checks[cargo]=xb_cargo_check;
