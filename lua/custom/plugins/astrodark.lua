return {
  {
    'AstroNvim/astrotheme',
    priority = 1000,
    opts = {
      palette = 'astrodark', -- String of the default palette to use or a table override
      background = {
        light = 'astrolight',
        dark = 'astrodark',
      },

      style = {
        transparent = false, -- Bool value, toggles transparency
        inactive = true, -- Bool value, toggles inactive window color
        float = true, -- Bool value, toggles floating windows background colors
        neotree = true, -- Bool value, toggles neo-tree background color
        border = true, -- Bool value, toggles borders
        title_invert = true, -- Bool value, swaps background and foreground colors for title
        italic_comments = true, -- Bool value, toggles italic comments
        simple_syntax_colors = true, -- Bool value, simplifies the amounts of colors for syntax highlighting
      },

      termguicolors = true,
      terminal_color = true,
      plugin_default = 'auto', -- Sets how all plugins will be loaded
    },
  },
}
