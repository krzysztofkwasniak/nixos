{ config, pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ./modules/packages.nix #pakiety
    ];


   # --- 1. Środowisko COSMIC ---
  services.displayManager.cosmic-greeter.enable = true;
  services.desktopManager.cosmic.enable = true;

  # Harmonogram procesów System76 (poprawia płynność i czas reakcji pulpitu)
  services.system76-scheduler.enable = true;

  # Zmienne środowiskowe dla schowka i natywnego trybu Wayland w aplikacjach Electron/Chromium
  environment.sessionVariables = {
    COSMIC_DATA_CONTROL_ENABLED = 1;
    NIXOS_OZONE_WL = "1";
COSMIC_DISABLE_DIRECT_SCANOUT = "y";
  };

  # --- 2. Konfiguracja grafiki AMD (Wayland / Vulkan / Akceleracja) ---
  boot.initrd.kernelModules = [ "amdgpu" ];
  services.xserver.videoDrivers = [ "amdgpu" ];

  hardware.graphics = {
    enable = true;
    enable32Bit = true; # Wymagane m.in. przez Steam, Wine oraz 32-bitowe biblioteki
  };

  # --- 3. Przydatne pakiety systemowe ---
  environment.systemPackages = with pkgs; [
    cosmic-ext-tweaks # Dodatkowe opcje personalizacji (np. zaawansowane motywy i panele)
    wl-clipboard      # Obsługa schowka z poziomu terminala
  ];

  # Zapobiega konfliktom motywów GTK/libadwaita w przeglądarce Firefox
  programs.firefox.preferences = {
    "widget.gtk.libadwaita-colors.enabled" = false;
  };

nix.settings.experimental-features = [ "nix-command" "flakes" ];


 services.xserver.inputClassSections = [
    ''
      Identifier "Marble Mouse"
      MatchProduct "Logitech USB Trackball"
      Driver "libinput"
      Option "ScrollMethod" "button"
      Option "ScrollButton" "9" #lewy maly 8 prawy maly
      Option "MiddleEmulation" "true"
    ''
  ];

    # =========================================================================
  # 1. BOOTLOADER I JĄDRO
  # =========================================================================
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.kernelPackages = pkgs.linuxPackages_latest;

  # =========================================================================
  # 2. SIEĆ I LOKALIZACJA
  # =========================================================================
  networking.hostName = "nixos";
  networking.networkmanager.enable = true;

  time.timeZone = "Europe/Warsaw";
  i18n.defaultLocale = "pl_PL.UTF-8";
  i18n.extraLocaleSettings = {
    LC_ADDRESS = "pl_PL.UTF-8";
    LC_IDENTIFICATION = "pl_PL.UTF-8";
    LC_MEASUREMENT = "pl_PL.UTF-8";
    LC_MONETARY = "pl_PL.UTF-8";
    LC_NAME = "pl_PL.UTF-8";
    LC_NUMERIC = "pl_PL.UTF-8";
    LC_PAPER = "pl_PL.UTF-8";
    LC_TELEPHONE = "pl_PL.UTF-8";
    LC_TIME = "pl_PL.UTF-8";
  };

  console.keyMap = "pl2";

  # =========================================================================
  # 3. ŚRODOWISKO GRAFICZNE I DŹWIĘK
  # =========================================================================
  services.xserver = {
    enable = true;
    xkb = {
      layout = "pl";
      variant = "";
    };
  };

 # services.displayManager.sddm.enable = true;
 # services.desktopManager.plasma6.enable = true;

  # Dźwięk (PipeWire)
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  # Sprzęt & Usługi pomocnicze
  hardware.bluetooth = {
    enable = true;
    powerOnBoot = false;
  };
  services.blueman.enable = true;
  services.printing.enable = true;
  services.flatpak.enable = true;
  services.gvfs.enable = true;

  # Wykrywanie urządzeń w sieci lokalnej (mDNS/Avahi)
  services.avahi = {
    enable = true;
    nssmdns4 = true;
    openFirewall = true;
  };

  # =========================================================================
  # 4. PROGRAMY SYSTEMOWE I WIRTUALIZACJA
  # =========================================================================
  programs.firefox.enable = true;

  programs.neovim = {
    enable = true;
    defaultEditor = true;
  };

  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true;
    dedicatedServer.openFirewall = true;
  };

  virtualisation.libvirtd.enable = true;
  programs.virt-manager.enable = true;

  # Zezwolenie na pakiety niewolne (Unfree)
  nixpkgs.config.allowUnfree = true;

  # =========================================================================
  # 5. UŻYTKOWNIK KK
  # =========================================================================
  users.users.kk = {
    isNormalUser = true;
    description = "kk";
    extraGroups = [ "networkmanager" "wheel" "libvirtd" "video" "render" ];
  #  packages = with pkgs; [

  #  ];
  };

  system.stateVersion = "25.05";
}
