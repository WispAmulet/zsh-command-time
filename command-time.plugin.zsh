_command_time_preexec() {
  timer=${timer:-$SECONDS}
  ZSH_COMMAND_TIME_MSG=${ZSH_COMMAND_TIME_MSG-"Time: %s"}
  ZSH_COMMAND_TIME_COLOR=${ZSH_COMMAND_TIME_COLOR-"white"}
  export ZSH_COMMAND_TIME=""
}

_command_time_precmd() {
  if [ $timer ]; then
    timer_show=$(($SECONDS - $timer))
    if [ -n "$TTY" ] && [ $timer_show -ge ${ZSH_COMMAND_TIME_MIN_SECONDS:-3} ]; then
      export ZSH_COMMAND_TIME="$timer_show"
      if [ ! -z ${ZSH_COMMAND_TIME_MSG} ]; then
        zsh_command_time
      fi
    fi
    unset timer
  fi
}

zsh_command_time() {
  if [ -n "$ZSH_COMMAND_TIME" ]; then
    hours=$(($ZSH_COMMAND_TIME/3600))
    min=$(($ZSH_COMMAND_TIME%3600/60))
    sec=$(($ZSH_COMMAND_TIME%3600%60))
    if [ "$ZSH_COMMAND_TIME" -le 60 ]; then
      timer_show="$ZSH_COMMAND_TIME s"
    elif [ "$ZSH_COMMAND_TIME" -gt 60 ] && [ "$ZSH_COMMAND_TIME" -le 3600 ]; then
      timer_show="$min min $sec s"
    else
      timer_show="$hours h $min min $sec s"
    fi
    print -P '%F{$ZSH_COMMAND_TIME_COLOR}`printf "${ZSH_COMMAND_TIME_MSG}\n" "$timer_show"`%f'
  fi
}

precmd_functions+=(_command_time_precmd)
preexec_functions+=(_command_time_preexec)
