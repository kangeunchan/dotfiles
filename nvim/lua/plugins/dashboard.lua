-- Keep the restored dashboard source intact so it can be backed up independently.
return dofile(vim.fn.stdpath "config" .. "/dashboard.backup.lua")
