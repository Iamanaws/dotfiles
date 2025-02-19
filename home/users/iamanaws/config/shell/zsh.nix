{ ... }:

{
  programs.zsh = {
    enable = true;
    completionInit = "autoload -Uz compinit";
    defaultKeymap = "emacs";
    dotDir = ".config/zsh";
    history.expireDuplicatesFirst = true;
    history.path = "$ZDOTDIR/.zsh_history";
    history.save = 10000;
    history.size = 10000;

    shellAliases = {
      cxf2 = "nix develop github:Iamanaws/cxf2-devshell";
      cxf2-fresh = "nix develop github:Iamanaws/cxf2-devshell#fresh";
      cxf2-migrate = "nix develop github:Iamanaws/cxf2-devshell#migrate";
      cxf2-load = "nix develop github:Iamanaws/cxf2-devshell#load";
    };

    initExtraBeforeCompInit =
      "\n      zstyle ':completion:*' matcher-list '' 'm:{a-zA-Z}={A-Za-z}' 'r:|=*' 'l:|=* r:|=*'\n      zstyle ':completion:*' list-colors ''\n    ";
    # zstyle ':completion:*' completer _list _complete _ignored _correct _approximate
    # zstyle ':completion:*' max-errors 4 numeric
    # zstyle ':completion:*' menu select=2
    # zstyle ':completion:*' select-prompt %SScrolling active: current selection at %p%s

    initExtra =
      "\n      \n      # Directory trimming\n      PROMPT_DIRTRIM=2\n\n      EDITOR=\"vim\"\n      \n      # Deny overwriting\n      set -o noclobber\n      \n      fet.sh\n\n      function parse_git_branch() {\n        git branch 2> /dev/null | sed -n -e 's/^\\* \\(.*\\)/(\\1) /p'\n      }\n\n      COLOR_USR=$'%F{15}'   # User color set to white\n      COLOR_DIR=$'%F{12}'   # Directory color set to blue\n      COLOR_GIT=$'%F{135}'  # Git color set to purple\n      COLOR_DEF=$'%F{15}'   # Prompt color set to white\n      setopt PROMPT_SUBST\n      export PROMPT='%B\${COLOR_DIR}%2~ \${COLOR_GIT}$(parse_git_branch)%b'$'\\n''\${COLOR_DEF}$ '\n    ";

    profileExtra =
      "\n      eval \"$(/opt/homebrew/bin/brew shellenv)\"\n\n      # Added by Toolbox App\n      export PATH=\"$PATH:/Users/angel/Library/Application Support/JetBrains/Toolbox/scripts\"\n    ";
  };
}
