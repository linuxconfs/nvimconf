return {
  {
    "yetone/avante.nvim",
    event = "VeryLazy",
    lazy = false,
    version = false, -- Set this to "*" to always pull the latest release version, or set it to false to update to the latest code changes.
    opts = {
      -- provider = "ollama",
      -- auto_suggestions_provider = "ollama",
      -- ollama = {
      --   __inherited_from = "openai",
      --   endpoint = "http://127.0.0.1:11434",
      --   model = "qwen2.5-coder:7b",
      --   max_tokens = 32768,
      --   disable_tools = true,
      -- },
      provider = "deepseek",
      auto_suggestions_provider = "deepseek",
      vendors = {
        -- official:
        -- deepseek = {
        --   __inherited_from = "openai",
        --   api_key_name = "DEEPSEEK_API_KEY",
        --   endpoint = "https://api.deepseek.com/v1",
        --   model = "deepseek-reasoner",
        --   timeout = 20000, -- timeout in milliseconds
        --   disable_tools = true,
        -- },
        deepseek = {
          __inherited_from = "openai",
          api_key_name = "DEEPSEEK_API_KEY",
          endpoint = "https://ark.cn-beijing.volces.com/api/v3",
          model = "deepseek-r1-250120",
          timeout = 20000, -- timeout in milliseconds
          -- endpoint = "http://192.168.1.100:9990/v1",
          -- model = "dllama_model_llama3_2_1b_instruct_q40.m",
          disable_tools = true,
        },
      },
    }, -- if you want to build from source then do `make BUILD_FROM_SOURCE=true`
    build = "make",
    -- build = "powershell -ExecutionPolicy Bypass -File Build.ps1 -BuildFromSource false" -- for windows
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
      "stevearc/dressing.nvim",
      "nvim-lua/plenary.nvim",
      "MunifTanjim/nui.nvim",
      --- The below dependencies are optional,
      "echasnovski/mini.pick", -- for file_selector provider mini.pick
      "nvim-telescope/telescope.nvim", -- for file_selector provider telescope
      "hrsh7th/nvim-cmp", -- autocompletion for avante commands and mentions
      "ibhagwan/fzf-lua", -- for file_selector provider fzf
      "nvim-tree/nvim-web-devicons", -- or echasnovski/mini.icons
      "zbirenbaum/copilot.lua", -- for providers='copilot'
      {
        -- support for image pasting
        "HakonHarnes/img-clip.nvim",
        event = "VeryLazy",
        opts = {
          -- recommended settings
          default = {
            embed_image_as_base64 = false,
            prompt_for_file_name = false,
            drag_and_drop = {
              insert_mode = true,
            },
            -- required for Windows users
            use_absolute_path = true,
          },
        },
      },
      {
        -- Make sure to set this up properly if you have lazy=true
        "MeanderingProgrammer/render-markdown.nvim",
        opts = {
          file_types = { "markdown", "Avante" },
        },
        ft = { "markdown", "Avante" },
      },
    },
  },
  {
    "olimorris/codecompanion.nvim",
    keys = {
      {
        "<leader>ia",
        "<cmd>CodeCompanionActions<cr>",
        mode = { "n", "v" },
        desc = "CodeCompanion Actions",
      },
      {
        "<leader>ic",
        "<cmd>CodeCompanionChat Toggle<cr>",
        mode = { "n", "v" },
        desc = "Toggle CodeCompanion Chat",
      },
      -- { "ga", "<cmd>CodeCompanionChat Add<cr>", mode = "v", desc = "Add to CodeCompanion Chat" },
    },
    opts = {
      --Refer to: https://github.com/olimorris/codecompanion.nvim/blob/main/lua/codecompanion/config.lua
      adapters = {
        -- copilot = function()
        --   return require("codecompanion.adapters").extend("copilot", {
        --     schema = {
        --       model = {
        --         default = "claude-3-7-sonnet-20250219",
        --       },
        --     },
        --   })
        -- end,
        -- anthropic = function()
        --   return require("codecompanion.adapters").extend("anthropic", {
        --     schema = {
        --       model = {
        --         default = "claude-3-7-sonnet-20250219",
        --       },
        --     },
        --   })
        -- end,
        deepseek = function()
          local function clean_streamed_data(data)
            if type(data) == "table" then
              return data.body
            end
            local find_json_start = string.find(data, "{") or 1
            return string.sub(data, find_json_start)
          end
          return require("codecompanion.adapters").extend("openai_compatible", {
            env = {
              url = "https://ark.cn-beijing.volces.com/api/v3",
              api_key = os.getenv("DEEPSEEK_API_KEY"),
              chat_url = "/chat/completions",
            },
            handlers = {
              chat_output = function(self, data)
                local output = {}

                if data and data ~= "" then
                  local data_mod = clean_streamed_data(data)
                  local ok, json = pcall(vim.json.decode, data_mod, { luanil = { object = true } })

                  if ok and json.choices and #json.choices > 0 then
                    local choice = json.choices[1]
                    local delta = (self.opts and self.opts.stream) and choice.delta or choice.message

                    if delta then
                      if delta.role then
                        output.role = delta.role
                      else
                        output.role = nil
                      end

                      output.content = ""

                      -- ADD THINKING OUTPUT
                      if delta.reasoning_content then
                        output.content = delta.reasoning_content
                      end

                      if delta.content then
                        output.content = output.content .. delta.content
                      end

                      return {
                        status = "success",
                        output = output,
                      }
                    end
                  end
                end
              end,
            },
            schema = {
              model = {
                default = "deepseek-r1-250120", -- define llm model to be used
              },
              temperature = {
                order = 2,
                mapping = "parameters",
                type = "number",
                optional = true,
                default = 0.0,
                desc = "What sampling temperature to use, between 0 and 2. Higher values like 0.8 will make the output more random, while lower values like 0.2 will make it more focused and deterministic. We generally recommend altering this or top_p but not both.",
                validate = function(n)
                  return n >= 0 and n <= 2, "Must be between 0 and 2"
                end,
              },
            },
          })
        end,
      },
      display = {
        action_palette = {
          provider = "telescope",
        },
      },
      strategies = {
        --NOTE: Change the adapter as required
        chat = {
          -- adapter = "my_openai",
          -- adapter = "anthropic",
          adapter = "deepseek",
          slash_commands = {
            ["buffer"] = {
              opts = {
                provider = "fzf_lua", -- default|telescope|mini_pick|fzf_lua
              },
            },
            ["file"] = {
              opts = {
                provider = "fzf_lua", -- default|telescope|mini_pick|fzf_lua
              },
            },
            ["help"] = {
              opts = {
                provider = "fzf_lua", -- telescope|mini_pick|fzf_lua
              },
            },
            ["symbols"] = {
              opts = {
                provider = "fzf_lua", -- default|telescope|mini_pick|fzf_lua
              },
            },
          },
        },
      },
      inline = {
        -- adapter = "my_openai"
        -- adapter = "anthropic",
        adapter = "deepseek",
      },
      opts = {
        log_level = "DEBUG",
      },
    },
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-treesitter/nvim-treesitter",
    },
  },
}
