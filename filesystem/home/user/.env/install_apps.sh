#!/bin/sh

PKGS=(
    gparted                        "GParted partition editor"                  off
    wget                           "Download files"                            off
    zip                            "Zip files"                                 off
    unzip                          "Unzip files"                               off
    ansi2html                      "Convert ANSI to HTML"                      off
    gnome-keyring                  "GNOME keyring"                             off
    polkit-gnome                   "PolicyKit authentication agent"            off
    neofetch                       "System info tool"                          off
    catfish                        "File search utility"                       off
    bitwarden                      "Password manager"                          off
    keepass                        "Password manager"                          off
    gigolo                         "Manage remote files"                       off
    filezilla                      "FTP client"                                off
    baobab                         "Disk usage analyzer"                       off
    bleachbit                      "System cleaner"                            off
    nvim                           "Neovim editor"                             off
    mousepad                       "Text editor"                               off
    leafpad                        "Text editor"                               off
    notable-bin                    "Markdown note-taking"                      off
    obsidian                       "Note-taking app"                           off
    atril                          "Document viewer"                           off
    pdftk                          "PDF toolkit"                               off
    xournalpp                      "PDF annotation"                            off
    meld                           "Diff & merge tool"                         off
    zeal                           "Offline documentation browser"             off
    octave                         "GNU Octave"                                off
    visual-studio-code-bin         "VS Code"                                   off
    vscodium-bin                   "VSCodium"                                  off
    pulsar-bin                     "Pulsar editor"                             off
    rstudio-desktop-bin            "RStudio"                                   off
    arduino-ide-bin                "Arduino IDE"                               off
    pycharm-community-edition      "PyCharm CE"                                off
    thonny                         "Python IDE"                                off
    qucs-s                         "Circuit simulator"                         off
    fritzing                       "Circuit design"                            off
    kikad                          "KiCad EDA"                                 off
    kikad-library                  "KiCad libraries"                           off
    kikad-library-3d               "KiCad 3D libraries"                        off
    chromium                       "Chromium browser"                          off
    google-chrome                  "Google Chrome"                             off
    firefox                        "Firefox browser"                           off
    librewolf-bin                  "LibreWolf browser"                         off
    mullvad-browser-bin            "Mullvad Browser"                           off
    brave                          "Brave browser"                             off
    vivaldi                        "Vivaldi browser"                           off
    transmission-gtk               "Transmission torrent client"               off
    zoom                           "Zoom video calls"                          off
    telegram-desktop-bin           "Telegram"                                  off
    slack-desktop                  "Slack"                                     off
    signal-desktop-beta-bin        "Signal"                                    off
    vlc                            "VLC media player"                          off
    lmms                           "Music production"                          off
    audacity                       "Audio editor"                              off
    gcolor2                        "Color picker"                              off
    pinta                          "Image editor"                              off
    gimp                           "GIMP image editor"                         off
    inkscape                       "Vector graphics editor"                    off
    blender                        "3D software"                               off
    shotcut                        "Video editor"                              off
    libreoffice-fresh              "LibreOffice"                               off
    onlyoffice-bin                 "OnlyOffice"                                off
    zotero-bin                     "Reference manager"                         off
    virtualbox                     "VirtualBox"                                off
    virtualbox-host-modules-arch   "VirtualBox kernel modules"                 off
    virtualbox-host-modules-dkms   "VirtualBox DKMS modules"                   off
    mullvad-vpn                    "Mullvad VPN"                               off
    rpi-imager-bin                 "Raspberry Pi Imager"                       off
    lxappearance-gtk3              "GTK theme editor"                          off
    docker                         "Docker"                                    off
    distrobox                      "Distrobox"                                 off
    tigervnc                       "VNC server"                                off
    sshfs                          "SSH filesystem"                            off
    fuse2                          "FUSE support"                              off
    syncthing                      "Sync files"                                off
    megacmd-bin                    "MEGA command-line client"                  off
    ollama                         "AI model manager"                          off
    cups                           "Print server (CUPS)"                       off
    sane                           "Scanner framework (SANE)"                  off
    sane-airscan                   "Network‑scanner backend for SANE"          off
    ipp-usb                        "USB‑to‑IPP bridge daemon"                  off
    xsane                          "Graphical front‑end for scanning (SANE)"   off
)


SELECTION_INSTALL=$(dialog --title "Install packages" \
    --separate-output --checklist "Select packages:" 30 100 20 \
    "${PKGS[@]}" 3>&1 1>&2 2>&3)
clear
for PKG in $SELECTION_INSTALL; do
    yay -S --needed --noconfirm $PKG
done
echo
echo "Done!"
read -p "Press Enter to continue..."


