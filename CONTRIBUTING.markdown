# Contributing to NixOS DCF Configuration

Thank you for considering contributing to this NixOS configuration for DeMoD Communication Framework development! We welcome improvements, bug fixes, and new features.

## How to Contribute

1. **Fork the Repository**:
   ```bash
   git clone https://github.com/ALH477/DeMoD-Framework16-NIXOS
   cd nixos-dcf-config
   ```

2. **Create a Feature Branch**:
   ```bash
   git checkout -b feature/your-feature
   ```

3. **Make Changes**:
   - Modify `configuration.nix`, `flake.nix`, or other files.
   - Test changes locally: `sudo nixos-rebuild switch --flake .#nixos`.
   - Ensure compatibility with DCF and general hardware.

4. **Commit Changes**:
   - Use clear commit messages: `git commit -m "Add feature X to configuration.nix"`.

5. **Push and Open a Pull Request**:
   ```bash
   git push origin feature/your-feature
   ```
   - Open a PR on GitHub with a detailed description of changes.

## Guidelines

- **Code Style**: Follow NixOS conventions. Use `nixfmt` for formatting: `nixfmt *.nix`.
- **Testing**: Test changes on your system and include test results in the PR description.
- **Documentation**: Update `README.md` if your changes affect setup or usage.
- **Scope**: Focus on DCF, networking, or development-related improvements. Generalize hardware-specific changes where possible.

## Reporting Issues

- Use [GitHub Issues](https://github.com/<your-username>/nixos-dcf-config/issues) to report bugs or suggest features.
- Provide details: NixOS version, hardware, error messages, and reproduction steps.

## Community

Join discussions on the [NixOS Discourse](https://discourse.nixos.org/) or the [DeMoD LLC community forum](https://github.com/ALH477/DeMoD-Communication-Framework/discussions) for support.
