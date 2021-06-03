#
# Battery detection and display formatting functions
#
# - only handles a single battery
# - useful for displaying battery charge level in prompt
# - combined with TMOUT + SIGALRM, can be almost realtime
#

typeset -g batpower_enabled
typeset -gH capacity_file status_file did_setup

function batpower-setup {
  typeset -gH did_setup=1
  local detected_batteries=$(2>/dev/null find /sys/class/power_supply/ -name BAT\*)
  local batteries=(${BATPOWER_BATTERIES:-${detected_batteries}})
  # If there are no batteries, fail.
  if [[ ${#batteries} -eq 0 ]]; then
    return 1
  fi
  # Otherwise, select the 1st battery.
  local selected_battery=${batteries[1]}
  # And if there are more batteries, issue a warning.
  if [[ ${#batteries} -gt 1 ]]; then
    printf 'batpower: multiple batteries detected! \n  %s\n' \
      "batteries=($batteries)"
  fi
  printf 'batpower: battery set: %s.\n' ${selected_battery}
  typeset -g batpower_enabled=1
  typeset -gH capacity_file="$selected_battery/capacity"
  typeset -gH status_file="$selected_battery/status"
}

function batpower-linux {
  if [[ -z ${did_setup} ]]; then
    batpower-setup
  fi
}

function batpower-darwin {
  typeset -g batpower_enabled=1
  local capacities=$(
    ioreg -rn AppleSmartBattery                                     \
      | sed -e 's/^[[:space:]]*//'                                  \
      | grep -E '"(Max|Current)Capacity"|"(Is|Fully)Charg(ing|ed)"' \
      | cut -d' ' -f1,3
  )
  local max_capacity current_capacity
  local -h status=Discharging
  local key value; for key value in ${=capacities}; do
    if   [[ ${key} =~         Max* ]]; then max_capacity=${value}
    elif [[ ${key} =~     Current* ]]; then current_capacity=${value}
    elif [[ ${key} =~   IsCharging && ${value} == Yes ]]; then status=Charging
    elif [[ ${key} =~ FullyCharged && ${value} == Yes ]]; then status=Full
    fi
  done
  local charge=$((100 * ${current_capacity} / ${max_capacity}))
  typeset -g batpower_charge=${charge}
  typeset -g batpower_status=${status}
}

function batpower-enabled { [[ -n ${batpower_enabled} ]] }
function batpower-charge  { batpower-enabled && cat ${capacity_file} }
function batpower-status  { batpower-enabled && cat ${status_file}   }

function batpower-fmt-charge {
  printf '%s%s' ${1} '%%'
}

function batpower-fmt-status {
  local status_symbol='?'
  case ${1} in
    ( "Full" | "Unknown" ) status_symbol='▬';;
    ( "Charging"         ) status_symbol='▲';;
    ( "Discharging"      ) status_symbol='▼';;
  esac
  printf '%s▐' ${status_symbol}
}

function batpower-visual-battery {
  batpower-enabled || return 0
  local color
  local    charge=${${batpower_charge}:-$(batpower-charge)}
  local -h status=${${batpower_status}:-$(batpower-status)}
  if   [[ ${charge} -ge 85 ]]; then
    color="${fg[118]}" # green
  elif [[ ${charge} -ge 50 ]]; then
    color="${fg[154]}" # yellow-green
  elif [[ ${charge} -ge 35 ]]; then
    color="${fg[011]}" # yellow
  elif [[ ${charge} -ge 20 ]]; then
    color="${fg[208]}" # orange
  elif [[ ${charge} -ge 00 ]]; then
    color="${fg[196]}" # red
  fi
  printf "%%{${color}%%}%s %s%%{${fx[reset]}%%}" \
    $(batpower-fmt-charge ${charge})             \
    $(batpower-fmt-status ${status})
}

