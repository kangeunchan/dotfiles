local function command(value) return "<Cmd>" .. value .. "<CR>" end

---@type LazySpec
return {
  "AstroNvim/astrocore",
  opts = function(_, opts)
    local astro = require "astrocore"
    local maps = astro.empty_map_table()

    opts.options = opts.options or {}
    opts.options.opt = opts.options.opt or {}
    opts.options.opt.timeoutlen = 700
    opts.options.opt.ttimeoutlen = 10

    -- Group names shown by which-key.
    maps.n["<Leader>f"] = { desc = "Find / File" }
    maps.n["<Leader>e"] = { desc = "Explorer" }
    maps.n["<Leader>b"] = { desc = "Buffer" }
    maps.n["<Leader>w"] = { desc = "Window" }
    maps.n["<Leader>l"] = { desc = "Language / LSP" }
    maps.n["<Leader>g"] = { desc = "Git" }
    maps.n["<Leader>t"] = { desc = "Terminal" }
    maps.n["<Leader>s"] = { desc = "Session" }
    maps.n["<Leader>u"] = { desc = "UI toggle" }
    maps.n["<Leader>p"] = { desc = "Packages" }
    maps.n["<Leader>d"] = { desc = "Debug" }
    maps.n["<Leader>x"] = { desc = "Lists" }
    maps.n["<Leader>c"] = { desc = "Code / Comment" }
    maps.n["<Leader>q"] = { desc = "Quit" }
    maps.n["<C-g>"] = { desc = "Control layer (KO/EN safe)" }

    -- Always-available editing and navigation.
    maps.n["j"] = { "v:count == 0 ? 'gj' : 'j'", expr = true, silent = true, desc = "Down by display line" }
    maps.n["k"] = { "v:count == 0 ? 'gk' : 'k'", expr = true, silent = true, desc = "Up by display line" }
    maps.x["j"] = maps.n["j"]
    maps.x["k"] = maps.n["k"]
    maps.n["<C-s>"] = { command "silent update", desc = "Save" }
    maps.i["<C-s>"] = { command "silent update", desc = "Save" }
    maps.n["<C-h>"] = { "<C-w>h", desc = "Window left" }
    maps.n["<C-j>"] = { "<C-w>j", desc = "Window down" }
    maps.n["<C-k>"] = { "<C-w>k", desc = "Window up" }
    maps.n["<C-l>"] = { "<C-w>l", desc = "Window right" }
    maps.n["<C-Left>"] = { command "vertical resize -3", desc = "Narrow window" }
    maps.n["<C-Down>"] = { command "resize +2", desc = "Grow window down" }
    maps.n["<C-Up>"] = { command "resize -2", desc = "Grow window up" }
    maps.n["<C-Right>"] = { command "vertical resize +3", desc = "Widen window" }
    maps.n["]b"] = { function() astro.buffer.nav(vim.v.count1) end, desc = "Next buffer" }
    maps.n["[b"] = { function() astro.buffer.nav(-vim.v.count1) end, desc = "Previous buffer" }
    maps.n["]d"] = { function() vim.diagnostic.jump { count = vim.v.count1 } end, desc = "Next diagnostic" }
    maps.n["[d"] = { function() vim.diagnostic.jump { count = -vim.v.count1 } end, desc = "Previous diagnostic" }
    maps.x["<Tab>"] = { ">gv", desc = "Indent selection" }
    maps.x["<S-Tab>"] = { "<gv", desc = "Unindent selection" }
    maps.x["J"] = { ":move '>+1<CR>gv=gv", desc = "Move selection down" }
    maps.x["K"] = { ":move '<-2<CR>gv=gv", desc = "Move selection up" }

    -- Find and files.
    maps.n["<Leader>ff"] = { command "Telescope find_files", desc = "Find files" }
    maps.n["<Leader>fg"] = { command "Telescope live_grep", desc = "Grep text" }
    maps.n["<Leader>fr"] = { command "Telescope oldfiles", desc = "Recent files" }
    maps.n["<Leader>fb"] = { command "Telescope buffers", desc = "Find buffers" }
    maps.n["<Leader>fp"] = { command "Telescope project", desc = "Projects" }
    maps.n["<Leader>fk"] = { command "Telescope keymaps", desc = "Keymaps" }
    maps.n["<Leader>fh"] = { command "Telescope help_tags", desc = "Help" }
    maps.n["<Leader>ft"] = { command "TodoTelescope", desc = "TODOs" }
    maps.n["<Leader>fn"] = { command "enew", desc = "New file" }
    maps.n["<Leader>fs"] = { command "silent update", desc = "Save file" }
    maps.n["<Leader>fS"] = { command "wall", desc = "Save all files" }
    maps.n["<Leader>fc"] = {
      function() require("telescope.builtin").find_files { cwd = vim.fn.stdpath "config" } end,
      desc = "Neovim config files",
    }

    -- Explorer.
    maps.n["<Leader>ee"] = { command "NvimTreeToggle", desc = "Toggle explorer" }
    maps.n["<Leader>ef"] = { command "NvimTreeFocus", desc = "Focus explorer" }
    maps.n["<Leader>er"] = { function() require("nvim-tree.api").tree.reload() end, desc = "Refresh explorer" }
    maps.n["<Leader>ec"] = { function() require("nvim-tree.api").tree.collapse_all() end, desc = "Collapse explorer" }

    -- Buffers.
    maps.n["<Leader>bn"] = { function() astro.buffer.nav(vim.v.count1) end, desc = "Next buffer" }
    maps.n["<Leader>bp"] = { function() astro.buffer.nav(-vim.v.count1) end, desc = "Previous buffer" }
    maps.n["<Leader>bb"] = { function() require("bufferline").pick_buffer() end, desc = "Pick buffer" }
    maps.n["<Leader>bc"] = { function() astro.buffer.close() end, desc = "Close buffer" }
    maps.n["<Leader>bx"] = { function() astro.buffer.close(0, true) end, desc = "Force close buffer" }
    maps.n["<Leader>bC"] = { function() astro.buffer.close_all(true) end, desc = "Close other buffers" }
    maps.n["<Leader>ba"] = { function() astro.buffer.close_all() end, desc = "Close all buffers" }
    maps.n["<Leader>bl"] = { function() astro.buffer.close_left() end, desc = "Close buffers left" }
    maps.n["<Leader>br"] = { function() astro.buffer.close_right() end, desc = "Close buffers right" }

    -- Windows.
    maps.n["<Leader>wh"] = maps.n["<C-h>"]
    maps.n["<Leader>wj"] = maps.n["<C-j>"]
    maps.n["<Leader>wk"] = maps.n["<C-k>"]
    maps.n["<Leader>wl"] = maps.n["<C-l>"]
    maps.n["<Leader>wv"] = { command "vsplit", desc = "Vertical split" }
    maps.n["<Leader>ws"] = { command "split", desc = "Horizontal split" }
    maps.n["<Leader>wq"] = { command "close", desc = "Close window" }
    maps.n["<Leader>wo"] = { command "only", desc = "Close other windows" }
    maps.n["<Leader>we"] = { "<C-w>=", desc = "Equalize windows" }
    maps.n["<Leader>wt"] = { "<C-w>T", desc = "Move window to tab" }

    -- LSP and diagnostics.
    maps.n["<Leader>lh"] = { vim.lsp.buf.hover, desc = "Hover" }
    maps.n["<Leader>ld"] = { vim.lsp.buf.definition, desc = "Definition" }
    maps.n["<Leader>lD"] = { vim.lsp.buf.declaration, desc = "Declaration" }
    maps.n["<Leader>li"] = { vim.lsp.buf.implementation, desc = "Implementation" }
    maps.n["<Leader>lr"] = { vim.lsp.buf.references, desc = "References" }
    maps.n["<Leader>ln"] = { vim.lsp.buf.rename, desc = "Rename symbol" }
    maps.n["<Leader>la"] = { vim.lsp.buf.code_action, desc = "Code action" }
    maps.x["<Leader>la"] = { vim.lsp.buf.code_action, desc = "Code action" }
    maps.n["<Leader>lf"] = { function() vim.lsp.buf.format { async = true } end, desc = "Format" }
    maps.x["<Leader>lf"] = { function() vim.lsp.buf.format { async = true } end, desc = "Format selection" }
    maps.n["<Leader>ls"] = { command "Telescope lsp_document_symbols", desc = "Document symbols" }
    maps.n["<Leader>lS"] = { command "Telescope lsp_dynamic_workspace_symbols", desc = "Workspace symbols" }
    maps.n["<Leader>le"] = { vim.diagnostic.open_float, desc = "Line diagnostics" }
    maps.n["<Leader>lq"] = { vim.diagnostic.setloclist, desc = "Diagnostics list" }

    -- Git.
    maps.n["<Leader>gg"] = { function() require("snacks").picker.git_status() end, desc = "Git status" }
    maps.n["<Leader>gb"] = { function() require("snacks").picker.git_branches() end, desc = "Git branches" }
    maps.n["<Leader>gc"] = { function() require("snacks").picker.git_log() end, desc = "Git commits" }
    maps.n["<Leader>gd"] = { function() require("snacks").picker.git_diff() end, desc = "Git diff" }
    maps.n["<Leader>gf"] = { function() require("snacks").picker.git_files() end, desc = "Git files" }
    maps.n["<Leader>gs"] = { function() require("snacks").picker.git_stash() end, desc = "Git stash" }
    maps.n["<Leader>go"] = { function() require("snacks").gitbrowse() end, desc = "Open in browser" }
    maps.x["<Leader>go"] = maps.n["<Leader>go"]

    -- Terminal.
    maps.n["<Leader>th"] = { command "1ToggleTerm direction=horizontal", desc = "Horizontal terminal" }
    maps.n["<Leader>tf"] = { command "2ToggleTerm direction=float", desc = "Floating terminal" }
    maps.n["<Leader>tv"] = { command "3ToggleTerm direction=vertical", desc = "Vertical terminal" }
    maps.t["<Esc><Esc>"] = { [[<C-\><C-n>]], desc = "Terminal normal mode" }
    maps.t["<C-h>"] = { [[<C-\><C-n><C-w>h]], desc = "Terminal window left" }
    maps.t["<C-j>"] = { [[<C-\><C-n><C-w>j]], desc = "Terminal window down" }
    maps.t["<C-k>"] = { [[<C-\><C-n><C-w>k]], desc = "Terminal window up" }
    maps.t["<C-l>"] = { [[<C-\><C-n><C-w>l]], desc = "Terminal window right" }

    -- Neovim sessions.
    maps.n["<Leader>ss"] = { function() require("resession").save() end, desc = "Save session" }
    maps.n["<Leader>sl"] = { function() require("resession").load "Last Session" end, desc = "Load last session" }
    maps.n["<Leader>sf"] = { function() require("resession").load() end, desc = "Find session" }
    maps.n["<Leader>sd"] = { function() require("resession").delete() end, desc = "Delete session" }
    maps.n["<Leader>st"] = { function() require("resession").save_tab() end, desc = "Save tab session" }

    -- UI toggles and package tools.
    maps.n["<Leader>un"] = { function() astro.toggles.number() end, desc = "Line numbers" }
    maps.n["<Leader>uw"] = { function() astro.toggles.wrap() end, desc = "Line wrap" }
    maps.n["<Leader>us"] = { function() astro.toggles.spell() end, desc = "Spell check" }
    maps.n["<Leader>ud"] = { function() astro.toggles.diagnostics() end, desc = "Diagnostics" }
    maps.n["<Leader>uv"] = { function() astro.toggles.virtual_text() end, desc = "Virtual text" }
    maps.n["<Leader>ui"] = { function() astro.toggles.indent() end, desc = "Indent settings" }
    maps.n["<Leader>ub"] = { function() astro.toggles.background() end, desc = "Background" }
    maps.n["<Leader>uz"] = { function() require("snacks").toggle.zen():toggle() end, desc = "Zen mode" }
    maps.n["<Leader>pp"] = { command "Lazy", desc = "Plugin manager" }
    maps.n["<Leader>pm"] = { command "Mason", desc = "Tool manager" }
    maps.n["<Leader>pu"] = { function() astro.update_packages() end, desc = "Update packages" }

    -- Debugging.
    maps.n["<Leader>db"] = { function() require("dap").toggle_breakpoint() end, desc = "Breakpoint" }
    maps.n["<Leader>dc"] = { function() require("dap").continue() end, desc = "Continue" }
    maps.n["<Leader>di"] = { function() require("dap").step_into() end, desc = "Step into" }
    maps.n["<Leader>do"] = { function() require("dap").step_over() end, desc = "Step over" }
    maps.n["<Leader>dO"] = { function() require("dap").step_out() end, desc = "Step out" }
    maps.n["<Leader>dq"] = { function() require("dap").terminate() end, desc = "Terminate" }
    maps.n["<Leader>du"] = { function() require("dapui").toggle() end, desc = "Debug UI" }

    -- Lists, comments, and quitting.
    maps.n["<Leader>xq"] = { command "copen", desc = "Quickfix" }
    maps.n["<Leader>xl"] = { command "lopen", desc = "Location list" }
    maps.n["<Leader>xn"] = { command "cnext", desc = "Next quickfix" }
    maps.n["<Leader>xp"] = { command "cprevious", desc = "Previous quickfix" }
    maps.n["<Leader>cc"] = { "gcc", remap = true, desc = "Comment line" }
    maps.x["<Leader>cc"] = { "gc", remap = true, desc = "Comment selection" }
    maps.n["<Leader>qq"] = { command "confirm q", desc = "Quit window" }
    maps.n["<Leader>qa"] = { command "confirm qall", desc = "Quit all" }
    maps.n["<Leader>qw"] = { command "wq", desc = "Save and quit" }
    maps.n["<Leader>qf"] = { command "q!", desc = "Force quit" }

    -- KO/EN-safe control layer. Keep Control held through both keystrokes.
    maps.n["<C-g><C-f>"] = maps.n["<Leader>ff"]
    maps.n["<C-g><C-r>"] = maps.n["<Leader>fg"]
    maps.n["<C-g><C-e>"] = maps.n["<Leader>ee"]
    maps.n["<C-g><C-b>"] = maps.n["<Leader>bb"]
    maps.n["<C-g><C-s>"] = maps.n["<C-s>"]
    maps.n["<C-g><C-t>"] = maps.n["<Leader>tf"]
    maps.n["<C-g><C-q>"] = maps.n["<Leader>qq"]
    maps.n["<C-g><C-h>"] = maps.n["<C-h>"]
    maps.n["<C-g><C-j>"] = maps.n["<C-j>"]
    maps.n["<C-g><C-k>"] = maps.n["<C-k>"]
    maps.n["<C-g><C-l>"] = maps.n["<C-l>"]
    maps.n["<C-g><C-d>"] = maps.n["<Leader>ld"]
    maps.n["<C-g><C-n>"] = maps.n["<Leader>ln"]
    maps.n["<C-g><C-o>"] = maps.n["<Leader>la"]

    opts.mappings = maps
  end,
}
