local empty_state_filetype = "eunchan_empty"

local function centered(text, width)
  local available = math.max(width - 2, 1)
  local value = vim.fn.strcharpart(text, 0, available)
  local padding = math.max(math.floor((width - vim.fn.strdisplaywidth(value)) / 2), 0)
  return (" "):rep(padding) .. value, padding, padding + #value
end

local function render_empty_state(bufnr, winid)
  if not vim.api.nvim_buf_is_valid(bufnr) or not vim.api.nvim_win_is_valid(winid) then return end

  local width = vim.api.nvim_win_get_width(winid)
  local height = vim.api.nvim_win_get_height(winid)
  local content = {
    { " PLEASE SELECT A FILE ", "EditorEmptyTitle" },
    { "", "EditorEmptyDesc" },
    { "Select a file from the explorer to begin editing.", "EditorEmptyDesc" },
    { "", "EditorEmptyDesc" },
    { "j / k  navigate   ·   Enter  open   ·   q  close", "EditorEmptyHint" },
  }
  local top = math.max(math.floor((height - #content) / 2), 0)
  local lines, highlight_ranges = {}, {}
  for _ = 1, top do lines[#lines + 1] = "" end
  for index, item in ipairs(content) do
    local line, start_col, end_col = centered(item[1], width)
    lines[#lines + 1] = line
    highlight_ranges[index] = { start_col, end_col }
  end

  vim.bo[bufnr].modifiable = true
  vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, lines)
  vim.api.nvim_buf_clear_namespace(bufnr, -1, 0, -1)
  for index, item in ipairs(content) do
    if item[1] ~= "" then
      local range = highlight_ranges[index]
      vim.api.nvim_buf_add_highlight(bufnr, -1, item[2], top + index - 1, range[1], range[2])
    end
  end
  vim.bo[bufnr].modifiable = false
end

local function create_empty_state(winid)
  local bufnr = vim.api.nvim_create_buf(false, true)
  vim.bo[bufnr].buftype = "nofile"
  vim.bo[bufnr].bufhidden = "wipe"
  vim.bo[bufnr].swapfile = false
  vim.bo[bufnr].filetype = empty_state_filetype
  vim.api.nvim_win_set_buf(winid, bufnr)

  vim.wo[winid].number = false
  vim.wo[winid].relativenumber = false
  vim.wo[winid].cursorline = false
  vim.wo[winid].signcolumn = "no"
  vim.wo[winid].foldcolumn = "0"
  vim.wo[winid].wrap = false
  vim.wo[winid].winbar = ""
  vim.wo[winid].winhighlight = "Normal:EditorEmptyNormal,NormalNC:EditorEmptyNormal"

  render_empty_state(bufnr, winid)
  vim.opt.showtabline = 0
end

local function replace_dashboard_with_empty_state()
  for _, winid in ipairs(vim.api.nvim_list_wins()) do
    local bufnr = vim.api.nvim_win_get_buf(winid)
    if vim.bo[bufnr].filetype == "snacks_dashboard" then
      create_empty_state(winid)
      return
    end
  end
end

---@type LazySpec
return {
  { "nvim-neo-tree/neo-tree.nvim", enabled = false },
  {
    "nvim-tree/nvim-tree.lua",
    cmd = { "NvimTreeToggle", "NvimTreeOpen", "NvimTreeFocus" },
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function(_, opts)
      require("nvim-tree").setup(opts)
      local api = require "nvim-tree.api"
      api.events.subscribe(api.events.Event.TreeOpen, function() vim.schedule(replace_dashboard_with_empty_state) end)

      local group = vim.api.nvim_create_augroup("eunchan_empty_editor", { clear = true })
      vim.api.nvim_create_autocmd({ "VimResized", "WinResized" }, {
        group = group,
        callback = function()
          for _, winid in ipairs(vim.api.nvim_list_wins()) do
            local bufnr = vim.api.nvim_win_get_buf(winid)
            if vim.bo[bufnr].filetype == empty_state_filetype then render_empty_state(bufnr, winid) end
          end
        end,
      })
    end,
    opts = {
      disable_netrw = true,
      hijack_netrw = true,
      hijack_cursor = true,
      sync_root_with_cwd = true,
      respect_buf_cwd = true,
      update_focused_file = { enable = true, update_root = true },
      git = { enable = false, ignore = true },
      hijack_directories = { enable = true, auto_open = true },
      actions = { open_file = { resize_window = true } },
      view = { side = "left", width = 25, adaptive_size = true },
      renderer = {
        root_folder_label = false,
        indent_markers = { enable = false },
        icons = { show = { file = true, folder = true, folder_arrow = true, git = false } },
      },
    },
    specs = {
      {
        "AstroNvim/astrocore",
        opts = function(_, opts)
          opts.mappings.n["<Leader>e"] = { "<Cmd>NvimTreeToggle<CR>", desc = "Toggle Explorer" }
          opts.mappings.n["<Leader>o"] = { "<Cmd>NvimTreeFocus<CR>", desc = "Focus Explorer" }
        end,
      },
    },
  },
}
