function prompt_char {
	if [ $UID -eq 0 ]; then echo "#"; else echo $; fi
}

# PROMPT='%(!.%{$fg_bold[red]%}.%{$fg_bold[cyan]%}%n@)%m %{$fg_bold[blue]%}%(!.%1~.%~) $(git_prompt_info)$(prompt_char)%{$reset_color%} '
PROMPT='%(!.%{$fg_bold[red]%}.%{$FG[039]%}%n@)%m %{$FG[050]%}%(!.%1~.%~) $(git_prompt_info)$(prompt_char)%{$reset_color%} '

ZSH_THEME_GIT_PROMPT_PREFIX="("
ZSH_THEME_GIT_PROMPT_SUFFIX=") "
