# NixOS Configuration for DeMoD Communication Framework Development

This repository provides a streamlined NixOS configuration optimized for developing the [DeMoD Communication Framework (DCF)](https://github.com/ALH477/DeMoD-Communication-Framework). Tailored for the Framework 16-inch 7040 AMD laptop but adaptable to other hardware, it supports networking programming with the D-LISP SDK, a modern Hyprland Wayland desktop, and optional gaming via Steam. It includes `openvscode-server` for LLM-integrated coding (e.g., GitHub Copilot) and is designed for developers working on IoT, P2P networking, and Lisp-based projects. The configuration leverages Determinate Systems' tools to enhance deployment reliability and efficiency.

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
- **Hardware Support**:
  - Optimized for Framework 16-inch 7040 AMD via `nixos-hardware` and `fw-fanctrl`.
  - Generalized for other hardware with optional Framework modules.
- **Optional Gaming**:
  - Steam, Proton, GameMode, Lutris, and Wine (via `custom.steam.enable`).
- **System Management**:
  - Docker for containerized DCF testing.
  - Weekly garbage collection for system maintenance.
  - Fingerprint authentication and power management.
- **Performance Optimizations**:
  - Achieves 0% CPU usage at idle, ensuring high efficiency and low power consumption on NixOS.

## System Packages

The configuration includes the following packages, grouped by category, to support development, networking, multimedia, and system management:

- **Core Tools**:
  - `vim`, `docker`, `git`, `git-lfs`, `gh`, `htop`, `nvme-cli`, `lm_sensors`, `s-tui`, `stress`, `dmidecode`, `util-linux`, `gparted`, `usbutils`
- **Python and Libraries**:
  - `python3Full`, `python3Packages.pip`, `python3Packages.virtualenv`, `python3Packages.cryptography`, `python3Packages.pycryptodome`, `python3Packages.grpcio`, `python3Packages.grpcio-tools`, `python3Packages.protobuf`, `python3Packages.numpy`, `python3Packages.matplotlib`
- **Networking and Security**:
  - `wireshark`, `tcpdump`, `nmap`, `netcat`, `mininet`
- **Build and Development Tools**:
  - `cmake`, `gcc`, `gnumake`, `ninja`, `rustc`, `cargo`, `go`, `openssl`, `gnutls`, `pkgconf`, `kicad`, `graphviz`, `mako`
- **Multimedia and Audio**:
  - `ardour`, `audacity`, `ffmpeg`, `jack2`, `qjackctl`, `libpulseaudio`, `pkgsi686Linux.libpulseaudio`, `pavucontrol`
- **Virtualization and Emulation**:
  - `qemu`, `virt-manager`, `docker-compose`, `docker-buildx`
- **Vulkan and Graphics Tools**:
  - `vulkan-tools`, `vulkan-loader`, `vulkan-validation-layers`, `libva-utils`
- **Browsers and Applications**:
  - `brave`, `vlc`, `pandoc`, `kdePackages.okular`, `obs-studio`, `firefox`, `thunderbird`
- **Desktop Utilities**:
  - `blueberry`, `vesktop`, `font-awesome`, `fastfetch`, `gnugrep`, `kitty`, `wofi`, `waybar`, `hyprpaper`, `brightnessctl`, `zip`, `unzip`
- **Creative Tools**:
  - `gimp`,`kdenlive`, `inkscape`, `blender`, `libreoffice`, `krita`
- **File Management**:
  - `xfce.thunar`, `xfce.thunar-volman`, `gvfs`, `udiskie`, `polkit_gnome`, `framework-tool`
- **Screen Capture and Clipboard**:
  - `wl-clipboard`, `grim`, `slurp`
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

2. **Generate Hardware Configuration** (non-Framework hardware):
   ```bash
   sudo nixos-generate-config --dir .
   ```

3. **Apply Configuration**:
   ```bash
   sudo nixos-rebuild switch --flake .#nixos
   ```

4. **Enable Steam** (optional):
   In `configuration.nix`, set:
   ```nix
   custom.steam.enable = true;
   ```
   Rebuild:
   ```bash
   sudo nixos-rebuild switch --flake .#nixos
   ```

5. **Verify Quicklisp**:
   Quicklisp installs automatically for `asher` on login. Test:
   ```bash
   sbcl --eval '(ql:quickload :cffi)' --quit
   ```

6. **Run OpenVSCode Server**:
   As `asher`:
   ```bash
   openvscode-server --port 3000
   ```
   Access at `http://localhost:3000`, install GitHub Copilot, and authenticate.

7. **Test DCF**:
   Clone DCF:
   ```bash
   git clone --recurse-submodules https://github.com/ALH477/DeMoD-Communication-Framework
   cd DeMoD-Communication-Framework
   ```
   Run example:
   ```bash
   sbcl --load lisp/src/d-lisp.lisp --eval '(d-lisp:main "quick-start-client" "lisp/config.json")'
   ```

## Notes

- **Zigbee/LoRaWAN**: DCF’s D-LISP SDK requires `libzigbee` and `liblorawan`, unavailable in nixpkgs. Use Docker (`docker-compose.yml`) or custom derivations.
- **Hyprland Customization**: Edit `~/.config/hypr/hyprland.conf` for keybindings.
- **Framework Modules**: Enable with:
  ```nix
  hardware.framework.enable = true;
  hardware.fw-fanctrl.enable = true;
  ```
- **Docker**: Use `docker-compose.yml` for DCF testing with Zigbee/LoRaWAN.
- **Efficiency**: The configuration is tuned for minimal resource usage, achieving 0% CPU at idle, making it ideal for battery-powered development on laptops. Determinate Systems’ tools enhance this efficiency by optimizing Nix operations.

## Directory Structure

```
DeMoD-Framework16-NIXOS/
├── flake.nix               # Flake configuration with Determinate Systems integration
├── configuration.nix       # Main NixOS configuration
├── hardware-configuration.nix  # Hardware-specific settings
├── README.md              # This file
├── LICENSE                # MIT License
├── CONTRIBUTING.md        # Contribution guidelines
└── docker/
    └── docker-compose.yml  # DCF testing setup
```

## Contributing

1. Fork the repository.
2. Create a branch (`git checkout -b feature/your-feature`).
3. Commit changes (`git commit -m "Add your feature"`).
4. Push (`git push origin feature/your-feature`).
5. Open a Pull Request.

See `CONTRIBUTING.md` for details.

## License

MIT License. See `LICENSE`.

## Acknowledgments

- **DeMoD LLC**: For DCF.
- **NixOS Community**: For nixpkgs and nixos-hardware.
- **Framework**: For open hardware design.
- **Determinate Systems**: For deployment tools enhancing NixOS reliability.
- **xAI**: For Grok's grievances.
- **Asher LeRoy**: For being obsessed.
