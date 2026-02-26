# 🎀 nya.dotfiles
<p align="center">
  <img src="images/2.gif" alt="Banner" width="100%">
  <br>
  <b>A sophisticated, high-performance Arch Linux environment.</b>
  <br>
  <i>Minimalism meets productivity through bspwm and i3-gaps.</i>
</p>

<p align="center">
  <a href="https://archlinux.org/"><img src="https://img.shields.io/badge/OS-Arch%20Linux-1793D1?style=for-the-badge&logo=arch-linux&logoColor=white" alt="Arch Linux"></a>
  <a href="https://github.com/baskerville/bspwm"><img src="https://img.shields.io/badge/WM-bspwm-000000?style=for-the-badge&logo=linux&logoColor=white" alt="bspwm"></a>
  <a href="https://github.com/i3/i3"><img src="https://img.shields.io/badge/WM-i3wm-E84D31?style=for-the-badge&logo=i3&logoColor=white" alt="i3wm"></a>
  <a href="https://www.gnu.org/software/bash/"><img src="https://img.shields.io/badge/Shell-Bash-4EAA25?style=for-the-badge&logo=gnu-bash&logoColor=white" alt="Bash"></a>
</p>

---

## 📸 Visual Showcase

Explore the interface and workflow.

<details>
  <summary>✨ Click to view screenshots</summary>
  <br>
  <p align="center">
    <img src="images/11.png" alt="App Launcher" width="48%">
    <img src="images/22.png" alt="System Usage" width="48%">
    <br>
    <img src="images/3.png" alt="Editor" width="48%">
    <img src="images/4.png" alt="Terminal" width="48%">
  </p>
</details>

---

## ⚡ Core Philosophy

| 🚀 **Performance** | 🎨 **Aesthetics** |
| :--- | :--- |
| **GPU Acceleration:** Utilizing Kitty and Picom for zero-lag rendering and tear-free windowing. | **Visual Polish:** Soft shadows, Gaussian blur, and a curated color palette for long-term comfort. |
| **⌨️ Efficiency** | **📂 Organization** |
| **Modal Control:** A keyboard-driven workflow powered by `sxhkd` to minimize mouse reliance. | **XDG Standard:** Clean `$HOME` directory following XDG Base Directory specifications. |

---

## 🛠️ Info

| Component | Choice |
| :--- | :--- |
| **Distro** | [Arch Linux](https://archlinux.org/) |
| **Window Managers** | `bspwm` (Main) / `i3-gaps` (Alternative) |
| **Hotkeys** | `sxhkd` |
| **Compositor** | `Picom` (Pijulius/Jonaburg fork) |
| **Terminals** | `Kitty` / `Xterm` |
| **Launchers** | `Rofi` / `Dmenu` |

---

## 🚀 Installation

> [!IMPORTANT]
> This installation script is designed for Arch Linux. It is recommended to review the `nya.sh` script before execution to ensure compatibility with your hardware.

```bash
# Clone the repository
git clone https://github.com/x11kitty/nya.git

# Navigate into the directory
cd nya

# Give execution permissions and run the installer
chmod +x nya.sh
./nya.sh
```
<div align="center">
  <img src="images/wifu.png" width="400" style="border-radius: 15px;" alt="Random Anime Character" />
  <p><i>"Code less. Automate more. ✨"</i></p>
</div>

### ⌨️ Keybindings

| Shortcut | Action |
| :--- | :--- |
| `Super + T` | Open Terminal |
| `Super + Q` | Close Windows |
| `Super + Shift + X` | Focus window in direction |
| `Super + R` | App Launcher (Rofi) |
| `Super + D` | App Launcher (Dmenu) |

---
