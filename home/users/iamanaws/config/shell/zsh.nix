{
  programs.zsh = {
    enable = false;
    # completionInit = "autoload -Uz compinit";
    # defaultKeymap = "emacs";
    # dotDir = ".config/zsh";
    # history.expireDuplicatesFirst = true;
    # history.path = ".config/zsh/zsh_history";
    # history.save = 10000;
    # history.size = 10000;
  };
  # programs.zsh.initExtraBeforeCompInit = "
  #   zstyle ':completion:*' completer _list _complete _ignored _correct _approximate
  #   zstyle ':completion:*' list-colors ''
  #   zstyle ':completion:*' max-errors 4 numeric
  #   zstyle ':completion:*' menu select=2
  #   zstyle ':completion:*' select-prompt %SScrolling active: current selection at %p%s
  #   zstyle :compinstall filename '/home/iamanaws/.zshrc'
  # ";

  # programs.zsh.initExtra = "
  #   compinit
  #
  #   # End of lines configured by zsh-newuser-install
    
  #   PROMPT=$'\\n%F{#61AFEF}%~%f \\n$ '
    
  #   # Deny overwriting
  #   set -o noclobber
    
  #   fet.sh
  #   echo \"Hello zsh\"
  # ";
}