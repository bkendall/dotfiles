ZSH_THEME_GIT_PROMPT_SUFFIX="%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_PREFIX="|%{$fg[cyan]%}"
ZSH_THEME_GIT_PROMPT_ADDED="%{$fg[green]%}+"
ZSH_THEME_GIT_PROMPT_MODIFIED="%{$fg[blue]%}?"
ZSH_THEME_GIT_PROMPT_DELETED="%{$fg[red]%}✖"
ZSH_THEME_GIT_PROMPT_RENAMED="%{$fg[magenta]%}➜"
ZSH_THEME_GIT_PROMPT_UNMERGED="%{$fg[yellow]%}═"
ZSH_THEME_GIT_PROMPT_UNTRACKED="%{$fg[cyan]%}✭"

ZSH_THEME_GIT_PROMPT_DIRTY="%{$fg_bold[red]%}?"
ZSH_THEME_GIT_PROMPT_AHEAD="%{$fg_bold[red]%}!"
ZSH_THEME_GIT_PROMPT_CLEAN="" # clean doesn't need anything

ZSH_THEME_GIT_PROMPT_SHA_BEFORE="(%{$fg[red]%}"
ZSH_THEME_GIT_PROMPT_SHA_AFTER="%{$reset_color%}"

ZSH_THEME_GIT_PROMPT_STATUS_SUFFIX="%{$reset_color%})"

function my_git_prompt_status () {
  GPS=$(git_prompt_status)
  if [[ "$GPS" != "" ]]; then
    echo "$GPS$ZSH_THEME_GIT_PROMPT_STATUS_SUFFIX"
  fi
}

PROMPT='%{$fg[green]%}%m%{$reset_color%}:\
%{$fg[magenta]%}%c%{$reset_color%}\
$(git_prompt_short_sha)$(git_prompt_info)$(my_git_prompt_status) \
%(?.%{$fg[green]%}.%{$fg[red]%})%(!.#.»)%{$reset_color%} '
PROMPT2='%{$fg[red]%}> %{$reset_color%}'
