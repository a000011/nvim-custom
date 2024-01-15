local overrides = require "custom.configs.overrides"

---@type NvPluginSpec[]
local plugins = {
  -- Override plugin definition options

  {
    "neovim/nvim-lspconfig",
    dependencies = {
      -- format & linting
      {
        "jose-elias-alvarez/null-ls.nvim",
        config = function()
          require "custom.configs.null-ls"
        end,
      },
    },
    config = function()
      require "plugins.configs.lspconfig"
      require "custom.configs.lspconfig"
    end, -- Override to setup mason-lspconfig
  },

  {
    "MunifTanjim/eslint.nvim",
    lazy = false,
    config = function()
      local null_ls = require "null-ls"
      local eslint = require "eslint"

      null_ls.setup()

      eslint.setup {
        bin = "eslint", -- or `eslint_d`
        code_actions = {
          enable = true,
          apply_on_save = {
            enable = true,
            types = { "directive", "problem", "suggestion", "layout" },
          },
          disable_rule_comment = {
            enable = true,
            location = "separate_line", -- or `same_line`
          },
        },
        diagnostics = {
          enable = true,
          report_unused_disable_directives = false,
          run_on = "type", -- or `save`
        },
      }
    end, -- Override to setup mason-lspconfig
  },

  {
    "elentok/format-on-save.nvim",
    lazy = false,
    config = function()
      local format_on_save = require "format-on-save"
      local formatters = require "format-on-save.formatters"

      format_on_save.setup {
        exclude_path_patterns = {
          "/node_modules/",
          ".local/share/nvim/lazy",
        },
        formatter_by_ft = {
          css = formatters.lsp,
          html = formatters.lsp,
          java = formatters.lsp,
          javascript = formatters.lsp,
          json = formatters.lsp,
          lua = formatters.lsp,
          markdown = formatters.prettierd,
          openscad = formatters.lsp,
          python = formatters.black,
          rust = formatters.lsp,
          scad = formatters.lsp,
          scss = formatters.lsp,
          sh = formatters.shfmt,
          terraform = formatters.lsp,
          typescript = formatters.lsp,
          typescriptreact = formatters.prettierd,
          yaml = formatters.lsp,

          -- Add your own shell formatters:
          myfiletype = formatters.shell { cmd = { "myformatter", "%" } },

          -- Add lazy formatter that will only run when formatting:
          my_custom_formatter = function()
            if vim.api.nvim_buf_get_name(0):match "/README.md$" then
              return formatters.prettierd
            else
              return formatters.lsp()
            end
          end,

          -- Add custom formatter
          filetype1 = formatters.remove_trailing_whitespace,
          filetype2 = formatters.custom {
            format = function(lines)
              return vim.tbl_map(function(line)
                return line:gsub("true", "false")
              end, lines)
            end,
          },

          -- Concatenate formatters
          python = {
            formatters.remove_trailing_whitespace,
            formatters.shell { cmd = "tidy-imports" },
            formatters.black,
            formatters.ruff,
          },

          -- Use a tempfile instead of stdin
          go = {
            formatters.shell {
              cmd = { "goimports-reviser", "-rm-unused", "-set-alias", "-format", "%" },
              tempfile = function()
                return vim.fn.expand "%" .. ".formatter-temp"
              end,
            },
            formatters.shell { cmd = { "gofmt" } },
          },

          -- Add conditional formatter that only runs if a certain file exists
          -- in one of the parent directories.
          javascript = {
            formatters.if_file_exists {
              pattern = ".eslintrc.*",
              formatter = formatters.eslint_d_fix,
            },
            formatters.if_file_exists {
              pattern = { ".prettierrc", ".prettierrc.*", "prettier.config.*" },
              formatter = formatters.prettierd,
            },
            -- By default it stops at the git repo root (or "/" if git repo not found)
            -- but it can be customized with the `stop_path` option:
            formatters.if_file_exists {
              pattern = ".prettierrc",
              formatter = formatters.prettierd,
              stop_path = function()
                return "/my/custom/stop/path"
              end,
            },
          },
        },

        -- Optional: fallback formatter to use when no formatters match the current filetype
        fallback_formatter = {
          formatters.remove_trailing_whitespace,
          formatters.remove_trailing_newlines,
          formatters.prettierd,
        },

        -- By default, all shell commands are prefixed with "sh -c" (see PR #3)
        -- To prevent that set `run_with_sh` to `false`.
        run_with_sh = false,
      }
    end, -- Override to setup mason-lspconfig
  },

  -- override plugin configs
  {
    "williamboman/mason.nvim",
    opts = overrides.mason,
  },

  {
    "nvim-treesitter/nvim-treesitter",
    opts = overrides.treesitter,
  },

  {
    "nvim-tree/nvim-tree.lua",
    opts = overrides.nvimtree,
  },

  -- Install a plugin
  {
    "Pocco81/auto-save.nvim",
    lazy = true,
    config = function()
      require("auto-save").setup {
        -- your config goes here
        -- or just leave it empty :)
        --
        {
          enabled = true, -- start auto-save when the plugin is loaded (i.e. when your package manager loads it)
          execution_message = {
            message = function() -- message to print on save
              return ("AutoSave: saved at " .. vim.fn.strftime "%H:%M:%S")
            end,
            dim = 0.18, -- dim the color of `message`
            cleaning_interval = 1250, -- (milliseconds) automatically clean MsgArea after displaying `message`. See :h MsgArea
          },
          trigger_events = { "InsertLeave", "TextChanged" }, -- vim events that trigger auto-save. See :h events
          -- function that determines whether to save the current buffer or not
          -- return true: if buffer is ok to be saved
          -- return false: if it's not ok to be saved
          condition = function(buf)
            local fn = vim.fn
            local utils = require "auto-save.utils.data"

            if fn.getbufvar(buf, "&modifiable") == 1 and utils.not_in(fn.getbufvar(buf, "&filetype"), {}) then
              return true -- met condition(s), can save
            end
            return false -- can't save
          end,
          write_all_buffers = false, -- write all buffers when the current one meets `condition`
          debounce_delay = 135, -- saves the file at most every `debounce_delay` milliseconds
          callbacks = { -- functions to be executed at different intervals
            enabling = nil, -- ran when enabling auto-save
            disabling = nil, -- ran when disabling auto-save
            before_asserting_save = nil, -- ran before checking `condition`
            before_saving = nil, -- ran before doing the actual save
            after_saving = nil, -- ran after doing the actual save
          },
        },
      }
    end,
  },
  {
    "max397574/better-escape.nvim",
    event = "InsertEnter",
    config = function()
      require("better_escape").setup()
    end,
  },

  -- To make a plugin not be loaded
  -- {
  --   "NvChad/nvim-colorizer.lua",
  --   enabled = false
  -- },

  -- All NvChad plugins are lazy-loaded by default
  -- For a plugin to be loaded, you will need to set either `ft`, `cmd`, `keys`, `event`, or set `lazy = false`
  -- If you want a plugin to load on startup, add `lazy = false` to a plugin spec, for example
  -- {
  --   "mg979/vim-visual-multi",
  --   lazy = false,
  -- }
}

return plugins
