#	---------------------------------------
#	  ENVIRONMENT CONFIGURATION
#	---------------------------------------

# Import some environment variables
if [ -f ~/.profile ]; then
	source ~/.profile
fi

# NPM AUTH
source ~/.bashrc

#	---------------------------------------
#	  ALIASES
#	---------------------------------------

# Git
alias g\?='git status '

# Network

alias ip="ifconfig | grep 'broadcast' | cut -d ' ' -f 2"