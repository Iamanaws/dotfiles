{ lib, ... }:

{
  programs.bash = {
    enable = true;
    shellAliases = {
      ls = lib.mkForce "ls -F --color=auto --show-control-chars";
      open = "xdg-open";
      o = "xdg-open";
    };
    bashrcExtra = "\n
      # If not running interactively, don't do anything\n
      [[ $- != *i* ]] && return\n
      \n
      parse_git_branch() {\n
        git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \\(.*\\)/ (\\1)/'\n
      }\n
      \n
      PS1='\\n\\[\\033[01;34m\\]\\w\\[\\033[1;35m\\]$(parse_git_branch)\\[\\033[00m\\]\\n\\$ '\n
      \n
      PROMPT_DIRTRIM=2\n
      \n
      ignore upper and lowercase when TAB completion\n
      bind \"set completion-ignore-case on\"\n
      \n
      # Deny overwriting\n
      set -o noclobber\n
      \n
      if [ \"$TERM\" = \"linux\" ]; then\n
        echo -en \"\\e]P05A6374\" #black\n
        echo -en \"\\e]P8282C34\" #darkgrey\n
        echo -en \"\\e]P1E06C75\" #darkred\n
        echo -en \"\\e]P9E06C75\" #red\n
        echo -en \"\\e]P298C379\" #darkgreen\n
        echo -en \"\\e]PA98C379\" #green\n
        echo -en \"\\e]P3E5C07B\" #brown\n
        echo -en \"\\e]PBE5C07B\" #yellow\n
        echo -en \"\\e]P461AFEF\" #darkblue\n
        echo -en \"\\e]PC61AFEF\" #blue\n
        echo -en \"\\e]P5C678DD\" #darkmagenta\n
        echo -en \"\\e]PDC678DD\" #magenta\n
        echo -en \"\\e]P656B6C2\" #darkcyan\n
        echo -en \"\\e]PE56B6C2\" #cyan\n
        echo -en \"\\e]P7DCDFE4\" #lightgrey\n
        echo -en \"\\e]PFDCDFE4\" #white\n
        clear #for background artifacting\n
      fi\n
      \n
      fet.sh\n
      \n
      # if uwsm check may-start && uwsm select; then\n
      # 	exec systemd-cat -t uwsm_start uwsm start default\n
      # fi\n
      \n
      if uwsm check may-start; then\n
        # exec uwsm start hyprland.desktop\n
        # exec uwsm start hyprland-systemd.desktop\n
        exec uwsm start hyprland-uwsm.desktop\n
      fi\n
      \n
    ";
  };

}
