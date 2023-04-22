{ config, pkgs, ... }:

let
	home-manager = builtins.fetchTarball "https://github.com/nix-community/home-manager/archive/master.tar.gz";
in {
	
	imports = [
		
		(import "${home-manager}/nixos")
	];
	
	home-manager.users.root = {
		
		home = {
			
			stateVersion = "18.09";
			packages = with pkgs; [
				
				yggdrasil
			];
			
		};
		
		programs.zsh = {
			
			enable = true;
			dotDir = ".config/zsh";
			history = {
				
				path = "$HOME/.config/zsh/hist";
				save = 1000;
				size = 1000;
			};
			
			shellAliases = {
				
				# default options
				grep = "grep -i --color=AUTO";
				ping = "ping -c4";
				du = "du -ah --max-depth=1";
				dus = "du | sort -h";
				df = "df -h";
				dd = "dd status=progress";
				pwd = "pwd -P";
				cp = "cp -r";
				bc = "bc ~/scripts/system/functions.bc";
				pv = "pv -WF '%e %a %b | %p | %I'";
				mkdir = "mkdir -p";
				calc = "sage";
				nethack = "nethack -u Le~Kat";
				ydl = "yt-dlp -o '%(title)s.%(ext)s' --prefer-free-formats --audio-format m4a --merge-output-format mkv";
				
				# forced sudo
				mount = "sudo mount";
				umount = "sudo umount";
				sctl = "sudo systemctl";
				
				# shortenings
				c = "clear";
				g = "git";
				n = "neofetch";
				m = "mullvad";
				za = "zathura";
				cn = "clear && n";
				dq = "disown && exit";
				trans = "transmission-remote";
				open = "xdg-open";
				bashism = "checkbashisms";
				bashisms = "checkbashisms";
				
				# because I'm a vim addict
				":e" = "$EDITOR";
				":q" = "exit";
				vim = "vim -u ~/.config/nvim/minimal.vim";
				
				# remove history/log files
				wget = "wget --no-hsts";
				sage = "sage; rm ~/.sage/ipython-5.0.0/profile_default/history.sqlite";
				
				# ls-related
				ls = "ls --color=always --group-directories-first -h";
				
				la = "ls -A";
				ll = "ls -l";
				lla = "ls -lA";
				
				cl = "clear && ls";
				cla = "clear && la";
				cll = "clear && ll";
				clla = "clear && lla";
				
				cdc = "cd ~ && clear";
				cdcl = "cd ~ && cl";
				cdcla = "cd ~ && cla";
				cdcll = "cd ~ && cll";
				cdclla = "cd ~ && clla";
			};
			
			initExtra = ''
			## enables specific features
			autoload colors && colors
			setopt PROMPT_SUBST
			
			## default variables & functions
			ZSH_UNAME='%F{magenta}%n'
			ZSH_DIR="%F{green}%~"
			ZSH_CORE=""
			ZSH_PROMPT="%(?,%F{white},%F{red})%(!,#,$)"
			NEWLINE=$'\n'
			ZSH_EXTRA=""
			
			## helper functions
			battery() {
				
				battery=$(cat /sys/class/power_supply/BAT1/capacity)
				charging=$(cat /sys/class/power_supply/ACAD/online)
				if [ "$charging" = "1" ]; then # charging
					
					if [ "$battery" -ge 75 ]; then
						
						echo "%F{green}$battery%F{green}%%"
					elif [ "$battery" -ge 50 ]; then
						
						echo "%F{white}$battery%F{green}%%"
					elif [ "$battery" -ge 25 ]; then
						
						echo "%F{yellow}$battery%F{green}%%"
					else
						
						echo "%F{red}$battery%F{green}%%"
					fi
				else
					
					if [ "$battery" -ge 75 ]; then
						
						echo "%F{green}$battery%F{white}%%"
					elif [ "$battery" -ge 50 ]; then
						
						echo "%F{white}$battery%F{white}%%"
					elif [ "$battery" -ge 25 ]; then
						
						echo "%F{yellow}$battery%F{white}%%"
					else
						
						echo "%F{red}$battery%F{white}%%"
					fi
				fi
			}
			
			## main logic of the program
			if [ -f ~/git/zshPlugins/zsh-git-prompt/zshrc.sh ]; then
				
				GIT_PROMPT_EXECUTABLE="haskell"
				source ~/git/zshPlugins/zsh-git-prompt/zshrc.sh ## https://github.com/olivierverdier/zsh-git-prompt.git
				
				ZSH_THEME_GIT_PROMPT_PREFIX="%B %F{color_reset}("
				ZSH_THEME_GIT_PROMPT_SUFFIX=")"
				ZSH_THEME_GIT_PROMPT_SEPARATOR="|"
				ZSH_THEME_GIT_PROMPT_BRANCH="%F{magenta}"
				ZSH_THEME_GIT_PROMPT_STAGED="%F{red}%{● %G%}"
				ZSH_THEME_GIT_PROMPT_CONFLICTS="%F{red}%{✖ %G%}"
				ZSH_THEME_GIT_PROMPT_CHANGED="%F{blue}%{✚ %G%}"
				ZSH_THEME_GIT_PROMPT_BEHIND="%{↓%G%}"
				ZSH_THEME_GIT_PROMPT_AHEAD="%{↑%G%}"
				ZSH_THEME_GIT_PROMPT_UNTRACKED="%{…%G%}"
				ZSH_THEME_GIT_PROMPT_CLEAN="%F{green}%{%G%}"
				
				if [[ $TTY == *"tty"* ]]; then
					
					ZSH_CORE='%F{green}@%F{magenta}%y$(git_super_status)'
					ZSH_EXTRA="%F{magenta}[%f\$(battery)%F{magenta}|%f%D{%H}%F{green}:%f%D{%M}%F{magenta}|%f%D{%Y}%F{green}/%f%D{%m}%F{green}/%f%D{%d}%F{magenta}]%f"
				elif [[ -n $SSH_CONNECTION ]]; then
					
					ZSH_CORE='%F{green}@%F{magenta}%m$(git_super_status)'
					ZSH_EXTRA="%F{blue}[%F{green}$(echo $SSH_CLIENT | awk '{print $1}')%F{blue}:%F{green}$(echo $SSH_CLIENT | awk '{print $3}')%F{blue}]"
				else
					
					ZSH_CORE='$(git_super_status)'
				fi
			else
				
				if [[ $TTY == *"tty"* ]]; then
					
					ZSH_CORE="%F{green}@%F{magenta}%y"
					ZSH_EXTRA="%F{magenta}[%f\$(battery)%F{magenta}|%f%D{%H}%F{green}:%f%D{%M}%F{magenta}|%f%D{%Y}%F{green}/%f%D{%m}%F{green}/%f%D{%d}%F{magenta}]%f"
				elif [[ -n $SSH_CONNECTION ]]; then
					
					ZSH_CORE="%F{green}@%F{magenta}%m"
					ZSH_EXTRA="%F{blue}[%F{green}$(echo $SSH_CONNECTION | awk '{print $3}')%F{blue}:%F{green}$(echo $SSH_CONNECTION | awk '{print $4}')%F{blue}]"
				fi
			fi
			
			## sets the PS1
			if [[ ! -z $ZSH_EXTRA ]]; then
				
				## TODO: find a better alternative than literal line splits
				PS1="%B"$'\n'"$ZSH_EXTRA"$'\n'"%F{magenta}%n$ZSH_CORE $ZSH_DIR $ZSH_PROMPT %f%b"
			else
				
				PS1="%B%F{magenta}%n$ZSH_CORE $ZSH_DIR $ZSH_PROMPT %f%b"
			fi
			'';
		};
	};
}
