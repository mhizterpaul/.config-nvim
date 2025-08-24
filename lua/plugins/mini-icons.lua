-- Mini icons
return   {
    "echasnovski/mini.icons",
    version = false,
    config = function()
      require("mini.icons").setup({
        icons = {
          File = "",
          Module = "",
          Namespace = "",
          Package = "",
          Class = "",
          Method = "",
          Property = "",
          Field = "",
          Constructor = "",
          Enum = "",
          Interface = "",
          Function = "",
          Variable = "",
          Constant = "",
          String = "",
          Number = "#",
          Boolean = "",
          Array = "",
          Object = "",
          Key = "",
          Null = "",
          EnumMember = "",
          Struct = "",
          Event = "",
          Operator = "",
          TypeParameter = "",
        },
      })
    end,
    opts = {
      file = {
        [".eslintrc.js"] = { glyph = "󰱺", hl = "MiniIconsYellow" },
        [".node-version"] = { glyph = "", hl = "MiniIconsGreen" },
        [".prettierrc"] = { glyph = "", hl = "MiniIconsPurple" },
        [".yarnrc.yml"] = { glyph = "", hl = "MiniIconsBlue" },
        ["eslint.config.js"] = { glyph = "󰱺", hl = "MiniIconsYellow" },
        ["package.json"] = { glyph = "", hl = "MiniIconsGreen" },
        ["tsconfig.json"] = { glyph = "", hl = "MiniIconsAzure" },
        ["tsconfig.build.json"] = { glyph = "", hl = "MiniIconsAzure" },
        ["yarn.lock"] = { glyph = "", hl = "MiniIconsBlue" },
      },
    },
  }

