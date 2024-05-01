{ user, config, pkgs, ... }:

let
  xdg_configHome = "${config.users.users.${user}.home}/.config";
  xdg_dataHome   = "${config.users.users.${user}.home}/.local/share";
  xdg_stateHome  = "${config.users.users.${user}.home}/.local/state"; in
{
  # Script to import Drafts into Emacs org-roam
  # "${xdg_dataHome}/bin/import-drafts" = {
  #   executable = true;
  #   text = ''
  #     #!/bin/sh

  #     for f in ${xdg_stateHome}/drafts/*
  #     do
  #       if [[ ! "$f" =~ "done" ]]; then
  #         echo "Importing $f"
  #         filename="$(head -c 10 $f)"
  #         output="${xdg_dataHome}/org-roam/daily/$filename.org"
  #         echo '\n' >> "$output"
  #         tail -n +3 $f >> "$output"
  #         mv $f done
  #       fi
  #     done
  #   '';
  # };
}
