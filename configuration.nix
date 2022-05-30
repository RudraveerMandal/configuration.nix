{ config, pkgs, lib, modulesPath, ... }:
{
  imports =
    [ <home-manager/nixos> (modulesPath + "/installer/scan/not-detected.nix") ];
  nixpkgs.config.allowBroken = true;
  nixpkgs.config.allowUnfree = true;
  hardware.bluetooth.enable = true;
  boot.kernelPackages = pkgs.linuxPackages_zen;
  nix = {
    package = pkgs.nixFlakes;
    extraOptions = ''
      experimental-features = nix-command flakes
    '';
  };
  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true; # Open ports in the firewall for Steam Remote Play
    dedicatedServer.openFirewall = true; # Open ports in the firewall for Source Dedicated Server
  };
  virtualisation = {
    waydroid. enable = true;
    lxd.enable = true;
  };
  boot.initrd.availableKernelModules = [ "xhci_pci" "ahci" "usb_storage" "sd_mod" "rtsx_pci_sdmmc" ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ "kvm-intel" ];
  boot.extraModulePackages = [ ];
  fileSystems."/" =
    { device = "/dev/disk/by-uuid/86a24b3b-8802-4768-a699-2043d3d182d7";
      fsType = "btrfs";
      options = [ "subvol=root" ];
    };
  fileSystems."/home" =
    { device = "/dev/disk/by-uuid/86a24b3b-8802-4768-a699-2043d3d182d7";
      fsType = "btrfs";
      options = [ "subvol=home" ];
    };
  fileSystems."/var" =
    { device = "/dev/disk/by-uuid/86a24b3b-8802-4768-a699-2043d3d182d7";
      fsType = "btrfs";
      options = [ "subvol=var" ];
    };
  fileSystems."/boot" =
    { device = "/dev/disk/by-uuid/6CC2-BB45";
      fsType = "vfat";
    };
  swapDevices =
    [ { device = "/dev/disk/by-uuid/22acad2e-296b-4eea-8657-31d7c7058b87"; }
    ];
  powerManagement.cpuFreqGovernor = lib.mkDefault "powersave";
  hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  networking.hostName = "lallantop";
  time.timeZone = "Asia/Kolkata";
  networking.networkmanager.enable = true;
  i18n.defaultLocale = "en_IN.UTF-8";
  console = {
    font = "Lat2-Terminus16";
    keyMap = "us";
  };
  services.xserver.enable = true;
  services.xserver.displayManager.defaultSession = "none+xmonad";
  services.xserver.windowManager = {
    xmonad.enable = true;
    xmonad.enableContribAndExtras = true;
    xmonad.extraPackages = hpkgs: [
    hpkgs.xmonad
    hpkgs.xmonad-contrib
    hpkgs.xmonad-extras
    ];
  };
  services.xserver.layout = "us";
  services.printing.enable = true;
  sound.enable = true;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };
  services.xserver.libinput.enable = true;
  users.users.magphi = {
     isNormalUser = true;
     extraGroups = [ "wheel" "networkmanager" "video" "audio" ];
  };
  environment.systemPackages = with pkgs; [
    neovim
    emacs
    ungoogled-chromium
    rofi
    git
    alacritty
    fish
    neofetch
    cmatrix
    bottom
    networkmanager 
    simplescreenrecorder
    qutebrowser
    pavucontrol
    unzip
    spotify
    home-manager
    wget
    bluez
    bluez-tools
  ];
  system.stateVersion = "unstable";
  home-manager.users.magphi = {
    home.file.".bashrc".text = ''
      [[ $- != *i* ]] && return
      alias ls='ls --color=auto'
      PS1='[\u@\h \W]\$ '
      export EDITOR="nvim"
      neofetch
      xinput set-prop "ETPS/2 Elantech Touchpad" "libinput Disable While Typing Enabled" 0
      export NVM_DIR="$HOME/.nvm"                         [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
      [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"
      export PATH="$PATH:$HOME/bin"
      [ -f "/home/magphi/.ghcup/env" ] && source "/home/magphi/.ghcup/env"
      fish
    '';
    home.file.".minecraft/config".source = ./.minecraft/config;
    home.file.".minecraft/resourcepacks".source = ./.minecraft/resourcepacks;
    home.file.".minecraft/shaderpacks".source = ./.minecraft/shaderpacks;
    home.file.".minecraft/mods".source = ./.minecraft/mods;
    home.file.".minecraft/options.txt".source = ./.minecraft/options.txt;
    home.file.".minecraft/server-resource-packs".source = ./.minecraft/server-resource-packs;
    home.file.".minecraft/XaeroWaypoints".source = ./.minecraft/XaeroWaypoints;
    home.file.".minecraft/XaeroWaypoints_BACKUP032021".source = ./.minecraft/XaeroWaypoints_BACKUP032021;
    home.file.".xinitrc".text = ''
      exec xmonad
    '';
    home.file.".config/dunst/dunstrc".text = ''
      [global]
      monitor = 0
      follow = mouse
      geometry = "300x60-15+46"
      indicate_hidden = yes
      shrink = yes
      transparency = 0
      notification_height = 0
      seperator_height = 2
      padding = 8
      horizontal_padding = 8
      frame_width = 3
      frame_color = #000000
      seperator_color = frame
      sort = yes
      idle_threshold = 120
      font = Museo Sans 10
      line_height = 0
      markup = full
      format = "<b>&s</b>/n%b"
      alignment = left
      show_age_threshold = 60
      word_wrap = yes
      ellipsize = middle
      ignore_newline = no
      stack_duplicates = true
      hide_duplicate_count = false
      show_indicators = yes
      icon_position = left
      max_icon_size = 32
      sticky_history = yes
      history_length = 20
      dmenu = /usr/bin/dmenu -p dunst:
      browser = /usr/bin/qutebrowser
      always_run_script = true
      title = Dunst
      class = Dunst
      startup_notification = false
      verbosity = mesg
      corner_radius = 8
      force_xinerama = false
      mouse_left_click = close_current
      mouse_middle_click = close_all
      mouse_right_click = do_action
      [experimental]
      per_monitor_dpi = false
      [shortcuts]
      close = ctrl+space
      close_all = ctrl+shift+space
      per_monitor_dpi = false
      close = ctrl+space
      close_all = ctrl+shift+space
      history = ctrl+grave
      context = ctrl+shift+grave
      [urgency_low]
      foreground = "#ffd5cd"
      background = "#121212"
      frame_colour = "#181A20"
      timeout = 10
      [urgency_normal]
      background = "#121212"
      foreground = "#ffd5cd"
      frame_color = "#181A20"
      timeout = 10
      [urgency_critical]
      background = "#121212"
      foreground = "#ffd5cd"
      frame_color = "#181A20"
      timeout = 0
    '';
    home.file.".config/greenclip.toml".text = ''
      [greenclip]
        blacklisted_applications = []
        enable_image_support = true
        history_file = "~/.cache/greenclip.history"
        image_cache_directory = "/tmp/greenclip"
        max_history_length = 50
        max_selection_size_bytes = 0
        static_history = ["Greenclip has been updated to v4.1, update your new config file at ~/.config/greenclip.toml"]
        trim_space_from_selection = true
        use_primary_selection_as_input = false
    '';
    home.file.".config/neofetch/config.conf".text = ''
      print_info() {
        info title
        info underline
        info "OS" distro
        info "Kernel" kernel
        info "Uptime" uptime
        info "Packages" packages
        info "Shell" shell
        info "DE" de
        info "WM" wm
        info "WM Theme" wm_theme
        info "Theme" theme
        info "Icons" icons
        info "Terminal" term
        info "Memory" memory
        info "Disk" disk
        info "Battery" battery
        info cols
      }
      title_fqdn="off"
      kernel_shorthand="off"
      distro_shorthand="off"
      os_arch="on"
      uptime_shorthand="on"
      memory_percent="on"
      memory_unit="mib"
      package_managers="on"
      shell_path="off"
      shell_version="on"
      speed_type="bios_limit"
      speed_shorthand="off"
      cpu_brand="on"
      cpu_speed="on"
      cpu_cores="logical"
      cpu_temp="off"
      gpu_brand="on"
      gpu_type="all"
      refresh_rate="off"
      gtk_shorthand="off"
      gtk2="on"
      gtk3="on"
      de_version="on"
      disk_show=('/' '/boot/efi')
      disk_subtitle="mount"
      disk_percent="on"
      colors=(distro)
      bold="on"
      underline_enabled="on"
      underline_char="-"
      seperator=":"
      block_range=(0 15)
      color_blocks="on"
      block_width=3
      block_height=1
      col_offset="auto"
      bar_char_elapsed="-"
      bar_char_total="="
      bar_border="on"
      bar_length=15
      bar_color_elapsed="distro"
      bar_color_total="distro"
      cpu_display="off"
      memory_display="off"
      battery_display="off"
      disk_display="off"
      image_backend="ascii"
      image_source="auto"
      ascii_distro="auto"
      ascii_colors=(distro)
      ascii_bold="on"
      image_loop="off"
      crop_mode="normal"
      crop_offset="center"
      image_size="auto"
      gap=3
      xoffset=0
      yoffset=0
      background_color=
      stdout="off"
    '';
    home.file.".config/qutebrowser/config.py".text = ''
      config.load_autoconfig(False)
      c.aliases = {'q': 'quit', 'w': 'session-save', 'wq': 'quit --save'}
      config.set('content.cookies.accept', 'all', 'chrome-devtools://*')
      config.set('content.cookies.accept', 'all', 'devtools://*')
      config.set('content.headers.user_agent', 'Mozilla/5.0 ({os_info}) AppleWebKit/{webkit_version} (KHTML, like Gecko) {upstream_browser_key}/{upstream_browser_version} Safari/{webkit_version}', 'https://web.whatsapp.com/')
      config.set('content.headers.user_agent', 'Mozilla/5.0 ({os_info}; rv:71.0) Gecko/20100101 Firefox/71.0', 'https://accounts.google.com/*')
      config.set('content.headers.user_agent', 'Mozilla/5.0 ({os_info}) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/99 Safari/537.36', 'https://*.slack.com/*')
      config.set('content.headers.user_agent', 'Mozilla/5.0 ({os_info}; rv:71.0) Gecko/20100101 Firefox/71.0', 'https://docs.google.com/*')
      config.set('content.headers.user_agent', 'Mozilla/5.0 ({os_info}; rv:71.0) Gecko/20100101 Firefox/71.0', 'https://drive.google.com/*')
      config.set('content.images', True, 'chrome-devtools://*')
      config.set('content.images', True, 'devtools://*')
      config.set('content.javascript.enabled', True, 'chrome-devtools://*')
      config.set('content.javascript.enabled', True, 'devtools://*')
      config.set('content.javascript.enabled', True, 'chrome://*/*')
      config.set('content.javascript.enabled', True, 'qute://*/*')
      c.downloads.location.directory = '~/Downloads'
      c.tabs.show = 'switching'
      c.url.default_page = 'https://google.com'
      c.url.start_pages = 'https://google.com'
      c.url.searchengines = {'ddg': 'https://duckduckgo.com/?q={}', 'am': 'https://www.amazon.com/s?k={}', 'aw': 'https://wiki.archlinux.org/?search={}', 'DEFAULT': 'https://www.google.com/search?q={}', 'hoog': 'https://hoogle.haskell.org/?hoogle={}', 're': 'https://www.reddit.com/r/{}', 'ub': 'https://www.urbandictionary.com/define.php?term={}', 'wiki': 'https://en.wikipedia.org/wiki/{}', 'yt': 'https://www.youtube.com/results?search_query={}'}
      c.colors.completion.fg = ['#9cc4ff', 'white', 'white']
      c.colors.completion.odd.bg = '#1c1f24'
      c.colors.completion.even.bg = '#232429'
      c.colors.completion.category.fg = '#e1acff'
      c.colors.completion.category.bg = 'qlineargradient(x1:0, y1:0, x2:0, y2:1, stop:0 #000000, stop:1 #232429)'
      c.colors.completion.category.border.top = '#3f4147'
      c.colors.completion.category.border.bottom = '#3f4147'
      c.colors.completion.item.selected.fg = '#282c34'
      c.colors.completion.item.selected.bg = '#ecbe7b'
      c.colors.completion.item.selected.match.fg = '#c678dd'
      c.colors.completion.match.fg = '#c678dd'
      c.colors.completion.scrollbar.fg = 'white'
      c.colors.downloads.bar.bg = '#282c34'
      c.colors.downloads.error.bg = '#ff6c6b'
      c.colors.hints.fg = '#282c34'
      c.colors.hints.match.fg = '#98be65'
      c.colors.messages.info.bg = '#282c34'
      c.colors.statusbar.normal.bg = '#282c34'
      c.colors.statusbar.insert.fg = 'white'
      c.colors.statusbar.insert.bg = '#497920'
      c.colors.statusbar.passthrough.bg = '#34426f'
      c.colors.statusbar.command.bg = '#282c34'
      c.colors.statusbar.url.warn.fg = 'yellow'
      c.colors.tabs.bar.bg = '#1c1f34'
      c.colors.tabs.odd.bg = '#282c34'
      c.colors.tabs.even.bg = '#282c34'
      c.colors.tabs.selected.odd.bg = '#282c34'
      c.colors.tabs.selected.even.bg = '#282c34'
      c.colors.tabs.pinned.odd.bg = 'seagreen'
      c.colors.tabs.pinned.even.bg = 'darkseagreen'
      c.colors.tabs.pinned.selected.odd.bg = '#282c34'
      c.colors.tabs.pinned.selected.even.bg = '#282c34'
      c.fonts.default_family = '"Source Code Pro"'
      c.fonts.default_size = '11pt'
      c.fonts.completion.entry = '11pt "Source Code Pro"'
      c.fonts.debug_console = '11pt "Source Code Pro"'
      c.fonts.prompts = 'default_size sans-serif'
      c.fonts.statusbar = '11pt "Source Code Pro"'
      config.bind('M', 'hint links spawn mpv {hint-url}')
      config.bind('Z', 'hint links spawn st -e youtube-dl {hint-url}')
      config.bind('t', 'set-cmd-text -s :open -t')
      config.bind('xb', 'config-cycle statusbar.show always never')
      config.bind('xt', 'config-cycle tabs.show always never')
      config.bind('xx', 'config-cycle statusbar.show always never;; config-cycle tabs.show always never')
      config.bind(',ap', 'config-cycle content.user_stylesheets ~/.config/qutebrowser/solarized-everything-css/css/apprentice/apprentice-all-sites.css ""')
      config.bind(',dr', 'config-cycle content.user_stylesheets ~/.config/qutebrowser/solarized-everything-css/css/darculized/darculized-all-sites.css ""')
      config.bind(',gr', 'config-cycle content.user_stylesheets ~/.config/qutebrowser/solarized-everything-css/css/gruvbox/gruvbox-all-sites.css ""')
      config.bind(',sd', 'config-cycle content.user_stylesheets ~/.config/qutebrowser/solarized-everything-css/css/solarized-dark/solarized-dark-all-sites.css ""')
      config.bind(',sl', 'config-cycle content.user_stylesheets ~/.config/qutebrowser/solarized-everything-css/css/solarized-light/solarized-light-all-sites.css ""')
    '';
    home.file.".config/rofi/config".text = ''
      rofi.theme:	Arc-Dark
      rofi.font:	Fira Code 22
    '';
  };
}
