-- You can add your own plugins here or in other files in this directory!
--  I promise not to create any merge conflicts in this directory :)
--
-- See the kickstart.nvim README for more information

-- ── Formatting: oxfmt via conform ──────────────────────────────
require('conform').setup {
  notify_on_error = false,
  format_on_save = function(bufnr)
    local ft = vim.bo[bufnr].filetype
    local enabled = {
      javascript = true, javascriptreact = true,
      typescript = true, typescriptreact = true,
    }
    return enabled[ft] and { timeout_ms = 1000, lsp_format = 'fallback' } or nil
  end,
  formatters_by_ft = {
    javascript      = { 'oxfmt' },
    javascriptreact = { 'oxfmt' },
    typescript      = { 'oxfmt' },
    typescriptreact = { 'oxfmt' },
  },
}

-- ── Linting: oxlint via its LSP server ─────────────────────────
-- nvim-lspconfig ships the `oxlint` config; kickstart loads lspconfig,
-- so we just enable it here (Neovim 0.11+ vim.lsp API).
vim.lsp.enable 'oxlint'

-- Optional: auto-fix all fixable issues on save
vim.api.nvim_create_autocmd('LspAttach', {
  callback = function(args)
    local client = vim.lsp.get_client_by_id(args.data.client_id)
    if client and client.name == 'oxlint' then
      vim.api.nvim_create_autocmd('BufWritePre', {
        buffer = args.buf,
        callback = function() vim.cmd 'silent! LspOxlintFixAll' end,
      })
    end
  end,
})
