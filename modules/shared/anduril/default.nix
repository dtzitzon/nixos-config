{ pkgs, lib, ... }:
{
  nix.settings = {
    substituters = [
      "https://s3-us-west-2.amazonaws.com/anduril-nix-cache/"
      "https://s3-us-west-2.amazonaws.com/anduril-nix-polyrepo-cache"
    ];
    trusted-public-keys = [
      "anduril-nix-cache:0FYOuMqEzbSX2PmByfePpJAsSV6CW+1YWoq7b21NxHc="
      "anduril-nix-polyrepo-cache:0FYOuMqEzbSX2PmByfePpJAsSV6CW+1YWoq7b21NxHc="
    ];
  };
}

