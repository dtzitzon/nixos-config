{ pkgs }:

with pkgs;
let shared-packages = import ../shared/packages.nix { inherit pkgs; }; in
shared-packages ++ [
  # App and package management
  gnumake
  cmake
  home-manager

  # Testing and development tools
  direnv
]
