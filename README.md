# .config-nvim — Minimalist Neovim Setup for Programmers

This repository contains a **minimal yet powerful Neovim configuration** tailored for programmers who want speed, clarity, and essential developer features without bloat. It provides syntax highlighting, file navigation, and intelligent code actions with TypeScript/JavaScript LSP enhancements.

---

## ✨ Features

* Syntax highlighting for:

  * TypeScript / JavaScript (TS, JS, TSX, JSX)
  * C++
  * Java
  * HTML / CSS
* File explorer via **NvimTree**
* Icons via **mini.icons**
* JetBrains Mono Nerd Font support (required)
* Minimal configuration (no bloat)
* TypeScript/JavaScript enhanced LSP actions (VS Code–like experience)

---

## 📦 Requirements

1. **Neovim 0.9+**
2. **JetBrains Mono Nerd Font** (for icons)
3. Node.js (for TypeScript language server)
4. Git (for plugin installation)

---

## 🚀 Installation

Clone this repository into your Neovim config directory:

```bash
# Backup your old config first
mv ~/.config/nvim ~/.config/nvim.backup

# Clone minimal config
git clone https://github.com/YOUR_USERNAME/.config-nvim ~/.config/nvim

# Launch Neovim
nvim
```

On first launch, plugins will install automatically.

---

## 🔑 Keybindings

### 🖥️ General LSP (works across languages)

| Key          | Action                                   |
| ------------ | ---------------------------------------- |
| `gd`         | Go to definition                         |
| `gD`         | Go to declaration                        |
| `gi`         | Go to implementation                     |
| `gr`         | List references (via Telescope/quickfix) |
| `K`          | Hover documentation                      |
| `<leader>rn` | Rename symbol                            |
| `<leader>ca` | Code actions (quick fixes, refactors)    |

### 📘 TypeScript/JavaScript-Specific (vtsls)

These mappings only activate inside TypeScript/JavaScript buffers.

| Key                       | Action                       | Usage Notes                                            |
| ------------------------- | ---------------------------- | ------------------------------------------------------ |
| **`gD`**                  | Go to **source definition**  | Jump to actual implementation source (not just type).  |
| **`gR`**                  | Find all **file references** | Shows where the file is referenced across the project. |
| **`<leader>co`**          | Organize imports             | Cleans and sorts imports.                              |
| **`<leader>cM`**          | Add missing imports          | Auto-imports any missing symbols.                      |
| **`<leader>cu`**          | Remove unused imports        | Deletes unused imports.                                |
| **`<leader>cD`**          | Fix all diagnostics          | Applies all auto-fixable issues.                       |
| **`<leader>cV`**          | Select TypeScript version    | Choose between workspace/global TypeScript.            |
| **Move file refactoring** | Move a file & update imports | Prompts you to pick a new destination.                 |

### 📂 File Navigation

| Key         | Action                          |
| ----------- | ------------------------------- |
| `<leader>e` | Toggle file explorer (NvimTree) |

---

## 🖋️ Fonts & Icons

* Install **[JetBrains Mono Nerd Font](https://www.nerdfonts.com/font-downloads)**
* Configure your terminal to use it
* This ensures icons render correctly in NvimTree and statuslines

---

## ⚡ Quick Start

1. Install dependencies
2. Clone repo
3. Launch Neovim → plugins install automatically
4. Open a project and start coding 🚀

---

## 📌 Notes

* This config is intentionally minimal. Extend it to taste.
* Designed for productivity with TypeScript-heavy workflows.
* Works out of the box for multiple languages without extra setup.

---

## 🛠️ Future Enhancements

* Statusline (lualine or feline)

---

Happy coding with **minimalist Neovim** 👨‍💻🔥
