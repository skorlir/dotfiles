# Path to your oh-my-zsh installation.
export ZSH=~/.oh-my-zsh

# Stop fucking with my window titles, OMZ!
DISABLE_AUTO_TITLE="true"

# Dot dot dot when completion is slow
COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(git)

# NOTE: zsh $path array mirrors colon-delimited PATH with a nicer API
# Default path, very POSIX
export path=(/usr/local/sbin /usr/local/bin /usr/sbin /usr/bin /sbin /bin)

# Set XDG_CONFIG_HOME correctly, mostly for dumb scripts with bad defaults
export XDG_CONFIG_HOME="${HOME}/.config"

# Add custom zsh functions to path so we can autoload them
export fpath=(${HOME}/.local/zsh-functions ${fpath})

# Load oh-my-zsh
source ${ZSH}/oh-my-zsh.sh

# Custom configuration
source ~/.zshrc.local

# Host-specific configuration
if [ -e ${HOME}/.zshrc.${HOST} ]; then
  source ${HOME}/.zshrc.${HOST}
fi

# Add custom zsh scripts and binaries to path
export path=(${HOME}/.local/bin ${HOME}/.local/zsh-scripts ${path})
