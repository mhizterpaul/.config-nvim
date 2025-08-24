-- nvim-lsp.lua

return {
    "neovim/nvim-lspconfig",
    version = "latest",
    config = function()
      require("lsp")
    end,
    opts = {
      servers = {
        tsserver = { enabled = false },
        ts_ls   = { enabled = false },
        vtsls   = {
          filetypes = {
            "javascript",
            "javascriptreact",
            "javascript.jsx",
            "typescript",
            "typescriptreact",
            "typescript.tsx",
          },
          settings = {
            complete_function_calls = true,
            vtsls = {
              enableMoveToFileCodeAction = true,
              autoUseWorkspaceTsdk = true,
              experimental = { maxInlayHintLength = 30, completion = { enableServerSideFuzzyMatch = true } },
            },
            typescript = {
              updateImportsOnFileMove = { enabled = "always" },
              suggest = { completeFunctionCalls = true },
              inlayHints = {
                enumMemberValues = { enabled = true },
                functionLikeReturnTypes = { enabled = true },
                parameterNames = { enabled = "literals" },
                parameterTypes = { enabled = true },
                propertyDeclarationTypes = { enabled = true },
                variableTypes = { enabled = false },
              },
            },
          },
        },
      },
      setup = {
        tsserver = function() return true end,
        ts_ls   = function() return true end,
        vtsls = function(_, opts)
          vim.api.nvim_create_autocmd("LspAttach", {
            callback = function(args)
              local client = vim.lsp.get_client_by_id(args.data.client_id)
              if client.name ~= "vtsls" then return end
              local buf = args.buf

              -- Go to source definition
              vim.keymap.set("n", "gD", function()
                local params = vim.lsp.util.make_position_params()
                vim.lsp.buf_request(buf, "typescript.goToSourceDefinition", params, function(err, result)
                  if err then return end
                  if result and not vim.tbl_isempty(result) then
                    vim.lsp.util.jump_to_location(result[1])
                  end
                end)
              end, { buffer = buf, desc = "Goto Source Definition" })

              -- Find all file references
              vim.keymap.set("n", "gR", function()
                vim.lsp.buf_request(buf, "typescript.findAllFileReferences", { textDocument = vim.lsp.util.make_text_document_params() }, function(err, result)
                  if err then return end
                  -- optionally open result with quickfix / telescope
                end)
              end, { buffer = buf, desc = "File References" })

              -- Organize Imports
              vim.keymap.set("n", "<leader>co", function()
                vim.lsp.buf.code_action({ context = { only = { "source.organizeImports" } } })
              end, { buffer = buf, desc = "Organize Imports" })

              -- Add missing imports
              vim.keymap.set("n", "<leader>cM", function()
                vim.lsp.buf.code_action({ context = { only = { "source.addMissingImports.ts" } } })
              end, { buffer = buf, desc = "Add missing imports" })

              -- Remove unused imports
              vim.keymap.set("n", "<leader>cu", function()
                vim.lsp.buf.code_action({ context = { only = { "source.removeUnused.ts" } } })
              end, { buffer = buf, desc = "Remove unused imports" })

              -- Fix all diagnostics
              vim.keymap.set("n", "<leader>cD", function()
                vim.lsp.buf.code_action({ context = { only = { "source.fixAll.ts" } } })
              end, { buffer = buf, desc = "Fix all diagnostics" })

              -- Select TS version
              vim.keymap.set("n", "<leader>cV", function()
                vim.lsp.buf_request(buf, "typescript.selectTypeScriptVersion", {}, function() end)
              end, { buffer = buf, desc = "Select TS workspace version" })

              -- Move file refactoring
              client.commands["_typescript.moveToFileRefactoring"] = function(command)
                local action, uri, range = unpack(command.arguments)
                local fname = vim.uri_to_fname(uri)

                local function move(newf)
                  client.request("workspace/executeCommand", {
                    command = command.command,
                    arguments = { action, uri, range, newf },
                  })
                end

                client.request("workspace/executeCommand", {
                  command = "typescript.tsserverRequest",
                  arguments = {
                    "getMoveToRefactoringFileSuggestions",
                    {
                      file = fname,
                      startLine = range.start.line + 1,
                      startOffset = range.start.character + 1,
                      endLine = range["end"].line + 1,
                      endOffset = range["end"].character + 1,
                    },
                  },
                }, function(_, result)
                  local files = result.body.files or {}
                  table.insert(files, 1, "Enter new path...")
                  vim.ui.select(files, {
                    prompt = "Select move destination:",
                    format_item = function(f) return vim.fn.fnamemodify(f, ":~:.") end,
                  }, function(f)
                    if f and f:find("^Enter new path") then
                      vim.ui.input({
                        prompt = "Enter move destination:",
                        default = vim.fn.fnamemodify(fname, ":h") .. "/",
                        completion = "file",
                      }, function(newf) if newf then move(newf) end end)
                    elseif f then
                      move(f)
                    end
                  end)
                end)
              end
            end
          })
          -- copy TypeScript settings to JavaScript
          opts.settings.javascript = vim.tbl_deep_extend("force", {}, opts.settings.typescript, opts.settings.javascript or {})
        end
      },
    },
  }
