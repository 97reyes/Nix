{
  home.file.".config/nvim/lua/plugins/theme/init.lua".text = ''
    return {
  {
    "Alexis12119/nightly.nvim",
    lazy = true,
    priority = 1000,
  },

  {
    "marko-cerovac/material.nvim",
    lazy = true,
    priority = 1000,
    config = function()
      vim.g.material_style = "deep ocean"
    end,
  },

  {
    "folke/tokyonight.nvim",
    lazy = true,
    priority = 1000,
  },

  {
    "catppuccin/nvim",
    lazy = true,
    name = "catppuccin",
    priority = 1000,
  },

  {
    "navarasu/onedark.nvim",
    lazy = true,
    priority = 1000,
  },

  {
    "rebelot/kanagawa.nvim",
    lazy = true,
    priority = 1000,
  },

  {
    "Mofiqul/dracula.nvim",
    lazy = true,
    priority = 1000,
  },
  {
    "ellisonleao/gruvbox.nvim",
    lazy = true,
    name = "gruvbox",
    priority = 1000,
  },
}
    '';
}
