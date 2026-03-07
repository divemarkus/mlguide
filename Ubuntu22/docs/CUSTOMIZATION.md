
# Shell Customization

Switch from Bash to Zsh for a more powerful shell experience. This file captures the common customization steps used in the Ubuntu22 guide.

## Table of Contents
1. [Install Zsh](#install-zsh)  
2. [Change Default Shell](#change-default-shell)  
3. [Oh My Zsh & PowerLevel10k](#oh-my-zsh--powerlevel10k)  
4. [Configure Zsh](#configure-zsh)

---

## 🧩 Install Zsh
1. Install Zsh:
```bash
sudo apt install zsh -y
```

## 🔁 Change Default Shell
2. Change your default shell to Zsh:
```bash
chsh -s $(which zsh)
```

Verify the change:
```bash
echo $SHELL
```

## 🎨 Oh My Zsh & PowerLevel10k
4. Install Oh My Zsh and PowerLevel10k theme:
- Visit https://ohmyz.sh/ for instructions.
- Clone the PowerLevel10k theme:
```bash
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git "$HOME/.oh-my-zsh/custom/themes/powerlevel10k"
```

Install fonts:
```bash
mkdir -p ~/.local/share/fonts
cd ~/.local/share/fonts
wget https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Regular.ttf
wget https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Bold.ttf
wget https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Italic.ttf
wget https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Bold%20Italic.ttf
```

## ⚙️ Configure Zsh
5. Configure `~/.zshrc`:
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
