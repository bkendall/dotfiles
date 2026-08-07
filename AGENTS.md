# AGENTS.md - Context & Instructions for AI Agents

This document provides context, architectural design details, and guidelines for AI agents (Cline, Cursor, Copilot Workspace, etc.) working on this repository.

---

## 1. Repository Architecture

- **`install.sh`**:
  - Main entrypoint script for installing and diagnosing dotfiles on macOS and Linux.
  - Supports `--install` (or default) for symlinking configurations and `--doctor` (or `-d`) for running health checks.
  - Written in portable Bash using `printf` formatting. Must remain non-interactive and scriptable for CI environments.
- **`shell/`**:
  - `shell/zshrc`: Main Zsh configuration file (sourced from `~/.zshrc`). Sets up Oh My Zsh plugins, persistent 50k history (`SHARE_HISTORY`), Go/tooling PATHs, and dynamic `~/.ssh/config.d/*.config` stitching.
  - `shell/zsh/themes/bryankendall.zsh-theme`: Minimalist custom prompt displaying background jobs (`§`), Git status/SHA, working directory, host, and return code arrow (`»`).
- **`vim/`**:
  - `vim/vimrc`: Main Vim configuration file (sourced from `~/.vimrc`). Auto-bootstraps `vim-plug` if missing, configures `vim-lsp` + `vim-lsp-settings` for async LSP support, auto-format on save, and sets up Solarized dark theme.
  - `vim/colors/`, `vim/ftdetect/`, `vim/ftplugin/`, `vim/syntax/`: Syntax and color support files.
- **`git/`**:
  - `git/.gitconfig`: Git global configuration with modern defaults (`init.defaultBranch = main`, `pull.rebase = true`, `branch.sort = -committerdate`) and custom aliases.
  - `git/.githelpers`: Gary Bernhardt's `pretty_git_log` bash helper function formatting git log output into aligned, colorized columns.
  - `git/.gitignore`: Global git ignore file.
  - `git/.gitk`: Gitk UI preferences.
- **`.github/workflows/ci.yml`**:
  - GitHub Actions workflow running `./install.sh --install` and `./install.sh --doctor` on Linux (`ubuntu-latest`) and macOS (`macos-latest`) runners across all branches.

---

## 2. Core Guidelines & Constraints

1. **Cross-Platform Compatibility**:
   - All shell scripts and configurations must work seamlessly on both macOS and Linux (Debian/Ubuntu/Fedora/Alpine).
2. **No Hardcoded Paths**:
   - Never hardcode user home paths (e.g. `/Users/username` or `/home/username`). Always use `$HOME`, `~`, or `${DOTFILES:-$HOME/dotfiles}`.
3. **Non-Interactive Execution**:
   - `install.sh` must be able to run non-interactively in automated CI runners or headless setups.
4. **Validation Requirements**:
   - Whenever modifying shell configs or scripts, validate syntax before committing:
     - `bash install.sh --doctor`
     - `zsh -n shell/zshrc`
     - `vim -u ~/.vimrc -c "qall!"`

---

## 3. Backlog & Ideas for Future Enhancements

The following tasks are pre-planned ideas for future development:

- [ ] **Neovim Support**:
  - Add native Neovim Lua config (`~/.config/nvim/init.lua`) or ensure `install.sh` automatically links `~/.config/nvim/init.vim` -> `$DOTFILES_DIR/vim/vimrc`.
- [ ] **Modern CLI Tool Integrations (Conditional)**:
  - Add optional detection and keybindings for modern CLI tools in `shell/zshrc` if installed:
    - **`fzf`**: Fuzzy finding for history and file searches.
    - **`zoxide`**: Smart `cd` replacement (`z`).
    - **`ripgrep`** (`rg`): Fast grep replacement.
    - **`eza`** / **`bat`**: Modern `ls` / `cat` with syntax highlighting and icons.
- [ ] **Modular Shell Config**:
  - Refactor `shell/zshrc` into sub-files if complexity grows (e.g. `shell/env.zsh`, `shell/aliases.zsh`, `shell/history.zsh`).
- [ ] **Starship Prompt Alternative**:
  - Provide an optional toggle or check for `starship` prompt while preserving the fallback custom `bryankendall.zsh-theme`.
