{ config, pkgs, lib, ... }:

let
  user = "dtzitzon";
  shared-programs = import ../shared/home-manager.nix { inherit config pkgs lib; };
  shared-files = import ../shared/files.nix { inherit config pkgs; };
in
{
  home = {
    username = "${user}";
    homeDirectory = "/home/${user}";
    packages = pkgs.callPackage ./packages.nix {};
    file = shared-files // import ./files.nix { inherit user pkgs; };
    stateVersion = "24.05";
  };

  programs = shared-programs;
}
