# A script to make using 256 colors in zsh less painful.
# P.C. Shyamshankar <sykora@lucentbeing.com>
# Copied from https://github.com/sykora/etc/blob/master/zsh/functions/spectrum/
#
# ... Then copied from oh-my-sh/lib/spectrum.zsh
#         ... and then patched by @fluffywaffles
#

typeset -AHg FX FG BG

FX=(
  reset     "%{[00m%}"
  bold      "%{[01m%}"
  dim       "%{[02m%}" normal       "%{[22m%}" # normal also un-bolds
  italic    "%{[03m%}" no-italic    "%{[23m%}"
  underline "%{[04m%}" no-underline "%{[24m%}"
  blink     "%{[05m%}" no-blink     "%{[25m%}"
  reverse   "%{[07m%}" no-reverse   "%{[27m%}"
  strikeout "%{[09m%}" no-strikeout "%{[29m%}"
)

for color in {000..255}; do
  FG[$color]="%{[38;5;${color}m%}"
  BG[$color]="%{[48;5;${color}m%}"
done

# Show all 256 colors with color number
function spectrum_ls() {
  local code
  local ZSH_SPECTRUM_TEXT=${ZSH_SPECTRUM_TEXT:-Arma virumque cano Troiae qui primus ab oris}
  for code in {000..255}; do
    print -P -- "$code: $FG[$code]$ZSH_SPECTRUM_TEXT%{$reset_color%}"
  done
}

# Show all 256 colors where the background is set to specific color
function spectrum_bls() {
  local ZSH_SPECTRUM_TEXT=${ZSH_SPECTRUM_TEXT:-Arma virumque cano Troiae qui primus ab oris}
  for code in {000..255}; do
    print -P -- "$code: $BG[$code]$ZSH_SPECTRUM_TEXT%{$reset_color%}"
  done
}