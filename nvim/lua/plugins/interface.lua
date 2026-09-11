local start_screen_filetypes = {
  snacks_dashboard = true,
  eunchan_empty = true,
}

local function start_screen_visible()
  for _, win in ipairs(vim.api.nvim_list_wins()) do
    local buf = vim.api.nvim_win_get_buf(win)
    if start_screen_filetypes[vim.bo[buf].filetype] then return true end
  end
  return false
end

local function apply_highlights()
  local links = {
    AlphaHeader = "Comment",
    AlphaButtons = "Normal",
    AlphaShortcut = "String",
    AlphaFooter = "Comment",
    WhichKeyFloat = "NormalFloat",
    WhichKeyBorder = "FloatBorder",
    WhichKey = "Special",
    WhichKeyDesc = "NormalFloat",
  }

  for group, target in pairs(links) do vim.api.nvim_set_hl(0, group, { link = target }) end
  vim.api.nvim_set_hl(0, "WinSeparator", { link = "NonText" })
  vim.api.nvim_set_hl(0, "CmpDocumentation", { fg = "#D0D0D0", bg = "#262626" })
  vim.api.nvim_set_hl(0, "CmpDocumentationBorder", { fg = "#393939", bg = "#262626" })
  vim.api.nvim_set_hl(0, "LuasnipInsertNodeActive", { bg = "#393939", underline = true, sp = "#BE95FF" })
  vim.api.nvim_set_hl(0, "LuasnipChoiceNodeActive", { bg = "#393939", underline = true, sp = "#BE95FF" })
  vim.api.nvim_set_hl(0, "SnippetTabstopActive", { bg = "#393939", underline = true, sp = "#BE95FF" })

  -- Dashboard: Oxocarbon information colors and solid status badges.
  vim.api.nvim_set_hl(0, "SnacksDashboardNormal", { fg = "#D0D0D0", bg = "#161616" })
  vim.api.nvim_set_hl(0, "SnacksDashboardTitle", { fg = "#78A9FF", bold = true })
  vim.api.nvim_set_hl(0, "SnacksDashboardMeta", { fg = "#6F6F6F" })
  vim.api.nvim_set_hl(0, "SnacksDashboardDesc", { fg = "#A8A8A8" })
  vim.api.nvim_set_hl(0, "SnacksDashboardSpecial", { fg = "#78A9FF", bold = true })
  vim.api.nvim_set_hl(0, "SnacksDashboardHealthOk", { fg = "#42BE65", bold = true })
  vim.api.nvim_set_hl(0, "SnacksDashboardHealthWarn", { fg = "#F1C21B", bold = true })
  vim.api.nvim_set_hl(0, "SnacksDashboardHealthError", { fg = "#FA4D56", bold = true })
  vim.api.nvim_set_hl(0, "SnacksDashboardMetricCpu", { fg = "#33B1FF" })
  vim.api.nvim_set_hl(0, "SnacksDashboardMetricGpu", { fg = "#BE95FF" })
  vim.api.nvim_set_hl(0, "SnacksDashboardMetricMemory", { fg = "#42BE65" })
  vim.api.nvim_set_hl(0, "SnacksDashboardMetricTrack", { fg = "#393939" })
  vim.api.nvim_set_hl(0, "SnacksDashboardBadgeKey", { fg = "#161616", bg = "#78A9FF", bold = true })
  vim.api.nvim_set_hl(0, "SnacksDashboardBadgeActive", { fg = "#161616", bg = "#42BE65", bold = true })
  vim.api.nvim_set_hl(0, "SnacksDashboardBadgeLazy", { fg = "#D0D0D0", bg = "#393939", bold = true })
  vim.api.nvim_set_hl(0, "SnacksDashboardBadgeUpdate", { fg = "#161616", bg = "#F1C21B", bold = true })
  vim.api.nvim_set_hl(0, "SnacksDashboardBadgeError", { fg = "#161616", bg = "#FA4D56", bold = true })
  vim.api.nvim_set_hl(0, "EditorEmptyNormal", { fg = "#D0D0D0", bg = "#161616" })
  vim.api.nvim_set_hl(0, "EditorEmptyTitle", { fg = "#161616", bg = "#78A9FF", bold = true })
  vim.api.nvim_set_hl(0, "EditorEmptyDesc", { fg = "#A8A8A8" })
  vim.api.nvim_set_hl(0, "EditorEmptyHint", { fg = "#6F6F6F" })
  vim.api.nvim_set_hl(0, "LspCodeLens", { fg = "#6F6F6F", italic = true })
  vim.api.nvim_set_hl(0, "LspCodeLensSeparator", { fg = "#525252" })
  vim.api.nvim_set_hl(0, "DiagnosticLineError", { bg = "#3D1F24" })
  vim.api.nvim_set_hl(0, "DiagnosticLineWarn", { bg = "#3D3518" })
end

local mode_names = {
  NORMAL = "RW",
  O_PENDING = "RO",
  VISUAL = "**",
  V_LINE = "**",
  V_BLOCK = "**",
  INSERT = "**",
  REPLACE = "RA",
  COMMAND = "VIEX",
  TERMINAL = "TERM",
}

---@type LazySpec
return {
  {
    "AstroNvim/astrocore",
    opts = function(_, opts)
      opts.options = opts.options or {}
      opts.options.opt = vim.tbl_deep_extend("force", opts.options.opt or {}, {
        laststatus = 3,
        cmdheight = 0,
        showtabline = 2,
        showmode = false,
        ruler = false,
        winblend = 0,
        pumblend = 0,
        termguicolors = true,
        fillchars = { eob = " ", fold = " ", foldopen = "▾", foldclose = "▸", diff = "╱" },
      })

      opts.autocmds = opts.autocmds or {}
      opts.autocmds.nyoom_ui = { { event = { "ColorScheme", "VimEnter" }, callback = apply_highlights } }
      opts.autocmds.dashboard_tabline = {
        {
          event = "User",
          pattern = "SnacksDashboardOpened",
          callback = function() vim.opt.showtabline = 0 end,
        },
        {
          event = "User",
          pattern = "SnacksDashboardClosed",
          callback = function() vim.opt.showtabline = start_screen_visible() and 0 or 2 end,
        },
        {
          event = "User",
          pattern = "VeryLazy",
          callback = function()
            vim.opt.showtabline = start_screen_visible() and 0 or 2
          end,
        },
        {
          event = "BufEnter",
          callback = function()
            vim.schedule(function() vim.opt.showtabline = start_screen_visible() and 0 or 2 end)
          end,
        },
      }
    end,
  },
  { "rebelot/heirline.nvim", enabled = false },
  {
    "akinsho/bufferline.nvim",
    event = "VeryLazy",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function(_, opts)
      require("bufferline").setup(opts)
      if start_screen_visible() then vim.opt.showtabline = 0 end
    end,
    opts = {
      options = {
        mode = "buffers",
        numbers = "none",
        diagnostics = "nvim_lsp",
        separator_style = { "", "" },
        indicator = { icon = "", style = "none" },
        tab_size = 22,
        max_name_length = 24,
        show_buffer_close_icons = true,
        show_close_icon = false,
        persist_buffer_sort = true,
        always_show_bufferline = true,
        custom_filter = function(bufnr)
          return not start_screen_filetypes[vim.bo[bufnr].filetype]
        end,
        offsets = { { filetype = "NvimTree", text = "Files", text_align = "center" } },
      },
    },
    specs = {
      {
        "AstroNvim/astrocore",
        opts = function(_, opts)
          local maps = opts.mappings.n
          maps["<S-h>"] = { "<Cmd>BufferLineCyclePrev<CR>", desc = "Previous buffer" }
          maps["<S-l>"] = { "<Cmd>BufferLineCycleNext<CR>", desc = "Next buffer" }
          maps["<Leader>bc"] = { "<Cmd>BufferLinePickClose<CR>", desc = "Pick buffer to close" }
          maps["<Leader>bp"] = { "<Cmd>BufferLinePick<CR>", desc = "Pick buffer" }
        end,
      },
    },
  },
  {
    "nvim-lualine/lualine.nvim",
    event = "VeryLazy",
    opts = {
      options = {
        theme = "oxocarbon",
        globalstatus = true,
        icons_enabled = true,
        component_separators = "",
        section_separators = "",
        disabled_filetypes = {
          winbar = { "alpha", "snacks_dashboard", "eunchan_empty", "NvimTree", "TelescopePrompt" },
        },
      },
      sections = {
        lualine_a = { { "mode", fmt = function(mode) return mode_names[mode] or mode end } },
        lualine_b = {
          {
            "filename",
            file_status = false,
            newfile_status = false,
            path = 0,
            fmt = function(name) return (name == "" or name == "[No Name]") and "nyoom-nvim" or name end,
          },
          { "branch", icon = "λ • #" },
          { function() return tostring(vim.api.nvim_get_current_buf()) end },
        },
        lualine_c = {},
        lualine_x = {
          { "diagnostics", symbols = { error = "", warn = "", info = "", hint = "" } },
          { "filetype", colored = true, icon_only = false },
        },
        lualine_y = {},
        lualine_z = { "location" },
      },
      inactive_sections = {
        lualine_a = {},
        lualine_b = { "filename" },
        lualine_c = {},
        lualine_x = { "location" },
        lualine_y = {},
        lualine_z = {},
      },
      winbar = { lualine_c = { { "filename", path = 1 } } },
      inactive_winbar = { lualine_c = { { "filename", path = 1 } } },
    },
  },
  { "folke/which-key.nvim", opts = { win = { border = "none", padding = { 1, 2 } } } },
}
