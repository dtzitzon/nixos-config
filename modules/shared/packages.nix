{ pkgs, ... }:

with pkgs; [
  # General packages for development and system management
  act
  aspell
  aspellDicts.en
  bash-completion
  bat
  btop
  cargo
  clang
  coreutils
  cmake
  cachix
  difftastic
  direnv
  nix-direnv
  nixpkgs-fmt
  nil
  nodejs_18
  du-dust
  git-filter-repo
  killall
  neofetch
  openssh
  pandoc
  rustc
  sqlite
  wget
  yarn
  zip

  # Encryption and security tools
  age
  age-plugin-yubikey
  gnupg
  libfido2

  # Cloud-related tools and SDKs
  # docker
  # docker-compose
  # awscli2 - marked broken Mar 22
  awscli2
  flyctl
  google-cloud-sdk
  go
  gopls
  ssm-session-manager-plugin
  terraform
  terraform-ls
  tflint

  # Text and terminal utilities
  htop
  hunspell
  iftop
  jetbrains-mono
  jetbrains.phpstorm
  jq
  ripgrep
  tree
  tmux
  unrar
  unzip
  zsh-powerlevel10k
]
