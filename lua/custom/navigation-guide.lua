-- Navigation and File Movement Guide for Neovim
-- This file contains useful navigation tips and commands

local function show_navigation_guide()
  local guide = [[
# FILE NAVIGATION

## Basic Movement
- `h` - Move left
- `j` - Move down  
- `k` - Move up
- `l` - Move right

## Word Movement
- `w` - Move to next word start
- `b` - Move to previous word start
- `e` - Move to next word end
- `ge` - Move to previous word end

## Line Movement
- `0` - Beginning of line
- `^` - First non-whitespace character
- `$` - End of line

## File Navigation
- `gg` - Top of file
- `G` - Bottom of file
- `:n` - Go to line number
- `%` - Go to matching bracket/paren

## Fast File Switching
- `<leader>ff` - Find files (Telescope)
- `<leader>fg` - Live grep in files
- `<leader>fb` - Switch between buffers
- `<leader>fr` - Recent files
- `<leader>s.` - Recent files (alternative)

# WINDOW MANAGEMENT

## Split Navigation
- `<C-h>` - Move to left window
- `<C-j>` - Move to lower window  
- `<C-k>` - Move to upper window
- `<C-l>` - Move to right window

## Creating Splits
- `<C-w>v` - Split vertical (vsplit)
- `<C-w>s` - Split horizontal (split)
- `<C-w>c` - Close current window
- `<C-w>q` - Quit current window
- `<C-w>o` - Close other windows (`<leader>o` alternative)

## Moving Between Windows
- `<C-w><C-w>` - Cycle through windows
- `<C-w>h/j/k/l` - Move to specific window direction
- `<C-w>t` - Move to top-left window
- `<C-w>b` - Move to bottom-right window

# BUFFER MANAGEMENT

## Buffer Navigation
- `<leader>1-5` - Go to specific buffer number
- `<C-6>` - Toggle between last two buffers
- `:bnext` / `:bn` - Next buffer
- `:bprev` / `:bp` - Previous buffer
- `:bdelete` / `:bd` - Delete buffer

# SEARCH AND REPLACE

## Searching Within Files
- `/pattern` - Search forward
- `?pattern` - Search backward
- `n` - Next match
- `N` - Previous match
- `*` - Search word under cursor forward
- `#` - Search word under cursor backward

## Searching Between Files
- `<leader>sg` - Live grep across all files
- `<leader>sw` - Search current word in all files
- `<leader>s/` - Search in open files only
- `<leader>sf` - Find files by name

# QUICK JUMPS

## Jump List
- `<C-o>` - Jump back in jump list
- `<C-i>` - Jump forward in jump list
- `:jumps` - Show jump list

## Change List  
- `g;` - Go to previous change
- `g,` - Go to next change
- `:changes` - Show change list

## Marks
- `m{a-z}` - Set local mark
- `m{A-Z}` - Set global mark
- ``{a-z}` - Go to local mark
- ``{A-Z}` - Go to global mark
- `:marks` - Show all marks

# LSP NAVIGATION (when configured)

- `grd` - Go to definition
- `gri` - Go to implementation  
- `grr` - Find references
- `grn` - Rename symbol
- `gra` - Code actions
- `gO` - Document symbols
- `gW` - Workspace symbols

# TIPS FOR FASTER NAVIGATION

1. Use `<leader>ff` (Telescope find files) instead of opening files manually
2. Use `<leader>sg` (live grep) to search across all project files
3. Use `<C-o>` and `<C-i>` to jump between locations
4. Use marks (`ma` and ``a`) for frequently visited locations
5. Use buffer numbers (`<leader>1-5`) for quick switching
6. Use `<leader>o` to close all other windows when focusing on one file
7. Use `%` to jump between matching brackets quickly
8. Use `*` and `#` to search for the current word under cursor

# DOCKER PHP DEBUGGING

Your config includes automatic PHP container detection:
- Use `<F5>` to start debugging
- Use `<leader>b` to set breakpoints
- The config automatically finds containers with 'php' in the name
]]
  
  -- Create a new buffer to display the guide
  local buf = vim.api.nvim_create_buf(false, true)
  vim.api.nvim_buf_set_lines(buf, 0, -1, false, vim.split(guide, '\n'))
  vim.api.nvim_buf_set_option(buf, 'filetype', 'text')
  vim.api.nvim_buf_set_option(buf, 'modifiable', false)
  
  -- Display the guide in a new window
  vim.cmd('split')
  vim.api.nvim_win_set_buf(0, buf)
  vim.api.nvim_buf_set_name(buf, 'Navigation Guide')
end

-- Create a keymap to show the navigation guide
vim.keymap.set('n', '<leader>ng', show_navigation_guide, { desc = '[N]avigation [G]uide' })

return {
  show_navigation_guide = show_navigation_guide,
}