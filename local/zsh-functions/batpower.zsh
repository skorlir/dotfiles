#
# Battery functions (used below)
#

function batpower-setup {
  setopt +o nomatch # NOTE: suppress 'no match' error message
  local detected_batteries=$(ls -d /sys/class/power_supply/BAT* 2>/dev/null)
  setopt -o nomatch
  local battery_listing=${BATPOWER_BATTERIES:-$detected_batteries}
  local batteries=()
  # NOTE: zsh: expansions don't perform word-splitting unless you use ${=...}
  for battery in ${=battery_listing}; do batteries+=($battery) done
  local battery_count=${#batteries}
  local selected_battery=''
  # If there are no batteries, fail.
  [[ $battery_count -eq 0 ]] && return 1
  # Otherwise, select the 1st battery.
  if [[ $battery_count -ge 1 ]]; then
    selected_battery=${batteries[1]}
    # When there's more than 1 battery, issue a notice
    if [[ $battery_count -gt 1 ]]; then
      printf 'batpower: multiple batteries detected! \n  %s\n' \
        "batteries=($batteries)"
    fi
  fi
  printf 'batpower: battery set: %s.\n' $selected_battery
  declare -g batpower_enabled=0
  declare -g batpower_battery_capacity_file="$selected_battery/capacity"
  declare -g batpower_battery_status_file="$selected_battery/status"
}

function batpower-enabled { return ${batpower_enabled:=1} }
function batpower-charge { batpower-enabled && cat $batpower_battery_capacity_file }
function batpower-status { batpower-enabled && cat $batpower_battery_status_file }
function batpower-fmt-charge { printf '%s%s' $1 '%%' }
function batpower-fmt-status {
  local status_symbol='?'
  case $1 in
    ( "Full" | "Unknown" ) status_symbol='▬';;
    ( "Charging"         ) status_symbol='▲';;
    ( "Discharging"      ) status_symbol='▼';;
  esac
  printf '%s▐' $status_symbol
}

function batpower-visual-battery {
  batpower-enabled || return 0
  local bat_charge=$(batpower-charge)
  local bat_status=$(batpower-status)
  local color=""
  if   [[ $bat_charge -ge 85 ]]; then
    color="$FG[118]" # green
  elif [[ $bat_charge -ge 50 ]]; then
    color="$FG[154]" # yellow-green
  elif [[ $bat_charge -ge 35 ]]; then
    color="$FG[011]" # yellow
  elif [[ $bat_charge -ge 20 ]]; then
    color="$FG[208]" # orange
  elif [[ $bat_charge -ge 00 ]]; then
    color="$FG[196]" # red
  fi
  printf "%s%s %s%s"                   \
    "%{${color}%}"                     \
    $(batpower-fmt-charge $bat_charge) \
    $(batpower-fmt-status $bat_status) \
    "%{$reset_color%}"
}

