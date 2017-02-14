#!/bin/sh

#	---------------------------------------
#  References
#	---------------------------------------

# Thanks to jonnyscholes for help and tips! https://github.com/jonnyscholes/.dot-files/
# Responsive git prompt from jondavidjohn https://github.com/jondavidjohn/dotfiles, http://jondavidjohn.com/quest-for-the-perfect-git-bash-prompt-redux/

# See also:
# http://natelandau.com/my-mac-osx-bash_profile/
# http://natelandau.com/bash-scripting-utilities/

# Git bash completion: https://conra.dk/2013/01/18/git-on-osx.html

#	---------------------------------------
#	Old (to fix/merge)
#	---------------------------------------

[[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm" # Load RVM into a shell session *as a function*

# Add `bins` to the `$PATH`
export PATH=/usr/local/bin:$PATH
export PATH=/usr/local/sbin:$PATH


#	---------------------------------------
#	0. Colors & Icons
#	---------------------------------------

function color() {
	echo "\[$( tput setaf $1 )\]"
}

black=$(tput setaf 0)
red=$(tput setaf 1)
green=$(tput setaf 2)
yellow=$(tput setaf 3)
blue=$(tput setaf 4)
magenta=$(tput setaf 5)

cyan=$(tput setaf 6)
white=$(tput setaf 7)

black_bright=$(tput setaf 8)
red_bright=$(tput setaf 9)
green_bright=$(tput setaf 10)
yellow_bright=$(tput setaf 11)
blue_bright=$(tput setaf 12)
magenta_bright=$(tput setaf 13)
cyan_bright=$(tput setaf 14)
white_bright=$(tput setaf 15)

reset=$(tput sgr0)
COLOREND="\[\e[00m\]"

red_bg=$(tput setab 1)
green_bg=$(tput setab 2)
yellow_bg=$(tput setab 3)
blue_bg=$(tput setab 4)
magenta_bg=$(tput setab 5)
cyan_bg=$(tput setab 6)


#	---------------------------------------
#	1.	 ENVIRONMENT CONFIGURATION
#	---------------------------------------

# Add tab completion for bash commands
if [ -f $(brew --prefix)/etc/bash_completion ]; then
	source $(brew --prefix)/etc/bash_completion
fi

# Add (optional) ruby config
if [ -f /usr/local/share/chruby/chruby.sh ]; then
	source /usr/local/share/chruby/chruby.sh
	source /usr/local/share/chruby/auto.sh
fi

#	---------------------------------------
#	2.	 ALIASES
#	---------------------------------------

# Git

alias g?='git status '
alias gb?='git branch '
alias ga='git add '
alias gundo='git checkout '
alias gco='git checkout '
alias grm='git reset HEAD '
alias gpull='git pull '
alias gdiff='git diff '

# Network

alias ip="ifconfig | grep 'broadcast' | cut -d ' ' -f 2"

# Vagrant

alias vrun='vagrant do runserver '
alias vass='vagrant do assets '

#	---------------------------------------
#	10. git
#	---------------------------------------

# Responsive colour-coded git things to bash prompt

parse_git_branch() {
  if [ -f $(brew --prefix)/etc/bash_completion ]; then
    source $(brew --prefix)/etc/bash_completion.d/git-prompt.sh
    GIT_PS1_SHOWDIRTYSTATE=1
  	branch=`__git_ps1 "%s"`
  else
  	ref=$(git-symbolic-ref HEAD 2> /dev/null) || return
  	branch="${ref#refs/heads/}"
  fi

  if [[ `tput cols` -lt 110 ]]; then
  	branch=`echo $branch | sed s/feature/f/1`
  	branch=`echo $branch | sed s/hotfix/h/1`
  	branch=`echo $branch | sed s/release/\r/1`

  	branch=`echo $branch | sed s/master/mstr/1`
  	branch=`echo $branch | sed s/develop/dev/1`
  fi

  if [[ $branch != "" ]]; then
  	if [[ $(git status 2> /dev/null | tail -n1) == "nothing to commit, working tree clean" ]]; then
  	  echo "${black_bright}on branch ${green}$branch${COLOREND} "
  	else
  	  echo "${black_bright}on branch ${red}$branch${COLOREND} "
  	fi
  fi

}


#	Custom prompt
#	------------------------------------------------------------

prompt() {

	time='\[$black_bright\][\A]\[$reset\]'
	user='\[$magenta\]\u\[$black_bright\] at \[$white\]\h'
	dir='\[$black_bright\]in \[$cyan\]\W\[$reset\]'

	if [[ $? -eq 0 ]]; then
		exit_status="${BLUE}$ ${COLOREND}"
	else
		exit_status="${RED}$ ${COLOREND}"
	fi

	PS1="\n${time} ${user} ${dir} $(parse_git_branch)\n$exit_status"
}


PROMPT_COMMAND="prompt; $PROMPT_COMMAND"
