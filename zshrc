# make ls colors consistent
#
# color is a semicolon-delimited list of attributes for each match
#   man://console_codes(4)
#
# attributes for effects and 16 colors
#   fx 0{0=none  1=bold     2=dim     3=italic    4=underscore
#        5=blink 6=<unused> 7=reverse 8=concealed 9=strikeout}
#   fg 3{0=black 1=red 2=green 3=yellow 4=blue 5=magenta 6=cyan 7=white}
#   bg 4{0=black 1=red 2=green 3=yellow 4=blue 5=magenta 6=cyan 7=white}
#
# NOTE that italic, concealed, and strikeout are not documented in
# console_codes and are not supported by all terminal emulators.
#
# additional codes 38 (fg) and 48 (bg) suppport 8- and 24-bit colors:
#   {38,48};5;x      -  8-bit  (256) color, x is in 0..255
#   {38,48};2;r;g;b  -  24-bit (rgb) color, each of r, g, b is in 0..255
#
# a complete escape is written:
#   [<parameters>m
# for example, a bright pastel-y purple:
#   [38;2;255;150;255m
#
# in zsh, codes can be tested using literal escape sequences in %{...%}:
#   print -P '%{[38;2;255;150;255m%}hello, purple!%{[0m%}'
#
# sharkdp/vivid provides a great reference for file codes (like pi=fifo):
#   https://github.com/sharkdp/vivid/blob/master/config/filetypes.yml
# otherwise i think you just have to reverse-engineer them from dircolors.
#
# TODO(jordan): use more than 16 colors when available
#
export ls_colors=(
  "rs=0"        # reset
  "di=01;34"    # directory
  "ln=01;36"    # link
  "mh=00"       # multihardlink
  "pi=40;33"    # fifo
  "so=01;35"    # socket
  "do=01;35"    # door [?]
  "bd=40;33;01" # block device driver
  "cd=40;33;01" # character device driver
  "or=40;31;01" # orphan (broken symlink, non-stat-able file)
  "mi=00"       # missing [?]
  "su=37;41"    # setuid (file with u+s)
  "sg=30;43"    # setgid (file with g+s)
  "ca=30;41"    # capability (file with capability [?])
  "tw=30;42"    # sticky other-writable (file with +t and o+w)
  "ow=34;42"    # other-writable non-sticky (file with o+w)
  "st=37;44"    # sticky (+t) and not other-writable
  "ex=01;32"    # executable (file with +x)
  # begin file extension based color patterns
  "*.tar=01;31"
  "*.tgz=01;31"
  "*.arc=01;31"
  "*.arj=01;31"
  "*.taz=01;31"
  "*.lha=01;31"
  "*.lz4=01;31"
  "*.lzh=01;31"
  "*.lzma=01;31"
  "*.tlz=01;31"
  "*.txz=01;31"
  "*.tzo=01;31"
  "*.t7z=01;31"
  "*.zip=01;31"
  "*.z=01;31"
  "*.dz=01;31"
  "*.gz=01;31"
  "*.lrz=01;31"
  "*.lz=0"
)
export LS_COLORS=${(j.:.)ls_colors}

# tell colorizable commands to print colors during interactive sessions
alias ls='ls --color=auto'
alias grep='grep --color=auto'
alias tree='tree -C'

#
# wide-ranging default settings
# man://zshoptions(1)
#
# ∙ changing directories
setopt auto_cd            # [-J] if a command is a directory, `cd {dir}`
setopt auto_pushd         # [-N] automatically pushd when cd
setopt pushd_ignore_dups  # don't push duplicates onto dirstack
setopt chase_links        # [-w] follow symlinks when changing directory
# ∙ completion
setopt auto_param_slash   # <default> add slashes when completing paths
setopt auto_remove_slash  # <default> remove last slash of completed path
setopt list_types         # <default> show type markers of file candidates
setopt no_list_ambiguous  # show menu even if unambiguous prefix [1]
setopt complete_in_word   # complete partial words, e.g. mk|r<tab> → mkdir
setopt globcomplete       # interpret * as part of completion in a word
# ∙ globbing
setopt extended_glob      # extended globbing, eg. *~*.txt (exclude *.txt)
setopt glob_star_short    # **.js expands to **/*.js; same for ***
setopt numeric_glob_sort  # numeric file names expand sorted numerically
setopt warn_create_global # warn on creating globals except `typeset -g`
# ∙ history
setopt extended_history   # add timestamp to histfile entries
setopt hist_find_no_dups  # don't display duplicates in history expansion
setopt hist_ignore_space  # [-g] commands with leading space are not saved
setopt hist_no_functions  # don't store function definitions
setopt hist_no_store      # don't store `history` invocations in history
setopt hist_save_no_dups  # don't save dups within the same session
setopt hist_verify        # don't execute expanded history right away
setopt share_history      # see commands from other still-running sessions
# ∙ initialization
setopt no_global_rcs      # [-d] don't source startup files from /etc
# ∙ input / output
setopt correct_all        # [-O] suggest corrections for all arguments
setopt no_clobber         # > won't truncate but >| or >! will
setopt no_flow_control    # no start/stop (C-S/C-Q) control sequences
# ∙ job control
setopt long_list_jobs     # [-R] print job notifications in long format
# ∙ prompting
setopt prompt_subst       # command subst, arith & param expn in [R]PROMPT
setopt transient_rprompt  # rprompt only shows on current ineractive line
# ∙ scripts and functions
setopt pipe_fail          # sets $? to non-zero if any pipe element fails
# ∙ shell emulation
setopt append_create      # >> creates new files despite no_clobber
# ∙ zsh line editor (zle)
setopt no_beep            # don't fucking beep
# options notes
#
# [1] no_list_ambiguous
#     this means that, with node and node-gyp installed,
#       $ no<tab>
#     will expand to:
#       $ node
#     BUT instead of stopping, a menu shows for further disambiguation:
#       $ node
#         node node-gyp
#     with the default setting, list_ambiguous, <tab> must be pressed
#     again to continue completing and to eventually get node-gyp.
#

#
# misc. zsh environment variable parameters
# man://zshparam(1) (section: PARAMETERS USED BY THE SHELL)
#
export DIRSTACKSIZE=100      # keep 100 entries in the directory stack
export HISTFILE="${HOME}/.zsh_history"
export HISTSIZE=50000        # keep 50k lines of internal session history
export LISTMAX=0             # ask before listing if it won't fit onscreen
unset NULLCMD                # error on redirection with no command
export SAVEHIST=${HISTSIZE}  # and the same in the shared ${HISTFILE}
# give all timings in ms (%m{U,S,E}) with max resident set size (%M)
export timefmt=(
  "%J"              # job name
  "%mU user"        # time spent in user-mode in milliseconds
  "%mS system"      # time spent in kernel-mode in milliseconds
  "%mE (%*E) total" # total time in milliseconds and hh:mm:ss.ttt
  "─"               # spacer between time and resource usage
  "max cpu %P"      # max cpu percentage
  "─"               # spacer between cpu and memory
  "max RSS %Mkb"    # max resident set size in kilobytes
)
export TIMEFMT=${(j: :)${timefmt}}
# zle: shells sometimes need a margin on the RPROMPT, but not in tmux
export ZLE_RPROMPT_INDENT=$((!${+TMUX}))
# zle: which characters should be removed during completion? (not pipe)
export ZLE_REMOVE_SUFFIX_CHARS=$' \t\n;&'

# special zsh array parameters
# default path, very POSIX
export path=(/usr/local/sbin /usr/local/bin /usr/sbin /usr/bin /sbin /bin)
# Add custom zsh functions to path so we can autoload them
export fpath=(${HOME}/.local/zsh-functions ${fpath})

# zshmodules
# loads the zstyle, zformat, zparseopts, zregexparse builtins
zmodload zsh/zutil
# zpty runs interactive commands non-interactively, used by deoplete-zsh
zmodload zsh/zpty
# extends completion with colors, highlighting of selection, scrolling...
zmodload zsh/complist

# complist is configured with styles of the format:
#   :completion:{function}:{completer}:{command}:{argument}:{tag}
zstyle ':completion:*:*:*:*:*' menu select        # always use complist
zstyle ':completion:*' list-colors "${LS_COLORS}" # same colors as ls
zstyle ':completion:*' use-cache yes              # cache candidates

# use a custom command for completing processes
#   -u ${USERNAME}    effectively owned by me, even indirectly via fork
#   -ww               drawn with with unlimited width to fill the screen
#   -o pid,user,comm  with columns for pid, user, and process name (comm)
process_complete_command="ps -ww -u ${USERNAME} -o pid,user,comm"
zstyle ':completion:*:*:*:*:processes' command ${process_complete_command}

# ctrl-o will accept the selected match and start completing the next word
bindkey -M menuselect '^o' accept-and-infer-next-history

# TODO(jordan): recreate COMPLETION_WAITING_DOTS functionality
# ~/.oh-my-zsh/lib/completion.zsh:61

# Add custom zsh scripts and binaries to path
export path=(${HOME}/.local/bin ${HOME}/.local/zsh-scripts ${path})

# perform compinit as late as possible, as it may override other settings
autoload -U compinit && compinit
autoload -U bashcompinit && bashcompinit # also load bash completions

#
# autoload custom text effects and colors functions. colorfx provides:
#   $fg, $bg, $fx, $codes, fg-rgb(), bg-rgb()
#   fgls-16 fgls-256   list foreground examples for 16 and 256 color
#   bgls-16 bgls-256   list background examples for 16 and 256 color
#   cls-24bit-square   enumerate rgb colors in a (127x, 50y)ish square
#
# basically a mashup of the best ideas from zshcontrib colors and
# spectrum.zsh.
#
autoload -U colorfx && colorfx

# use vcs_info for git prompt information, ships with zsh in zshcontrib
autoload -U vcs_info
#
# vcs_info is configured with styles of the format:
#   :vcs_info:{vcs}:{user-context}:{repo-root}
#
# generally speaking, {user-context} is rarely used.
# {repo-root} can be used to set custom styles for specific repos.
#
zstyle ':vcs_info:*' enable git    # only enable git repos, not bzr, etc.
zstyle ':vcs_info:*' max-exports 3 # export 3 ${vcs_info_msg_N_} variables
zstyle ':vcs_info:git:*' stagedstr   1 # %c=1 if staged changes found
zstyle ':vcs_info:git:*' unstagedstr 1 # %u=1 if unstaged changes found
zstyle ':vcs_info:git:*' formats '%b' '%c' '%u' # branch, staged, unstaged
zstyle ':vcs_info:git:*' check-for-changes true # yes, compute %c and %u
zstyle ':vcs_info:git:*:*' check-untracked true

#
# parse-vcs-info()
#
# parse ${vcs_info_msg_N_} variables into an associative array, vcs
#   [branch]            branch name
#   [untracked_files]   list of untracked files (NOTE: may be slow?)
#   [dirty]             1 if unstaged or untracked changes
#   [staged]            1 if staged changes
#   [unstaged]          1 if unstaged changes
#   [untracked]         1 if there are untracked files
#
# OPTIMIZE? setting for disabling detection of untracked files?
# hard to say without further testing if `git ls-files --other` is slow.
#
typeset -Ag vcs=([branch]='')
function parse-vcs-info() {
  typeset -Ag vcs=(
    [branch]=${vcs_info_msg_0_}
    [untracked_files]=''
    [dirty]=''
    [staged]=${vcs_info_msg_1_}
    [unstaged]=${vcs_info_msg_2_}
    [untracked]=''
  )
  # don't continue parsing info if we can already tell we're not in a repo
  if [[ -z ${vcs[branch]} ]]; then
    return 0
  fi
  local git_root=$(git rev-parse --show-toplevel)
  local check_untracked
  { # compute check_untracked from default and repo styles
    local default repo
    zstyle -g default ":vcs_info:git:*:*"           check-untracked
    zstyle -g repo    ":vcs_info:git:*:${git_root}" check-untracked
    check_untracked=${repo[1]:-${default[1]}} # there's only 1 result
  }
  if [[ ${check_untracked} == true ]]; then
    vcs[untracked_files]=$(git ls-files --exclude-standard --others)
  fi
  vcs[untracked]=${vcs[untracked_files]:+1}
  vcs[dirty]=${vcs[dirty]:=${vcs[unstaged]}}
  vcs[dirty]=${vcs[dirty]:=${vcs[untracked]}}
}

precmd() {
  set +o warn_nested_var
  vcs_info # sets ${vcs_info_msg_N_} variables
  set -o warn_nested_var
  parse-vcs-info
}

# Custom configuration
source ~/.zshrc.local

# Report slow / high-memory commands AFTER running global and local setup
export REPORTMEMORY=100      # print timing stats for commands using >100k
export REPORTTIME=1          # print timing stats for commands taking >1s

# Host-specific configuration and overrides
# This should come last so it can override e.g. REPORTTIME
if [ -e ${HOME}/.zshrc.${HOST} ]; then
  source ${HOME}/.zshrc.${HOST}
fi
