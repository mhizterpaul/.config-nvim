-- lua/plugins/avante.lua
return {
  "yetone/avante.nvim",
  build = "make",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "MunifTanjim/nui.nvim",
    "nvim-tree/nvim-web-devicons",
  },
  event = "VeryLazy",
  keys = {
    { "<leader>aa", "<cmd>AvanteAsk<cr>",    desc = "Avante: Ask" },
    { "<leader>ae", "<cmd>AvanteEdit<cr>",   desc = "Avante: Edit selection" },
    { "<leader>at", "<cmd>AvanteToggle<cr>", desc = "Avante: Toggle panel" },
  },
  config = function()
    ---------------------------------------------------------------------------
    -- Gemini multi-key pool (all 7 keys)
    ---------------------------------------------------------------------------
    local raw_gemini_keys = {
      os.getenv("GEMINI_KEY_1"),
      os.getenv("GEMINI_KEY_2"),
      os.getenv("GEMINI_KEY_3"),
      os.getenv("GEMINI_KEY_4"),
      os.getenv("GEMINI_KEY_5"),
      os.getenv("GEMINI_KEY_6"),
      os.getenv("GEMINI_KEY_7"),
    }

    local gemini_keys = {}
    for _, key in ipairs(raw_gemini_keys) do
      if key and key ~= "" then table.insert(gemini_keys, key) end
    end

    if #gemini_keys == 0 then
      vim.notify("[Avante] No valid Gemini API keys found!", vim.log.levels.ERROR)
      return
    end

    local gemini_index = 1
    local function current_gemini_key() return gemini_keys[gemini_index] end
    local function rotate_gemini_key()
      gemini_index = (gemini_index % #gemini_keys) + 1
      return gemini_keys[gemini_index]
    end

    ---------------------------------------------------------------------------
    -- Avante setup: DeepSeek default, Gemini fallback
    ---------------------------------------------------------------------------
    require("avante").setup({
      provider = "deepseek", -- default
      templates_path = vim.fn.stdpath("config") .. "/avante-templates",
      providers = {
        -- DeepSeek provider
        deepseek = {
          __inherited_from = "openai",
          endpoint         = "https://openrouter.ai/api/v1",
          model            = "deepseek/deepseek-chat-v3.1",
          api_key_name     = "OPENROUTER_API_KEY",
          on_error = function(err, retry)
            if err then
              vim.notify("[Avante] DeepSeek error: " .. err, vim.log.levels.WARN)
              -- fallback to Gemini automatically
              if retry then return retry("gemini") end
            end
          end,
        },

        -- Gemini provider (inherits from OpenAI)
        gemini = {
          __inherited_from = "openai",
          endpoint         = "https://generativelanguage.googleapis.com/v1beta/openai/",
          model            = "gemini-2.5-flash",
          api_key          = function() return current_gemini_key() end,
          on_error = function(err, retry)
            if err and (err:match("429") or err:match("quota")
                       or err:match("403") or err:match("401")) then
              vim.notify("[Avante] Gemini key quota/auth error. Rotating key...", vim.log.levels.WARN)
              rotate_gemini_key()
              if retry then return retry() end
            end
          end,
        },
      },

      strategy = function(request)
        if request.type == "ask" or request.type == "plan" then
          return "deepseek"
        elseif request.type == "edit" or request.type == "new_file" then
          return "gemini"
        end
        return "deepseek"
      end,
    })
  end,
}
