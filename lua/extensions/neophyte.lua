local neophyte = require('neophyte')
neophyte.setup({
  fonts = {
    {
      name = 'Iosevka Nerd Font Mono',
    },
    -- Fallback fonts 
    -- {
    --   name = 'Monaspace Argon Var',
    --   -- Variable font axes
    --   variations = {
    --     {
    --       name = 'slnt',
    --       value = -11,
    --     },
    --   },
    -- },
    -- -- Shorthand for no features or variations
    -- 'Symbols Nerd Font',
    -- 'Noto Color Emoji',
  },
  font_size = {
    kind = 'width', -- 'width' | 'height'
    size = 13,
  },
  -- Multipliers of the base animation speed.
  -- To disable animations, set these to large values like 1000.
  cursor_speed = 2,
  scroll_speed = 2,
  -- Increase or decrease the distance from the baseline for underlines.
  underline_offset = 1,
  -- For transparent window effects, use this to set the default background color. 
  -- This is because most colorschemes in transparent mode unset the background,
  -- which normally defaults to the terminal background, but we don't have that here. 
  -- You must also pass --transparent as a command-line argument to see the effect.
  -- Channel values are in the range 0-255. 
  -- bg_override = {
  --   r = 48,
  --   g = 52,
  --   b = 70,
  --   a = 128,
  -- },
})

-- There are also freestanding functions to set these options as desired. 
-- Below is a keymap for increasing and decreasing the font size:

-- Increase font size
vim.keymap.set('n', '<D-+>', function()
  neophyte.set_font_width(neophyte.get_font_width() + 1)
end)

-- Decrease font size
vim.keymap.set('n', '<D-->', function()
  neophyte.set_font_width(neophyte.get_font_width() - 1)
end)

-- Neophyte can also record frames to a PNG sequence.
-- You can convert to a video with ffmpeg:
--
-- ffmpeg -framerate 60 -pattern_type glob -i '/my/frames/location/*.png' 
-- -pix_fmt yuv422p -c:v libx264 -vf 
-- "colorspace=all=bt709:iprimaries=bt709:itrc=srgb:ispace=bt709:range=tv:irange=pc"  
-- -color_range 1 -colorspace 1 -color_primaries 1 -crf 23 -y /my/output/video.mp4

-- Start rendering
neophyte.start_render('/directory/to/output/frames/')
-- Stop rendering
neophyte.end_render()
