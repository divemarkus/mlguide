
# macOS — SSH Key Migration and GitHub Access

This guide migrates existing SSH keys from a trusted MacBook to a new Mac mini, configures SSH authentication, verifies GitHub access, and clones the dotfiles repository.

**Security principles**

- Transfer private keys only through a trusted, encrypted channel.
- Never commit private keys to GitHub or store them in the dotfiles repository.
- Preserve existing keys rather than generating replacements unnecessarily.
- Verify GitHub's host key and the identity of the destination account.
- Use SSH agent integration and restrictive file permissions.

## 1. Identify SSH Keys on the MacBook

On the existing MacBook, inspect the SSH directory:

```bash
ls -la ~/.ssh
```

Typical files include:

```text
~/.ssh/
├── id_ed25519          # Private key
├── id_ed25519.pub      # Public key
├── config              # SSH client configuration
└── known_hosts         # Previously trusted SSH host keys
```

Your filenames may differ. Identify the actual key used for GitHub.

List public-key fingerprints:

```bash
for key in ~/.ssh/*.pub; do
  [ -f "$key" ] || continue
  ssh-keygen -lf "$key"
done
```

Check the active SSH configuration:

```bash
ssh -G github.com | grep -E '^(user|hostname|identityfile|identitiesonly) '
```

If you use a GitHub host alias, substitute that alias for `github.com`.

Check which key GitHub authentication currently uses:

```bash
ssh -vT git@github.com
```

Review the debug output for the identity offered. GitHub may return a successful authentication message even though it does not provide an interactive shell.

## 2. Transfer Keys to the Mac mini

### Option A — Direct transfer over the trusted LAN

On the Mac mini, create the SSH directory:

```bash
mkdir -p ~/.ssh
chmod 700 ~/.ssh
```

From the MacBook, copy the required private key, public key, and SSH configuration if applicable:

```bash
scp ~/.ssh/id_ed25519 ~/.ssh/id_ed25519.pub \
    ~/.ssh/config \
    <username>@<mac-mini-ip>:~/.ssh/
```

Replace the username, address, and filenames with your actual values.

**Important:** `scp` transfers private keys over SSH. First verify that the Mac mini's SSH host key is trusted and correct. Do not blindly accept an unexpected host-key prompt.

If the configuration file references other keys, certificates, or included configuration files, migrate those dependencies as well.

If you use a non-default private-key filename, substitute that filename in the command.

### Option B — Encrypted removable storage

If using an encrypted removable drive, copy the required files to it, transfer the drive to the Mac mini, and copy the files into `~/.ssh/`.

Do not use an unencrypted USB drive or an untrusted cloud-sync folder to transfer private keys.

After confirming the destination files are correct, remove temporary transfer copies and securely manage the removable media according to its encryption and storage capabilities.

## 3. Set Permissions on the Mac mini

On the Mac mini:

```bash
chmod 700 ~/.ssh
chmod 600 ~/.ssh/config
chmod 600 ~/.ssh/id_ed25519
chmod 644 ~/.ssh/id_ed25519.pub
```

Only run commands for files that exist. Repeat the appropriate private-key permissions for any additional private keys.

Verify:

```bash
ls -ld ~/.ssh
ls -l ~/.ssh
```

Expected permissions:

| Item | Permissions |
|---|---|
| `~/.ssh/` | `700` |
| Private key | `600` |
| Public key | `644` |
| `config` | `600` |
| `known_hosts` | `600` or more restrictive |

If `known_hosts` does not exist yet, SSH will create it when a host key is accepted.

## 4. Configure the SSH Agent and macOS Keychain

macOS supports SSH agent integration with Keychain. Configure the shell environment to use the system-provided SSH agent.

Inspect the current agent:

```bash
ssh-add -l
```

If the key is not loaded, add it:

```bash
ssh-add --apple-use-keychain ~/.ssh/id_ed25519
```

On macOS versions that support this option, the command adds the key to the agent and stores its passphrase in the login Keychain.

If your macOS release does not recognize `--apple-use-keychain`, check the installed `ssh-add` manual and use the supported alternative.

### SSH configuration

Review `~/.ssh/config` and ensure the GitHub host configuration references the correct key.

Example:

```sshconfig
Host github.com
    HostName github.com
    User git
    IdentityFile ~/.ssh/id_ed25519
    IdentitiesOnly yes
    AddKeysToAgent yes
    UseKeychain yes
```

`UseKeychain` is an Apple OpenSSH extension. If you use a custom SSH configuration across macOS and Linux, keep platform-specific options in a macOS-specific configuration or otherwise ensure non-Apple SSH clients do not encounter unsupported directives.

Do not replace an existing configuration blindly. Preserve required host aliases, work profiles, jump hosts, and other entries.

## 5. Verify GitHub Authentication

Test the connection:

```bash
ssh -T git@github.com
```

The first connection may prompt you to verify GitHub's host key.

Verify the fingerprint against GitHub's official documentation before accepting it:

https://docs.github.com/en/authentication/keeping-your-account-and-data-secure/githubs-ssh-key-fingerprints

A successful authentication message identifies the GitHub account associated with the accepted key. GitHub normally reports that it does not provide shell access; this is expected.

If authentication fails, use verbose output:

```bash
ssh -vT git@github.com
```

Check:

- The correct private key is being offered.
- The matching public key is registered with the intended GitHub account.
- File permissions are correct.
- The SSH configuration selects the expected identity.
- The agent has the key loaded.
- Network access to GitHub SSH is permitted.

If the public key is not registered with GitHub, add it through:

**GitHub → Settings → SSH and GPG keys → New SSH key**

Never upload a private key.

## 6. Clone the Dotfiles Repository

Create the desired repository directory:

```bash
mkdir -p ~/repos/personal
cd ~/repos/personal
```

Clone using the repository's SSH URL:

```bash
git clone git@github.com:<OWNER>/<REPOSITORY>.git dotfiles
```

Replace `<OWNER>` and `<REPOSITORY>` with the actual GitHub owner and repository name.

If the repository uses a different SSH host alias or URL, use the matching configured URL.

Enter the repository:

```bash
cd dotfiles
git status
git remote -v
git branch --show-current
```

Verify that:

- The repository is the expected one.
- The remote uses SSH rather than HTTPS, if SSH authentication is intended.
- The working tree is clean.
- The expected branch has been checked out.

## 7. Verify Git Identity and Repository Access

Inspect the effective Git configuration:

```bash
git config --show-origin --get user.name
git config --show-origin --get user.email
git config --show-origin --get core.sshCommand
```

Some commands may return no value if the setting is not configured.

Set the appropriate identity if necessary:

```bash
git config --global user.name "<YOUR_NAME>"
git config --global user.email "<YOUR_EMAIL>"
```

Use the email address appropriate for your GitHub commit-signing and privacy preferences.

Test repository read access:

```bash
git ls-remote origin
```

Test write access without modifying the repository:

```bash
git push --dry-run origin HEAD
```

A dry run checks the proposed push but does not guarantee every server-side rule or subsequent real push will succeed.

## 8. Final Verification

Run on the Mac mini:

```bash
ssh-add -l
ssh -T git@github.com

cd ~/repos/personal/dotfiles
git status
git remote -v
git ls-remote origin
```

Expected outcome:

- SSH keys are readable only by the intended user.
- GitHub authenticates the expected account.
- The repository uses the intended SSH remote.
- Repository read access succeeds.
- Git operations work without repeatedly entering the private-key passphrase, if Keychain integration is configured.

## References

- [GitHub — Connecting to GitHub with SSH](https://docs.github.com/en/authentication/connecting-to-github-with-ssh)
- [GitHub — SSH key fingerprints](https://docs.github.com/en/authentication/keeping-your-account-and-data-secure/githubs-ssh-key-fingerprints)
- [GitHub — Adding a new SSH key](https://docs.github.com/en/authentication/connecting-to-github-with-ssh/adding-a-new-ssh-key-to-your-github-account)
- [Apple — `ssh-add` manual](https://keith.github.io/xcode-man-pages/ssh-add.1.html)
