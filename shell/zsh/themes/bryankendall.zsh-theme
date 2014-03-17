autoload -U colors && colors

autoload -Uz vcs_info

zstyle ':vcs_info:*' stagedstr '%F{green}●'
zstyle ':vcs_info:*' unstagedstr '%F{yellow}●'
zstyle ':vcs_info:*' check-for-changes true
zstyle ':vcs_info:(sv[nk]|bzr):*' branchformat '%b%F{1}:%F{11}%r'
theme_precmd () {
    if [[ -z $(git ls-files --other --exclude-standard 2> /dev/null) ]] {
        zstyle ':vcs_info:*' formats ' [%b%c%u%F{green}]'
    } else {
        zstyle ':vcs_info:*' formats ' [%b%c%u%F{red}●%F{green}]'
    }

    vcs_info
}

PROMPT='%{$fg[cyan]%}%n@%m%{$reset_color%} \
%{$fg[green]%}%c\
${vcs_info_msg_0_}%{$reset_color%} \
%(?.%{$fg[green]%}.%{$fg[red]%})%(!.#.»)%{$reset_color%} '
PROMPT2='%{$fg[red]%}> %{$reset_color%}'

autoload -U add-zsh-hook
add-zsh-hook precmd  theme_precmd
