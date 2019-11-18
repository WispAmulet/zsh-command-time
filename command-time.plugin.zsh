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
  day=$((60*60*24))
  hour=$((60*60))
  min=$((60))

  if [ -n "$ZSH_COMMAND_TIME" ]; then
    d=$(($ZSH_COMMAND_TIME/$day))
    h=$(($ZSH_COMMAND_TIME%$day/$hour))
    m=$(($ZSH_COMMAND_TIME%$day%$hour/$min))
    s=$(($ZSH_COMMAND_TIME%$day%$hour%$min))

    if [ "$ZSH_COMMAND_TIME" -le $min ]; then
      timer_show="$s s"
    elif [ "$ZSH_COMMAND_TIME" -gt $min ] && [ "$ZSH_COMMAND_TIME" -le $hour ]; then
      timer_show="$m m $s s"
    elif [ "$ZSH_COMMAND_TIME" -gt $hour ] && [ "$ZSH_COMMAND_TIME" -le $day ]; then
      timer_show="$h h $m m $s s"
    fi
    print -P '%F{$ZSH_COMMAND_TIME_COLOR}`printf "${ZSH_COMMAND_TIME_MSG}\n" "$timer_show"`%f'
  fi
}

precmd_functions+=(_command_time_precmd)
preexec_functions+=(_command_time_preexec)
