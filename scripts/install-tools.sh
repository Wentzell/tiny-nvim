#!/bin/bash

# Check if mise is installed, if not install it
if ! command -v mise &> /dev/null; then
    echo "Installing mise..."
    curl https://mise.run | sh
    # Add mise to shell
    echo '' >> ~/.bashrc
    echo 'eval "$(mise activate)"' >> ~/.bashrc
    echo '' >> ~/.zshrc  
    echo 'eval "$(mise activate)"' >> ~/.zshrc
    mkdir -p ~/.config/fish
    echo '' >> ~/.config/fish/config.fish
    echo 'eval "$(mise activate)"' >> ~/.config/fish/config.fish
    # Activate mise for current session
    eval "$(mise activate)"
fi

# Install tools with mise first
echo "Installing tools with mise..."
mise use -g \
  delta@latest \
  fzf@latest \
  fd@latest \
  gh@latest \
  lazygit@latest \
  lua-language-server@latest \
  ninja@latest \
  rg@latest \
  ruff@latest \
  rye@latest \
  stylua@latest \
  uv@latest

# Compiled software pieces
mise plugins add neovim
mise use -g \
  neovim@ref:release-0.11 \
  tmux@latest

  # Install tools with uv
echo "Installing tools with uv..."
uv tool install codespell
uv tool install pyright
uv tool install ruff
uv tool install cmake-language-server
uv tool install cmakelang  # Provides cmake-format

echo "All tools have been installed successfully!"
