# java-method-search.nvim

This Neovim plugin integrates with telescope.nvim and nvim-treesitter to enable interactive fuzzy finding and navigation through Java methods within a file.

[![asciicast](https://asciinema.org/a/0V6bFRxWP7EZNorV8Z0FPfuss.svg)](https://asciinema.org/a/0V6bFRxWP7EZNorV8Z0FPfuss)

### Installation ###
* Make sure you have Neovim v0.9.0 or greater. :exclamation:
* Dependecies: treesiter && telescope && plenary (telescope dep)
* Install using you plugin manager

`Vim-Plug`  
```lua
Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-telescope/telescope.nvim'

Plug 'nvim-treesitter/nvim-treesitter'

Plug 'jkeresman01/maven-test-runner.nvim'
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

## Keymapings ##

Set the keymapings as you see fit, here is one example:

```lua
local java_methods = require ("java-method-search")

vim.keymap.set("n", "<leader>j", function () java_methods.search() end)
```


