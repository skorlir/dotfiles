#
# Battery detection and display formatting functions
#
# - only handles a single battery
# - useful for displaying battery charge level in prompt
# - combined with TMOUT + SIGALRM, can be almost realtime
#

typeset -g batpower_enabled
typeset -gH capacity_file status_file

function batpower-setup {
  local detected_batteries=$(find /sys/class/power_supply/ -name BAT\*)
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
  typeset -g capacity_file="$selected_battery/capacity"
  typeset -g status_file="$selected_battery/status"
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
  local    charge=$(batpower-charge)
  local -h status=$(batpower-status) # -h bc. status is a special variable
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
  printf "%s%s %s%s"                 \
    "%{${color}%}"                   \
    $(batpower-fmt-charge ${charge}) \
    $(batpower-fmt-status ${status}) \
    "%{${reset_color}%}"
}

