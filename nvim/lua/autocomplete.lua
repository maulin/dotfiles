local cmp = require('cmp')
local luasnip = require('luasnip')
local cmp_action = require('lsp-zero').cmp_action()
local cmp_format = require('lsp-zero').cmp_format({details = true})

luasnip.filetype_extend("ruby", {"rails"})
require('luasnip.loaders.from_vscode').lazy_load()

cmp.setup({
  window = {
    completion = cmp.config.window.bordered(),
    documentation = cmp.config.window.bordered(),
  },
  sources = {
    {name = 'nvim_lsp'},
    {name = 'luasnip'},
    {name = 'buffer'},
  },
  mapping = cmp.mapping.preset.insert({
    ['<CR>'] = cmp.mapping.confirm({select = false}),
  }),
  preselect = 'item',
  completion = {
    completeopt = 'menu,menuone,noinsert'
  },
  snippet = {
    expand = function(args)
      luasnip.lsp_expand(args.body)
    end,
  },
  formatting = cmp_format,
})
