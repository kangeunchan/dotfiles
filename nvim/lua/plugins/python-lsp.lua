-- Python language support: pyright for types/completion, ruff for lint/format.
---@type LazySpec
return {
  {
    "AstroNvim/astrolsp",
    opts = function(_, opts)
      opts.servers = opts.servers or {}
      for _, server in ipairs { "pyright", "ruff" } do
        if not vim.tbl_contains(opts.servers, server) then
          opts.servers[#opts.servers + 1] = server
        end
      end

      opts.config = opts.config or {}

      -- pyright: type checking and IntelliSense. Defer linting/formatting to ruff.
      opts.config.pyright = vim.tbl_deep_extend("force", opts.config.pyright or {}, {
        settings = {
          pyright = {
            -- ruff owns import organization.
            disableOrganizeImports = true,
          },
          python = {
            analysis = {
              typeCheckingMode = "basic",
              autoSearchPaths = true,
              useLibraryCodeForTypes = true,
              diagnosticMode = "openFilesOnly",
            },
          },
        },
      })

      -- ruff: fast linting and formatting. Let pyright provide hover docs.
      opts.config.ruff = vim.tbl_deep_extend("force", opts.config.ruff or {}, {
        on_attach = function(client)
          client.server_capabilities.hoverProvider = false
        end,
      })
    end,
  },
}
