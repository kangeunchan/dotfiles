---@type LazySpec
return {
  {
    "akinsho/toggleterm.nvim",
    opts = function(_, opts)
      opts.direction = "horizontal"
      opts.size = function(term)
        if term.direction == "horizontal" then return math.max(12, math.floor(vim.o.lines * 0.3)) end
        return math.max(40, math.floor(vim.o.columns * 0.35))
      end
      opts.persist_size = true
      opts.persist_mode = true
      opts.start_in_insert = true
      opts.close_on_exit = true
      opts.shade_terminals = false
      opts.highlights = {
        Normal = { guibg = "#262626" },
        NormalFloat = { guibg = "#262626" },
        SignColumn = { guibg = "#262626" },
        EndOfBuffer = { guibg = "#262626" },
        FloatBorder = { guifg = "#393939", guibg = "#262626" },
        StatusLine = { guibg = "#262626" },
        StatusLineNC = { guibg = "#262626" },
      }
      opts.float_opts = {
        border = "solid",
        width = function() return math.floor(vim.o.columns * 0.82) end,
        height = function() return math.floor(vim.o.lines * 0.78) end,
        winblend = 0,
      }

      local previous_on_create = opts.on_create
      opts.on_create = function(term)
        if previous_on_create then previous_on_create(term) end
        vim.keymap.set("t", "<Esc><Esc>", [[<C-\><C-n>]], {
          buffer = term.bufnr,
          desc = "Terminal normal mode",
        })
      end
    end,
    specs = {
      {
        "AstroNvim/astrocore",
        opts = function(_, opts)
          local maps = opts.mappings
          maps.n["<Leader>th"] = {
            "<Cmd>1ToggleTerm direction=horizontal<CR>",
            desc = "Terminal bottom",
          }
          maps.n["<Leader>tf"] = {
            "<Cmd>2ToggleTerm direction=float<CR>",
            desc = "Terminal floating",
          }
          maps.n["<C-j>"] = { "<Cmd>1ToggleTerm direction=horizontal<CR>", desc = "Terminal bottom" }
        end,
      },
    },
  },
}
