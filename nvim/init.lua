require("config.lazy")
require("mappings.neo-tree")
require("mappings.telescopo")
require("mappings.navigation")
require("mappings.gitsigns")
require("mappings.lsp")
require("mappings.toggle-term")
require("mappings.dap")
require("mappings.golang")

vim.cmd.colorscheme("retrobox")

vim.cmd.set("number")

vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
-- vim.opt.expandtab = true

vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, {
	border = "single",
})

vim.opt.clipboard = "unnamedplus"
vim.keymap.set('v', '>', '>gv')
vim.keymap.set('v', '<', '<gv')

vim.cmd.set('nowrap')
vim.cmd('TransparentEnable')

require('lualine').setup {
  options = {
    icons_enabled = true,
    theme = 'auto',
    component_separators = { left = '', right = ''},
    section_separators = { left = '', right = ''},
    disabled_filetypes = {
      statusline = {},
      winbar = {},
    },
    ignore_focus = {},
    always_divide_middle = true,
    always_show_tabline = true,
    globalstatus = false,
    refresh = {
      statusline = 100,
      tabline = 100,
      winbar = 100,
    }
  },
  sections = {
    lualine_a = {'mode'},
    lualine_b = {'branch', 'diff', 'diagnostics'},
    lualine_c = {'filename'},
    lualine_x = {'encoding', 'fileformat', 'filetype'},
    lualine_y = {'progress'},
    lualine_z = {'location'}
  },
  inactive_sections = {
    lualine_a = {},
    lualine_b = {},
    lualine_c = {'filename'},
    lualine_x = {'location'},
    lualine_y = {},
    lualine_z = {}
  },
  tabline = {},
  winbar = {},
  inactive_winbar = {},
  extensions = {}
}

