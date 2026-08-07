#!/usr/bin/env bash
#
# Dotfiles Install & Doctor Script
#

set -e

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Ensure Homebrew paths are in PATH for non-interactive installer sessions
if [ -d "/opt/homebrew/bin" ] && [[ ":$PATH:" != *":/opt/homebrew/bin:"* ]]; then
  export PATH="/opt/homebrew/bin:$PATH"
fi
if [ -d "/usr/local/bin" ] && [[ ":$PATH:" != *":/usr/local/bin:"* ]]; then
  export PATH="/usr/local/bin:$PATH"
fi

# ANSI Color Codes
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
BOLD='\033[1m'
NC='\033[0m' # No Color

print_header() {
  printf "\n%b=== %s ===%b\n" "${BLUE}${BOLD}" "$1" "${NC}"
}

ok() {
  printf " [%bOK%b] %s\n" "${GREEN}" "${NC}" "$1"
}

warn() {
  printf " [%bWARN%b] %s\n" "${YELLOW}" "${NC}" "$1"
}

fail() {
  printf " [%bFAIL%b] %s\n" "${RED}" "${NC}" "$1"
}

symlink_file() {
  local src="$1"
  local dst="$2"

  if [ -L "$dst" ]; then
    local current_target
    current_target="$(readlink "$dst")"
    if [ "$current_target" = "$src" ]; then
      ok "Symlink already points to $src: $dst"
      return
    else
      warn "Updating existing symlink $dst (was $current_target)"
      rm -f "$dst"
    fi
  elif [ -e "$dst" ]; then
    warn "Backing up existing file $dst to ${dst}.bak"
    mv "$dst" "${dst}.bak"
  fi

  ln -s "$src" "$dst"
  ok "Created symlink: $dst -> $src"
}

ensure_line_in_file() {
  local line="$1"
  local file="$2"

  if [ ! -f "$file" ]; then
    echo "$line" > "$file"
    ok "Created $file with configuration line."
  elif grep -Fq "$line" "$file"; then
    ok "Line already present in $file"
  else
    echo "" >> "$file"
    echo "$line" >> "$file"
    ok "Added configuration line to $file"
  fi
}

do_install() {
  print_header "Installing Dotfiles"
  echo "Dotfiles directory: $DOTFILES_DIR"

  # 1. Directory & Environment Setup
  print_header "1. Environment Setup"
  mkdir -p "$HOME/.vim/undodir" "$HOME/.vim/backup" "$HOME/.vim/autoload"
  ok "Ensured ~/.vim/undodir, ~/.vim/backup, and ~/.vim/autoload exist."

  if [ ! -f "$HOME/.vim/autoload/plug.vim" ]; then
    curl -fLo "$HOME/.vim/autoload/plug.vim" --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
    ok "Downloaded vim-plug to ~/.vim/autoload/plug.vim"
  fi

  # 2. Vim Setup
  print_header "2. Vim Configuration"
  mkdir -p "$HOME/.vim/undodir" "$HOME/.vim/backup"
  ok "Ensured ~/.vim/undodir and ~/.vim/backup exist."

  local vimrc_line="set runtimepath^=$DOTFILES_DIR/vim | runtime vimrc"
  ensure_line_in_file "$vimrc_line" "$HOME/.vimrc"

  # 3. Zsh & Prompt Setup
  print_header "3. Zsh Configuration"
  if ! command -v starship >/dev/null 2>&1; then
    if command -v brew >/dev/null 2>&1; then
      ok "Installing Starship prompt via Homebrew..."
      brew install starship || warn "Could not install Starship automatically via Homebrew."
    else
      warn "Starship prompt is not installed. Native Zsh vcs_info prompt fallback will be used."
    fi
  else
    ok "Starship prompt is already installed ($(command -v starship))"
  fi

  mkdir -p "$HOME/.config"
  symlink_file "$DOTFILES_DIR/shell/starship.toml" "$HOME/.config/starship.toml"

  local zshrc_line="source \"$DOTFILES_DIR/shell/zshrc\""
  ensure_line_in_file "$zshrc_line" "$HOME/.zshrc"

  # 4. Git Configs
  print_header "4. Git Configuration"
  symlink_file "$DOTFILES_DIR/git/.gitconfig" "$HOME/.gitconfig"
  symlink_file "$DOTFILES_DIR/git/.githelpers" "$HOME/.githelpers"
  symlink_file "$DOTFILES_DIR/git/.gitignore" "$HOME/.gitignore"
  if [ -f "$DOTFILES_DIR/git/.gitk" ]; then
    symlink_file "$DOTFILES_DIR/git/.gitk" "$HOME/.gitk"
  fi

  print_header "Installation Complete!"
  printf "%bRun './install.sh --doctor' to verify your setup.%b\n\n" "${GREEN}" "${NC}"
}

do_doctor() {
  local errors=0
  local warnings=0

  print_header "Running Dotfiles Doctor"
  echo "Dotfiles directory: $DOTFILES_DIR"

  # 1. System Requirements
  print_header "System Tools"
  for cmd in zsh git vim curl; do
    if command -v "$cmd" >/dev/null 2>&1; then
      ok "Command '$cmd' found: $(command -v "$cmd")"
    else
      fail "Command '$cmd' is missing from PATH."
      errors=$((errors + 1))
    fi
  done

  if [ "$SHELL" = "$(command -v zsh 2>/dev/null)" ] || [[ "$SHELL" == *"zsh"* ]]; then
    ok "Default shell is Zsh ($SHELL)"
  else
    warn "Default shell is not Zsh (current: $SHELL). Consider running: chsh -s \$(which zsh)"
    warnings=$((warnings + 1))
  fi

  # 2. Oh My Zsh & Theme
  print_header "Zsh & Oh My Zsh"
  if [ -d "$HOME/.oh-my-zsh" ]; then
    ok "Oh My Zsh installed at ~/.oh-my-zsh"
  else
    fail "Oh My Zsh is not installed at ~/.oh-my-zsh"
    errors=$((errors + 1))
  fi

  if command -v starship >/dev/null 2>&1; then
    ok "Starship prompt is installed ($(command -v starship))"
  else
    warn "Starship prompt is not installed. Using native Zsh vcs_info fallback prompt. (Install via: brew install starship)"
    warnings=$((warnings + 1))
  fi

  if [ -f "$HOME/.zshrc" ]; then
    if grep -q "shell/zshrc" "$HOME/.zshrc"; then
      ok "~/.zshrc correctly sources shell/zshrc"
    else
      warn "~/.zshrc exists but does not source shell/zshrc"
      warnings=$((warnings + 1))
    fi
  else
    fail "~/.zshrc does not exist"
    errors=$((errors + 1))
  fi

  # 3. Vim
  print_header "Vim Setup"
  if [ -f "$HOME/.vimrc" ]; then
    if grep -q "vimrc" "$HOME/.vimrc"; then
      ok "~/.vimrc references dotfiles/vim"
    else
      warn "~/.vimrc exists but does not reference dotfiles/vim"
      warnings=$((warnings + 1))
    fi
  else
    fail "~/.vimrc does not exist"
    errors=$((errors + 1))
  fi

  if [ -d "$HOME/.vim/undodir" ] && [ -d "$HOME/.vim/backup" ]; then
    ok "~/.vim/undodir and ~/.vim/backup exist"
  else
    warn "Vim undo/backup directories (~/.vim/undodir, ~/.vim/backup) missing"
    warnings=$((warnings + 1))
  fi

  # 4. Git Setup
  print_header "Git Configuration"
  for gitfile in .gitconfig .githelpers .gitignore; do
    if [ -e "$HOME/$gitfile" ] || [ -L "$HOME/$gitfile" ]; then
      ok "~/$gitfile is present"
    else
      fail "~/$gitfile is missing"
      errors=$((errors + 1))
    fi
  done

  local git_name
  local git_email
  git_name="$(git config --global user.name || true)"
  git_email="$(git config --global user.email || true)"

  if [ -n "$git_name" ]; then
    ok "Git global user.name: $git_name"
  else
    warn "Git global user.name is not set"
    warnings=$((warnings + 1))
  fi

  if [ -n "$git_email" ]; then
    ok "Git global user.email: $git_email"
  else
    warn "Git global user.email is not set"
    warnings=$((warnings + 1))
  fi

  # 5. Vim Plugins & LSP
  print_header "Vim Plugins & LSP"
  local plug_file="$HOME/.vim/autoload/plug.vim"
  if [ -f "$plug_file" ] || [ -f "$HOME/.local/share/nvim/site/autoload/plug.vim" ]; then
    ok "vim-plug plugin manager is installed"
  else
    warn "vim-plug is not installed yet. Launching Vim will auto-download it."
    warnings=$((warnings + 1))
  fi

  # Summary
  print_header "Doctor Summary"
  if [ $errors -eq 0 ] && [ $warnings -eq 0 ]; then
    printf "%bAll checks passed! Everything is configured properly.%b\n\n" "${GREEN}${BOLD}" "${NC}"
  elif [ $errors -eq 0 ]; then
    printf "%bPassed with %d warning(s). Run './install.sh' to fix missing configurations.%b\n\n" "${YELLOW}${BOLD}" "$warnings" "${NC}"
  else
    printf "%bFound %d error(s) and %d warning(s). Run './install.sh' to set up missing pieces.%b\n\n" "${RED}${BOLD}" "$errors" "$warnings" "${NC}"
  fi
}

show_help() {
  echo "Usage: ./install.sh [OPTION]"
  echo ""
  echo "Options:"
  echo "  --install, -i    Install dotfiles and symlink configs (default)"
  echo "  --doctor, -d     Run diagnostic checks on dotfiles setup"
  echo "  --help, -h       Show this help message"
}

case "${1:-}" in
  --doctor|-d|doctor)
    do_doctor
    ;;
  --install|-i|install|"")
    do_install
    ;;
  --help|-h|help)
    show_help
    ;;
  *)
    echo "Unknown option: $1"
    show_help
    exit 1
    ;;
esac

