export NIXPKGS_ALLOW_UNFREE=1

alias ne='nix-env'
alias ni='nix-env -iA'
alias ns='nix-shell'
alias nq='nix-env -qa 2> /dev/null | fzf -m'
