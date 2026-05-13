local map = vim.keymap.set
local opts = { silent = true }

-- Quick Escape from insert/visual mode
map("i", ";;", "<Esc>", opts)
map("x", ";;", "<Esc>", opts)

-- Switch to previous buffer
map("n", "<leader>e", ":b#<CR>", { desc = "Switch to previous buffer" })
map("x", "<leader>e", ":b#<CR>", { desc = "Switch to previous buffer" })

-- System clipboard
map("x", "<leader>y", '"*y', { desc = "Copy to system clipboard" })
map("n", "<leader>p", '"*p', { desc = "Paste from system clipboard" })
map("x", "<leader>p", '"*p', { desc = "Paste from system clipboard" })

-- Scroll with ;j / ;k
map("n", ";j", "<C-D>", { desc = "Scroll down" })
map("n", ";k", "<C-U>", { desc = "Scroll up" })
map("x", ";j", "<C-D>", { desc = "Scroll down" })
map("x", ";k", "<C-U>", { desc = "Scroll up" })

-- Window navigation and management
map("n", "<leader>h", "<C-W>h", { desc = "Go to left window" })
map("n", "<leader>j", "<C-W>j", { desc = "Go to lower window" })
map("n", "<leader>k", "<C-W>k", { desc = "Go to upper window" })
map("n", "<leader>l", "<C-W>l", { desc = "Go to right window" })
map("n", "<leader>s", "<C-W>s", { desc = "Split window horizontally" })
map("n", "<leader>v", "<C-W>v", { desc = "Split window vertically" })
map("n", "<leader>o", "<C-W>o", { desc = "Close other windows" })
map("n", "<leader>x", "<C-W>c", { desc = "Close window" })
map("n", "<leader>c", "<C-W>x", { desc = "Exchange windows" })
map("n", "<leader>m", "<C-W><", { desc = "Decrease window width" })
map("n", "<leader>.", "<C-W>>", { desc = "Increase window width" })

-- Quickfix navigation
map("n", ";n", ":cn<CR>", { desc = "Next quickfix item" })
map("n", ";p", ":cp<CR>", { desc = "Previous quickfix item" })

-- Toggle search highlighting
map("n", ";h", ":set hlsearch!<CR>", { desc = "Toggle search highlighting" })

-- Toggle line wrapping (with buffer-local j/k/0/$ remap when wrapping)
local function toggle_wrap()
  if vim.wo.wrap then
    print "Wrap OFF"
    vim.wo.wrap = false
    vim.o.virtualedit = "all"
    pcall(vim.keymap.del, "n", "k", { buffer = true })
    pcall(vim.keymap.del, "n", "j", { buffer = true })
    pcall(vim.keymap.del, "n", "0", { buffer = true })
    pcall(vim.keymap.del, "n", "$", { buffer = true })
  else
    print "Wrap ON"
    vim.wo.wrap = true
    vim.wo.linebreak = true
    vim.wo.list = false
    vim.o.virtualedit = ""
    vim.opt_local.display:append "lastline"
    map("n", "k", "gk", { buffer = true, silent = true })
    map("n", "j", "gj", { buffer = true, silent = true })
    map("n", "0", "g0", { buffer = true, silent = true })
    map("n", "$", "g$", { buffer = true, silent = true })
  end
end
map("n", "<leader>w", toggle_wrap, { desc = "Toggle line wrapping" })

-- LSP buffer-local bindings
vim.api.nvim_create_autocmd("LspAttach", {
  callback = function(args)
    local bufnr = args.buf
    local client = vim.lsp.get_client_by_id(args.data.client_id)

    map("n", "<C-]>", vim.lsp.buf.definition, { buffer = bufnr, desc = "Go to definition" })
    map("x", "<C-]>", vim.lsp.buf.definition, { buffer = bufnr, desc = "Go to definition" })
    map("n", "<C-h>", vim.lsp.buf.rename, { buffer = bufnr, desc = "Rename symbol" })
    map("x", "<C-h>", vim.lsp.buf.rename, { buffer = bufnr, desc = "Rename symbol" })

    if client and client.name == "clangd" then
      map("n", ",of", ":ClangdSwitchSourceHeader<CR>", { buffer = bufnr, desc = "Switch header/source" })
    end
  end,
})

-- Terminal mode window navigation
map("t", "<leader>h", "<cmd>wincmd h<cr>", { desc = "Go to left window" })
map("t", "<leader>j", "<cmd>wincmd j<cr>", { desc = "Go to lower window" })
map("t", "<leader>k", "<cmd>wincmd k<cr>", { desc = "Go to upper window" })
map("t", "<leader>l", "<cmd>wincmd l<cr>", { desc = "Go to right window" })
map("t", "<leader>x", "<cmd>wincmd c<cr>", { desc = "Close window" })

-- Remove trailing whitespace
vim.api.nvim_create_user_command("Delwsp", ":%s/\\s\\+$//e", { desc = "Remove trailing whitespace" })

-- Toggle spell
map("n", "<leader>ts", "<cmd>set spell!<CR>", { desc = "Toggle Spell", silent = true })
