{ pkgs, lib, ... }:
{
  nix.settings = {
    trusted-users = [
      "root"
      "dtzitzon"
    ];
  };
}

