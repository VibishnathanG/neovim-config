# Neovim Master Cheatsheet

## 🎯 Navigation & Movement

| Shortcut | Keybinding | Usage | Shortcut | Keybinding | Usage |
|----------|-----------|-------|----------|-----------|-------|
| 1 | `w` | Jump to next word (punctuation) | 2 | `W` | Jump to next word (space-separated) |
| 3 | `b` | Jump back one word | 4 | `B` | Jump back (space-separated) |
| 5 | `e` | Jump to end of word | 6 | `E` | Jump to end of word (space) |
| 7 | `^` | Start of non-blank line | 8 | `$` | End of line |
| 9 | `0` | Start of line (absolute) | 10 | `g_` | Last non-blank char |
| 11 | `gg` | Jump to top of file | 12 | `G` | Jump to bottom of file |
| 13 | `19G` | Go to line 19 | 14 | `:19` | Go to line 19 (command) |
| 15 | `<PageUp>` | Jump to top + insert | 16 | `<PageDown>` | Jump to last line + insert |
| 17 | `<A-Left>` | Jump to line start (all modes) | 18 | `<A-Right>` | Jump to line end (all modes) |
| 19 | `%` | Jump to matching bracket | 20 | `)` | Jump to next sentence |

---

## 📂 File & Project Management

| Shortcut | Keybinding | Usage | Shortcut | Keybinding | Usage |
|----------|-----------|-------|----------|-----------|-------|
| 1 | `<S-e>` | Toggle file explorer | 2 | `<A-Home>` | Toggle tree + telescope |
| 3 | `<S-f><S-f>` | Find files in project | 4 | `<S-f><S-g>` | Grep text in project |
| 5 | `<S-c><S-f>` | Find files in current folder | 6 | `<S-f><S-h>` | Find files in HOME |
| 7 | `<S-f><S-s>` | Find files in custom path | 8 | `<S-t><S-s>` | Grep in custom path |
| 9 | `:e {file}` | Open/edit file | 10 | `:e.` | Browse files (netrw) |
| 11 | `:w` | Save current file | 12 | `:q` | Quit current file |
| 13 | `:wq` or `:x` | Save and quit | 14 | `:q!` | Force quit (no save) |
| 15 | `S` (capital) | Save all + quit | 16 | `Z` (capital) | Quit all NO save |

---

## 🪟 Window & Split Management

| Shortcut | Keybinding | Usage | Shortcut | Keybinding | Usage |
|----------|-----------|-------|----------|-----------|-------|
| 1 | `<A-v>` | Vertical split | 2 | `<A-h>` | Horizontal split |
| 3 | `<C-w>w` | Cycle through windows | 4 | `<C-w>p` | Jump to previous window |
| 5 | `<C-w>h` | Jump to left window | 6 | `<C-w>j` | Jump to down window |
| 7 | `<C-w>k` | Jump to up window | 8 | `<C-w>l` | Jump to right window |
| 9 | `<S-Home>` | Switch to next window | 10 | `<C-w>c` | Close current window |
| 11 | `<C-w>q` | Quit current window | 12 | `<C-w>o` | Close all others |
| 13 | `:close` | Close current window | 14 | `:only` | Keep only current window |
| 15 | `<S-PageUp>` | Jump to prev window + insert | 16 | `<S-PageDown>` | Jump to next window + insert |

---

## ✂️ Selection & Bulk Editing

| Shortcut | Keybinding | Usage | Shortcut | Keybinding | Usage |
|----------|-----------|-------|----------|-----------|-------|
| 1 | `v` | Visual character mode | 2 | `V` | Visual line mode |
| 3 | `<S-v>` or `<C-v>` | Visual block mode | 4 | `<C-a>` | Select all (Ctrl+A) |
| 5 | `<C-c>` | Copy all | 6 | `<C-x>` | Cut all |
| 7 | `<C-z>` | Delete all (no yank) | 8 | `y` | Yank (copy) in visual |
| 9 | `p` | Paste after cursor | 10 | `P` | Paste before cursor |
| 11 | `"*p` | Paste from system clipboard | 12 | `"*y` | Copy to system clipboard |

---

## 🗑️ Delete & Remove Operations

| Shortcut | Keybinding | Usage | Shortcut | Keybinding | Usage |
|----------|-----------|-------|----------|-----------|-------|
| 1 | `dd` | Delete line (yanks) | 2 | `:%d` | Delete all content |
| 3 | `D` or `d$` | Delete to end of line | 4 | `d0` | Delete to start of line |
| 5 | `dw` | Delete word (to start) | 6 | `daw` | Delete word + spaces |
| 7 | `db` | Delete backward one word | 8 | `de` | Delete to end of word |
| 9 | `dk` | Delete above + current line | 10 | `dj` | Delete below + current line |
| 11 | `dt{char}` | Delete till character | 12 | `d{` / `d}` | Delete to paragraph |
| 13 | `"{_}d` | Delete without yank (blackhole) | 14 | `x` | Delete single character |

---

## ✏️ Change & Replace

| Shortcut | Keybinding | Usage | Shortcut | Keybinding | Usage |
|----------|-----------|-------|----------|-----------|-------|
| 1 | `c` | Change (delete + insert) | 2 | `cw` | Change word |
| 3 | `caw` | Change word + spaces | 4 | `cc` or `S` | Change entire line |
| 5 | `c$` | Change to end of line | 6 | `c0` | Change from start |
| 7 | `ci"` | Change inside quotes | 8 | `ca"` | Change around quotes |
| 9 | `ci(` | Change inside parentheses | 10 | `ca(` | Change around parentheses |
| 11 | `ct{char}` | Change till character | 12 | `r` | Replace single character |
| 13 | `R` | Replace mode (overstrike) | 14 | `u` | Undo last change |
| 15 | `<C-r>` | Redo last undo | 16 | `U` | Undo all on line |

---

## 🔍 Search & Replace

| Shortcut | Keybinding | Usage | Shortcut | Keybinding | Usage |
|----------|-----------|-------|----------|-----------|-------|
| 1 | `/pattern` | Search forward | 2 | `?pattern` | Search backward |
| 3 | `n` | Next match | 4 | `N` | Previous match |
| 5 | `*` | Search word under cursor | 6 | `#` | Search word backward |
| 7 | `:%s/old/new/g` | Replace all in file | 8 | `:s/old/new/g` | Replace in current line |
| 9 | `:nohlsearch` | Remove highlight | 10 | `gn` | Select next match |
| 11 | `/\c` | Case insensitive search | 12 | `/\<word\>` | Whole word match |

---

## 🔤 Indentation & Formatting

| Shortcut | Keybinding | Usage | Shortcut | Keybinding | Usage |
|----------|-----------|-------|----------|-----------|-------|
| 1 | `>` (visual) | Indent right (repeatable) | 2 | `<` (visual) | Indent left (repeatable) |
| 3 | `>>` | Indent line right | 4 | `<<` | Indent line left |
| 5 | `==` | Auto-indent line | 6 | `gg=G` | Auto-indent entire file |
| 7 | `>j` | Indent current + next | 8 | `<k` | Unindent current + prev |
| 9 | `<C-d>` (insert) | Outdent in insert mode | 10 | `<C-t>` (insert) | Indent in insert mode |

---

## 🌳 Treesitter & Structural Editing

| Shortcut | Keybinding | Usage | Shortcut | Keybinding | Usage |
|----------|-----------|-------|----------|-----------|-------|
| 1 | `<Space>ss` | Start syntax selection | 2 | `<Space>si` | Expand selection |
| 3 | `<Space>sd` | Shrink selection | 4 | `vaf` | Select all of function |
| 5 | `vif` | Select inside function | 6 | `vac` | Select all of class |
| 7 | `vic` | Select inside class | 8 | `vab` | Select all of block |
| 9 | `vib` | Select inside block | 10 | `daf` | Delete entire function |
| 11 | `dac` | Delete entire class | 12 | `dab` | Delete entire block |
| 13 | `caf` | Change function | 14 | `cac` | Change class |
| 15 | `]f` / `[f` | Next / previous function | 16 | `]c` / `[c` | Next / previous class |
| 17 | `<Space>a` | Swap next parameter | 18 | `<Space>A` | Swap prev parameter |

---

## 🖥️ Terminal & System

| Shortcut | Keybinding | Usage | Shortcut | Keybinding | Usage |
|----------|-----------|-------|----------|-----------|-------|
| 1 | `<A-t>` | Toggle terminal split | 2 | In Terminal: `<Esc>` | Exit terminal mode |
| 3 | In Terminal: `i` | Enter insert/type | 4 | `:!{cmd}` | Run shell command |
| 5 | `:read !{cmd}` | Insert command output | 6 | `:shell` | Drop to shell |

---

## 🧪 Diagnostics & LSP

| Shortcut | Keybinding | Usage | Shortcut | Keybinding | Usage |
|----------|-----------|-------|----------|-----------|-------|
| 1 | `<S-d><S-t>` | Toggle diagnostics on/off | 2 | `:help` | Open help |
| 3 | `:help {keyword}` | Help for specific command | 4 | `:options` | Show all options |
| 5 | `:InspectTree` | View treesitter context | 6 | `:TSPlaygroundToggle` | Inspect syntax tree |

---

## 🎛️ Insert Mode Helpers

| Shortcut | Keybinding | Usage | Shortcut | Keybinding | Usage |
|----------|-----------|-------|----------|-----------|-------|
| 1 | `i` | Insert at cursor | 2 | `a` | Append after cursor |
| 3 | `I` | Insert at line start | 4 | `A` | Append at line end |
| 5 | `o` | New line below + insert | 6 | `O` | New line above + insert |
| 7 | `<C-h>` | Delete prev char (backspace) | 8 | `<C-w>` | Delete prev word |
| 9 | `<C-u>` | Delete to line start | 10 | `<C-k>` | Delete to line end |
| 11 | `<A-Left>` (insert) | Go to line start | 12 | `<A-Right>` (insert) | Go to line end |

---

## 🔗 Marks & Jumps

| Shortcut | Keybinding | Usage | Shortcut | Keybinding | Usage |
|----------|-----------|-------|----------|-----------|-------|
| 1 | `m{a-z}` | Set mark at current pos | 2 | `'{a-z}` | Jump to mark |
| 3 | `` `{a-z}`` | Jump to mark (exact column) | 4 | `:marks` | List all marks |
| 5 | `<C-o>` | Jump to previous location | 6 | `<C-i>` | Jump to next location |
| 7 | `<C-]>` | Jump to definition | 8 | `:jumps` | Show jump history |

---

## 📋 Buffer & Multiple Files

| Shortcut | Keybinding | Usage | Shortcut | Keybinding | Usage |
|----------|-----------|-------|----------|-----------|-------|
| 1 | `:bn` | Next buffer | 2 | `:bp` | Previous buffer |
| 3 | `:bd` | Delete buffer | 4 | `:b {n}` | Jump to buffer n |
| 5 | `:e {file}` | Open file | 6 | `:vs {file}` | Open in vertical split |
| 7 | `:sp {file}` | Open in horizontal split | 8 | `:buffers` | List all buffers |

---

## 🎮 Macros & Automation

| Shortcut | Keybinding | Usage | Shortcut | Keybinding | Usage |
|----------|-----------|-------|----------|-----------|-------|
| 1 | `q{a-z}` | Start macro recording | 2 | `q` | Stop recording |
| 3 | `@{a-z}` | Play macro | 4 | `@@` | Repeat last macro |
| 5 | `.` | Repeat last change | 6 | `:normal @a` | Apply macro to selection |

---

## 🧩 Visual Block Operations

| Shortcut | Keybinding | Usage | Shortcut | Keybinding | Usage |
|----------|-----------|-------|----------|-----------|-------|
| 1 | `<C-v>` | Enter visual block | 2 | `I` (block) | Insert all lines |
| 3 | `A` (block) | Append all lines | 4 | `r` (block) | Replace in all lines |
| 5 | `d` (block) | Delete block | 6 | `y` (block) | Copy block |
| 7 | `>` (block) | Indent block right | 8 | `<` (block) | Indent block left |

---

## 📌 Settings & Configuration

| Shortcut | Keybinding | Usage | Shortcut | Keybinding | Usage |
|----------|-----------|-------|----------|-----------|-------|
| 1 | `:set number` | Show line numbers | 2 | `:set nonumber` | Hide line numbers |
| 3 | `:set relativenumber` | Relative line numbers | 4 | `:set wrap` | Enable line wrap |
| 5 | `:set nowrap` | Disable line wrap | 6 | `:set mouse=a` | Enable mouse |
| 7 | `:set clipboard=unnamedplus` | Use system clipboard | 8 | `:set spell` | Enable spell check |

---

## ⚡ Most Common Power Combos

| Shortcut | Keybinding | Usage | Shortcut | Keybinding | Usage |
|----------|-----------|-------|----------|-----------|-------|
| 1 | `vaw` + `d` | Select + delete word | 2 | `vif` + `c` | Edit function body |
| 3 | `daf` | Delete entire function | 4 | `cac` | Rename class |
| 5 | `gg=G` | Format entire file | 6 | `:%s/old/new/g` | Find & replace all |
| 7 | `5dd` | Delete 5 lines | 8 | `yy` + `p` | Duplicate line |
| 9 | `d}` | Delete to next paragraph | 10 | `gn` + `c` | Change next match |

---

## 🚀 Quick Tips & Speed Hacks

| Shortcut | Keybinding | Usage | Shortcut | Keybinding | Usage |
|----------|-----------|-------|----------|-----------|-------|
| 1 | `<Home>` | Jump back to editor | 2 | `nvim` | Open project UI |
| 3 | `nvim {folder}` | Open folder in project UI | 4 | `nvim {file}` | Open file only |
| 5 | `.` | Repeat last change | 6 | `<C-z>` (terminal) | Suspend editor |
| 7 | `fg` (terminal) | Resume suspended editor | 8 | `q:` | Open command history |

---

**Legend:**
- `<A-*>` = Alt+key
- `<S-*>` = Shift+key  
- `<C-*>` = Ctrl+key
- `<Space>` = Spacebar (Leader key)
- `*` = Any key [a-z]
