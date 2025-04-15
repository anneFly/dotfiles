-- The following code was AI generated based on this original
-- vimscript code:
-- ```
-- " open blame on github
-- function GitHubBlame()
--     let line_number = line(".")
--     let file_path = @%
--     let remote = substitute(system('git config --get remote.origin.url'), '\n', '', 'g')
--     let url = 'https://github.com/' . substitute(remote, 'git@github\.com:', '', 'g')
--     let full_url = substitute(url, '\.git', '', 'g') . '/blame/master/' . file_path . '#L' . line_number
--     call system('chromium ' . full_url)
--     echom 'opening ' . full_url
-- endfunction
-- ```

-- Function to open blame on GitHub (Improved Lua version)
local function GitHubBlame()
  -- 1. Get current line number
  local line_number = vim.api.nvim_win_get_cursor(0)[1] -- {row, col}, 1-based index

  -- 2. Get git repository root
  local git_root_cmd = { 'git', 'rev-parse', '--show-toplevel' }
  local git_root = vim.fn.system(git_root_cmd)
  if vim.v.shell_error ~= 0 then
    vim.notify("Error getting git root: Not inside a git repository?", vim.log.levels.ERROR)
    return
  end
  git_root = vim.fn.trim(git_root) -- Remove trailing newline

  -- 3. Get current buffer's full path
  local full_file_path = vim.api.nvim_buf_get_name(0)
  if full_file_path == '' then
    vim.notify("Cannot get file path for the current buffer.", vim.log.levels.WARN)
    return
  end

  -- 4. Calculate file path relative to git root
  local relative_file_path
  -- Ensure the file path starts with the git root path. Add 1 for the path separator.
  if string.find(full_file_path, git_root, 1, true) == 1 then
     -- Add 1 for the path separator character (like '/')
    relative_file_path = string.sub(full_file_path, #git_root + 2)
  else
    vim.notify("Error: File path '" .. full_file_path .. "' does not seem to be inside git root '" .. git_root .. "'.", vim.log.levels.ERROR)
    -- Fallback to expand('%') like original script, but warn user
    relative_file_path = vim.fn.expand('%')
    if relative_file_path == '' then
      vim.notify("Cannot determine relative file path.", vim.log.levels.ERROR)
      return
    else
      vim.notify("Warning: Using path relative to CWD ('" .. relative_file_path .. "'), which might be incorrect for GitHub.", vim.log.levels.WARN)
    end
  end

  -- Handle Windows backslashes
  -- if vim.fn.has('win32') == 1 then
  --   relative_file_path = string.gsub(relative_file_path, '\\', '/')
  -- end

  -- 5. Get remote origin URL
  local remote_cmd = { 'git', 'config', '--get', 'remote.origin.url' }
  local remote = vim.fn.system(remote_cmd)
  if vim.v.shell_error ~= 0 then
    vim.notify("Error getting git remote 'origin' URL.", vim.log.levels.ERROR)
    return
  end
  remote = vim.fn.trim(remote) -- Remove trailing newline

  -- 6. Get current branch name
  local branch_cmd = { 'git', 'rev-parse', '--abbrev-ref', 'HEAD' }
  local branch = vim.fn.system(branch_cmd)
  if vim.v.shell_error ~= 0 then
    vim.notify("Error getting current git branch. Falling back to 'main'.", vim.log.levels.WARN)
    branch = "main" -- Default fallback
  else
    branch = vim.fn.trim(branch) -- Remove trailing newline
  end

  -- 7. Construct GitHub URL base
  local url_base = remote
  -- Convert SSH URL to HTTPS base: git@github.com:user/repo -> https://github.com/user/repo
  url_base = string.gsub(url_base, '^git@github%.com:', 'https://github.com/')
  -- Remove .git suffix if present
  url_base = string.gsub(url_base, '%.git$', '')
  -- Ensure it starts with https:// (handles case where remote is already https)
  if not string.find(url_base, '^https://') then
     -- This case might indicate an unsupported URL format (e.g., http, file)
     vim.notify("Warning: Remote URL format might not be standard HTTPS or SSH: " .. remote, vim.log.levels.WARN)
     -- Attempt a basic conversion assuming github.com if it wasn't SSH
     if string.find(url_base, "github.com") then
        url_base = "https://" .. string.gsub(url_base, "^.*github.com[:/]", "github.com/")
     else
        vim.notify("Error: Could not determine GitHub base URL from remote: " .. remote, vim.log.levels.ERROR)
        return
     end
  end


  -- 8. Construct the full URL
  local full_url = url_base .. '/blame/' .. branch .. '/' .. relative_file_path .. '#L' .. line_number

  -- 9. Determine the OS-specific opener command
  local opener
  local os = vim.loop.os_uname().sysname
  if os == "Linux" then
    opener = "xdg-open"
  elseif os == "Darwin" then -- macOS
    opener = "open"
  elseif os == "Windows_NT" then
    -- Using 'start ""' is safer for URLs with '&' on Windows cmd.exe
    opener = 'start ""'
  else
    vim.notify("Unsupported OS: " .. os .. ". Trying 'xdg-open'.", vim.log.levels.WARN)
    opener = "xdg-open" -- Fallback guess
  end

  -- 10. Open the URL asynchronously
  local cmd = opener .. ' ' .. vim.fn.shellescape(full_url)
  vim.fn.jobstart(cmd, { detach = true })

  vim.notify('Opening GitHub blame: ' .. full_url, vim.log.levels.INFO)
end

-- Optional: Create a user command to easily call the function
vim.api.nvim_create_user_command(
  'GitHubBlame', -- Command name (:GitHubBlame)
  GitHubBlame,   -- Function to call
  {}             -- Command attributes (e.g., range, nargs - none needed here)
)
