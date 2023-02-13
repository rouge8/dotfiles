-- Ident Blankline
require("indent_blankline").setup({})

-- Treesitter
require("nvim-treesitter.configs").setup({
    ensure_installed = {
        "bash",
        "comment",
        "css",
        "dockerfile",
        "fish",
        "go",
        "gomod",
        "hcl",
        "html",
        "http",
        "javascript",
        "json",
        "latex",
        "lua",
        "make",
        "markdown",
        "markdown_inline",
        "python",
        "regex",
        "rst",
        "ruby",
        "rust",
        "toml",
        "typescript",
        "vim",
        "yaml",
    },
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
    mapping = cmp.mapping.preset.insert({
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
    }),
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
    -- Mappings.
    local bufopts = { noremap = true, silent = true, buffer = bufnr }

    -- Nav between diagnostic results
    vim.keymap.set("n", "<up>", vim.diagnostic.goto_prev, bufopts)
    vim.keymap.set("n", "<down>", vim.diagnostic.goto_next, bufopts)
    -- Use 'K' to show LSP hover info
    vim.keymap.set("n", "K", vim.lsp.buf.hover, bufopts)
    -- Go-to definition
    vim.keymap.set("n", "<leader>j", vim.lsp.buf.definition, bufopts)
    -- References
    vim.keymap.set("n", "<leader>r", vim.lsp.buf.references, bufopts)
    -- Formatting
    vim.keymap.set("n", "<leader>f", vim.lsp.buf.formatting, bufopts)
    vim.keymap.set("v", "<leader>f", vim.lsp.buf.range_formatting, bufopts)
end

local capabilities = require("cmp_nvim_lsp").default_capabilities()

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
            rustfmt = {
                extraArgs = { "+nightly" },
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
nvim_lsp.lua_ls.setup({
    capabilities = capabilities,
    on_attach = function(client, bufnr)
        client.server_capabilities.documentFormattingProvider = false
        client.server_capabilities.documentRangeFormattingProvider = false
        on_attach(client, bufnr)
    end,
    settings = {
        Lua = {
            runtime = {
                version = "LuaJIT",
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

-- Terraform
nvim_lsp.terraformls.setup({})

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

-- lualine
local function vim_gitgutter_diff_source()
    local added, modified, removed = unpack(vim.fn.GitGutterGetHunkSummary())
    return {
        added = added,
        modified = modified,
        removed = removed,
    }
end
local statusline_sections = {
    lualine_a = { "mode" },
    lualine_b = {
        { "FugitiveHead", icon = "" },
        { "diff", source = vim_gitgutter_diff_source },
        "diagnostics",
    },
    lualine_c = { "filename" },
    lualine_x = { "encoding", { "fileformat", icons_enabled = false }, "filetype" },
    lualine_y = { "progress" },
    lualine_z = { "location" },
}
require("lualine").setup({
    sections = statusline_sections,
    inactive_sections = statusline_sections,
    extensions = {
        "fugitive",
        "fzf",
        "man",
        "quickfix",
        -- vim-plug
        {
            sections = {
                lualine_a = {
                    function()
                        return "PLUGINS"
                    end,
                },
            },
            filetypes = { "vim-plug" },
        },
        -- vim-startuptime
        {
            sections = {
                lualine_a = {
                    function()
                        return "STARTUP TIME"
                    end,
                },
            },
            filetypes = { "startuptime" },
        },
    },
})

-- Neotest
local neotest = require("neotest")
neotest.setup({
    discovery = { enabled = false },
    adapters = {
        require("neotest-python")({
            args = { "-v" },
        }),
        require("neotest-rust")({}),
        require("neotest-plenary")({}),
    },
})

local bufopts = { noremap = true, silent = true }
-- Run the nearest test
vim.keymap.set("n", "<leader>t", neotest.run.run, bufopts)
-- Run all tests in the file
vim.keymap.set("n", "<leader>T", function()
    neotest.run.run(vim.fn.expand("%"))
end, bufopts)
-- View the test output
vim.keymap.set("n", "<leader>to", neotest.output.open, bufopts)
-- View the test summary
vim.keymap.set("n", "<leader>ts", neotest.summary.open, bufopts)
