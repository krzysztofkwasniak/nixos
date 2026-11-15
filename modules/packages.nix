
{ pkgs, ... }:

{

environment.systemPackages = with pkgs; [
    # Narzędzia systemowe i CLI

    bat
    fetch
    git
    ghostty
    htop
    mc
    unrar
    helix
    micro
    atop
    exiftool
    fastfetch
    google-chrome
    kdePackages.kate
    libreoffice-fresh
    ncdu
    gparted
    kdePackages.partitionmanager

    btop             # Nowoczesny menedżer zadań w terminalu
    p7zip            # Obsługa archiwów 7z
    rsync            # Do kopii zapasowych
    smartmontools    # Diagnostyka dysków (S.M.A.R.T.)
    curl             # Pobieranie z sieci
    wget             # Pobieranie z sieci
    nmap             # Skaner sieciowy


    # Multimedia i obróbka

    ffmpeg_6-full
    imagemagick
    kdePackages.dragon
    kdePackages.gwenview
    kdePackages.kdenlive
    mpv-unwrapped
    smplayer
    vlc
    mpv

    # Inne / Sterowniki

    mediawriter
    samsung-unified-linux-driver
  ];

  }
