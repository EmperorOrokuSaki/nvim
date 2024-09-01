return {
  "hrsh7th/nvim-cmp",
  event = "InsertEnter",
  dependencies = {
    "hrsh7th/cmp-buffer", -- source for text in buffer
    "hrsh7th/cmp-path", -- source for file system paths
    {
      "L3MON4D3/LuaSnip",
      -- follow latest release.
      version = "v2.*", -- Replace <CurrentMajor> by the latest released major (first number of latest release)
      -- install jsregexp (optional!).
      build = "make install_jsregexp",
    },
    "saadparwaiz1/cmp_luasnip", -- for autocompletion
    "rafamadriz/friendly-snippets", -- useful snippets
    "onsails/lspkind.nvim", -- vs-code like pictograms
    "hrsh7th/cmp-nvim-lsp", -- LSP completion source
    "hrsh7th/cmp-nvim-lua", -- Lua runtime API completion
    "hrsh7th/cmp-nvim-lsp-signature-help", -- function signature help
    "hrsh7th/cmp-vsnip", -- VSnip completion source
  },
  config = function()
    local cmp = require("cmp")
    local luasnip = require("luasnip")
    local lspkind = require("lspkind")

    -- loads vscode style snippets from installed plugins (e.g. friendly-snippets)
    require("luasnip.loaders.from_vscode").lazy_load()

    cmp.setup({
      completion = {
        completeopt = "menu,menuone,preview,noselect",
      },
      snippet = { -- configure how nvim-cmp interacts with snippet engine
        expand = function(args)
          luasnip.lsp_expand(args.body)
        end,
      },
      mapping = cmp.mapping.preset.insert({
        ["<C-k>"] = cmp.mapping.select_prev_item(), -- previous suggestion
        ["<C-j>"] = cmp.mapping.select_next_item(), -- next suggestion
        ["<C-b>"] = cmp.mapping.scroll_docs(-4),
        ["<C-f>"] = cmp.mapping.scroll_docs(4),
        ["<C-Space>"] = cmp.mapping.complete(), -- show completion suggestions
        ["<C-e>"] = cmp.mapping.abort(), -- close completion window
        ["<CR>"] = cmp.mapping.confirm({ behavior = cmp.ConfirmBehavior.Insert, select = true }),
        ["<Tab>"] = cmp.mapping.select_next_item(),
        ["<S-Tab>"] = cmp.mapping.select_prev_item(),
      }),
      -- sources for autocompletion
      sources = cmp.config.sources({
        { name = "luasnip" }, -- snippets
        { name = "buffer", keyword_length = 2 }, -- text within current buffer
        { name = "path" }, -- file system paths
        { name = "nvim_lsp", keyword_length = 3 }, -- LSP completion
        { name = "nvim_lsp_signature_help" }, -- function signature help
        { name = "nvim_lua", keyword_length = 2 }, -- Lua runtime API
        { name = "vsnip", keyword_length = 2 }, -- VSnip snippets
        { name = "calc" }, -- source for math calculation
      }),
      window = {
        completion = cmp.config.window.bordered(),
        documentation = cmp.config.window.bordered(),
      },
      formatting = {
        format = lspkind.cmp_format({
          mode = 'symbol_text', -- Show text and symbols
          maxwidth = 50,
          ellipsis_char = "...",
          menu = {
            buffer = "Ω",
            nvim_lsp = "λ",
            vsnip = "⋗",
            path = "🖫",
            nvim_lua = "",
          },
        }),
      },
    })
  end,
}

