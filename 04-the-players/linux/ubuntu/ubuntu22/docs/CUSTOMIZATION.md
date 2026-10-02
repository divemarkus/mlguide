
# Shell Customization

Switch from Bash to Zsh for a more powerful shell experience. This file captures the common customization steps used in the Ubuntu22 guide.

## Table of Contents
1. [Install Zsh](#install-zsh)  
2. [Change Default Shell](#change-default-shell)  
3. [Oh My Zsh & PowerLevel10k](#oh-my-zsh-powerlevel10k)  
4. [Configure Zsh](#configure-zsh)

---

<a id="install-zsh"></a>
## 🧩 Install Zsh
1. Install Zsh:
```bash
sudo apt install zsh -y
```

<a id="change-default-shell"></a>
## 🔁 Change Default Shell
2. Change your default shell to Zsh:
```bash
chsh -s $(which zsh)
```

Verify the change:
```bash
echo $SHELL
```

<a id="oh-my-zsh-powerlevel10k"></a>
## 🎨 Oh My Zsh & PowerLevel10k
3. Install Oh My Zsh and PowerLevel10k theme:
- Visit https://ohmyz.sh/ for instructions. **Do this first before proceeding**
- Clone the PowerLevel10k theme:
```bash
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git "$HOME/.oh-my-zsh/custom/themes/powerlevel10k"
```

4. Install fonts:
```bash
mkdir -p ~/.local/share/fonts
cd ~/.local/share/fonts
wget https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Regular.ttf
wget https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Bold.ttf
wget https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Italic.ttf
wget https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Bold%20Italic.ttf
```

5. Install plugins:
- Auto-suggestions
```bash
git clone https://github.com/zsh-users/zsh-autosuggestions \
  ~/.oh-my-zsh/custom/plugins/zsh-autosuggestions
```
- Syntax-highlighting
```bash
git clone https://github.com/zsh-users/zsh-syntax-highlighting \
  ~/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting
```
- More plugins can be installed. See oh-my-zsh write-up.


<a id="configure-zsh"></a>
## ⚙️ Configure Zsh
6. Configure `~/.zshrc`:
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
