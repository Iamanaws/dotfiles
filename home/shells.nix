{
  pkgs,
  ...
}: {

  programs.bash.enable = true;
  programs.bash.bashrcExtra = "
# If not running interactively, don't do anything
[[ $- != *i* ]] && return

parse_git_branch() {
    git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \\(.*\\)/ (\\1)/'
}

PS1='\\n\\[\\033[01;34m\\]\\w\\[\\033[1;35m\\]$(parse_git_branch)\\[\\033[00m\\]\\n\\$ '

PROMPT_DIRTRIM=2

# ignore upper and lowercase when TAB completion
bind \"set completion-ignore-case on\"

### ALIASES ###

# Deny overwriting
set -o noclobber

if [ \"$TERM\" = \"linux\" ]; then
    echo -en \"\\e]P05A6374\" #black
    echo -en \"\\e]P8282C34\" #darkgrey
    echo -en \"\\e]P1E06C75\" #darkred
    echo -en \"\\e]P9E06C75\" #red
    echo -en \"\\e]P298C379\" #darkgreen
    echo -en \"\\e]PA98C379\" #green
    echo -en \"\\e]P3E5C07B\" #brown
    echo -en \"\\e]PBE5C07B\" #yellow
    echo -en \"\\e]P461AFEF\" #darkblue
    echo -en \"\\e]PC61AFEF\" #blue
    echo -en \"\\e]P5C678DD\" #darkmagenta
    echo -en \"\\e]PDC678DD\" #magenta
    echo -en \"\\e]P656B6C2\" #darkcyan
    echo -en \"\\e]PE56B6C2\" #cyan
    echo -en \"\\e]P7DCDFE4\" #lightgrey
    echo -en \"\\e]PFDCDFE4\" #white
    clear #for background artifacting
fi

fet.sh

# if uwsm check may-start && uwsm select; then
# 	exec systemd-cat -t uwsm_start uwsm start default
# fi

if uwsm check may-start; then
    # exec uwsm start hyprland.desktop
    # exec uwsm start hyprland-systemd.desktop
    exec uwsm start hyprland-uwsm.desktop
fi

  ";
  
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


  # Shell Aliases
  home.shellAliases = {
    vim="nvim";
    v="vim";
    sd="sudo vim";
    p="PATH=$PATH:$(pwd)";
    ls="ls -F --color=auto --show-control-chars";
    l="ls -oshA";
    sl="l";
    dir="l";
    ".."="cd ..";
    "..."="cd ../..";
    cls="clear";
    cl="clear";
    t="touch";
    md="mkdir";
    "~"="cd";
    w="cat << EOF";
    hd="head";
    tl="tail";

    ## Colorize the grep command output for ease use
    grep="grep --color=auto";
    egrep="egrep --color=auto";
    fgrep="fgrep --color=auto";

    open="xdg-open";
    o="xdg-open";

    py="python3";

    # Aliases for software managment
    # sudo nixos-rebuild switch --flake .#nixos
    #   --show-trace --option eval-cache false
    # nix-store --gc
    # nix-channel --update
    # sudo nix flake update
    # sudo nixos-rebuild switch --upgrade-all --flake .#nixos

    # nix-collect-garbage (nix-store -gc)
    # sudo nix-collect-garbage -d / --delete-old (nix-env --delete-generations old) (delete all execept current)
    # sudo nix-collect-garbage --delete-older-than 30d (nix-env --delete-generations 30d)
    # sudo nix-env --delete-generations +5 (keep the last 5 and newer than current)
    # sudo nixos-rebuild list-generations

    # journalctl -e --unit home-manager-iamanaws.service 

    # Shutdown and Reboot
    ssn="sudo shutdown now";
    sr="sudo reboot";

    xd="ls /usr/share/xsessions";
  };
}