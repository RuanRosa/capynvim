vim.keymap.set('n', '<leader>tt', function()
  local filename = vim.fn.expand '%:t'
  local dirname = vim.fn.expand '%:h'
  if not filename:match '_test.go' then
    local impl_filename = filename:gsub('.go', '_test.go')
    vim.cmd('edit ' .. dirname .. '/' .. impl_filename)
  else
    local test_filename = filename:gsub('_test.go', '.go')
    vim.cmd('edit ' .. dirname .. '/' .. test_filename)
  end
end)

-- Test coverage on module

local coverage_ns = vim.api.nvim_create_namespace 'go_coverage'
local is_coverage_on = false

vim.api.nvim_command 'highlight Covered cterm=NONE ctermbg=22 guibg=#003300'
vim.api.nvim_command 'highlight Uncovered cterm=NONE ctermbg=52 guibg=#330000'

local function hightlight_coverage(buf, lines)
  for _, line in ipairs(lines) do
    local start_line, start_col, end_line, end_col, ok = line:match ':(%d+).(%d+),(%d+).(%d+) %d+ (%d)'
    start_line = tonumber(start_line)
    start_col = tonumber(start_col)
    end_line = tonumber(end_line)
    end_col = tonumber(end_col)
    local hgroup = ok == '1' and 'Covered' or 'Uncovered'

    vim.api.nvim_buf_add_highlight(buf, coverage_ns, hgroup, start_line - 1, start_col - 1, 1000)
    for i = start_line, end_line - 2 do
      vim.api.nvim_buf_add_highlight(buf, coverage_ns, hgroup, i, 0, 1000)
    end
    vim.api.nvim_buf_add_highlight(buf, coverage_ns, hgroup, end_line - 1, 0, end_col - 1)
  end
end

vim.keymap.set('n', '<leader>tc', function()
  local cwd = vim.loop.cwd()
  if cwd == nil then
    vim.print 'Not in a project directory'
    return
  end
  cwd = string.gsub(cwd, '%-', '%%-')
  local bufname = vim.api.nvim_buf_get_name(0)
  if not bufname:match(cwd) then
    vim.print 'Not in the same project directory'
    return
  end

  local buf = vim.api.nvim_get_current_buf()
  vim.api.nvim_buf_clear_namespace(buf, coverage_ns, 0, -1)

  if is_coverage_on then
    is_coverage_on = false
    return
  end

  local file_path = string.gsub(bufname, cwd, '')
  local file_name = file_path:match '/([^/]+)$'
  local module_name = string.gsub(file_path, '/' .. file_name, '')

  vim.print('Running coverage for module ' .. module_name)

  local cmd = '!go test -count=1 -coverprofile /tmp/nvim_gocoverage -failfast ./' .. module_name .. ' | grep -P "^FAIL|:\\d+.\\d+,\\d+.\\d+ \\d+ \\d+$" || :'
  vim.api.nvim_exec2(cmd, {})

  -- read from /tmp/nvim_gocoverage
  local lines = vim.fn.readfile '/tmp/nvim_gocoverage'

  if #lines < 2 then
    vim.print('No coverage data found for ' .. module_name)
    return
  end

  if lines[#lines - 1]:match 'FAIL' then
    vim.print 'Tests failed'
    return
  end

  lines = vim.tbl_filter(function(line)
    return line:match(file_name .. ':')
  end, lines)

  if #lines == 0 then
    vim.print('No coverage data for ' .. file_name .. ' found')
    return
  end

  hightlight_coverage(buf, lines)
  is_coverage_on = true
  vim.print 'Coverage data found'
end, { noremap = true, silent = true })


-- if set, when we switch between buffers, it will not split more than once. It will switch to the existing buffer instead
vim.opt.switchbuf = 'useopen'
