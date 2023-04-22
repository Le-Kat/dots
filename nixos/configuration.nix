{ config, pkgs, ... }:

{
	imports = [
		
		./hardware-configuration.nix
		./home-manager.nix
	];
	
	# Use the GRUB 2 boot loader.
	boot.loader.grub.enable = true;
	boot.loader.grub.version = 2;
	# Define on which hard drive you want to install Grub.
	boot.loader.grub.device = "/dev/sda"; # or "nodev" for efi only
	
	networking.hostName = "nixos"; # Define your hostname.
	# Pick only one of the below networking options.
	#networking.networkmanager.enable = true;  # Easiest to use and most distros use this by default.
	
	# Set your time zone.
	time.timeZone = "Canada/Eastern";
	
	# Select internationalisation properties.
	i18n.defaultLocale = "en_US.UTF-8";
	console = {
		font = "Lat2-Terminus16";
		#keyMap = "us";
		useXkbConfig = true; # use xkbOptions in tty.
	};
	
	# Configure keymap in X11
	services.xserver = {
		
		layout = "us";
		xkbOptions = "caps:control";
	};
	
	# Enable CUPS to print documents.
	#services.printing.enable = true;
	
	# Enable sound.
	#sound.enable = true;
	#hardware.pulseaudio.enable = true;
	
	# Define a user account. Don't forget to set a password with ‘passwd’.
	users.users.nas = {
		
		isNormalUser = true;
		home = "/home/nas" # TODO: set to external drive
	};
	
	# List packages installed in system profile. To search, run:
	environment.systemPackages = with pkgs; [
		
		vim
		mullvad-vpn
		aria
		python3
	];
	
	environment.sessionVariables = rec {
		
		XDG_CONFIG_HOME = "$HOME/.config";
		XDG_DATA_HOME = "$HOME/.local/share";
		XDG_CACHE_HOME = "$HOME/.cache";
		XDG_DESKTOP_DIR = "/dev/null";
		XDG_DOCUMENTS_DIR = "$HOME/docs";
		XDG_DOWNLOAD_DIR = "$HOME/downloads";
		XDG_DOWNLOADS_DIR = "$HOME/downloads";
		XDG_MUSIC_DIR = "$HOME/media/music";
		XDG_PICTURES_DIR = "$HOME/media/pictures";
		XDG_VIDEOS_DIR = "$HOME/media/videos";
		SSH_AUTH_SOCK = "$XDG_RUNTIME_DIR/ssh-agent.socket";
		EDITOR = "vim";
		LESSHISTFILE = "/dev/null";
		GNUPGHOME = "~/.config/gnupg";
		PYTHON3_HOST_PROG = "/usr/bin/env python3";
		CARGO_HOME = "$HOME/.config/cargo";
		RUSTUP_HOME = "$HOME/.config/rustup";
		GOPATH = "$HOME/.config/go";
	};
	
	programs.zsh = {
		
		enable = true;
		shellAliases = {
			
			# minimal settings
			c = "clear";
			ping = "ping -c4";
			g = "git";
			":e" = "$EDITOR";
			":q" = "exit";
			wget = "wget --no-hsts";
			ls = "ls --color=always --group-directories-first -h";
			cl = "clear && ls";
			la = "ls -A";
			ll = "ls -l";
		};
	};
	users.defaultUserShell = pkgs.zsh;
	
	# Enable the OpenSSH daemon.
	services.openssh = {
		
		enable = true;
		passwordAuthentication = false;
		permitRootLogin = "yes";
	};
	
	users.users.root.openssh.authorizedKeys.keys = [
		"ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIFiepHVWb7SVXSOISOIUgVauZY2Zyp0QTwsbqX8BhMZh le3kat@laptop"
	];
	users.users.nas.openssh.authorizedKeys.keys = [
		"ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIFiepHVWb7SVXSOISOIUgVauZY2Zyp0QTwsbqX8BhMZh le3kat@laptop"
	];
	
	# Open ports in the firewall.
	networking.firewall = {
		
		enable = true;
		allowedTCPPorts = [ 22 ];
		allowedUDPPorts = [ 22 ];
	};
	
	system.stateVersion = "22.11";
}
