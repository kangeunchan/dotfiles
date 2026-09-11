local codelens_namespace = vim.api.nvim_create_namespace "eunchan_lsp_codelens"
local refresh_generation = {}

local function configure_diagnostics()
  vim.diagnostic.config {
    severity_sort = true,
    update_in_insert = true,
    signs = {
      linehl = {
        [vim.diagnostic.severity.ERROR] = "DiagnosticLineError",
        [vim.diagnostic.severity.WARN] = "DiagnosticLineWarn",
      },
    },
  }
end

local function render_codelenses(bufnr, lenses)
  if not vim.api.nvim_buf_is_valid(bufnr) then return end
  vim.api.nvim_buf_clear_namespace(bufnr, codelens_namespace, 0, -1)

  local rows = {}
  for _, lens in ipairs(lenses) do
    if lens.command and lens.command.title then
      local row = lens.range.start.line
      rows[row] = rows[row] or {}
      rows[row][#rows[row] + 1] = lens.command.title
    end
  end

  for row, titles in pairs(rows) do
    vim.api.nvim_buf_set_extmark(bufnr, codelens_namespace, row, 0, {
      virt_text = { { "  " .. table.concat(titles, "  ·  "), "LspCodeLens" } },
      virt_text_pos = "eol",
      hl_mode = "combine",
      priority = 90,
    })
  end
end

local function request_codelenses(bufnr)
  if not vim.api.nvim_buf_is_valid(bufnr) or vim.bo[bufnr].buftype ~= "" then return end

  local generation = (refresh_generation[bufnr] or 0) + 1
  refresh_generation[bufnr] = generation
  local clients = vim.tbl_filter(function(client)
    return client:supports_method("textDocument/codeLens")
  end, vim.lsp.get_clients { bufnr = bufnr })

  if #clients == 0 then
    render_codelenses(bufnr, {})
    return
  end

  local all_lenses = {}
  local clients_remaining = #clients
  local function finish_client()
    clients_remaining = clients_remaining - 1
    if clients_remaining == 0 and refresh_generation[bufnr] == generation then
      vim.schedule(function() render_codelenses(bufnr, all_lenses) end)
    end
  end

  for _, client in ipairs(clients) do
    client:request("textDocument/codeLens", {
      textDocument = vim.lsp.util.make_text_document_params(bufnr),
    }, function(error, result)
      if error or not result or #result == 0 then
        finish_client()
        return
      end

      local lenses_remaining = #result
      local function finish_lens(lens)
        if lens and lens.command then all_lenses[#all_lenses + 1] = lens end
        lenses_remaining = lenses_remaining - 1
        if lenses_remaining == 0 then finish_client() end
      end

      for _, lens in ipairs(result) do
        if lens.command then
          finish_lens(lens)
        else
          local sent = client:request("codeLens/resolve", lens, function(_, resolved)
            finish_lens(resolved or lens)
          end, bufnr)
          if not sent then finish_lens(lens) end
        end
      end
    end, bufnr)
  end
end

local function schedule_codelens_refresh(bufnr)
  local generation = (refresh_generation[bufnr] or 0) + 1
  refresh_generation[bufnr] = generation
  vim.defer_fn(function()
    if refresh_generation[bufnr] == generation then request_codelenses(bufnr) end
  end, 250)
end

---@type LazySpec
return {
  {
    "AstroNvim/astrolsp",
    opts = function(_, opts)
      opts.features = opts.features or {}
      opts.features.codelens = false

      local group = vim.api.nvim_create_augroup("eunchan_lsp_ui", { clear = true })
      vim.api.nvim_create_autocmd("VimEnter", {
        group = group,
        callback = function() vim.schedule(configure_diagnostics) end,
      })
      vim.api.nvim_create_autocmd("LspAttach", {
        group = group,
        callback = function(event)
          configure_diagnostics()
          schedule_codelens_refresh(event.buf)
        end,
      })
      vim.api.nvim_create_autocmd({ "BufEnter", "BufWritePost", "TextChanged", "InsertLeave" }, {
        group = group,
        callback = function(event) schedule_codelens_refresh(event.buf) end,
      })
      vim.api.nvim_create_autocmd("BufWipeout", {
        group = group,
        callback = function(event) refresh_generation[event.buf] = nil end,
      })
    end,
  },
}
