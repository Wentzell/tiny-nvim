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
  lazygit@latest \
  lua-language-server@latest \
  neovim@nightly \
  rg@latest \
  ruff@latest \
  rye@latest \
  stylua@latest \
  uv@latest

  # Install tools with uv
echo "Installing tools with uv..."
uv tool install codespell
uv tool install isort
uv tool install pyright
uv tool install ruff

echo "All tools have been installed successfully!"
