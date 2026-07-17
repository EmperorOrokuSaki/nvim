-- Sets the main leader key to Space.
-- Any mapping that starts with <leader> now starts with Space.
vim.g.mapleader = " "

-- Sets the local leader key to Space too.
-- Local leader is usually used for filetype-specific mappings.
vim.g.maplocalleader = " "

-- Short alias for vim.opt, Neovim's interface for editor options.
local opt = vim.opt

-- Show absolute line numbers.
opt.number = true

-- Show relative line numbers next to the current line.
-- Useful for motions like 5j, 3k, d7j, etc.
opt.relativenumber = true

-- Always reserve the left column used for diagnostics, git signs, etc.
-- This prevents the text from shifting when signs appear.
opt.signcolumn = "yes"

-- Highlight the line your cursor is currently on.
opt.cursorline = true

-- Keep at least 8 lines visible above/below the cursor when scrolling.
opt.scrolloff = 8

-- Insert spaces when pressing Tab.
opt.expandtab = true

-- Make auto-indentation a bit smarter for code.
opt.smartindent = true

-- A tab character visually appears as 2 spaces.
opt.tabstop = 2

-- Indentation commands use 2 spaces.
opt.shiftwidth = 2

-- Do not soft-wrap long lines visually.
opt.wrap = false

-- Search case-insensitively by default.
opt.ignorecase = true

-- But if your search contains uppercase letters, make it case-sensitive.
opt.smartcase = true

-- Open vertical splits to the right.
opt.splitright = true

-- Open horizontal splits below.
opt.splitbelow = true

-- Keep undo history even after closing a file.
opt.undofile = true

-- Enable true-color support.
opt.termguicolors = true

-- Configure built-in completion menu behavior.
-- menu: show a completion menu.
-- menuone: show it even if there is only one result.
-- noselect: do not preselect an item.
-- popup: use Neovim's newer popup style when available.
opt.completeopt = { "menu", "menuone", "noselect", "popup" }

-- Use Neovim's built-in habamax colorscheme.
-- No plugin needed.
vim.cmd.colorscheme("habamax")

-- Short alias for setting keymaps.
local map = vim.keymap.set

-- Space+w saves the current file.
map("n", "<leader>w", "<cmd>write<cr>", { desc = "Save" })

-- Space+q quits the current window.
map("n", "<leader>q", "<cmd>quit<cr>", { desc = "Quit" })

-- Space+e opens Neovim's built-in file explorer.
map("n", "<leader>e", "<cmd>Explore<cr>", { desc = "File explorer" })

-- Escape clears highlighted search results.
map("n", "<Esc>", "<cmd>nohlsearch<cr>", { desc = "Clear search" })

-- Path where lazy.nvim should be installed.
-- stdpath("data") is usually ~/.local/share/nvim.
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"

-- Check whether lazy.nvim already exists at that path.
if not vim.uv.fs_stat(lazypath) then
  -- If lazy.nvim is missing, clone it from GitHub.
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "--branch=stable",
    "https://github.com/folke/lazy.nvim.git",
    lazypath,
  })
end

-- Add lazy.nvim to Neovim's runtime path so require("lazy") works.
vim.opt.rtp:prepend(lazypath)

-- Start lazy.nvim and declare plugins.
require("lazy").setup({
  -- Plugin: nvim-lspconfig.
  -- Gives Neovim ready-made LSP server configurations.
  {
    "neovim/nvim-lspconfig",

    -- Runs after the plugin loads.
    config = function()
      -- Configure how diagnostics are displayed.
      vim.diagnostic.config({
        -- Show diagnostic messages inline.
        virtual_text = true,

        -- Underline problematic code.
        underline = true,

        -- Sort diagnostics by severity.
        severity_sort = true,
      })

      -- Create an autocommand that runs whenever an LSP attaches to a buffer.
      vim.api.nvim_create_autocmd("LspAttach", {
        callback = function(event)
          -- Buffer number for the file the LSP attached to.
          local bufnr = event.buf

          -- The LSP client that just attached.
          local client = vim.lsp.get_client_by_id(event.data.client_id)

          -- Helper for buffer-local LSP keymaps.
          local function lspmap(lhs, rhs, desc)
            map("n", lhs, rhs, { buffer = bufnr, desc = desc })
          end

          -- Go to the symbol definition.
          lspmap("gd", vim.lsp.buf.definition, "Go to definition")

          -- Show references to the symbol under the cursor.
          lspmap("gr", vim.lsp.buf.references, "References")

          -- Show hover documentation.
          lspmap("K", vim.lsp.buf.hover, "Hover docs")

          -- Rename the symbol under the cursor.
          lspmap("<leader>rn", vim.lsp.buf.rename, "Rename")

          -- Show available code actions.
          lspmap("<leader>ca", vim.lsp.buf.code_action, "Code action")

          -- Format the current buffer with the active LSP.
          lspmap("<leader>f", function()
            vim.lsp.buf.format({ bufnr = bufnr })
          end, "Format")

          -- If the server supports completion, enable Neovim's built-in LSP completion.
          if client and client:supports_method("textDocument/completion") then
            vim.lsp.completion.enable(true, client.id, bufnr, { autotrigger = true })
          end
        end,
      })

      -- Configure rust-analyzer.
      vim.lsp.config("rust_analyzer", {
        settings = {
          ["rust-analyzer"] = {
            -- Analyze all Cargo features, not only default features.
            cargo = { allFeatures = true },

            -- Use clippy instead of plain cargo check for diagnostics.
            check = { command = "clippy" },
          },
        },
      })

      -- Enable rust-analyzer.
      vim.lsp.enable({ "rust_analyzer" })
    end,
  },

  -- Plugin: Treesitter.
  -- Gives better syntax highlighting and indentation.
  {
    "nvim-treesitter/nvim-treesitter",

    -- Use the compatibility branch for Neovim 0.11.
    branch = "master",

    -- After installing/updating the plugin, update parsers.
    build = ":TSUpdate",

    -- Runs after the plugin loads.
    config = function()
      -- Configure Treesitter.
      require("nvim-treesitter.configs").setup({
        -- Parsers to install.
        ensure_installed = { "rust", "lua", "toml", "vim", "vimdoc" },

        -- Enable Treesitter highlighting.
        highlight = { enable = true },

        -- Enable Treesitter-based indentation.
        indent = { enable = true },
      })
    end,
  },
  {
    "stevearc/oil.nvim",
    opts = {},
    keys = {
      { "<leader>e", "<cmd>Oil<cr>", desc = "File explorer" },
    },
  }
}, {
  rocks = {
      enabled = false
    },
})
