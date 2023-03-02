local keymaps = require("configs.keymaps")

local M = {}

function M.on_attach(client, buffer)
  local Keys = require("lazy.core.handler.keys")
  local maps = {} ---@type table<string,LazyKeys|{has?:string}>

  for _, value in ipairs(keymaps.lsp.config()) do
    local keys = Keys.parse(value)
    if keys[2] == vim.NIL or keys[2] == false then
      maps[keys.id] = nil
    else
      maps[keys.id] = keys
    end
  end

  for _, keys in pairs(maps) do
    if not keys.has or client.server_capabilities[keys.has .. "Provider"] then
      local opts = Keys.opts(keys)
      ---@diagnostic disable-next-line: no-unknown
      opts.has = nil
      opts.silent = true
      opts.buffer = buffer
      vim.keymap.set(keys.mode or "n", keys[1], keys[2], opts)
    end
  end
end

return M
