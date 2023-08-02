"------------------------------------------------------------------------------
" INIT-------------------------------------------------------------------------
"------------------------------------------------------------------------------
set nocompatible
syntax on
set encoding=utf-8

nnoremap <SPACE> <Nop>
let mapleader="\<Space>"
let maplocalleader="\<Space>"
set termguicolors

if exists('+termguicolors')
    let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum"
    let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum"
    set termguicolors
endif

let g:python3_host_prog = '/usr/local/bin/python3'

let g:pydocstring_doq_path = '/usr/local/bin/doq'

"------------------------------------------------------------------------------
" PLUGINS ---------------------------------------------------------------------
"------------------------------------------------------------------------------
if empty(glob('~/.config/nvim/autoload/plug.vim'))
  silent !curl -fLo ~/.config/nvim/autoload/plug.vim --create-dirs
       \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall
endif

call plug#begin('~/.config/nvim/plugged')

Plug 'sainnhe/gruvbox-material'
Plug 'kyazdani42/nvim-web-devicons'
Plug 'akinsho/bufferline.nvim', { 'tag': 'v3.*' }

Plug 'neovim/nvim-lspconfig'
Plug 'hrsh7th/nvim-compe'
Plug 'hrsh7th/vim-vsnip'
" symbols when doing autocomplete
Plug 'onsails/lspkind-nvim'
Plug 'preservim/nerdcommenter'
Plug 'windwp/nvim-autopairs'

Plug 'nvim-lualine/lualine.nvim'

Plug 'Chiel92/vim-autoformat'

Plug 'ojroques/nvim-osc52'

Plug 'nvim-lua/popup.nvim'
Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-telescope/telescope.nvim'
Plug 'smartpde/telescope-recent-files'
" Plug 'nvim-telescope/telescope-frecency.nvim'
" Plug 'tami5/sql.nvim'
Plug 'nvim-telescope/telescope-fzf-native.nvim', { 'do': 'make' }
Plug 'nvim-telescope/telescope-file-browser.nvim'
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'

" show colors of hex values
Plug 'norcalli/nvim-colorizer.lua'

Plug 'dominikduda/vim_current_word'
Plug 'unblevable/quick-scope'
Plug 'machakann/vim-sandwich'
Plug 'wellle/targets.vim'

Plug 'airblade/vim-gitgutter'
Plug 'tpope/vim-fugitive'
Plug 'kdheepak/lazygit.nvim'

Plug 'mg979/vim-visual-multi', {'branch': 'master'}

Plug 'knubie/vim-kitty-navigator', {'do': 'cp ./*.py ~/.config/kitty/'}

Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}

" formatting python
Plug 'smbl64/vim-black-macchiato'

" start vim with file options
Plug 'mhinz/vim-startify'
Plug 'yegappan/mru'

" Plug 'tpope/vim-markdown'

Plug 'antoinemadec/FixCursorHold.nvim'
Plug 'iamcco/markdown-preview.nvim', { 'do': 'cd app && yarn install' }

call plug#end()

"------------------------------------------------------------------------------
" LUA -------------------------------------------------------------------------
"------------------------------------------------------------------------------
lua << EOF

require('osc52').setup {
  max_length = 0,  -- Maximum length of selection (0 for no limit)
  silent = true,  -- Disable message on successful copy
  trim = true,    -- Trim text before copy
}

vim.keymap.set('n', '<leader>y', require('osc52').copy_operator, {expr = true})
-- vim.keymap.set('n', 'Y', '<leader>c_', {remap = true})
vim.keymap.set('x', '<leader>y', require('osc52').copy_visual)

require("nvim-autopairs").setup {}

require('colorizer').setup(nil, {names=false, mode='background'})

require'nvim-treesitter.configs'.setup {
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
    "help",
    "json",
    "vim",
    "yaml",
    "javascript",
    "typescript",
    "lua",
    "scss"
  },
}

-- :TSInstall python
local lspconfig = require'lspconfig'

lspconfig.pylsp.setup{}
lspconfig.tsserver.setup{}
lspconfig.jsonls.setup{}

--Enable (broadcasting) snippet capability for completion
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities.textDocument.completion.completionItem.snippetSupport = true

lspconfig.cssls.setup {
  capabilities = capabilities,
}

local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities.textDocument.completion.completionItem.snippetSupport = true

lspconfig.html.setup {
  capabilities = capabilities,
}

vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(
    vim.lsp.diagnostic.on_publish_diagnostics, {
        underline = false,
        virtual_text = false,
        signs = true,
        update_in_insert = false,
        focusable = false,
        --- error before gutter sign
        severity_sort = true
  }
)

vim.fn.sign_define('LspDiagnosticsSignError', { text = "", texthl = "LspDiagnosticsDefaultError" })
vim.fn.sign_define('LspDiagnosticsSignWarning', { text = "", texthl = "LspDiagnosticsDefaultWarning" })
vim.fn.sign_define('LspDiagnosticsSignInformation', { text = "", texthl = "LspDiagnosticsDefaultInformation" })
vim.fn.sign_define('LspDiagnosticsSignHint', { text = "", texthl = "LspDiagnosticsDefaultHint" })

require('lspkind').init()

local telescope = require('telescope')
local builtin = require("telescope.builtin")
local actions = require("telescope.actions")

telescope.setup{
  defaults = {
    vimgrep_arguments = {
      'rg',
      '--color=never',
      '--no-heading',
      '--with-filename',
      '--line-number',
      '--column',
      '--smart-case'
    },
    mapping = {
      ["<cr>"] = actions.select_default + actions.center,
    },

    prompt_prefix = '❯ ',
    selection_caret = '▍ ',
    multi_icon = 'v',
    set_env = { COLORTERM = 'truecolor' },

    layout_strategy = 'flex',
    layout_config = {
        width = 0.9,
        height = 0.85,
        prompt_position = 'bottom',
        horizontal = {
            preview_width = horizontal_preview_width,
        },
        vertical = {
            width = 0.75,
            height = 0.85,
            preview_height = 0.4,
            mirror = false,
        },
            flex = {
                flip_columns = 120,
            },
    },
    file_sorter =  require'telescope.sorters'.get_fuzzy_file,
    file_ignore_patterns = {},
    generic_sorter =  require'telescope.sorters'.get_generic_fuzzy_sorter,
    border = {},
    -- borderchars = { '─', '│', '─', '│', '┌', '┐', '┘', '└' },
    borderchars = { '─', '│', '─', '│', '╭', '╮', '╯', '╰' },
    color_devicons = true,
    use_less = true,
    set_env = { ['COLORTERM'] = 'truecolor' }, -- default = nil,
    file_previewer = require'telescope.previewers'.vim_buffer_cat.new,
    grep_previewer = require'telescope.previewers'.vim_buffer_vimgrep.new,
    qflist_previewer = require'telescope.previewers'.vim_buffer_qflist.new,

    -- Developer configurations: Not meant for general override
    buffer_previewer_maker = require'telescope.previewers'.buffer_previewer_maker

},
  extensions = {
--    frecency = {
 ----     show_scores = false,
----      show_unindexed = true,
 ----     ignore_patterns = {"*.git/*", "*/tmp/*"},
----      workspaces = {
----        ["d"]    = vim.fn.expand("$HOME/dotfiles"),
  ----      ["s"]    = vim.fn.expand("$HOME/backup/samplecodes")
----      }
 ----   },
    extensions = {
    recent_files = {
      -- This extension's options, see below.
    }
  },
    fzf = {
      fuzy = true,
      override_generic_sorter = true, -- override the generic sorter
      override_file_sorter = true,     -- override the file sorter
      case_mode = "smart_case",        -- or "ignore_case" or "respect_case"
                                       -- the default case_mode is "smart_case"
    }
  },
}

local find_files_opts = {
  attach_mappings = function(_)
    actions.center:replace(function(_)
      vim.wo.foldmethod = vim.wo.foldmethod or "expr"
      vim.wo.foldexpr = vim.wo.foldexpr or "nvim_treesitter#foldexpr()"
      vim.cmd(":normal! zx")
      vim.cmd(":normal! zz")
      pcall(vim.cmd, ":loadview") -- silent load view
    end)
    return true
  end,
}

builtin.my_find_files = function(opts)
  opts = opts or {}
  return builtin.find_files(vim.tbl_extend("error", find_files_opts, opts))
end

--telescope.extensions.frecency.my_frecency = function(opts)
--  opts = opts or {}
--  return telescope.extensions.frecency.frecency(vim.tbl_extend("error", find_files_opts, opts))
--end

--telescope.load_extension('frecency')
telescope.load_extension("recent_files")
telescope.load_extension('fzf')
telescope.load_extension('file_browser')

vim.g.nvim_tree_git_hl = 0
vim.g.nvim_tree_gitignore = 0
vim.g.nvim_tree_show_icons = { git = 0, folders = 1, files = 1, }


vim.api.nvim_set_keymap("n", "<Leader>ff",
  [[<cmd>lua require('telescope').extensions.recent_files.pick()<CR>]],
  {noremap = true, silent = true})

-- vim.api.nvim_set_keymap('n', '<leader>ff', "<Cmd>lua require('telescope').extensions.frecency.my_frecency()<CR>", {noremap = true, silent = true})
vim.api.nvim_set_keymap('n', '<leader>gr', '<cmd> Telescope lsp_references<CR>', { noremap = true})
vim.api.nvim_set_keymap('n', '<leader>gd', '<cmd> Telescope lsp_definitions<CR>', { noremap = true})
vim.api.nvim_set_keymap('n', '<leader>v', '<cmd>lua require"telescope.builtin".lsp_definitions({jump_type="vsplit"})<CR>', {noremap=true, silent=true})

if vim.bo.filetype == "python" then
    vim.api.nvim_set_keymap('n', '<leader>fm', '<cmd> Telescope lsp_document_symbols  symbols={"function","method"}<CR>', { noremap = true})
else
    vim.api.nvim_set_keymap('n', '<leader>fm', '<cmd> Telescope lsp_document_symbols theme=dropdown symbols={"interface","class","constructor",method"}<CR>', { noremap = true})
end

vim.api.nvim_set_keymap('n', '<leader>dd', '<cmd>lua vim.diagnostic.open_float()<CR>',{noremap = true, silent = true})

vim.opt.termguicolors = true

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

vim.keymap.set(
    {"n"}, "<c-.>", ":call vm#commands#add_cursor_up(0, v:count1)<cr>",
    { noremap = true, silent = true }
)

vim.keymap.set(
    {"n"}, "<c-,>", ":call vm#commands#add_cursor_down(0, v:count1)<cr>",
    { noremap = true, silent = true }
)

local nvim_web_devicons = require "nvim-web-devicons"

local current_icons = nvim_web_devicons.get_icons()
local new_icons = {}

-- put gray because txt file color icon does not change
for key, icon in pairs(current_icons) do
    icon.color = "#6f6b79"
    icon.cterm_color = 198
    new_icons[key] = icon
end

nvim_web_devicons.set_icon(new_icons)

local lualine = require('lualine')

local custom_theme = require'lualine.themes.gruvbox-material'

custom_theme.normal.c.bg = '#323741'


custom_theme.replace.c.bg = '#323741'
custom_theme.visual.c.bg = '#323741'
custom_theme.insert.c.bg = '#323741'
custom_theme.command.c.bg = '#323741'

custom_theme.normal.b.bg = '#323741'
custom_theme.replace.b.bg = '#323741'
custom_theme.visual.b.bg = '#323741'
custom_theme.insert.b.bg = '#323741'
custom_theme.command.b.bg = '#323741'

-- custom_theme.normal.a.bg = '#323741'
-- custom_theme.insert.a.bg = '#323741'
-- custom_theme.command.a.bg = '#323741'
-- custom_theme.replace.a.bg = '#323741'
-- custom_theme.visual.a.bg = '#323741'
 custom_theme.normal.a.bg = '#81A8C1'
-- custom_theme.normal.a.bg = '#9999aa'
custom_theme.command.a.bg = '#c48eb0'
--custom_theme.command.a.bg = '#945e80'

--custom_theme.normal.a.fg = '#bdc6d1'
--custom_theme.insert.a.fg = '#bbe67e'
--custom_theme.replace.a.fg = '#ffae57'
--custom_theme.visual.a.fg = '#f07178'
--custom_theme.command.a.fg = '#d4bfff'

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

local function file_location()
  local percent = math.floor(100 * vim.fn.line('.') / vim.fn.line('$'))
  return string.format('%4s:%-3s %3s%%%%', vim.fn.line('.'), vim.fn.col('.'), percent)
end

local function file_path()
  return string.format('%s', vim.fn.expand("%:p:h:t"))
end

lualine.setup{
  options = {
    theme = custom_theme,
    component_separators = { left = ' ', right = ' '},
   -- section_separators = { left = ' ', right = ' '},
   -- section_separators = { left = '', right = ''},
     section_separators = { left = '', right = ''},
    -- section_separators = { left = '', right = ''},
  },
  sections = {
    lualine_b = { file_path,{'filename', symbols = { modified = '[+]', readonly = ' ' } } },
    lualine_c = {
      { 'branch', separator = '' },
       { 'diff', left_padding = 0, symbols = { added = ' ', modified = ' ', removed = ' ' } }
    },
    lualine_x = {
        {
                'diagnostics',
                sources = { 'nvim_diagnostic' },
                 diagnostics_color = {
                      error = 'LspDiagnosticsDefaultError', -- Changes diagnostics' error color.
                         warn  = 'LspDiagnosticsDefaultWarning',  -- Changes diagnostics' warn color.
                       info  = 'LspDiagnosticsDefaultInformation',  -- Changes diagnostics' info color.
                      hint  = 'LspDiagnosticsDefaultHint',  -- Changes diagnostics' hint color.
                  },
                    symbols = {error = ' ', warn = ' ', info = ' ', hint = 'H '},
                  colored = true,           -- Displays diagnostics status in color if set to true.
                    update_in_insert = false, -- Update diagnostics in insert mode.
                 always_visible = false,   -- Show diagnostics even if there are none.
    }},
    lualine_y = { 'filetype' },
    -- lualine_z = {'%-3l:%-3c', '%p%%/%L'},
    lualine_z = { file_location},
  },
  inactive_sections = {
    lualine_b = { { 'filename', symbols = { modified = '[+]', readonly = ' ' } } },

    lualine_c = { { 'diff', symbols = { added = ' ', modified = ' ', removed = ' ' } } },
    lualine_x = { { 'diagnostics', sources = { 'nvim_diagnostic' } } },
    lualine_y = { 'filetype' },
  },
  extensions = { 'fzf', 'nvim-tree', 'fugitive' },
}


-- map helper for gx (open url)
local function map(mode, lhs, rhs, opts)
    local options = { noremap = true }
    if opts then
        options = vim.tbl_extend("force", options, opts)
    end
    vim.api.nvim_set_keymap(mode, lhs, rhs, options)
end

-- source: https://sbulav.github.io/vim/neovim-opening-urls/
if vim.fn.has("mac") == 1 then
  map("", "gu", '<Cmd>call jobstart(["open", expand("<cfile>")], {"detach": v:true})<CR>', {})
elseif vim.fn.has("unix") == 1 then
  map("", "gu", '<Cmd>call jobstart(["xdg-open", expand("<cfile>")], {"detach": v:true})<CR>', {})
else
  map[''].gu = {'<Cmd>lua print("Error: gx is not supported on this OS!")<CR>'}
end

EOF
"------------------------------------------------------------------------------
" BASICS  --------------------------------------------------------------------
"------------------------------------------------------------------------------
" global status line for multiple windows
set laststatus=3
" nmap <silent> gx :silent !open <cWORD><cr>
nmap <c-leftmouse> gx

set noshowmode                 " we have another blah line to show the status
set noshowcmd                  " not sure if it is necessary to show cmd
set lazyredraw

set updatetime=200             " also impacts lsp.diagnostic.show_line...
set timeoutlen=500

set autoread                   " vim reloads file if modified externally

set foldcolumn=0               " avoid folding left column
set visualbell                 " turn off visual and sound bell
set t_vb=


set hidden                     "I can switch buffers without saving them

set list lcs=trail:¬,tab:»·

let &titleold=getcwd()         " put directory name in terminal when exiting vim

set backspace=indent,eol,start " make backspace work as in any other application

set t_ZH=^[[3m
set t_ZR=^[[23m
filetype on                        " enable file type stuff
filetype plugin on
filetype plugin indent on

set termguicolors                  " set basic color enablement as
let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum"
let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum"
set t_Co=256
syntax enable                      " I don't want ugly colors ;-)

set splitbelow splitright          " new windows show up below and right
" set title                          " show the filename in the window title bar
set scrolloff=5                    " start scrolling n lines before horizontal

set wildmenu                       " autocomplete commands using a menu
set wildmode=full

set mouse=a                        "Proper mouse (need vim-pbcopy plugin)
"vmap <D-c> y

" open file in the same position closed (line and screen positions)
au BufWinLeave * silent! mkview
au BufWinEnter * silent! loadview

" folding
set foldmethod=indent
set foldnestmax=10
set nofoldenable
set foldlevel=2

" search/replace
set ignorecase
set smartcase
set incsearch
set wrapscan
set hlsearch
"set nohlsearch      " to think about... no search highlight
set showmatch       " bracket matching
set gdefault


" indentation
set expandtab                   " Expand tabs to spaces
set autoindent smartindent      " auto/smart indent
set copyindent                  " copy previous indentation on auto indent
set softtabstop=4               " Tab key results in # spaces
set tabstop=4                   " Tab is # spaces
set shiftwidth=4                " The # of spaces for indenting.
set smarttab                    " At start of line, <Tab> inserts shift width
"   spaces, <Bs> deletes shift width spaces.
set wrap                        " wrap lines
set textwidth=80
set formatoptions=qrn1          " automatic formating.
set formatoptions-=o            " don't start new lines w/ comment leader on

set cursorline
set cursorcolumn

fu! ToggleCurline ()
  if &cursorline && &cursorcolumn
    set nocursorline
    set nocursorcolumn
  else
    set cursorline
    set cursorcolumn
  endif
endfunction

map <silent><leader><leader>c :call ToggleCurline()<CR>

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


set listchars=tab:▸\ ,trail:¬,nbsp:.,extends:❯,precedes:❮

autocmd CompleteDone :<silent><buffer> lua vim.lsp.buf.signature_help()
set shortmess+=c   "avoid showing Pattern not found messages (from lsp)


" set previewheight=5
" had to put this in after/syntax/css.vim
" avoids breaking syntax highlight when jumping in large files
" syntax sync minlines=10000
" syntax sync fromstart

"------------------------------------------------------------------------------
" AUTOCMD  --------------------------------------------------------------------
"------------------------------------------------------------------------------

" autocmd CursorHold * lua vim.diagnostic.show()
autocmd CursorHold * silent lua vim.diagnostic.open_float()
" autocmd CursorHold * lua vim.diagnostic.open_float(0, { scope = "line", border = "single" })
" autocmd CursorHold * lua vim.lsp.diagnostic.show_line_diagnostics()
" autocmd CursorHoldI * silent! lua vim.lsp.buf.signature_help()

augroup filetype_python
  autocmd!
  autocmd FileType python,json set list
  autocmd FileType python,json set listchars=tab:▸\ ,trail:¬,nbsp:.,extends:❯,precedes:❮
  autocmd FileType python,json set number
  autocmd FileType python,json set cursorline
  autocmd FileType python,json set signcolumn=yes
augroup END

au InsertEnter *  :echo ""

:au FocusLost   * :set nocursorline
:au FocusLost   * :set nocursorcolumn
:au FocusGained * :set cursorline
:au FocusGained * :set cursorcolumn

"------------------------------------------------------------------------------
" PLUGIN CONF  ----------------------------------------------------------------
"------------------------------------------------------------------------------
set completeopt=menuone,noselect

let g:compe = {}
let g:compe.enabled = v:true
let g:compe.autocomplete = v:true
let g:compe.debug = v:false
let g:compe.min_length = 1
let g:compe.preselect = 'enable'
let g:compe.throttle_time = 80
let g:compe.source_timeout = 200
let g:compe.incomplete_delay = 400
let g:compe.max_abbr_width = 100
let g:compe.max_kind_width = 100
let g:compe.max_menu_width = 100
let g:compe.documentation = v:true

let g:compe.source = {}
let g:compe.source.path = v:true
let g:compe.source.buffer = v:true
let g:compe.source.calc = v:true
let g:compe.source.nvim_lsp = v:true
let g:compe.source.nvim_lua = v:true
let g:compe.source.vsnip = v:true
let g:compe.source.ultisnips = v:true


" plugin: vim_current_word
let g:vim_current_word#highlight_delay = 300


" plugin: nerdcommenter
vmap ++ <plug>NERDCommenterToggle
nmap ++ <plug>NERDCommenterToggle
" force detecting json type (needed it for nerdcommenter)
au BufNewFile,BufRead *.json   setf json
" bufline is not updated automatically when adding new buffer
" Add spaces after comment delimiters by default
let g:NERDSpaceDelims = 1


" plugin: rainbow
let g:rainbow_active = 0
let g:rainbow_guifgs = ['LightCoral', 'GoldenRod', 'DarkOrchid3', 'RoyalBlue3', 'LightSalmon']
let g:rainbow_ctermfgs = ['lightblue', 'lightgreen', 'yellow', 'red', 'magenta']

" plugin: indentguides
" ---> remove the line that specifies trail their
let g:indentguides_spacechar = '▏'
let g:indent_guides_start_level = 0
let g:indentguides_firstlevel = 1
let g:indent_guides_enable_on_vim_startup = 0


let g:markdown_fenced_languages = ['html', 'python', 'bash=sh', 'c', 'javascript','json']

" plugin: quickscope
let g:qs_highlight_on_keys = ['f', 'F']
highlight QuickScopePrimary guifg='#ffffff'


"plugin: gitgutter
" let g:gitgutter_sign_added = '▏'
let g:gitgutter_sign_added = '┃'
let g:gitgutter_sign_modified = '┃'
let g:gitgutter_sign_removed = '┃'
let g:gitgutter_sign_removed_first_line = '┃'
let g:gitgutter_sign_removed_above_and_below = '┃'
let g:gitgutter_sign_modified_removed = '┃'
:au InsertLeave * call gitgutter#process_buffer(bufnr(''), 0)
" the following is specific to neovim
:au TextChanged * call gitgutter#process_buffer(bufnr(''), 0)


let g:kitty_navigator_no_mappings = 1
nnoremap <silent> <c-p> :KittyNavigateRight<cr>
nnoremap <silent> <c-h> :KittyNavigateLeft<cr>


inoremap <silent><expr> <TAB> pumvisible() ? "\<C-n>" : "\<TAB>"
inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"


" plugin: startify
" https://ricostacruz.com/til/project-switcher-using-startify

let g:startify_lists = [
          \ { 'type': 'files',     'header': ['   MRU']            },
          \ { 'type': 'dir',       'header': ['   MRU '. getcwd()] },
          \ { 'type': 'sessions',  'header': ['   Sessions']       },
          \ { 'type': 'bookmarks', 'header': ['   Bookmarks']      },
          \ { 'type': 'commands',  'header': ['   Commands']       },
          \ ]
let g:startify_session_dir = '~/.local/share/nvim/sessions'

let g:startify_files_number           = 10

" Update session automatically as you exit vim
let g:startify_session_persistence    = 1

let g:startify_bookmarks = [
      \ '~/.config/nvim/init.vim',
      \ '~/.fun'
      \ ]

" Fancy custom header
let g:startify_custom_header = [
  \ "     ",
  \ '       ┏┓ ╻   ╻ ╻   ╻   ┏┳┓',
  \ '       ┃┃┏┛   ┃┏┛   ┃   ┃┃┃',
  \ '       ┃┗┛    ┗┛    ╹   ╹ ╹',
  \ '   ',
  \ ]


function! s:sy_add_bookmark(bookmark)
  if !exists('g:startify_bookmarks')
    let g:startify_bookmarks = []
  endif
  let g:startify_bookmarks += [ a:bookmark ]
endfunction

command! -nargs=1 StartifyAddBookmark call <sid>sy_add_bookmark(<q-args>)

" lazygit
nnoremap <silent> <leader>gg :LazyGit<CR>
let g:lazygit_floating_window_winblend = 0 " transparency of floating window
let g:lazygit_floating_window_scaling_factor = 0.9 " scaling factor for floating window
let g:lazygit_floating_window_corner_chars = ['╭', '╮', '╰', '╯'] " customize lazygit popup window corner characters
let g:lazygit_floating_window_use_plenary = 0 " use plenary.nvim to manage floating window if available
let g:lazygit_use_neovim_remote = 1 " fallback to 0 if neovim-remote is not installed

"------------------------------------------------------------------------------
" KEYMAPS  --------------------------------------------------------------------
"------------------------------------------------------------------------------
nnoremap <leader>z :x<CR>
nnoremap <leader>q :q!<CR>

nnoremap <silent> <leader>w :silent w<CR>:echo ""<CR>


" nnoremap <silent> <leader>w :silent w<CR>:sleep 700m<CR>:echo ""<CR>
" nnoremap <silent> <leader>w :call SaveAndClear()<CR>

" function! SaveAndClear()
    " :silent write
    " let a=resolve(expand('%:t'))
    " echo "saved:"a
    " function! ClearMessage(timer)
        " echo ""
    " endfunction
    " call timer_start(0800, 'ClearMessage')
" endfunction

nnoremap }   }zz
nnoremap {   {zz
nnoremap <A-Up> {
nnoremap <A-Down> }

nmap <leader>l *

nnoremap cd ciw
" do something (cut or delete) then press dot to replace down or up
nnoremap c* /\<<C-R>=expand('<cword>')<CR>\>\C<CR>``cgn
nnoremap c# /\<<C-R>=expand('<cword>')<CR>\>\C<CR>``cgN
nnoremap d* /\<<C-r>=expand('<cword>')<CR>\>\C<CR>``dgn
nnoremap d# ?\<<C-r>=expand('<cword>')<CR>\>\C<CR>``dgN


nnoremap <Space> i<Space><Esc>l
nnoremap <C-Space> i<Space><Esc>l

" clear research highlight
nmap <silent> <leader>/ :set nohlsearch<CR>:echo ""<CR>:let @/ = ''<CR>:set hlsearch<CR>

map <S-up> <Nop>
map <S-down> <Nop>

" map <leader>y "+y
map <leader>p "+p

" remove new line when yanking
" by converting the linewise visual selection to characterwise
" before yanking it
" vnoremap Y <Esc>'<0v'>g_"+y
" vnoremap <leader>y :OSCYank<CR>
nmap <silent> Y 0vg_<leader>y:echo "yank line"<CR>:sleep 700m<CR>:echo ""<CR>
"nmap <silent> Y <leader>y_:echo "yank line"<CR>:sleep 700m<CR>:echo ""<CR>

" yank current line to clipboard
" nnoremap <silent> Y :call setreg('+', getline('.'))<CR>:echo "yank line"<CR>:sleep 700m<CR>:echo ""<CR>

" disable multi cursor move selection
let g:VM_maps = {}
let g:VM_maps["Select l"] = ''
let g:VM_maps["Select h"] = ''

nnoremap <silent> <S-q> :bp<cr>:bd #<cr>
nnoremap <silent> <leader>bq :bp<cr>:bd #<cr>
nnoremap <silent> <leader>k :bp<cr>:bd #<cr>
nnoremap <silent> <S-Right> :bnext<CR>
nnoremap <silent> <S-Left>  :bprevious<CR>
" inoremap <silent> <ESC>+r  :bnext<CR>
" inoremap <silent> <ESC>+l  :bprevious<CR>
" nmap  <silent> <leader>b1  :bprevious<CR>
" nmap  <silent> <leader>b2  :bnext<CR>
map <silent> <leader>tt  :enew<CR>

"Clone Paragraph with cp
noremap <leader>cp yip<S-}>o<ESC>p:echo "cloned paragraph"<CR>

"Yank Paragraph with yp
noremap <leader>gp yip<S-}>:echo "yanked paragraph"<CR>

"Align Current Paragraph
noremap <silent> <leader>fa =ip

"format current line
noremap  <silent> <leader>a :AutoformatLine<CR>

nnoremap U <C-R> " redo

" nnoremap <C-n> :NvimTreeToggle<CR>
" map <leader>tr :RainbowToggle<CR>

" Reload vimrc
"nnoremap <silent> <Leader>r :so $MYVIMRC<CR>

" nnoremap <leader>ti :IndentGuidesToggle<CR>

map <F2> :%!column -t <CR>

" add color column (toggle)
nnoremap <silent> <F7> :let &cc = &cc == '' ? join(range(81,82),",") : ''<CR>

" see color definition
map <F9> :echo "hi<" . synIDattr(synID(line("."),col("."),1),"name") . '> trans<'
\ . synIDattr(synID(line("."),col("."),0),"name") . "> lo<"
\ . synIDattr(synIDtrans(synID(line("."),col("."),1)),"name") . ">"<CR>

nnoremap <silent> <leader>fs :Telescope lsp_document_symbols theme=dropdown<CR>
nnoremap <silent> <leader>lg :Telescope live_grep<CR>
nnoremap <silent> <leader>fc :Telescope find_files cwd=%:h<CR>
nnoremap <silent> <leader>ss :Telescope current_buffer_fuzzy_find<CR>
nnoremap <silent> <leader>fw :Telescope file_browser<CR>
" nnoremap <silent> <leader>fb :Telescope buffers<CR>
" nnoremap <silent> <leader>fd :lua require('telescope.builtin').find_files( {prompt_title = "< dotfiles >", cwd= "$HOME/dotfiles/"})<CR><CR>

" nnoremap <silent> <leader>fs :Telescope session-lens search_session<CR>
nnoremap <leader>j :set ft=json<cr>:%!python3 -m json.tool<cr>
" nnoremap <leader>j :set ft=json<cr>:%!python3 -m json.tool<cr>gg=G<cr>

" https://vi.stackexchange.com/questions/31197/add-current-position-to-the-jump-list-the-first-time-c-u-or-c-d-is-pressed


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

" plugin: startify
nnoremap <silent> <leader>ls :SSave<CR>
nnoremap <silent> <leader>ll :SClose<CR>

" plugin: vim-black-macchiato
autocmd FileType python xmap <silent> <buffer> <C-f> <plug>(BlackMacchiatoSelection)
autocmd FileType python nmap <silent> <buffer> <C-f> <plug>(BlackMacchiatoCurrentLine)

" plugin: gitgutter
nmap <leader>hv <Plug>(GitGutterPreviewHunk)
nmap <leader><leader>a <Plug>(GitGutterPrevHunk)
nmap <leader><leader>s <Plug>(GitGutterNextHunk)

" nnoremap <silent> <leader>pb }ge
" nnoremap <silent> <leader>pe {w
nnoremap <silent> <C-A-up> {w
nnoremap <silent> <C-A-down> }ge

" remove trailing spaces when saving file
" autocmd BufWritePre * :%s/\s\+$//e
function! StripTrailingWhitespaces()
"function! <SID>StripTrailingWhitespaces()
  if !&binary && &filetype != 'diff'
    let l:save = winsaveview()
    keeppatterns %s/\s\+$//e
    call winrestview(l:save)
  endif
endfun


nnoremap <silent> <Leader><leader>w :call StripTrailingWhitespaces()<cr>:silent w<cr>:echo ""<CR>

" autocmd BufWritePre <buffer> :call <SID>StripTrailingWhitespaces()
autocmd BufWrite *.py,*.js,*.css,*.html,*.json :Autoformat

nnoremap <leader>h <cmd> lua vim.lsp.buf.hover()<cr>
nnoremap <leader>gd <cmd> lua vim.lsp.buf.definition()<cr>
" autocmd FileType markdown,vim,java,ruby,python,lua autocmd BufWritePre <buffer> :call <SID>StripTrailingWhitespaces()
" autocmd CursorHold * lua vim.lsp.diagnostic.show_line_diagnostics({focusable = false})

"------------------------------------------------------------------------------
" COLOR STUFF  ----------------------------------------------------------------
"------------------------------------------------------------------------------
function! SetLSPHighlights()
    highlight LspDiagnosticsUnderlineError guifg=#aa4917 gui=none
    highlight LspDiagnosticsUnderlineWarning guifg=#EBA217 gui=undercurl
    highlight LspDiagnosticsUnderlineInformation guifg=#17D6EB, gui=undercurl
    highlight LspDiagnosticsUnderlineHint guifg=#17EB7A gui=undercurl
endfunction
autocmd ColorScheme * call SetLSPHighlights()

let g:gruvbox_material_palette = 'material'
let g:gruvbox_material_transparent_background = 1
let g:gruvbox_material_background = 'soft'
let g:gruvbox_transparent_background = 1
" avoid problem with tmux
let g:gruvbox_material_enable_italic = 0
let g:gruvbox_material_disable_italic_comment = 1

colorscheme gruvbox-material

exe "hi! CursorLine guibg=#323741"
exe "hi! CursorColumn guibg=#323741"
exe "hi! ColorColumn guibg=#2f353e"
exe "hi! CurrentWordTwins guibg=#3A4149"
exe "hi! CurrentWord guibg=#3A4149"
autocmd InsertEnter * highlight  CursorLine guibg=#373c47
autocmd InsertEnter * highlight  CursorColumn guibg=#373c47
autocmd InsertLeave * highlight  CursorLine guibg=#323741
autocmd InsertLeave * highlight  CursorColumn guibg=#323741
" hi Pmenu guibg='#3C424B' guifg='#CFB181'

highlight GitGutterAdd    guifg=#526F6D ctermfg=2
highlight GitGutterChange guifg=#bbbb00 ctermfg=3
highlight GitGutterDelete guifg=#f2777a ctermfg=1

" exe "hi! Normal guibg=NONE guifg=#D4BE98 ctermbg=NONE"

" area after EOF
exe "hi! NonText guifg=#777777 guibg=None gui=bold"

" background of line number column
exe "hi! LineNr guifg=#47525C guibg=None gui=bold"

" highlighted background of line number column
exe "hi! CursorLineNr guifg=#AAAAAA guibg=None gui=bold"
exe "hi! SignColumn guifg=#AAAAAA guibg=None gui=bold"
" colors of the cells
exe "hi! LspDiagnosticsDefaultError guifg=#FF8888 guibg=#323741 gui=bold"
exe "hi! LspDiagnosticsDefaultWarning guifg=#f9af28 guibg=#323741 gui=bold"
exe "hi! LspDiagnosticsDefaultInformation guifg=#AAAAAA guibg=None gui=bold"
exe "hi! LspDiagnosticsDefaultHint guifg=#AAAAAA guibg=None gui=bold"


exe " highlight! link SignColumn LineNr"

exe "hi! link TSError Normal"
exe "hi! QuickScopePrimary guifg=#ffffff gui=none"
exe "hi! QuickScopeSecondary guifg=#ffffff gui=none"

exe "hi! EndOfBuffer guifg=#2C323B guibg=None"


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
