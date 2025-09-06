# NixOS Configuration for DeMoD Communication Framework Development

This repository provides a streamlined NixOS configuration optimized for developing the [DeMoD Communication Framework (DCF)](https://github.com/ALH477/DeMoD-Communication-Framework). Tailored for the Framework 16-inch 7040 AMD laptop but adaptable to other hardware, it supports networking programming with the D-LISP SDK, a modern Hyprland Wayland desktop, and optional gaming via Steam. It includes `openvscode-server` for LLM-integrated coding (e.g., GitHub Copilot) and is designed for developers working on IoT, P2P networking, and Lisp-based projects.

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
