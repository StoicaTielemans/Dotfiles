return {
  -- give #fff color
  'norcalli/nvim-colorizer.lua',
  config = function()
    require('colorizer').setup {
      '*', -- Highlight all files, but customize some others.
      css = { css = true, css_fn = true }, -- Enable parsing rgb(...) functions in css.
      html = { css = true, css_fn = true }, -- Disable parsing "names" like Blue or Gray
    }
  end,
}
