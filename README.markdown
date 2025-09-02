# NixOS Configuration for DeMoD Communication Framework Development

This repository provides a NixOS configuration optimized for development with the [DeMoD Communication Framework (DCF)](https://github.com/ALH477/DeMoD-Communication-Framework), specifically tailored for the Framework 16-inch 7040 AMD laptop but generalized for other hardware. It supports networking programming with the D-LISP SDK, a modern Hyprland Wayland desktop, and optional gaming support via Steam. The configuration includes `openvscode-server` for LLM-integrated coding (e.g., GitHub Copilot) and is designed for developers working on IoT, P2P networking, and Lisp-based projects.

## Features

- **Networking Development**:
  - Full support for DCF’s D-LISP SDK with Common Lisp (SBCL) and dependencies (`cffi`, `cl-grpc`, `cl-lorawan`, etc.).
  - System libraries for DCF transports (`libserialport`, `can-utils`, `lksctp-tools`, `cjson`, `ncurses`, `libuuid`).
  - Networking tools: `wireshark`, `tcpdump`, `nmap`, `netcat`, `mininet`, `ns3`.
  - Python and Perl bindings for DCF interoperability (`grpcio`, `GoogleProtocolBuffersDynamic`).
- **Development Environment**:
  - `openvscode-server` for LLM integration (e.g., GitHub Copilot via API key).
  - Tools: `git`, `git-lfs`, `gh`, `gcc`, `rustc`, `cargo`, `go`, `cmake`, `kicad`.
  - Automated Quicklisp setup for D-LISP.
- **Desktop Environment**:
  - Hyprland with Wayland, including `wofi`, `waybar`, `hyprpaper`, `mako`, `wl-clipboard`, `grim`, `slurp`.
  - Fallback X11 support with Cinnamon and DWM.
- **Hardware Support**:
  - Optimized for Framework 16-inch 7040 AMD with `nixos-hardware` and `fw-fanctrl`.
  - Generalized for other hardware by making Framework modules optional.
- **Optional Gaming**:
  - Steam, Proton, GameMode, Lutris, and Wine (enabled via `custom.steam.enable`).
- **System Management**:
  - Docker for containerized testing.
  - Weekly garbage collection for system maintenance.
  - Fingerprint authentication and power management.

## Prerequisites

- NixOS 25.05 or later with Flakes enabled.
- Framework 16-inch 7040 AMD laptop (optional; configuration is generalized).
- Internet access for fetching dependencies and Quicklisp.
- (Optional) GitHub Copilot or other LLM API key for `openvscode-server`.

## Installation

1. **Clone the Repository**:
   ```bash
   git clone https://github.com/<your-username>/nixos-dcf-config
   cd nixos-dcf-config
   ```

2. **Generate Hardware Configuration** (if not using Framework 16):
   ```bash
   sudo nixos-generate-config --dir .
   ```

3. **Apply the Configuration**:
   ```bash
   sudo nixos-rebuild switch --flake .#nixos
   ```

4. **Enable Optional Features** (e.g., Steam):
   Edit `configuration.nix` and set:
   ```nix
   custom.steam.enable = true;
   ```
   Then rebuild:
   ```bash
   sudo nixos-rebuild switch --flake .#nixos
   ```

5. **Set Up Quicklisp**:
   Quicklisp is automatically installed for the `asher` user on first login. To verify:
   ```bash
   sbcl --eval '(ql:quickload :cffi)' --quit
   ```

6. **Configure OpenVSCode Server**:
   Start the server as the `asher` user:
   ```bash
   openvscode-server --port 3000
   ```
   Access at `http://localhost:3000`, install the GitHub Copilot extension, and authenticate with your API key.

7. **Test DCF**:
   Clone the DCF repository:
   ```bash
   git clone --recurse-submodules https://github.com/ALH477/DeMoD-Communication-Framework
   cd DeMoD-Communication-Framework
   ```
   Load and run the D-LISP example:
   ```bash
   sbcl --load lisp/src/d-lisp.lisp --eval '(d-lisp:main "quick-start-client" "lisp/config.json")'
   ```

## Notes

- **Zigbee/LoRaWAN**: The DCF D-LISP SDK requires `libzigbee` and `liblorawan` for specific transports, which are not in nixpkgs. Use Docker or create custom derivations (see `docker-compose.yml` example in the repository).
- **Hyprland Customization**: Edit `~/.config/hypr/hyprland.conf` for custom keybindings or settings.
- **Framework-Specific Modules**: Enable Framework support by setting:
  ```nix
  hardware.framework.enable = true;
  hardware.fw-fanctrl.enable = true;
  ```
- **Docker for DCF Testing**: Use the provided `docker-compose.yml` for testing DCF with Zigbee/LoRaWAN libraries.

## Directory Structure

```
nixos-dcf-config/
├── flake.nix               # Flake configuration
├── configuration.nix       # Main NixOS configuration
├── hardware-configuration.nix  # Hardware-specific settings (generate with nixos-generate-config)
├── README.md              # This file
├── LICENSE                # MIT License
├── CONTRIBUTING.md        # Contribution guidelines
└── docker/
    └── docker-compose.yml  # Docker setup for DCF testing
```

## Contributing

Contributions are welcome! Please follow these steps:
1. Fork the repository.
2. Create a feature branch (`git checkout -b feature/your-feature`).
3. Commit changes (`git commit -m "Add your feature"`).
4. Push to the branch (`git push origin feature/your-feature`).
5. Open a Pull Request.

See `CONTRIBUTING.md` for detailed guidelines.

## License

This project is licensed under the MIT License. See `LICENSE` for details.

## Acknowledgments

- **DeMoD LLC**: For the DeMoD Communication Framework.
- **NixOS Community**: For nixpkgs, nixos-hardware, and tools.
- **Framework**: For open hardware design enabling this configuration.