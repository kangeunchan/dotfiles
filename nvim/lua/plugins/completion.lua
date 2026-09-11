---@type LazySpec
return {
  { "saghen/blink.cmp", enabled = false },
  {
    "hrsh7th/nvim-cmp",
    event = "InsertEnter",
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-path",
      "hrsh7th/cmp-cmdline",
      "saadparwaiz1/cmp_luasnip",
      "L3MON4D3/LuaSnip",
      "onsails/lspkind.nvim",
    },
    config = function()
      local cmp = require "cmp"
      local luasnip = require "luasnip"
      local kind_icon = require("lspkind").cmp_format { mode = "symbol", maxwidth = 38, ellipsis_char = "…" }

      cmp.setup {
        experimental = { ghost_text = true },
        preselect = cmp.PreselectMode.None,
        completion = { completeopt = "menu,menuone,noselect" },
        window = {
          completion = cmp.config.window.bordered {
            border = "none",
            side_padding = 0,
            scrollbar = false,
            max_height = 12,
            winhighlight = "Normal:Pmenu,CursorLine:PmenuSel,Search:None",
          },
          documentation = {
            border = "none",
            scrollbar = false,
            max_width = 64,
            max_height = 16,
            col_offset = 0,
            zindex = 1001,
            winhighlight = "Normal:CmpDocumentation,FloatBorder:CmpDocumentationBorder,Search:None",
          },
        },
        snippet = { expand = function(args) luasnip.lsp_expand(args.body) end },
        mapping = cmp.mapping.preset.insert {
          ["<C-b>"] = cmp.mapping.scroll_docs(-4),
          ["<C-f>"] = cmp.mapping.scroll_docs(4),
          ["<C-g>"] = cmp.mapping.complete(),
          ["<C-e>"] = cmp.mapping.abort(),
          ["<CR>"] = cmp.mapping.confirm { select = false },
          ["<Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_next_item()
            elseif luasnip.expand_or_jumpable() then
              luasnip.expand_or_jump()
            else
              fallback()
            end
          end, { "i", "s" }),
          ["<S-Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_prev_item()
            elseif luasnip.jumpable(-1) then
              luasnip.jump(-1)
            else
              fallback()
            end
          end, { "i", "s" }),
        },
        sources = cmp.config.sources {
          { name = "lazydev", group_index = 0 },
          { name = "nvim_lsp" },
          { name = "luasnip" },
          { name = "buffer" },
          { name = "path" },
        },
        formatting = {
          fields = { "kind", "abbr", "menu" },
          format = function(entry, item)
            local kind = item.kind
            item = kind_icon(entry, item)
            item.menu = kind
            return item
          end,
        },
      }

      cmp.setup.cmdline("/", { mapping = cmp.mapping.preset.cmdline(), sources = { { name = "buffer" } } })
      cmp.setup.cmdline(":", {
        mapping = cmp.mapping.preset.cmdline(),
        sources = cmp.config.sources({ { name = "path" } }, { { name = "cmdline" } }),
      })
    end,
    specs = {
      {
        "AstroNvim/astrolsp",
        opts = function(_, opts)
          opts.servers = opts.servers or {}
          if not vim.tbl_contains(opts.servers, "lua_ls") then opts.servers[#opts.servers + 1] = "lua_ls" end

          opts.config = opts.config or {}
          opts.config["*"] = opts.config["*"] or {}
          opts.config["*"].capabilities = require("cmp_nvim_lsp").default_capabilities(
            opts.config["*"].capabilities
          )
          opts.config.lua_ls = vim.tbl_deep_extend("force", opts.config.lua_ls or {}, {
            settings = {
              Lua = {
                runtime = { version = "LuaJIT" },
                diagnostics = { globals = { "vim" } },
                workspace = { checkThirdParty = false },
                telemetry = { enable = false },
                hint = { enable = true, semicolon = "Disable" },
              },
            },
          })
        end,
      },
    },
  },
  {
    "lukas-reineke/indent-blankline.nvim",
    main = "ibl",
    opts = {
      indent = { char = "│" },
      scope = { enabled = true, show_start = true },
      exclude = {
        buftypes = { "terminal" },
        filetypes = { "help", "terminal", "alpha", "lazy", "lspinfo", "TelescopePrompt", "mason", "" },
      },
    },
  },
}
