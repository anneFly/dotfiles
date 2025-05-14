-- helper to dump objects to string for debugging
local function dump(o)
   if type(o) == 'table' then
      local s = '{ '
      for k,v in pairs(o) do
         if type(k) ~= 'number' then k = '"'..k..'"' end
         s = s .. '['..k..'] = ' .. dump(v) .. ','
      end
      return s .. '} '
   else
      return tostring(o)
   end
end


---Toggles Harper LS spell checking for the current buffer.
---@param enable boolean True to enable, false to disable
local function toggle_harper_spellcheck(enable)
  local bufnr = vim.api.nvim_get_current_buf()

  -- Get all clients attached to the current buffer
  -- The first argument is an optional filter table.
  -- { bufnr = 0 } means current buffer. { bufnr = bufnr } is also valid.
  -- We will filter by name afterwards if needed.
  local all_clients_for_buffer = vim.lsp.get_clients({ bufnr = bufnr })

  local harper_clients = {}
  for _, client in ipairs(all_clients_for_buffer) do
    if client.name == "harper_ls" then
      table.insert(harper_clients, client)
    end
  end

  if #harper_clients == 0 then
    vim.notify("Harper LS is not active for the current buffer.", vim.log.levels.WARN)
    return
  end

  for _, client in ipairs(harper_clients) do
    local new_client_settings = vim.deepcopy(client.config.settings or {})
    --vim.notify(dump(new_client_settings), vim.log.levels.DEBUG)

    if not new_client_settings["harper-ls"] then
      new_client_settings["harper-ls"] = {}
    end
    if not new_client_settings["harper-ls"]["linters"] then
      new_client_settings["harper-ls"]["linters"] = {}
    end
    if not new_client_settings["harper-ls"]["linters"]["SpellCheck"] then
      new_client_settings["harper-ls"]["linters"]["SpellCheck"] = false
    end

    new_client_settings["harper-ls"]["linters"]["SpellCheck"] = enable

    client.config.settings = new_client_settings
    --vim.notify(dump(new_client_settings), vim.log.levels.DEBUG)

    -- Notify the server about the configuration change.
    -- The server expects the full settings object under the `settings` key.
    client.notify("workspace/didChangeConfiguration", { settings = new_client_settings })

    vim.notify(
      string.format("Harper LS spell checking %s for this buffer.", enable and "ENABLED" or "DISABLED"),
      vim.log.levels.INFO
    )
  end
end


vim.api.nvim_create_user_command("HarperSpellDisable", function()
  toggle_harper_spellcheck(false)
end, {
  desc = "Disable Harper LS spell checking for the current buffer",
})

vim.api.nvim_create_user_command("HarperSpellEnable", function()
  toggle_harper_spellcheck(true)
end, {
  desc = "Enable Harper LS spell checking for the current buffer",
})

