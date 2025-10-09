# NixOS Configuration for DeMoD Communication Framework Development
```
  ___      __  __     ___          ___                 __      __       _     _  _ _      ___  ___ 
 |   \ ___|  \/  |___|   \  __ __ | __| _ __ _ _ __  __\ \    / /__ _ _| |__ | \| (_)_ __/ _ \/ __|
 | |) / -_) |\/| / _ \ |) | \ \ / | _| '_/ _` | '  \/ -_) \/\/ / _ \ '_| / / | .` | \ \ / (_) \__ \
 |___/\___|_|  |_\___/___/  /_\_\ |_||_| \__,_|_|_|_\___|\_/\_/\___/_| |_\_\ |_|\_|_/_\_\\___/|___/                                                                                                                                                                                                 
```
This repository provides a streamlined NixOS configuration optimized for developing the [DeMoD Communication Framework (DCF)](https://github.com/ALH477/DeMoD-Communication-Framework). Tailored for the Framework 16-inch 7040 AMD laptop but adaptable to other hardware, it supports networking programming with the D-LISP SDK, a modern Hyprland Wayland desktop, and optional gaming via Steam. It includes `openvscode-server` for LLM-integrated coding (e.g., GitHub Copilot) and is designed for developers working on IoT, P2P networking, and Lisp-based projects. The configuration leverages Determinate Systems' tools to enhance deployment reliability and efficiency.

## Power Efficiency: Achieving 0% CPU Usage at Idle

This configuration achieves 0% CPU usage at idle, ensuring minimal power consumption (typically 4-8W system-wide on Framework laptops) and optimal battery life for development. The following optimizations enable this efficiency:

- **Streamlined Kernel and Modules**: Uses `linuxPackages_latest` with minimal modules (`nvme`, `xhci_pci`, `thunderbolt`, etc.) and AMD microcode updates, enabling deep C-states (e.g., C6) for near-zero CPU activity.
- **Dynamic Power Profiles**: `power-profiles-daemon` enables runtime switching to "power-saver" mode, downclocking the AMD Ryzen CPU and leveraging the `amd-pstate` driver for efficient idle states.
- **Hardware-Specific Tuning**: Integrates `nixos-hardware` for Framework 16 AMD, with `amdgpu` parameters (`abmlevel=0`, `sg_display=0`) and `fw-fanctrl` to minimize GPU and fan wakeups.
- **Minimal Services**: Socket-activated services (e.g., Docker) and weekly garbage collection reduce background processes, avoiding unnecessary polling.
- **Efficient Graphics Stack**: Hyprland on Wayland with Mesa/AMDVLK drivers supports GPU power gating, minimizing compositing overhead.
- **Determinate Systems Integration**: Tools like `nix-dram` optimize Nix builds, ensuring clean system starts without lingering processes.
- **Event Handling**: `services.logind` ignores lid switch suspends for clamshell mode, preventing wakeups.

These factors, combined with NixOS's declarative purity, eliminate bloat and ensure the system remains idle, making it ideal for battery-powered development.

## Features

- **Networking Development**:
  - Full D-LISP SDK support with Common Lisp (SBCL) and dependencies (`cffi`, `cl-grpc`, `cl-lorawan`, etc.).
  - System libraries for DCF transports (`libserialport`, `can-utils`, `lksctp-tools`, `cjson`, `libuuid`).
  - Networking tools: `wireshark`, `tcpdump`, `nmap`, `netcat`, `mininet`.
  - Python/Perl bindings for DCF (`grpcio`, `GoogleProtocolBuffersDynamic`).
- **Development Environment**:
  - `openvscode-server` for LLM integration (e.g., GitHub Copilot).
  - Tools: `git`, `git-lfs`, `gh`, `gcc`, `rustc`, `cargo`, `go`, `cmake`, `kicad`.
  - Automated Quicklisp setup for D-LISP.
- **Desktop Environment**:
  - Hyprland Wayland with `wofi`, `waybar`, `hyprpaper`, `mako`, `wl-clipboard`, `grim`, `slurp`.
  - Fallback X11 support with Cinnamon and DWM.
  - Clamshell mode support: Automatically disables the internal laptop display (`eDP-2`) when the lid is closed, allowing use with an external monitor without suspending the system. Includes a manual toggle and failsafe restore.
- **Hardware Support**:
  - Optimized for Framework 16-inch 7040 AMD via `nixos-hardware` and `fw-fanctrl`.
  - Generalized for other hardware with optional Framework modules.
  - Virtual camera support via `v4l2loopback` kernel module for screen sharing and streaming applications.
- **Optional Gaming**:
  - Steam, Proton, GameMode, Lutris, and Wine (via `custom.steam.enable`).
- **System Management**:
  - Docker for containerized DCF testing.
  - Weekly garbage collection for system maintenance.
  - Fingerprint authentication and power management.

## System Packages

The configuration includes the following packages, grouped by category, to support development, networking, multimedia, and system management:

- **Core Tools**:
  - `vim`, `docker`, `git`, `git-lfs`, `gh`, `htop`, `nvme-cli`, `lm_sensors`, `s-tui`, `stress`, `dmidecode`, `util-linux`, `gparted`, `usbutils`
- **Python and Libraries**:
  - `python3Full`, `python3Packages.pip`, `python3Packages.virtualenv`, `python3Packages.cryptography`, `python3Packages.pycryptodome`, `python3Packages.grpcio`, `python3Packages.grpcio-tools`, `python3Packages.protobuf`, `python3Packages.numpy`, `python3Packages.matplotlib`
- **Networking and Security**:
  - `wireshark`, `tcpdump`, `nmap`, `netcat`, `mininet`
- **Build and Development Tools**:
  - `cmake`, `gcc`, `gnumake`, `ninja`, `rustc`, `cargo`, `go`, `openssl`, `gnutls`, `pkgconf`, `kicad`, `graphviz`, `mako`, `openscad`, `freecad`
- **Multimedia and Audio**:
  - `ardour`, `audacity`, `ffmpeg`, `jack2`, `qjackctl`, `libpulseaudio`, `pkgsi686Linux.libpulseaudio`, `pavucontrol`
- **Virtualization and Emulation**:
  - `qemu`, `virt-manager`, `docker-compose`, `docker-buildx`
- **Vulkan and Graphics Tools**:
  - `vulkan-tools`, `vulkan-loader`, `vulkan-validation-layers`, `libva-utils`
- **Doom 3 Source Port**:
  - `dhewm3`, `darkradiant`
- **Browsers and Applications**:
  - `brave`, `vlc`, `pandoc`, `kdePackages.okular`, `obs-studio`, `firefox`, `thunderbird`
- **Desktop Utilities**:
  - `blueberry`, `vesktop`, `font-awesome`, `fastfetch`, `gnugrep`, `kitty`, `wofi`, `waybar`, `hyprpaper`, `brightnessctl`, `zip`, `unzip`, `obsidian`
- **Creative Tools**:
  - `gimp`, `kdePackages.kdenlive`, `inkscape`, `blender`, `libreoffice`, `krita`
- **File Management**:
  - `xfce.thunar`, `xfce.thunar-volman`, `gvfs`, `udiskie`, `polkit_gnome`, `framework-tool`
- **Screen Capture and Clipboard**:
  - `wl-clipboard`, `grim`, `slurp`, `v4l2loopback` (kernel module for virtual webcam support)
- **Editors and Servers**:
  - `unstable.openvscode-server`
- **Language-Specific Packages**:
  - Perl: `JSON`, `GetoptLong`, `CursesUI`, `ModulePluggable`, `Appcpanminus`
  - SBCL: `cffi`, `cl-ppcre`, `cl-json`, `cl-csv`, `usocket`, `bordeaux-threads`, `log4cl`, `trivial-backtrace`, `cl-store`, `hunchensocket`, `fiveam`, `cl-dot`, `cserial-port`
- **Hardware and Protocol Libraries**:
  - `libserialport`, `can-utils`, `lksctp-tools`, `cjson`, `ncurses`, `libuuid`
- **Xorg Fallback**:
  - `xorg.xinit`
- **USB Flashing Tools**:
  - `unetbootin`, `popsicle`, `gnome-disk-utility`
- **Gaming (Optional, enabled via `custom.steam.enable`)**:
  - `steam`, `steam-run`, `linuxConsoleTools`, `lutris`, `wineWowPackages.stable`, `proton-ge-bin`

## Use Cases

- **IoT and P2P Networking Development**:
  - Develop and test DCF applications with D-LISP for protocols like Zigbee, LoRaWAN, and SCTP.
  - Use `mininet` for network simulation and `wireshark` for packet analysis.
- **Lisp-Based Development**:
  - Leverage SBCL and Quicklisp for rapid prototyping of DCF components.
  - Integrate with Python/Perl for cross-language interoperability.
- **Hardware Prototyping**:
  - Use `kicad` and system libraries for IoT hardware design on Framework or other platforms.
- **Coding with LLM Support**:
  - Run `openvscode-server` for GitHub Copilot or other LLM tools to enhance coding productivity.
- **Gaming and Multimedia**:
  - Enable Steam for gaming or use multimedia tools (`ardour`, `audacity`, `blender`) for creative projects.
  - Utilize `obs-studio` with `v4l2loopback` for virtual camera setups in streaming or video conferencing.
- **System Administration**:
  - Manage containers with Docker, monitor hardware with `s-tui`, and maintain system hygiene with automated garbage collection.

## Determinate Systems Usage

This configuration integrates tools from [Determinate Systems](https://determinate.systems/) to enhance the reliability, reproducibility, and efficiency of the NixOS deployment process. Specifically:

- **Determinate Nix Installer**: Included via the `determinate` input in `flake.nix`, this provides a robust installation mechanism for Nix, ensuring consistent setup across systems. It simplifies initial deployment and reduces errors during environment setup.
- **NixOS Module**: The `determinate.nixosModules.default` module, imported in `flake.nix`, enhances system configuration with tools like `nix-dram`, which optimizes Nix store operations and improves build performance. This contributes to the configuration’s efficiency, helping achieve 0% CPU usage at idle by minimizing background processes.
- **Benefits**: Determinate Systems’ tools streamline flake-based deployments, improve error handling, and provide diagnostic utilities, making the configuration more reliable for developers working on complex projects like DCF. They also ensure compatibility with the latest Nix features, aligning with the configuration’s use of NixOS 25.05 and `nixpkgs-unstable`.

## Prerequisites

- NixOS 25.05+ with Flakes enabled.
- Framework 16-inch 7040 AMD laptop (optional; configuration is hardware-agnostic).
- Internet access for dependencies and Quicklisp.
- (Optional) GitHub Copilot or LLM API key for `openvscode-server`.

## Installation

1. **Clone the Repository**:
   ```bash
   git clone https://github.com/ALH477/DeMoD-Framework16-NIXOS
   cd DeMoD-Framework16-NIXOS
   ```
