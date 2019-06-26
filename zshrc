# Path to your oh-my-zsh installation.
export ZSH=~/.oh-my-zsh

# Stop fucking with my window titles, OMZ!
DISABLE_AUTO_TITLE="true"

# Uncomment the following line to use hyphen-insensitive completion. Case
# sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

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

# User configuration

# Default path, very POSIX
export PATH="/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin"

# Add custom zsh functions to path so we can autoload them
export fpath=(~/.local/zsh-functions $fpath)

# Add custom zsh scripts to path
export path=(~/.local/bin ~/.local/zsh-scripts $path)

# Load oh-my-zsh
source $ZSH/oh-my-zsh.sh

# Custom configuration
source ~/.zshrc.local

# Any information that shouldn't be tracked in git should be in a different file
if [ -e ~/.zshrc.sensitive ]; then
	source ~/.zshrc.sensitive
fi

# FZF
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
