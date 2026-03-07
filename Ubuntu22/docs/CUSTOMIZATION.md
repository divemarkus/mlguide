
# Shell Customization

Switch from Bash to Zsh for a more powerful shell experience.

1. Install Zsh:
   ```bash
   sudo apt install zsh -y
   ```

2. Change your default shell to Zsh:
   ```bash
   chsh -s $(which zsh)
   ```

3. Verify the change:
   ```bash
   echo $SHELL
   ```

4. Install Oh My Zsh and PowerLevel10k theme:
   - Visit [Oh My Zsh](https://ohmyz.sh/) for detailed instructions.
   - Clone the PowerLevel10k theme:
     ```bash
     git clone --depth=1 https://github.com/romkatv/powerlevel10k.git "$HOME/.oh-my-zsh/custom/themes/powerlevel10k"
     ```
   - Install Fonts:
     ```bash
     mkdir -p ~/.local/share/fonts
     cd ~/.local/share/fonts
     wget https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Regular.ttf
     wget https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Bold.ttf
     wget https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Italic.ttf
     wget https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Bold%20Italic.ttf
     ```

5. Configure Zsh settings in `~/.zshrc`:
   ```bash
   plugins=(git zsh-autosuggestions zsh-syntax-highlighting)
   ZSH_THEME="powerlevel10k/powerlevel10k"
   ```
   Apply changes:
   ```bash
   source ~/.zshrc
   fc-cache -fv
   p10k configure
   ```
