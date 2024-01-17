local on_attach = require("plugins.configs.lspconfig").on_attach
local capabilities = require("plugins.configs.lspconfig").capabilities

local lspconfig = require "lspconfig"
-- local util = require "lspconfig.util"

local servers = { "html", "cssls", "tsserver", "clangd" }

for _, lsp in ipairs(servers) do
  lspconfig[lsp].setup {
    on_attach = on_attach,
    capabilities = capabilities,
  }
end

-- lspconfig.eslint.setup {
--   settings = {
--     format = false,
--     workingDirectory = {
--       mode = "location",
--     },
--     -- root_dir = "~/Desktop/git/informer-bot/src/services/admin/",
--   },
-- }
