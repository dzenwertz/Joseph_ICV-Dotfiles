-- Neovim Configuration - Minimalist & Elegant
-- Theme: Catppuccin Mocha
-- Package Manager: lazy.nvim (automatically installed on first run)

-- 1. Bootstrap lazy.nvim (package manager)
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"
  local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { "Error bootstrapping lazy.nvim:\n", "ErrorMsg" },
      { out, "WarningMsg" },
      { "\nPress any key to exit..." },
    }, true, {})
    vim.fn.getchar()
    os.exit(1)
  end
end
vim.opt.rtp:prepend(lazypath)

-- 2. General Editor Settings
vim.g.mapleader = " "         -- Space is the leader key
vim.opt.number = true         -- Show line numbers
vim.opt.relativenumber = true -- Relative line numbers for easier movement
vim.opt.mouse = "a"           -- Enable mouse support in all modes
vim.opt.ignorecase = true     -- Case insensitive search...
vim.opt.smartcase = true      -- ...unless search contains uppercase letters
vim.opt.tabstop = 4           -- Render tabs as 4 spaces
vim.opt.shiftwidth = 4        -- Indentation width
vim.opt.expandtab = true      -- Convert tabs to spaces
vim.opt.termguicolors = true  -- Enable 24-bit RGB colors
vim.opt.clipboard = "unnamedplus" -- Sync clipboard with system clipboard
vim.opt.wrap = false          -- Disable line wrapping
vim.opt.cursorline = true     -- Highlight the line under cursor
vim.opt.signcolumn = "yes"    -- Always show sign column (prevents screen jumps)

-- 3. Custom Keymaps (shortcuts)
local map = vim.keymap.set
-- Space + e opens/closes file explorer
map("n", "<leader>e", ":NvimTreeToggle<CR>", { desc = "Toggle File Explorer", silent = true })
-- Telescope fuzzy search shortcuts
map("n", "<leader>ff", ":Telescope find_files<CR>", { desc = "Find Files", silent = true })
map("n", "<leader>fg", ":Telescope live_grep<CR>", { desc = "Grep Search", silent = true })
map("n", "<leader>fb", ":Telescope buffers<CR>", { desc = "Find Buffers", silent = true })
-- Window Navigation (Ctrl + h/j/k/l)
map("n", "<C-h>", "<C-w>h", { desc = "Move to Left Window" })
map("n", "<C-j>", "<C-w>j", { desc = "Move to Bottom Window" })
map("n", "<C-k>", "<C-w>k", { desc = "Move to Top Window" })
map("n", "<C-l>", "<C-w>l", { desc = "Move to Right Window" })

-- 4. Plugin Setup
require("lazy").setup({
  -- Catppuccin Mocha Color Theme
  {
    "catppuccin/nvim",
    name = "catppuccin",
    priority = 1000,
    config = function()
      require("catppuccin").setup({
        flavour = "mocha",
        transparent_background = true, -- Looks beautiful with Kitty blur!
        integrations = {
          treesitter = true,
          nvimtree = true,
          telescope = { enabled = true },
          gitsigns = true,
        }
      })
      vim.cmd.colorscheme("catppuccin-mocha")
    end
  },

  -- Lualine (Beautiful Status Bar at the bottom)
  {
    "nvim-lualine/lualine.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      require("lualine").setup({
        options = {
          theme = "catppuccin",
          component_separators = { left = "|", right = "|" },
          section_separators = { left = "", right = "" },
        }
      })
    end
  },

  -- Nvim-Tree (File Explorer Sidebar)
  {
    "nvim-tree/nvim-tree.lua",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      require("nvim-tree").setup({
        sort_by = "case_sensitive",
        view = {
          width = 30,
        },
        renderer = {
          group_empty = true,
        },
        filters = {
          dotfiles = false,
        },
      })
    end
  },

  -- Telescope (Fuzzy Finder Search Engine)
  {
    "nvim-telescope/telescope.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
      require("telescope").setup({
        defaults = {
          file_ignore_patterns = { "node_modules", ".git" }
        }
      })
    end
  },

  -- Treesitter (Rich Syntax Highlighting & AST parsing)
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    config = function()
      local configs = require("nvim-treesitter.configs")
      configs.setup({
        ensure_installed = { "lua", "python", "bash", "markdown", "c", "html", "css", "javascript" },
        sync_install = false,
        highlight = { enable = true },
        indent = { enable = true },
      })
    end
  },

  -- Git integration (Shows changes on the left margin)
  {
    "lewis6991/gitsigns.nvim",
    config = function()
      require("gitsigns").setup()
    end
  },

  -- Autocomplete bracket pairs
  {
    "windwp/nvim-autopairs",
    event = "InsertEnter",
    config = true
  }
})
