{ config, pkgs, lib, modulesPath, ... }:
let
  home-manager = builtins.fetchTarball "https://github.com/nix-community/home-manager/archive/master.tar.gz";
in
{
  imports =
    [ "${home-manager}/nixos" (modulesPath + "/installer/scan/not-detected.nix") ];
  nixpkgs.config.allowBroken = true;
  nixpkgs.config.allowUnfree = true;
  hardware.bluetooth.enable = true;
  nix = {
    package = pkgs.nixVersions.unstable;
  };
  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true;
    dedicatedServer.openFirewall = true;
  };
  virtualisation = {
    docker.enable = true;
  };
  boot = {
    kernelPackages = pkgs.linuxPackages_zen;
    initrd.availableKernelModules = [ "xhci_pci" "ahci" "usb_storage" "sd_mod" "rtsx_pci_sdmmc" ];
    kernelModules = [ "kvm-intel" ];
    loader.systemd-boot.enable = true;
    loader.efi.canTouchEfiVariables = true;
  };
  fileSystems = {
    "/" =
      { device = "/dev/sda3";
        fsType = "btrfs";
        options = [ "defaults" "ssd" ];
      };
    "/boot" =
      { device = "/dev/sda1";
        fsType = "vfat";
      };
    };
  swapDevices =
    [ { device = "/dev/sda2"; }
    ];
  powerManagement.cpuFreqGovernor = lib.mkDefault "powersave";
  hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
  networking.hostName = "lallantop";
  time.timeZone = "Asia/Kolkata";
  networking.networkmanager.enable = true;
  i18n.defaultLocale = "en_IN";
  console = {
    font = "Lat2-Terminus16";
    keyMap = "us";
  };
  sound.enable = true;
  security.rtkit.enable = true;
  services = {
    xserver = {
      enable = true;
      displayManager.defaultSession = "none+qtile";
      windowManager.qtile.enable = true;
      layout = "us";
      libinput.enable = true;
    };
    printing.enable = true;
    pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
    };
  };
  users = {
    mutableUsers = false;
    users.magphi = {
      isNormalUser = true;
      extraGroups = [ "wheel" "networkmanager" "video" "audio" "docker" ];
      initialHashedPassword = "$6$bAdD2kAwUHGKN8Iv$WwS4bvAV3L4fGdZ4JxNIVm85YIjqVZFhEDCgq0VlTwF.t4EH0h/2ab27.qzm8pvBdcDFd5unxtNXOMEzb8GZq/"; 
    };
    users.root.initialHashedPassword = "$6$bAdD2kAwUHGKN8Iv$WwS4bvAV3L4fGdZ4JxNIVm85YIjqVZFhEDCgq0VlTwF.t4EH0h/2ab27.qzm8pvBdcDFd5unxtNXOMEzb8GZq/";
  };
  environment.systemPackages = with pkgs; [
    chromium
    git
    alacritty
    fish
    neofetch
    networkmanager
    qutebrowser
    pavucontrol
    unzip
    spotify
    home-manager
    wget
    nodejs
    surrealdb
    shutter
    clang
  ];
  system.stateVersion = "22.05";
  home-manager.users.magphi = {
    home.stateVersion = "22.05";
    home.file = {
      ".bashrc".text = ''
        [[ $- != *i* ]] && return
        alias ls='ls --color=auto'
        PS1='[\u@\h \W]\$ '
        export EDITOR="nano"
        neofetch
        xinput set-prop "ETPS/2 Elantech Touchpad" "libinput Disable While Typing Enabled" 0
        fish 
      '';  
      ".minecraft/config".source = ./.minecraft/config;
      ".minecraft/resourcepacks".source = ./.minecraft/resourcepacks;
      ".minecraft/shaderpacks".source = ./.minecraft/shaderpacks;
      ".minecraft/mods".source = ./.minecraft/mods;
      ".minecraft/options.txt".source = ./.minecraft/options.txt;
      ".minecraft/server-resource-packs".source = ./.minecraft/server-resource-packs;
      ".minecraft/XaeroWaypoints".source = ./.minecraft/XaeroWaypoints;
      ".minecraft/XaeroWaypoints_BACKUP032021".source = ./.minecraft/XaeroWaypoints_BACKUP032021;
      ".xinitrc".text = ''
        exec qtile start
      '';
      ".config/qtile/config.py".text = ''
from libqtile import bar, layout, widget
from libqtile.config import Click, Drag, Group, Key, Match, Screen
from libqtile.lazy import lazy
from libqtile.utils import guess_terminal
mod = "mod4"
terminal = guess_terminal()
keys = [
	Key([mod], "h", lazy.layout.left(), desc="Move focus to left"),
      	Key([mod], "l", lazy.layout.right(), desc="Move focus to right"),
      	Key([mod], "j", lazy.layout.down(), desc="Move focus down"),
      	Key([mod], "k", lazy.layout.up(), desc="Move focus up"),
       	Key([mod], "space", lazy.layout.next(), desc="Move window focus to other window"),
       	Key([mod, "shift"], "h", lazy.layout.shuffle_left(), desc="Move window to the left"),
      	Key([mod, "shift"], "l", lazy.layout.shuffle_right(), desc="Move window to the right"),
      	Key([mod, "shift"], "j", lazy.layout.shuffle_down(), desc="Move window down"),
      	Key([mod, "shift"], "k", lazy.layout.shuffle_up(), desc="Move window up"),
	Key([mod, "control"], "h", lazy.layout.grow_left(), desc="Grow window to the left"),
      	Key([mod, "control"], "l", lazy.layout.grow_right(), desc="Grow window to the right"),
      	Key([mod, "control"], "j", lazy.layout.grow_down(), desc="Grow window down"),
      	Key([mod, "control"], "k", lazy.layout.grow_up(), desc="Grow window up"),
      	Key([mod], "n", lazy.layout.normalize(), desc="Reset all window sizes"),
      	Key(
		[mod, "shift"],
        	"Return",
		lazy.layout.toggle_split(),
        	desc="Toggle between split and unsplit sides of stack",
        ),
      	Key([mod], "Return", lazy.spawn(terminal), desc="Launch terminal"),
      	Key([mod], "Tab", lazy.next_layout(), desc="Toggle between layouts"),
      	Key([mod], "w", lazy.window.kill(), desc="Kill focused window"),
      	Key([mod, "control"], "r", lazy.reload_config(), desc="Reload the config"),
      	Key([mod, "control"], "q", lazy.shutdown(), desc="Shutdown Qtile"),
      	Key([mod], "r", lazy.spawncmd(), desc="Spawn a command using a prompt widget"),
]
groups = [Group(i) for i in "123456789"]
for i in groups:
        keys.extend(
        	[
        		Key(
        			[mod],
                  		i.name,
                  		lazy.group[i.name].toscreen(),
                  		desc="Switch to group {}".format(i.name),
              		),
              		Key(
                  		[mod, "shift"],
                  		i.name,
                  		lazy.window.togroup(i.name, switch_group=True),
                  		desc="Switch to & move focused window to group {}".format(i.name),
              		),
            	]
        )
layouts = [
	layout.Columns(border_focus_stack=["#d75f5f", "#8f3d3d"], border_width=4),
      	layout.Max(),
      	layout.Stack(num_stacks=2),
      	layout.Bsp(),
      	layout.Matrix(),
      	layout.MonadTall(),
    	layout.MonadWide(),
    	layout.RatioTile(),
    	layout.Tile(),
    	layout.TreeTab(),
    	layout.VerticalTile(),
    	layout.Zoomy(),
]
widget_defaults = dict(
	font="Cascadia Code",
	fontsize=12,
      	padding=3,
)
extension_defaults = widget_defaults.copy()
screens = [
	Screen(
        	bottom=bar.Bar(
              		[
                		widget.CurrentLayout(),
               			widget.GroupBox(),
                		widget.Prompt(),
        			widget.WindowName(),
                		widget.Chord(
                  			chords_colors={
                    				"launch": ("#ff0000", "#ffffff"),
                  			},
                  			name_transform=lambda name: name.upper(),
                		),
                		widget.TextBox("default config", name="default"),
                		widget.TextBox("Press &lt;M-r&gt; to spawn", foreground="#d75f5f"),
                		widget.Systray(),
                		widget.Clock(format="%Y-%m-%d %a %I:%M %p"),
                		widget.QuickExit(),
              		],
              		24,
        	),
	),
]
mouse = [
	Drag([mod], "Button1", lazy.window.set_position_floating(), start=lazy.window.get_position()),
      	Drag([mod], "Button3", lazy.window.set_size_floating(), start=lazy.window.get_size()),
      	Click([mod], "Button2", lazy.window.bring_to_front()),
]
dgroups_key_binder = None
dgroups_app_rules = []
follow_mouse_focus = True
bring_front_click = False
cursor_warp = False
floating_layout = layout.Floating(
	float_rules=[
        	*layout.Floating.default_float_rules,
            	Match(wm_class="confirmreset"),
            	Match(wm_class="makebranch"),
            	Match(wm_class="maketag"),
            	Match(wm_class="ssh-askpass"),
            	Match(title="branchdialog"),
            	Match(title="pinentry"),
      	]
)	
auto_fullscreen = True
focus_on_window_activation = "smart"
reconfigure_screens = True
auto_minimize = True
wl_input_rules = None
wmname = "Qtile"
      '';
      ".config/dunst/dunstrc".text = ''
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
      ".config/greenclip.toml".text = ''
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
      ".config/neofetch/config.conf".text = ''
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
        disk_show=('/nix' '/boot')
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
      ".config/alacritty.yml".text = ''
font:
  normal:
    family: Cascadia Code
    style: Regular
  bold:
    family: Cascadia Code
    style: Bold
  italic:
    family: Cascadia Code 
    style: Italic
  bold_italic:
    family: Cascadia Code
    style: Bold Italic
  size: 12.0
    '';
      ".config/qutebrowser/config.py".text = ''
config.load_autoconfig(False)
c.aliases = {'q': 'quit', 'w': 'session-save', 'wq': 'quit --save'}
c.fonts.default_family = '"Cascadia Code"'
c.fonts.default_size = '11pt'
c.fonts.completion.entry = '11pt "Cascadia Code"'
c.fonts.debug_console = '11pt "Cascadia Code"'
c.fonts.prompts = 'default_size sans-serif'
c.fonts.statusbar = '11pt "Cascadia Code"'
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
    };
  };
}
