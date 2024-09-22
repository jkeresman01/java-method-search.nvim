<div align="center">

  <h1>java-method-search.nvim</h1>
  <h6>Neovim plugin that makes navigation and searching through Java methods a lot easier.</h6>

[![Lua](https://img.shields.io/badge/Lua-blue.svg?style=for-the-badge&logo=lua)](http://www.lua.org)
[![Neovim 0.10](https://img.shields.io/badge/Neovim%200.10-green.svg?style=for-the-badge&logo=neovim)](https://neovim.io)
![Work In Progress](https://img.shields.io/badge/Work%20In%20Progress-orange?style=for-the-badge)

</div>

## Table of Contents

- [The problem](#problem)
- [The solution](#solution)
- [Functionalities](#functionalities)
- [Installation](#installation)
- [Key - mappings](#key-mappings)

## The problem :warning: <a name="problem"></a>  ##

You open your favorite editor, Neovim, and navigate to a new Java class you're unfamiliar with. You want to preview all available methods, easily search through them, and navigate to each one for exploration, but this seems impossible. 

## The solution :trophy: <a name="solution"></a>  ##

This Neovim plugin integrates with telescope.nvim and nvim-treesitter to enable interactive fuzzy finding and navigation through Java methods within a file.

[![asciicast](https://asciinema.org/a/0V6bFRxWP7EZNorV8Z0FPfuss.svg)](https://asciinema.org/a/0V6bFRxWP7EZNorV8Z0FPfuss)

### Functionalities :pick: <a name="functionalities"></a> ###

- [x] Fuzzy find trough all java methods in a class
- [x] Easily navigate to all java methods in a class
- [x] Preview all java methods in a class


### Installation :star:  <a name="installation"></a> ###
* Make sure you have Neovim v0.9.0 or greater. :exclamation:
* Dependecies: treesiter && telescope && plenary (telescope dep)
* Install using you plugin manager

***
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
***

## Key - mapings :musical_keyboard: <a name="key-mappings"></a> ##

Set the keymapings as you see fit, here is one example:

```lua
local java_methods = require ("java-method-search")

vim.keymap.set("n", "<leader>fm", function () java_methods.search() end)
```
***

| Key - map     | Action                                                             |
|---------------|--------------------------------------------------------------------|
| `<leader>fm`  | Search through Java methods within a file.                         |


