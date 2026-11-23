
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

  (writeShellScriptBin "rebuild" ''
      set -e

      # Przejdź do głównego katalogu Flake'a
      cd /etc/nixos

      # Dodaj wszystkie pliki (łącznie z podfolderem modules/)
      sudo git add .

      # Przebuduj system dla hosta 'nixos'
      echo "🚀 Przebudowuję NixOS..."
      sudo nixos-rebuild switch --flake /etc/nixos#nixos

      # Jeśli są zmiany, zrób commit i wyślij na GitHuba
      if ! sudo git diff --cached --quiet; then
        MSG="''${1:-Aktualizacja: $(date +'%Y-%m-%d %H:%M')}"
        sudo git commit -m "$MSG"
        echo "☁️ Wysyłam na GitHuba..."
        sudo git push
      else
        echo "✅ Brak zmian do wysłania na GitHuba."
      fi
    '')

  ];

  }
