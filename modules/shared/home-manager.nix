{ config, pkgs, lib, ... }:

let
  name = "Demitri Tzitzon";
  user = "dtzitzon";
  email = "dtzitzon@anduril.com";
in
{
  zsh = {
    enable = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;
    defaultKeymap = "viins";
    oh-my-zsh = {
      enable = true;
      plugins = [ "git" ];
    };
    plugins = [
      {
        name = "powerlevel10k";
        src = pkgs.zsh-powerlevel10k;
        file = "share/zsh-powerlevel10k/powerlevel10k.zsh-theme";
      }
      {
        name = "powerlevel10k-config";
        src = lib.cleanSource ./config;
        file = "p10k.zsh";
      }
    ];
    initExtraFirst = ''
      # Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
      # Initialization code that may require console input (password prompts, [y/n]
      # confirmations, etc.) must go above this block; everything else may go below.
      if [[ -r "''${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-''${(%):-%n}.zsh" ]]; then
        source "''${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-''${(%):-%n}.zsh"
      fi

      if [[ -f /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh ]]; then
        . /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh
        . /nix/var/nix/profiles/default/etc/profile.d/nix.sh
      fi

      # Remove history data we don't want to see
      export HISTIGNORE="pwd:ls:cd"

      # Vim settings
      export EDITOR="vim"

      # Use difftastic, syntax-aware diffing
      alias diff=difft

      export GOPATH="$HOME/go"
      export PATH="$GOPATH/bin:$PATH"

      # Anduril setup
      export GOPRIVATE=ghe.anduril.dev
      export NIX_PATH=nixpkgs=/Users/dtzitzon/sources/anix
      if [ -e /Users/dtzitzon/.nix-profile/etc/profile.d/nix.sh ]; then . /Users/dtzitzon/.nix-profile/etc/profile.d/nix.sh; fi # added by Nix installer

      # Always color ls and group directories
      alias ls='ls --color=auto'

      alias pbcopy='xclip -selection clipboard'
      alias pbpaste='xclip -selection clipboard -o'
      alias bashconfig="vim ~/.bashrc"
      alias cdg="cd ~/go/src/ghe.anduril.dev/anduril"
      alias cda="cd ~/sources/anix"
      alias grbm="git fetch origin master && grb -i origin/master"
      alias gcopy="git rev-parse HEAD | pbcopy"
      alias clion="clion . &>/dev/null &"
      alias goland="goland . &>/dev/null &"
    '';
  };

  git = {
    enable = true;
    ignores = [ "*.swp" ];
    userName = name;
    userEmail = email;
    lfs = {
      enable = true;
    };
    extraConfig = {
      core = {
        editor = "vim";
      };
    };
  };

  vim = {
    enable = true;
    plugins = with pkgs.vimPlugins; [ vim-airline vim-airline-themes copilot-vim vim-startify vim-tmux-navigator ];
    settings = { ignorecase = true; };
    extraConfig = ''
      "" General
      set number
      set history=1000
      set nocompatible
      set modelines=0
      set encoding=utf-8
      set scrolloff=3
      set showmode
      set showcmd
      set hidden
      set wildmenu
      set wildmode=list:longest
      set cursorline
      set ttyfast
      set nowrap
      set ruler
      set backspace=indent,eol,start
      set laststatus=2
      set clipboard=autoselect

      " Dir stuff
      set nobackup
      set nowritebackup
      set noswapfile
      set backupdir=~/.config/vim/backups
      set directory=~/.config/vim/swap

      " Relative line numbers for easy movement
      set relativenumber
      set rnu

      "" Whitespace rules
      set tabstop=8
      set shiftwidth=2
      set softtabstop=2
      set expandtab

      "" Searching
      set incsearch
      set gdefault

      "" Statusbar
      set nocompatible " Disable vi-compatibility
      set laststatus=2 " Always show the statusline
      let g:airline_theme='bubblegum'
      let g:airline_powerline_fonts = 1

      "" Local keys and such
      let mapleader=","
      let maplocalleader=" "

      "" Change cursor on mode
      :autocmd InsertEnter * set cul
      :autocmd InsertLeave * set nocul

      "" File-type highlighting and configuration
      syntax on
      filetype on
      filetype plugin on
      filetype indent on

      "" Paste from clipboard
      nnoremap <Leader>, "+gP

      "" Copy from clipboard
      xnoremap <Leader>. "+y

      "" Move cursor by display lines when wrapping
      nnoremap j gj
      nnoremap k gk

      "" Map leader-q to quit out of window
      nnoremap <leader>q :q<cr>

      "" Move around split
      nnoremap <C-h> <C-w>h
      nnoremap <C-j> <C-w>j
      nnoremap <C-k> <C-w>k
      nnoremap <C-l> <C-w>l

      "" Easier to yank entire line
      nnoremap Y y$

      "" Move buffers
      nnoremap <tab> :bnext<cr>
      nnoremap <S-tab> :bprev<cr>

      "" Like a boss, sudo AFTER opening the file to write
      cmap w!! w !sudo tee % >/dev/null

      let g:startify_lists = [
        \ { 'type': 'dir',       'header': ['   Current Directory '. getcwd()] },
        \ { 'type': 'sessions',  'header': ['   Sessions']       },
        \ { 'type': 'bookmarks', 'header': ['   Bookmarks']      }
        \ ]

      let g:startify_bookmarks = [
        \ '~/.local/share/src',
        \ ]

      let g:airline_theme='bubblegum'
      let g:airline_powerline_fonts = 1
    '';
  };

  vscode = {
    enable = true;
    extensions = with pkgs.vscode-extensions; [
      arrterian.nix-env-selector
      bbenoist.nix
      dracula-theme.theme-dracula
      eamodio.gitlens
      golang.go
      jnoortheen.nix-ide
      llvm-vs-code-extensions.vscode-clangd
      mkhl.direnv
      ms-vscode.cmake-tools
      ms-vscode-remote.remote-ssh
      vscodevim.vim
      yzhang.markdown-all-in-one
      zxh404.vscode-proto3
    ];
    userSettings = {
      "editor.autoClosingBrackets" = "never";
      "editor.autoClosingQuotes" = "never";
      "editor.formatOnSave" = true;
      "editor.dragAndDrop" = false;
      "editor.minimap.enabled" = false;
      "editor.scrollBeyondLastLine" = false;
      "editor.tabSize" = 2;

      "explorer.confirmDelete" = false;
      "explorer.confirmDragAndDrop" = false;

      "files.insertFinalNewline" = true;
      "files.trimTrailingWhitespace" = true;
      "files.autoSave" = "onFocusChange";

      "gitlens.currentLine.enabled" = false;
      "gitlens.hovers.currentLine.over" = "line";
      "gitlens.codeLens.scopes" = [ "document" ];
      "github-enterprise.uri" = "https://ghe.anduril.dev/";

      "go.toolsManagement.autoUpdate" = true;
      "go.coverOnTestPackage" = false;
      "go.autocompleteUnimportedPackages" = true;

      "keyboard.dispatch" = "keyCode";

      "nix.enableLanguageServer" = true;
      "nix.serverPath" = "nil";
      "nix.serverSettings" = {
        "nil" = {
          "diagnostics" = {
            "ignored" = [ "unused_binding" "unused_with" ];
          };
          "formatting" = {
            "command" = [ "nixpkgs-fmt" ];
          };
        };
      };
      "[nix]" = {
        "editor.formatOnSave" = false;
      };

      "[markdown]" = {
        "editor.formatOnSave" = false;
      };
      "[go]" = {
        "editor.suggest.insertMode" = "insert";
      };
      "[python]" = {
        "editor.defaultFormatter" = "ms-python.black-formatter";
        "editor.formatOnType" = true;
      };
      "security.workspace.trust.untrustedFiles" = "open";
      "window.zoomLevel" = 1;
      "workbench.editor.revealIfOpen" = true;
      "cmake.configureOnOpen" = true;
      "redhat.telemetry.enabled" = false;
    };
    keybindings = [
      {
        key = "cmd+]";
        command = "workbench.action.navigateRight";
      }
      {
        key = "cmd+[";
        command = "workbench.action.navigateLeft";
      }
      {
        key = "shift+cmd+-";
        command = "workbench.action.zoomOut";
      }
      {
        key = "shift+cmd+-";
        command = "-workbench.action.zoomOut";
      }
      {
        key = "cmd+-";
        command = "workbench.action.navigateBack";
      }
      {
        key = "ctrl+-";
        command = "-workbench.action.navigateBack";
      }
      {
        key = "cmd+=";
        command = "workbench.action.navigateForward";
      }
      {
        key = "ctrl+shift+-";
        command = "-workbench.action.navigateForward";
      }
      {
        key = "cmd+-";
        command = "-workbench.action.zoomOut";
      }
      {
        key = "shift+cmd+=";
        command = "workbench.action.zoomIn";
      }
      {
        key = "cmd+=";
        command = "-workbench.action.zoomIn";
      }
      {
        key = "shift+cmd+right";
        command = "workbench.action.moveEditorToNextGroup";
      }
      {
        key = "ctrl+cmd+right";
        command = "-workbench.action.moveEditorToNextGroup";
      }
      {
        key = "shift+cmd+left";
        command = "workbench.action.moveEditorToPreviousGroup";
      }
      {
        key = "ctrl+cmd+left";
        command = "-workbench.action.moveEditorToPreviousGroup";
      }
    ];
  };
}
