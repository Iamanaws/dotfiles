{ ... }:

{
  programs.zsh = {
    enable = true;
    completionInit = "autoload -Uz compinit";
    defaultKeymap = "emacs";
    dotDir = "~/.config/zsh";
    history.expireDuplicatesFirst = true;
    history.path = "~/.config/zsh/zsh_history";
    history.save = 10000;
    history.size = 10000;
  };
  programs.zsh.initExtraBeforeCompInit = "
    zstyle ':completion:*' matcher-list '' 'm:{a-zA-Z}={A-Za-z}' 'r:|=*' 'l:|=* r:|=*'
    zstyle ':completion:*' completer _list _complete _ignored _correct _approximate
    zstyle ':completion:*' list-colors ''
  ";
    # zstyle ':completion:*' max-errors 4 numeric
    # zstyle ':completion:*' menu select=2
    # zstyle ':completion:*' select-prompt %SScrolling active: current selection at %p%s

  programs.zsh.initExtra = "
    
    # Directory trimming
    PROMPT_DIRTRIM=2

    EDITOR=\"vim\"
    
    # Deny overwriting
    set -o noclobber
    
    fet.sh
    echo \"Hello zsh\"

    function parse_git_branch() {
      git branch 2> /dev/null | sed -n -e 's/^\\* \\(.*\\)/(\\1) /p'
    }

    COLOR_USR=$'%F{15}'   # User color set to white
    COLOR_DIR=$'%F{12}'   # Directory color set to blue
    COLOR_GIT=$'%F{135}'  # Git color set to purple
    COLOR_DEF=$'%F{15}'   # Prompt color set to white
    setopt PROMPT_SUBST
    export PROMPT='%B\${COLOR_DIR}%2~ \${COLOR_GIT}$(parse_git_branch)%b'$'\\n''\${COLOR_DEF}$ '
  ";
}