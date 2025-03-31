-- Indent Blankline
require("ibl").setup()

-- ripgrep
vim.opt.grepprg = "rg --vimgrep"

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
        "hjson",
        "html",
        "http",
        "javascript",
        "json",
        "jsonc",
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
        "terraform",
        "toml",
        "typescript",
        "vim",
        "vimdoc",
        "yaml",
    },
    auto_install = true,
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
            "yaml",
        },
    },
    matchup = {
        enable = true,
    },
})
require("ts_context_commentstring")

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
    -- Go-to definition in a split
    vim.keymap.set("n", "<leader>j", ":split | lua vim.lsp.buf.definition()<CR>", bufopts)
    -- References
    vim.keymap.set("n", "<leader>r", vim.lsp.buf.references, bufopts)
    -- Formatting
    vim.keymap.set("n", "<leader>f", function()
        vim.lsp.buf.format({ async = false, timeout_ms = 5000 })
    end, bufopts)
    vim.keymap.set("v", "<leader>f", function()
        vim.lsp.buf.format({ async = false })
    end, bufopts)
    -- Code actions
    vim.keymap.set({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, bufopts)
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
local pyright_capabilities = vim.deepcopy(capabilities)
pyright_capabilities.textDocument["publishDiagnostics"] =
    { tagSupport = { valueSet = { 2 } } }
nvim_lsp.pyright.setup({
    capabilities = pyright_capabilities,
    on_attach = on_attach,
    settings = {
        python = {
            -- pyright only accepts absolute paths
            venvPath = vim.api.nvim_call_function("fnamemodify", { "~", ":p" })
                .. ".virtualenvs",
            analysis = {
                useLibraryCodeForTypes = false,
            },
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
nvim_lsp.terraformls.setup({
    capabilities = capabilities,
    on_attach = on_attach,
})

-- EFM
nvim_lsp.efm.setup({
    init_options = { documentFormatting = true },
    filetypes = vim.fn.getcompletion("", "filetype"),
    on_attach = on_attach,
})

-- TypeScript / Vue
local mise_where_vue_language_server_path = vim.system(
    { "mise", "where", "npm:@vue/language-server" },
    { text = true }
):wait()
local vue_language_server_path = vim.trim(mise_where_vue_language_server_path.stdout)
    .. "/lib/node_modules/@vue/language-server"

local mise_where_typescript_path = vim.system(
    { "mise", "where", "npm:typescript" },
    { text = true }
):wait()
local typescript_path = vim.trim(mise_where_typescript_path.stdout)
    .. "/lib/node_modules/typescript"

nvim_lsp.ts_ls.setup({
    capabilities = capabilities,
    on_attach = on_attach,
    init_options = {
        plugins = {
            {
                name = "@vue/typescript-plugin",
                location = vue_language_server_path,
                languages = { "vue" },
            },
        },
    },
    filetypes = {
        "typescript",
        "javascript",
        "javascriptreact",
        "typescriptreact",
        "vue",
    },
})
nvim_lsp.volar.setup({
    capabilities = capabilities,
    on_attach = on_attach,
    init_options = {
        typescript = {
            tsdk = typescript_path .. "/lib",
        },
    },
})

-- Tailwind CSS
nvim_lsp.tailwindcss.setup({
    capabilities = capabilities,
    on_attach = on_attach,
})

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
