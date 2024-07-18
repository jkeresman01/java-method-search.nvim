## The problem :warning: ##

You open your favorite editor, Neovim, and navigate to a new Java class you're unfamiliar with. You want to preview all available methods, easily search through them, and navigate to each one for exploration, but this seems impossible. 

## The solution :trophy: ##

This Neovim plugin integrates with telescope.nvim and nvim-treesitter to enable interactive fuzzy finding and navigation through Java methods within a file.

[![asciicast](https://asciinema.org/a/0V6bFRxWP7EZNorV8Z0FPfuss.svg)](https://asciinema.org/a/0V6bFRxWP7EZNorV8Z0FPfuss)

### Installation :star: ###
* Make sure you have Neovim v0.9.0 or greater. :exclamation:
* Dependecies: treesiter && telescope && plenary (telescope dep)
* Install using you plugin manager

`Vim-Plug`  
```lua
Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-telescope/telescope.nvim'

Plug 'nvim-treesitter/nvim-treesitter'

Plug 'jkeresman01/java-method-search.nvim'
```

`Packer`  
```lua

use {
  'nvim-telescope/telescope.nvim', tag = '0.1.8',
-- or                            , branch = '0.1.x',
  requires = { {'nvim-lua/plenary.nvim'} }
}

 use 'nvim-treesitter/nvim-treesitter'

 use 'jkeresman01/java-method-search.nvim'
```

## Keymapings :musical_keyboard: ##

Set the keymapings as you see fit, here is one example:

```lua
local java_methods = require ("java-method-search")

vim.keymap.set("n", "<leader>fm", function () java_methods.search() end)
```
***

| Keybind       | Action                                                             |
|---------------|--------------------------------------------------------------------|
| `<leader>fm`  | Search through Java methods within a file.                         |


