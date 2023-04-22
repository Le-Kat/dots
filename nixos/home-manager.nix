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
			
		};
	};
}
