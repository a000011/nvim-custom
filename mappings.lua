---@type MappingsTable
local M = {}

M.general = {
  n = {
    [";"] = { ":", "enter command mode", opts = { nowait = true } },
    ["<leader>F"] = { ":Telescope lsp_references<CR>", "find usages", opts = { nowait = true } },
    ["<leader>gz"] = { ":DiffviewFileHistory %<CR>", "current file history", opts = { nowait = true } },
    ["<leader>gd"] = { ":DiffviewOpen<CR>", "show diff", opts = { nowait = true } },
    ["<leader>gc"] = { ":DiffviewClose<CR>", "close git diff", opts = { nowait = true } },
    ["<leader>go"] = { ":GitBlameOpenCommitURL<CR>", "open commit url", opts = { nowait = true } },
  },
  v = {
    [">"] = { ">gv", "indent" },
  },
}

-- more keybinds!

return M
