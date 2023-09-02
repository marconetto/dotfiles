vim.g.mapleader = " "

--------------------------------------------------------------------------------
--- plugin manager -------------------------------------------------------------
--------------------------------------------------------------------------------
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
    vim.fn.system(
        {
            "git",
            "clone",
            "--filter=blob:none",
            "https://github.com/folke/lazy.nvim.git",
            "--branch=stable",
            lazypath
        }
    )
end
vim.opt.rtp:prepend(lazypath)

--------------------------------------------------------------------------------
--- plugins --------------------------------------------------------------------
--------------------------------------------------------------------------------
require("lazy").setup(
    {
        -- colorscheme ---------------------------------------------------------------
        {
            "sainnhe/gruvbox-material",
            enabled = true,
            lazy = false,
            priority = 1000,
            config = function(_, opts)
                vim.cmd [[colorscheme gruvbox-material]]
            end,
            init = function()
                vim.g.gruvbox_material_palette = "material"
                vim.g.gruvbox_material_transparent_background = 1
                vim.g.gruvbox_material_background = "soft"
                vim.g.gruvbox_material_better_performance = 1
                vim.g.gruvbox_material_enable_bold = 1
                vim.g.gruvbox_material_enable_italic = 0
                vim.g.gruvbox_material_disable_italic_comment = 1
            end
        },
        -- statusline ---------------------------------------------------------------
        {
            "nvim-lualine/lualine.nvim",
            dependencies = { "nvim-tree/nvim-web-devicons" },
            config = function()
                local function file_location()
                    local percent = math.floor(100 * vim.fn.line(".") / vim.fn.line("$"))
                    return string.format("%4s:%-3s %3s%%%%", vim.fn.line("."), vim.fn.col("."),
                        percent)
                end

                local function file_path()
                    return string.format("%s", vim.fn.expand("%:p:h:t"))
                end

                local custom_theme = require "lualine.themes.gruvbox_dark"

                custom_theme.normal.c.bg = '#323741'
                custom_theme.insert.a.bg = '#a9b665'

                custom_theme.replace.c.bg = '#323741'
                custom_theme.visual.c.bg = '#323741'
                custom_theme.insert.c.bg = '#323741'
                custom_theme.command.c.bg = '#323741'

                custom_theme.normal.b.bg = '#323741'
                custom_theme.replace.b.bg = '#323741'
                custom_theme.visual.b.bg = '#323741'
                custom_theme.insert.b.bg = '#323741'
                custom_theme.command.b.bg = '#323741'

                custom_theme.normal.a.bg = '#81A8C1'
                custom_theme.command.a.bg = '#c48eb0'

                custom_theme.visual.a.bg = '#ffae57'
                custom_theme.replace.a.bg = '#f07178'

                custom_theme.normal.c.fg = '#888888'
                custom_theme.normal.b.fg = '#888888'

                custom_theme.insert.c.fg = '#888888'
                custom_theme.insert.b.fg = '#888888'

                custom_theme.visual.c.fg = '#888888'
                custom_theme.visual.b.fg = '#888888'

                custom_theme.replace.c.fg = '#888888'
                custom_theme.replace.b.fg = '#888888'

                custom_theme.command.c.fg = '#888888'
                custom_theme.command.b.fg = '#888888'

                require("lualine").setup(
                    {
                        options = {
                            theme = custom_theme,
                            component_separators = { left = " ", right = " " },
                            section_separators = { left = "", right = "" }
                        },
                        sections = {
                            lualine_b = { file_path,
                                {
                                    "filename",
                                    symbols = { modified = "[+]", readonly = " " }
                                } },
                            lualine_c = {
                                { "branch", separator = "" },
                                {
                                    "diff",
                                    left_padding = 0,
                                    symbols = {
                                        added = " ",
                                        modified = " ",
                                        removed = " "
                                    }
                                }
                            },
                            lualine_z = { file_location },
                            lualine_x = {
                                {
                                    "diagnostics",
                                    sources = { "nvim_diagnostic" },
                                    -- diagnostics_color = {
                                    --     error = "LspDiagnosticsDefaultError",      -- Changes diagnostics' error color.
                                    --     warn = "LspDiagnosticsDefaultWarning",     -- Changes diagnostics' warn color.
                                    --     info = "LspDiagnosticsDefaultInformation", -- Changes diagnostics' info color.
                                    --     hint =
                                    --     "LspDiagnosticsDefaultHint"                -- Changes diagnostics' hint color.
                                    -- },
                                    -- " ", Warn = " ", Hint = " ", Info = " " }
                                    symbols = {
                                        error = " ",
                                        warn = " ",
                                        info = " ",
                                        hint = " "
                                    },
                                    -- symbols = {
                                    --     error = "E",
                                    --     warn = "W",
                                    --     info = "I",
                                    --     hint = "H"
                                    -- },
                                    colored = true,           -- Displays diagnostics status in color if set to true.
                                    update_in_insert = false, -- Update diagnostics in insert mode.
                                    always_visible = false    -- Show diagnostics even if there are none.
                                }
                            },
                            lualine_y = { "filetype" }
                        },
                        inactive_sections = {
                            lualine_b = {
                                {
                                    "filename",
                                    symbols = { modified = "[+]", readonly = " " }
                                } },
                            lualine_c = {
                                {
                                    "diff",
                                    symbols = {
                                        added = " ",
                                        modified = " ",
                                        removed = " "
                                    }
                                } },
                            lualine_x = { { "diagnostics", sources = { "nvim_diagnostic" } } },
                            lualine_y = { "filetype" }
                        }
                    }
                )
            end
        },
        -- clipboard handler ---------------------------------------------------------------
        {
            'ojroques/nvim-osc52',
            config = function()
                require('osc52').setup {
                    max_length = 0, -- Maximum length of selection (0 for no limit)
                    silent = true,  -- Disable message on successful copy
                    trim = true,    -- Trim text before copy
                }
            end
        },
        -- lsp -----------------------------------------------------------------------------
        {
            "williamboman/mason.nvim",
            "williamboman/mason-lspconfig.nvim",
            cond = function()
                if vim.fn.executable('npm') == 1 then
                    return true
                else
                    return false
                end
            end,
        },
        {
            "VonHeikemen/lsp-zero.nvim",
            dependencies = {
                "lukas-reineke/lsp-format.nvim",
                "neovim/nvim-lspconfig",
                "hrsh7th/nvim-cmp",
                "hrsh7th/cmp-buffer",
                "hrsh7th/cmp-path",
                "saadparwaiz1/cmp_luasnip",
                "hrsh7th/cmp-nvim-lsp",
                "hrsh7th/cmp-nvim-lua",
                "L3MON4D3/LuaSnip",
                "rafamadriz/friendly-snippets",
                "onsails/lspkind-nvim",
            },
            config = function()
                local lsp = require("lsp-zero")
                lsp.preset("recommended")
                -- lsp.on_attach(function(client, bufnr)
                --   require("lsp-format").on_attach(client, bufnr)
                -- end)
                lsp.nvim_workspace()
                lsp.setup()
                vim.diagnostic.config({ virtual_text = true })

                require("mason-lspconfig").setup({
                    ensure_installed = {
                        "lua_ls",
                    },
                })
                if vim.fn.executable('npm') == 1 then
                    require("mason-lspconfig").setup({
                        ensure_installed = {
                            "tsserver",
                            "bashls",
                            "cssls",
                            "lua_ls",
                            "html",
                            "jsonls",
                            "pyright",
                            "yamlls",
                            "bicep",
                        },
                    })
                end
            end,
        },
        -- proper syntax colors -------------------------------------------------------------
        {
            'nvim-treesitter/nvim-treesitter',
            cond = function()
                if vim.fn.executable('make') == 1 then
                    return true
                else
                    return false
                end
            end,
            config = function()
                require('nvim-treesitter.configs').setup({
                    highlight = {
                        enable = true,
                        disable = {},
                    },
                    indent = {
                        enable = false,
                        disable = {},
                    },
                    ensure_installed = {
                        "html",
                        "bash",
                        "css",
                        "python",
                        "json",
                        "vim",
                        "yaml",
                        "javascript",
                        "typescript",
                        "lua",
                        "scss",
                        "bicep"
                    },
                })
            end,
            build = ':TSUpdate',
        },
        -- telescope -----------------------------------------------------------------------
        {
            'nvim-telescope/telescope.nvim',
            tag = '0.1.2',
            dependencies = { 'nvim-lua/plenary.nvim' }
        },
        {
            "nvim-telescope/telescope-file-browser.nvim",
            dependencies = { "nvim-telescope/telescope.nvim", "nvim-lua/plenary.nvim" }
        },
        {

            'smartpde/telescope-recent-files',
            config = function()
                require('telescope').load_extension('recent_files')
                vim.keymap.set('n', '<space>ff', "<cmd>lua require('telescope').extensions.recent_files.pick()<CR>",
                    { noremap = true, silent = true })
            end,
            dependencies = { 'nvim-telescope/telescope.nvim' }

        },
        {
            'nvim-telescope/telescope-fzf-native.nvim',
            cond = function()
                if vim.fn.executable('make') == 1 then
                    return true
                else
                    return false
                end
            end,
            build = 'make'
        },
        -- toggle comment --------------------------------------------------------------------
        {
            "terrortylor/nvim-comment",
            config = function()
                require('nvim_comment').setup()
            end,
        },
        -- highlight current word ------------------------------------------------------------
        {

            'dominikduda/vim_current_word'
        },
        -- auto pair brackets ----------------------------------------------------------------
        {
            'windwp/nvim-autopairs',
            event = "InsertEnter",
            opts = {} -- this is equalent to setup({}) function
        },
        -- buffer names on top of screen -----------------------------------------------------
        {
            'akinsho/bufferline.nvim',
            version = "*",
            dependencies = 'nvim-tree/nvim-web-devicons',
            config = function()
                require('bufferline').setup {
                    options = {
                        show_close_icon = false,
                        show_buffer_close_icons = false,
                        show_tab_indicators = false,
                        separator_style = { ' ', ' ' },
                        always_show_bufferline = false,
                        indicator = {
                            icon = ' ',
                            style = 'none',
                        },
                    },
                    highlights = {
                        background = {
                            bold = true,
                            italic = true,
                            fg = '#6f6b79'
                        },
                        buffer_selected = {
                            bold = true,
                            italic = true,
                            fg = '#dddddd'
                        },
                    }
                }
            end

        },
        -- MRU -------------------------------------------------------------------------------
        {

            "yegappan/mru"
        },
        -- git support -----------------------------------------------------------------------
        {
            "lewis6991/gitsigns.nvim",
            dependencies = {
                'nvim-lua/plenary.nvim'
            },
            config = function()
                require('gitsigns').setup {}
            end
        },
        {
            "iamcco/markdown-preview.nvim",
            cond = function()
                if vim.fn.executable('yarn') == 1 then
                    return true
                else
                    return false
                end
            end,
            lazy = true,
            ft = "markdown",
            build = "cd app && yarn install",
            config = function()
                vim.g.mkdp_page_title = "${name}"
            end,
        },
        -- kitty -----------------------------------------------------------------------------
        {
            "knubie/vim-kitty-navigator",
            cond = function()
                if vim.fn.has("mac") == 1 then
                    return true
                else
                    return false
                end
            end,
            build = "cp ./*.py ~/.config/kitty/",
            init = function()
                vim.g.kitty_navigator_no_mappings = 1
            end,

        },
    }
)

-------------------------------------------------------------------------------
-- more plugin reelated config
-------------------------------------------------------------------------------

-- have decent autocompletion with ENTER + TAB ---------------
local cmp = require('cmp')
local cmp_action = require('lsp-zero').cmp_action()
cmp.setup({
    mapping = {
        ['<CR>'] = cmp.mapping.confirm({ select = false }),
        ['<Tab>'] = cmp_action.tab_complete(),
        ['<S-Tab>'] = cmp_action.select_prev_or_fallback(),
    },
    window = {
        completion = cmp.config.window.bordered(),
        documentation = cmp.config.window.bordered(),
    }
})



-------------------------------------------------------------------------------
--- settings ------------------------------------------------------------------
-------------------------------------------------------------------------------

vim.opt.termguicolors = true -- Enable 24-bit RGB colors
vim.opt.updatetime = 200

vim.opt.clipboard = 'unnamedplus' -- Copy/paste to system clipboard
vim.opt.swapfile = false          -- Don't use swapfile
vim.opt.ignorecase = true         -- Search case insensitive...
vim.opt.smartcase = true          -- ... but not it begins with upper case

vim.opt.expandtab = true          -- expand tabs into spaces
vim.opt.shiftwidth = 4            -- number of spaces to use for each step of indent.
vim.opt.tabstop = 4               -- number of spaces a TAB counts for
vim.opt.autoindent = true         -- copy indent from current line when starting a new line
vim.opt.wrap = true

vim.opt.cursorline = true
vim.opt.cursorcolumn = true
vim.opt.showmode = false

vim.keymap.set('n', '<leader>y', require('osc52').copy_operator, { expr = true })
-- vim.keymap.set('n', 'Y', '<leader>c_', {remap = true})
vim.keymap.set('x', '<leader>y', require('osc52').copy_visual)


require("telescope").load_extension "file_browser"

vim.api.nvim_set_keymap(
    "n",
    "<space>fw",
    ":Telescope file_browser<CR>",
    { noremap = true }
)

-- vim.keymap.set('n', '++', 'gcc')
-- vim.keymap.set('v', '++', 'gcc')


-- source: https://sbulav.github.io/vim/neovim-opening-urls/
if vim.fn.has("mac") == 1 then
    vim.keymap.set("", "gu", '<Cmd>call jobstart(["open", expand("<cfile>")], {"detach": v:true})<CR>', {})
elseif vim.fn.has("unix") == 1 then
    vim.keymap.set("", "gu", '<Cmd>call jobstart(["xdg-open", expand("<cfile>")], {"detach": v:true})<CR>', {})
end

vim.cmd [[autocmd BufWritePre <buffer> lua vim.lsp.buf.format()]]





vim.cmd [[

nnoremap <leader>z :x<CR>
nnoremap <leader>q :q!<CR>

nnoremap <silent> <leader>w :silent w<CR>:echo ""<CR>

set noswapfile
set nobackup
set nomodeline

nnoremap <silent> <c-p> :KittyNavigateRight<cr>
nnoremap <silent> <c-h> :KittyNavigateLeft<cr>
nmap <silent> Y 0vg_<leader>y:echo "yank line"<CR>:sleep 700m<CR>:echo ""<CR>


" open file in the same position closed (line and screen positions)
au BufWinLeave * silent! mkview
au BufWinEnter * silent! loadview


" clear research highlight
nmap <silent> <leader>/ :set nohlsearch<CR>:echo ""<CR>:let @/ = ''<CR>:set hlsearch<CR>

nmap <silent> W viw


exe "hi! CursorLine guibg=#323741"
exe "hi! CursorColumn guibg=#323741"
exe "hi! ColorColumn guibg=#2f353e"
exe "hi! CurrentWordTwins guibg=#3A4149"
exe "hi! CurrentWord guibg=#3A4149"
autocmd InsertEnter * highlight  CursorLine guibg=#373c47
autocmd InsertEnter * highlight  CursorColumn guibg=#373c47
autocmd InsertLeave * highlight  CursorLine guibg=#323741
autocmd InsertLeave * highlight  CursorColumn guibg=#323741


exe "hi! CursorLineNr guifg=#AAAAAA guibg=None gui=bold"
exe "hi! SignColumn guifg=#AAAAAA guibg=None gui=bold"
exe "hi! EndOfBuffer guifg=#2C323B guibg=None"

exe "hi! LineNr guifg=#47525C guibg=None gui=bold"

set nonumber
"autocmd BufReadPre * if &filetype != 'zsh' | set number | else | set nonumber | endif

set list
set listchars=tab:▸\ ,trail:¬,nbsp:.,extends:❯,precedes:❮
set signcolumn=no

autocmd BufRead * if !empty(&filetype) && &filetype != 'text' | set number | set signcolumn=yes  |endif


function! SaveJump(motion)
  if exists('#SaveJump#CursorMoved')
    autocmd! SaveJump
  else
    normal! m'
  endif
  let m = a:motion
  if v:count
    let m = v:count.m
  endif
  execute 'normal!' m
endfunction

function! SetJump()
  augroup SaveJump
    autocmd!
    autocmd CursorMoved * autocmd! SaveJump
  augroup END
endfunction


nnoremap <silent> <PageUp> :call SaveJump("\<lt>C-u>")<CR>:call SetJump()<CR>
nnoremap <silent> <PageDown> :cal SaveJump("\<lt>C-d>")<CR>:call SetJump()<CR>

"Clone Paragraph with cp
noremap <leader>cp yip<S-}>o<ESC>p:echo "cloned paragraph"<CR>

"Yank Paragraph with yp
noremap <leader>gp yip<S-}>:echo "yanked paragraph"<CR>

"Align Current Paragraph
noremap <silent> <leader>fa =ip

"format current line
noremap  <silent> <leader>a :AutoformatLine<CR>

nnoremap U <C-R> " redo

nmap ++ gcc
vmap ++ gc

if has('persistent_undo')
    set undodir=~/.undodir
    set undofile
    if !isdirectory(expand(&undodir))
        call mkdir(expand(&undodir), "p")
    endif
    set undolevels=99999
    set undolevels=10000
  endif

set noswapfile
set nobackup
set nomodeline


nnoremap <silent> <leader>fc :Telescope find_files cwd=%:h<CR>

let g:vim_current_word#highlight_delay = 300

nnoremap <silent> <S-q> :bw<cr>
" nnoremap <silent> <S-q> :bp<cr>:bd #<cr>
nnoremap <silent> <leader>bq :bp<cr>:bd #<cr>
nnoremap <silent> <leader>k :bp<cr>:bd #<cr>
nnoremap <silent> <S-Right> :bnext<CR>
nnoremap <silent> <S-Left>  :bprevious<CR>

function! JumpWithinFile(back, forw)
    let [n, i] = [bufnr('%'), 1]
    let p = [n] + getpos('.')[1:]
    sil! exe 'norm!1' . a:forw
    while 1
        let p1 = [bufnr('%')] + getpos('.')[1:]
        if n == p1[0] | break | endif
        if p == p1
            sil! exe 'norm!' . (i-1) . a:back
            break
        endif
        let [p, i] = [p1, i+1]
        sil! exe 'norm!1' . a:forw
    endwhile
endfunction

nnoremap <silent> <c-k> :call JumpWithinFile("\<c-i>", "\<c-o>")<cr>
nnoremap <silent> <c-j> :call JumpWithinFile("\<c-o>", "\<c-i>")<cr>

" autocmd CursorHold * silent lua vim.diagnostic.open_float()
nnoremap cd ciw

function! SetLSPHighlights()
    highlight LspDiagnosticsUnderlineError guifg=#aa4917 gui=none
    highlight LspDiagnosticsUnderlineWarning guifg=#EBA217 gui=undercurl
    highlight LspDiagnosticsUnderlineInformation guifg=#17D6EB, gui=undercurl
    highlight LspDiagnosticsUnderlineHint guifg=#17EB7A gui=undercurl
endfunction

autocmd ColorScheme * call SetLSPHighlights()

set scrolloff=8                    " start scrolling n lines before horizontal


" float for diagnosticis and pmenu keep transparent background
exe "hi! link FloatBorder Normal"
exe "hi! link NormalFloat Normal"
exe "hi! WildMenu guifg=#226622"
exe "hi! PMenu guifg=Normal guibg=None"



"exe "hi! MatchParen guifg=lightblue guibg=darkblue"

" pmenu up and down arrow support
if &wildoptions =~ "pum"
    cnoremap <expr> <up> pumvisible() ? "<C-p>" : "\\<up>"
    cnoremap <expr> <down> pumvisible() ? "<C-n>" : "\\<down>"
endif

" temporary solution for not showing ~@k when scrolling
set noshowcmd
let g:lsp_diagnostics_float_delay = 5000
]]


require('bufferline').setup {
    options = {
        show_close_icon = false,
        show_buffer_close_icons = false,
        show_tab_indicators = false,
        separator_style = { ' ', ' ' },
        always_show_bufferline = false,
        indicator = {
            icon = ' ',
            style = 'none',
        },
    },
    highlights = {
        background = {
            bold = true,
            italic = true,
            fg = '#6f6b79'
        },
        buffer_selected = {
            bold = true,
            italic = true,
            fg = '#dddddd'
        },
    }
}

vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(
    vim.lsp.diagnostic.on_publish_diagnostics, {
        underline = false,
        virtual_text = false,
        signs = true,
        update_in_insert = true,
        focusable = false,
        --- error before gutter sign
        severity_sort = true
    }
)

require("nvim-web-devicons").set_icon {
    txt = {
        icon = "",
        color = "#999999",
        cterm_color = "65",
        name = "Txt"
    }
}

-- local signs = { Error = "E", Warn = "W", Hint = "H", Info = "I" }
-- local signs = { Error = " ", Warn = " ", Hint = " ", Info = " " }
local signs = { Error = "", Warn = "", Hint = "", Info = "" }
for type, icon in pairs(signs) do
    local hl = "DiagnosticSign" .. type
    vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
end

vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(
    vim.lsp.handlers.hover, { focusable = false }
)

-- local diag_float_grp = vim.api.nvim_create_augroup("DiagnosticFloat", { clear = true })
-- vim.api.nvim_create_autocmd("CursorHold", {
--     callback = function()
--         vim.diagnostic.open_float(nil, { focusable = false })
--     end,
--     group = diag_float_grp,
-- })
--
--
-- vim.o.updatetime = 250
-- vim.cmd [[autocmd CursorHold * lua vim.diagnostic.open_float(nil, {focus=false})]]

vim.cmd [[autocmd CursorHold * lua vim.diagnostic.open_float(0, {scope="line", focus=false,close_events = {"CursorMoved", "CursorMovedI", "BufHidden", "InsertCharPre", "WinLeave","InsertEnter"}})]]

-- vim.cmd [[
--   autocmd BufNewFile,BufRead * if empty(&filetype) or &filetype != 'text' or (line('$') == 1 and getline(1) == '') then echo 'hello' end
-- ]]



--   autocmd!
--   autocmd FileType lua,python,json,bash,sh,bicep,zsh set list
--   autocmd FileType lua,python,json,bash,sh,bicep,zsh set listchars=tab:▸\ ,trail:¬,nbsp:.,extends:❯,precedes:❮
--  autocmd FileType lua,python,json,bash,sh,bicep,zsh set number
-- autocmd FileType lua,python,json,bash,sh,bicep,zsh set cursorline
--autocmd FileType lua,python,json,bash,sh,bicep,zsh set signcolumn=yes
--augroup END

-- vim.cmd("autocmd VimEnter * highlight Pmenu guifg=#073642 guibg=#002b36")
-- vim.cmd("autocmd VimEnter * highlight PmenuSel guifg=#002b36 guibg=#b58900")
-- vim.cmd("autocmd VimEnter * highlight PmenuSbar guifg=#073642 guibg=#002b36")
-- vim.cmd("autocmd VimEnter * highlight PmenuThumb guifg=#586e75 guibg=#002b36")

-- vim.fn.sign_define('LspDiagnosticsSignError', { text = "", texthl = "LspDiagnosticsDefaultError" })
-- vim.fn.sign_define('LspDiagnosticsSignWarning', { text = "", texthl = "LspDiagnosticsDefaultWarning" })
-- vim.fn.sign_define('LspDiagnosticsSignInformation', { text = "", texthl = "LspDiagnosticsDefaultInformation" })
-- vim.fn.sign_define('LspDiagnosticsSignHint', { text = "", texthl = "LspDiagnosticsDefaultHint" })

--vim.cmd([[highlight DiagnosticVirtualTextError guibg=#ff212e]])
--vim.cmd([[highlight DiagnosticVirtualTextWarn guibg=#ff212e]])
--vim.cmd([[highlight DiagnosticVirtualTextInfo guibg=#ff212e]])
--vim.cmd([[highlight DiagnosticVirtualTextHint guibg=#ff212e]])
------------------------------------------------------------------
------------------------------------------------------------------
------------------------------------------------------------------
------------------------------------------------------------------
--MISC------------------------------------------------------------
--MISC------------------------------------------------------------

-- print(os.getenv("SHELL"))
