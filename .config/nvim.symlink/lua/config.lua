-- Ident Blankline
require("indent_blankline").setup({})

-- Treesitter
require("nvim-treesitter.configs").setup({
    ensure_installed = "maintained",
    ignore_install = {},
    highlight = {
        enable = true,
        disable = {},
        additional_vim_regex_highlighting = false,
    },
    indent = {
        enable = true,
        disable = {
            "rust",
            "python",
            "yaml",
        },
    },
    matchup = {
        enable = true,
    },
    context_commentstring = {
        enable = true,
    },
})

-- Autocomplete
vim.opt.completeopt = "menu,menuone,noinsert"

local cmp = require("cmp")

local feedkey = function(key, mode)
    vim.api.nvim_feedkeys(
        vim.api.nvim_replace_termcodes(key, true, true, true),
        mode,
        true
    )
end

cmp.setup({
    sources = {
        { name = "nvim_lsp" },
        { name = "calc" },
        { name = "nvim_lua" },
    },
    mapping = {
        ["<C-x><C-o>"] = cmp.mapping.complete(), -- Manually trigger completion
        ["<Right>"] = cmp.mapping.confirm({
            behavior = cmp.ConfirmBehavior.Replace,
            select = true,
        }),
        ["<Tab>"] = function(fallback)
            if cmp.visible() then
                cmp.confirm({
                    behavior = cmp.ConfirmBehavior.Replace,
                    select = true,
                })
            elseif vim.fn["vsnip#available"](1) == 1 then
                feedkey("<Plug>(vsnip-expand-or-jump)", "")
            else
                fallback()
            end
        end,
    },
    snippet = {
        expand = function(args)
            vim.fn["vsnip#anonymous"](args.body)
        end,
    },
})

-- LSP
local nvim_lsp = require("lspconfig")

-- Use an on_attach function to only map the following keys
-- after the language server attaches to the current buffer
local on_attach = function(client, bufnr)
    local function buf_set_keymap(...)
        vim.api.nvim_buf_set_keymap(bufnr, ...)
    end

    -- Mappings.
    local opts = { noremap = true, silent = true }

    -- Nav between diagnostic results
    buf_set_keymap("n", "<up>", "<cmd>lua vim.diagnostic.goto_prev()<CR>", opts)
    buf_set_keymap("n", "<down>", "<cmd>lua vim.diagnostic.goto_next()<CR>", opts)
    -- Use 'K' to show LSP hover info
    buf_set_keymap("n", "K", "<cmd>lua vim.lsp.buf.hover()<CR>", opts)
    -- Go-to definition
    buf_set_keymap("n", "<leader>j", "<cmd>lua vim.lsp.buf.definition()<CR>", opts)
    -- References
    buf_set_keymap("n", "<leader>r", "<cmd>lua vim.lsp.buf.references()<CR>", opts)
    -- Formatting
    buf_set_keymap("n", "<leader>f", "<cmd>lua vim.lsp.buf.formatting()<CR>", opts)
    buf_set_keymap("v", "<leader>f", "<cmd>lua vim.lsp.buf.range_formatting()<CR>", opts)
end

local capabilities = require("cmp_nvim_lsp").update_capabilities(
    vim.lsp.protocol.make_client_capabilities()
)

-- Rust
nvim_lsp.rust_analyzer.setup({
    capabilities = capabilities,
    on_attach = on_attach,
    settings = {
        ["rust-analyzer"] = {
            cargo = {
                loadOutDirsFromCheck = true,
            },
            procMacro = {
                enable = true,
            },
            checkOnSave = {
                command = "clippy",
                enable = true,
            },
        },
    },
})

-- Python
nvim_lsp.pyright.setup({
    capabilities = capabilities,
    on_attach = on_attach,
    settings = {
        python = {
            -- pyright only accepts absolute paths
            venvPath = vim.api.nvim_call_function("fnamemodify", { "~", ":p" })
                .. ".virtualenvs",
        },
    },
})

-- Lua
local LUA_PATH = vim.split(package.path, ";")
table.insert(LUA_PATH, "lua/?.lua")
table.insert(LUA_PATH, "lua/?/init.lua")

nvim_lsp.sumneko_lua.setup({
    capabilities = capabilities,
    on_attach = on_attach,
    settings = {
        Lua = {
            runtime = {
                version = "LuaJIT",
                path = LUA_PATH,
            },
            diagnostics = {
                -- Get the language server to recognize the `vim` global
                globals = { "vim" },
            },
            workspace = {
                -- Make the server aware of Neovim runtime files
                library = vim.api.nvim_get_runtime_file("", true),
            },
            telemetry = {
                enable = false,
            },
        },
    },
})

-- null-ls
local null_ls = require("null-ls")
null_ls.setup({
    diagnostics_format = "[#{c}] #{m} (#{s})",
    sources = {
        null_ls.builtins.diagnostics.flake8,
        null_ls.builtins.diagnostics.vint,
        null_ls.builtins.diagnostics.yamllint,
        null_ls.builtins.formatting.black,
        null_ls.builtins.formatting.djhtml.with({
            extra_args = { "--tabwidth", "2" },
        }),
        null_ls.builtins.formatting.fish_indent,
        null_ls.builtins.formatting.isort,
        null_ls.builtins.formatting.stylua,
    },
    on_attach = on_attach,
})

-- Go-to definition in a split window
-- https://github.com/neovim/nvim-lspconfig/wiki/UI-customization#go-to-definition-in-a-split-window
local function goto_definition(split_cmd)
    local util = vim.lsp.util
    local log = require("vim.lsp.log")
    local api = vim.api

    local handler = function(_, result, ctx)
        if result == nil or vim.tbl_isempty(result) then
            local _ = log.info() and log.info(ctx.method, "No location found")
            return nil
        end

        if split_cmd then
            vim.cmd(split_cmd)
        end

        if vim.tbl_islist(result) then
            util.jump_to_location(result[1])

            if #result > 1 then
                util.set_qflist(util.locations_to_items(result))
                api.nvim_command("copen")
                api.nvim_command("wincmd p")
            end
        else
            util.jump_to_location(result)
        end
    end

    return handler
end

vim.lsp.handlers["textDocument/definition"] = goto_definition("split")

-- List all LSP diagnostic errors
vim.cmd([[ command! Errors lua vim.diagnostic.setloclist() ]])