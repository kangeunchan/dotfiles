---@type LazySpec

return {
  {
    "nvim-telescope/telescope.nvim",
    cmd = "Telescope",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-telescope/telescope-ui-select.nvim",
      "nvim-telescope/telescope-project.nvim",
      { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
    },
    opts = {
      defaults = {
        prompt_prefix = "   ",
        selection_caret = "  ",
        entry_prefix = "  ",
        sorting_strategy = "ascending",
        layout_strategy = "flex",
        layout_config = {
          horizontal = { prompt_position = "top", preview_width = 0.55 },
          vertical = { mirror = false },
          width = 0.87,
          height = 0.8,
          preview_cutoff = 120,
        },
        dynamic_preview_title = true,
        set_env = { COLORTERM = "truecolor" },
      },
      extensions = { project = { base_dirs = { "~/.config/nvim" } } },
    },
    config = function(_, opts)
      local telescope = require "telescope"
      telescope.setup(opts)
      for _, extension in ipairs { "ui-select", "project", "fzf" } do pcall(telescope.load_extension, extension) end
    end,
    specs = {
      {
        "AstroNvim/astrocore",
        opts = function(_, opts)
          local builtin = require "telescope.builtin"
          local maps = opts.mappings.n
          maps["<Leader>ff"] = { builtin.find_files, desc = "Find files" }
          maps["<Leader>fo"] = { builtin.oldfiles, desc = "Recent files" }
          maps["<Leader>fg"] = { builtin.live_grep, desc = "Live grep" }
          maps["<Leader>fp"] = { "<Cmd>Telescope project<CR>", desc = "Projects" }
          maps["<Leader>fk"] = { builtin.keymaps, desc = "Keymaps" }
        end,
      },
    },
  },
}
