vim.g.mapleader = ' '

--------------------------------------------------------------------------------
--- plugin manager -------------------------------------------------------------
--------------------------------------------------------------------------------
local lazypath = vim.fn.stdpath 'data' .. '/lazy/lazy.nvim'
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system {
    'git',
    'clone',
    '--filter=blob:none',
    'https://github.com/folke/lazy.nvim.git',
    '--branch=stable',
    lazypath,
  }
end
vim.opt.rtp:prepend(lazypath)

--------------------------------------------------------------------------------
--- plugins --------------------------------------------------------------------
--------------------------------------------------------------------------------
require('lazy').setup {
  -- colorscheme ---------------------------------------------------------------
  {
    'sainnhe/gruvbox-material',
    enabled = true,
    lazy = false,
    priority = 1000,
    config = function(_, opts)
      vim.cmd [[colorscheme gruvbox-material]]
    end,
    init = function()
      vim.g.gruvbox_material_palette = 'material'
      vim.g.gruvbox_material_transparent_background = 1
      vim.g.gruvbox_material_background = 'soft'
      vim.g.gruvbox_material_better_performance = 1
      vim.g.gruvbox_material_enable_bold = 1
      vim.g.gruvbox_material_enable_italic = 0
      vim.g.gruvbox_material_disable_italic_comment = 1
    end,
  },
  -- statusline ---------------------------------------------------------------
  {
    'nvim-lualine/lualine.nvim',
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    config = function()
      local function file_location()
        local percent = math.floor(100 * vim.fn.line '.' / vim.fn.line '$')
        return string.format('%4s:%-3s %3s%%%%', vim.fn.line '.', vim.fn.col '.', percent)
      end

      local function file_path()
        if vim.fn.has 'mac' == 1 then
          return string.format('%s', vim.fn.expand '%:p:h:t')
        else
          local f = io.popen '/bin/hostname'
          local hostname = f:read '*a' or ''
          f:close()
          hostname = string.gsub(hostname, '\n$', '')
          return string.format('[%s] %s', hostname, vim.fn.expand '%:p:h:t')
        end
      end

      local custom_theme = require 'lualine.themes.gruvbox_dark'

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

      require('lualine').setup {
        options = {
          theme = custom_theme,
          component_separators = { left = ' ', right = ' ' },
          section_separators = { left = '', right = '' },
        },
        sections = {
          lualine_b = {
            file_path,
            {
              'filename',
              symbols = { modified = '[+]', readonly = ' ' },
            },
            {
              require('nvim-possession').status,
              cond = function()
                return require('nvim-possession').status() ~= nil
              end,
            },
          },
          lualine_c = {
            { 'branch', separator = '' },
            {
              'diff',
              left_padding = 0,
              symbols = {
                added = ' ',
                modified = ' ',
                removed = ' ',
              },
            },
          },
          lualine_z = {
            { file_location },
          },
          lualine_x = {
            {
              'diagnostics',
              sources = { 'nvim_diagnostic' },
              -- diagnostics_color = {
              --     error = "LspDiagnosticsDefaultError",      -- Changes diagnostics' error color.
              --     warn = "LspDiagnosticsDefaultWarning",     -- Changes diagnostics' warn color.
              --     info = "LspDiagnosticsDefaultInformation", -- Changes diagnostics' info color.
              --     hint =
              --     "LspDiagnosticsDefaultHint"                -- Changes diagnostics' hint color.
              -- },
              -- " ", Warn = " ", Hint = " ", Info = " "
              symbols = {
                error = ' ',
                -- error = " ",
                warn = ' ',
                -- warn = " ",
                info = ' ',
                hint = '󰌶 ',
                -- hint = " "
              },
              -- symbols = {
              --     error = "E",
              --     warn = "W",
              --     info = "I",
              --     hint = "H"
              -- },
              colored = true, -- Displays diagnostics status in color if set to true.
              update_in_insert = false, -- Update diagnostics in insert mode.
              always_visible = false, -- Show diagnostics even if there are none.
            },
          },
          lualine_y = { 'filetype' },
        },
        inactive_sections = {
          lualine_b = {
            {
              'filename',
              symbols = { modified = '[+]', readonly = ' ' },
            },
          },
          lualine_c = {
            {
              'diff',
              symbols = {
                added = ' ',
                modified = ' ',
                removed = ' ',
              },
            },
          },
          lualine_x = { { 'diagnostics', sources = { 'nvim_diagnostic' } } },
          lualine_y = { 'filetype' },
        },
      }
    end,
  },
  -- clipboard handler ---------------------------------------------------------------
  {
    'ojroques/nvim-osc52',
    config = function()
      require('osc52').setup {
        max_length = 0, -- Maximum length of selection (0 for no limit)
        silent = true, -- Disable message on successful copy
        trim = false, -- Trim text before copy
      }
    end,
  },
  -- lsp -----------------------------------------------------------------------------
  {
    -- TODO, add here black and shfmt to auto install
    'williamboman/mason.nvim',
    'williamboman/mason-lspconfig.nvim',
    cond = function()
      if vim.fn.executable 'npm' == 1 then
        return true
      else
        return false
      end
    end,
  },
  {
    'VonHeikemen/lsp-zero.nvim',
    dependencies = {
      'lukas-reineke/lsp-format.nvim',
      'neovim/nvim-lspconfig',
      'hrsh7th/nvim-cmp',
      'hrsh7th/cmp-buffer',
      'hrsh7th/cmp-path',
      'saadparwaiz1/cmp_luasnip',
      'hrsh7th/cmp-nvim-lsp',
      'hrsh7th/cmp-nvim-lua',
      'L3MON4D3/LuaSnip',
      'rafamadriz/friendly-snippets',
      'onsails/lspkind-nvim',
    },
    config = function()
      local lsp = require 'lsp-zero'
      lsp.preset 'recommended'
      -- lsp.on_attach(function(client, bufnr)
      --   require("lsp-format").on_attach(client, bufnr)
      -- end)
      lsp.nvim_workspace()
      lsp.setup()
      vim.diagnostic.config { virtual_text = true }

      require('mason-lspconfig').setup {
        ensure_installed = {
          'lua_ls',
        },
      }
      if vim.fn.executable 'npm' == 1 then
        require('mason-lspconfig').setup {
          ensure_installed = {
            'tsserver',
            'bashls',
            'cssls',
            'lua_ls',
            'html',
            'jsonls',
            -- "shfmt",
            'pyright',
            'yamlls',
            'bicep',
          },
        }
      end
    end,
  },
  -- proper syntax colors -------------------------------------------------------------
  {
    'nvim-treesitter/nvim-treesitter',
    cond = function()
      if vim.fn.executable 'make' == 1 then
        return true
      else
        return false
      end
    end,
    config = function()
      require('nvim-treesitter.configs').setup {
        highlight = {
          enable = true,
          disable = {},
        },
        indent = {
          enable = true,
          -- disable = { "python" }
        },
        ensure_installed = {
          'html',
          'bash',
          'css',
          'python',
          'json',
          'vim',
          'yaml',
          'javascript',
          'typescript',
          'lua',
          'scss',
          'bicep',
        },
      }
    end,
    build = ':TSUpdate',
  },
  -- telescope -----------------------------------------------------------------------
  {
    'nvim-telescope/telescope.nvim',
    tag = '0.1.2',
    dependencies = { 'nvim-lua/plenary.nvim' },
  },
  {
    'nvim-telescope/telescope-file-browser.nvim',
    dependencies = { 'nvim-telescope/telescope.nvim', 'nvim-lua/plenary.nvim' },
  },
  {

    'smartpde/telescope-recent-files',
    config = function()
      require('telescope').load_extension 'recent_files'
      vim.keymap.set(
        'n',
        '<space>ff',
        "<cmd>lua require('telescope').extensions.recent_files.pick()<CR>",
        { noremap = true, silent = true }
      )
    end,
    dependencies = { 'nvim-telescope/telescope.nvim' },
  },
  {
    'nvim-telescope/telescope-fzf-native.nvim',
    cond = function()
      if vim.fn.executable 'make' == 1 then
        return true
      else
        return false
      end
    end,
    build = 'make',
  },
  -- toggle comment --------------------------------------------------------------------
  {
    'terrortylor/nvim-comment',
    config = function()
      require('nvim_comment').setup()
    end,
  },
  -- highlight current word ------------------------------------------------------------
  {

    -- 'dominikduda/vim_current_word'
    'RRethy/vim-illuminate',
    -- event = "BufReadPost",
    event = { 'BufReadPost', 'BufWinEnter' },
    opts = { delay = 500 },
    config = function(_, opts)
      require('illuminate').configure(opts)
    end,
  },
  -- auto pair brackets ----------------------------------------------------------------
  {
    'windwp/nvim-autopairs',
    event = 'InsertEnter',
    opts = {}, -- this is equalent to setup({}) function
  },
  -- multi cursor ----------------------------------------------------------------------
  {
    'mg979/vim-visual-multi',
  },
  -- buffer names on top of screen -----------------------------------------------------
  {
    'akinsho/bufferline.nvim',
    version = '*',
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
            fg = '#6f6b79',
          },
          buffer_selected = {
            bold = true,
            italic = true,
            fg = '#dddddd',
          },
        },
      }
    end,
  },
  -- MRU -------------------------------------------------------------------------------
  {

    'yegappan/mru',
  },
  -- git support -----------------------------------------------------------------------
  {
    'lewis6991/gitsigns.nvim',
    dependencies = {
      'nvim-lua/plenary.nvim',
    },
    config = function()
      require('gitsigns').setup {}
    end,
  },
  {

    'kdheepak/lazygit.nvim',
    -- optional for floating window border decoration
    dependencies = {
      'nvim-lua/plenary.nvim',
    },

    config = function()
      require('telescope').load_extension 'lazygit'
      vim.g.lazygit_floating_window_winblend = 0
      vim.g.lazygit_floating_window_scaling_factor = 0.9
      vim.g.lazygit_floating_window_border_chars = { '╭', '─', '╮', '│', '╯', '─', '╰', '│' }
      -- vim.g.lazygit_floating_window_use_plenary = 1
      vim.g.lazygit_use_neovim_remote = 1
    end,
  },
  -- preview markdown in browser -------------------------------------------------------
  {
    'iamcco/markdown-preview.nvim',
    cond = function()
      if vim.fn.executable 'yarn' == 1 then
        return true
      else
        return false
      end
    end,
    lazy = true,
    ft = 'markdown',
    build = 'cd app && yarn install',
    config = function()
      vim.g.mkdp_page_title = '${name}'
    end,
  },
  -- kitty -----------------------------------------------------------------------------
  {
    'knubie/vim-kitty-navigator',
    cond = function()
      if vim.fn.has 'mac' == 1 then
        return true
      else
        return false
      end
    end,
    build = 'cp ./*.py ~/.config/kitty/',
    init = function()
      vim.g.kitty_navigator_no_mappings = 1
    end,
  },
  -- {
  --   'chentoast/marks.nvim',
  --   event = 'VeryLazy',
  --
  --   config = function()
  --     require('marks').setup {
  --       mappings = {
  --         set_next = 'm,',
  --         toggle = '<c-6>',
  --         next = '<c-n>',
  --         -- next = "<leader>]",
  --         prev = '<c-j>',
  --         -- prev = "<leader>["
  --         preview = 'm:',
  --         --set_bookmark0 = "m0",
  --       },
  --     }
  --     -- vim.keymap.set("n", "<leader>s", ":MarksListBuf<CR>", { silent = true })
  --   end,
  -- },
  {
    'github/copilot.vim',

    config = function()
      vim.g.copilot_no_tab_map = true
      vim.g.copilot_assume_mapped = true
      vim.api.nvim_set_keymap('i', '<C-Enter>', 'copilot#Accept("<CR>")', { silent = true, expr = true })
      vim.api.nvim_set_keymap('i', '<C-;>', '<Plug>(copilot-next)', {})
      vim.g.copilot_filetypes = {
        ['*'] = false,
        ['javascript'] = false,
        ['typescript'] = false,
        ['lua'] = true,
        ['sh'] = true,
        ['zsh'] = true,
        ['bash'] = true,
        ['rust'] = true,
        ['c'] = true,
        ['c#'] = true,
        ['c++'] = true,
        ['python'] = true,
      }
    end,
  },
  {
    'kevinhwang91/nvim-bqf',
    ft = 'qf',
    config = function()
      require('bqf').setup {
        func_map = {
          openc = '<cr>',
        },
        preview = {
          winblend = 0,
        },
      }
    end,
  },
  {
    'stevearc/conform.nvim',
    opts = {
      -- Define your formatters
      formatters_by_ft = {
        -- lua = { "stylua" },
        python = { 'isort', 'black' },
        javascript = { { 'prettierd', 'prettier' } },
      },
      -- Set up format-on-save
      -- format_on_save = {
      --   timeout_ms = 1000,
      --   lsp_fallback = true,
      -- },
      -- Customize formatters
      formatters = {
        shfmt = {
          prepend_args = { '-i', '2' },
        },
        stylua = {
          prepend_args = { '--indent-width', '2', '--indent-type', 'Spaces' },
        },
      },
    },
    init = function()
      -- If you want the formatexpr, here is the place to set it
      vim.o.formatexpr = "v:lua.require'conform'.formatexpr()"
    end,
    config = function(_, opts)
      require('conform').setup(opts)
      notify_on_error = false
      -- vim.api.nvim_create_autocmd('BufWritePre', {
      --   pattern = '*',
      --   callback = function(args) require('conform').format({ bufnr = args.buf }) end,
      -- })
    end,
  },
  {
    'MattesGroeger/vim-bookmarks',
  },
  {
    'tom-anders/telescope-vim-bookmarks.nvim',
  },
  -- {
  --
  --   'jedrzejboczar/possession.nvim',
  --
  --   config = function()
  --     require('possession').setup {}
  --   end
  -- },
  {
    'gennaro-tedesco/nvim-possession',
    dependencies = {
      'ibhagwan/fzf-lua',
    },

    config = function()
      require('nvim-possession').setup {
        autoload = true,
        autoswitch = {
          enable = true, -- default false
        },
        sessions = {
          sessions_icon = ' ',
        },
        fzf_winopts = {
          -- any valid fzf-lua winopts options, for instance
          width = 0.5,
          preview = {
            vertical = 'right:30%',
          },
        },
      }
    end,
    init = function()
      local possession = require 'nvim-possession'
      vim.keymap.set('n', '\\s', function()
        possession.list()
      end)
      vim.keymap.set('n', '\\n', function()
        possession.new()
      end)
      vim.keymap.set('n', '\\u', function()
        possession.update()
      end)
      vim.keymap.set('n', '\\d', function()
        possession.delete()
      end)
    end,
  },
}

-- f3

-------------------------------------------------------------------------------

-- more plugin reelated config

-------------------------------------------------------------------------------

-- have decent autocompletion with ENTER + TAB ---------------
local cmp = require 'cmp'
local cmp_action = require('lsp-zero').cmp_action()
cmp.setup {
  mapping = {
    ['<CR>'] = cmp.mapping.confirm { select = false },
    ['<Tab>'] = cmp_action.tab_complete(),
    ['<S-Tab>'] = cmp_action.select_prev_or_fallback(),
  },
  window = {
    completion = cmp.config.window.bordered(),
    documentation = cmp.config.window.bordered(),
  },
}

-------------------------------------------------------------------------------
--- settings ------------------------------------------------------------------
-------------------------------------------------------------------------------

vim.opt.termguicolors = true -- Enable 24-bit RGB colors
vim.opt.updatetime = 200

-- vim.opt.clipboard = 'unnamedplus' -- Copy/paste to system clipboard -- PLEASE NO!
vim.opt.swapfile = false -- Don't use swapfile
vim.opt.ignorecase = true -- Search case insensitive...
vim.opt.smartcase = true -- ... but not it begins with upper case

vim.opt.expandtab = true -- expand tabs into spaces
vim.opt.shiftwidth = 4 -- number of spaces to use for each step of indent.
vim.opt.tabstop = 4 -- number of spaces a TAB counts for
vim.opt.autoindent = true -- copy indent from current line when starting a new line
vim.opt.wrap = true
vim.opt.smartindent = true

vim.opt.cursorline = true
vim.opt.cursorcolumn = true
vim.opt.showmode = false

vim.keymap.set('n', '<leader>y', require('osc52').copy_operator, { expr = true }) -- required for yank line
vim.keymap.set('x', '<c-y>', require('osc52').copy_visual)
vim.keymap.set('x', '<leader>y', require('osc52').copy_visual) --- not working???

-- vim.keymap.set('n', '<leader>y', require('osc52').copy_operator, { expr = true })
-- vim.keymap.set('n', 'Y', '<leader>c_', {remap = true})
-- vim.keymap.set('x', '<leader>y', require('osc52').copy_visual)

require('telescope').load_extension 'file_browser'
-- require('telescope').load_extension 'possession'
-- vim.keymap.set('n', '\\S', require('telescope').extensions.possession.list, { desc = '[S]essionManager: load session' })

vim.api.nvim_set_keymap('n', '<space>fw', ':Telescope file_browser<CR>', { noremap = true })

-- vim.keymap.set('n', '++', 'gcc')
-- vim.keymap.set('v', '++', 'gcc')

-- source: https://sbulav.github.io/vim/neovim-opening-urls/
if vim.fn.has 'mac' == 1 then
  vim.keymap.set('', 'gu', '<Cmd>call jobstart(["open", expand("<cfile>")], {"detach": v:true})<CR>', {})
elseif vim.fn.has 'unix' == 1 then
  vim.keymap.set('', 'gu', '<Cmd>call jobstart(["xdg-open", expand("<cfile>")], {"detach": v:true})<CR>', {})
end

-- vim.cmd [[autocmd BufWritePre <buffer> lua vim.lsp.buf.format()]]

vim.api.nvim_set_keymap('n', '<leader>gd', '<cmd> Telescope lsp_definitions<CR>', { noremap = true })

-- vim.keymap.set({ 'n' }, '<C-b>', '<cmd>rshada<cr><Plug>(Marks-toggle)<cmd>wshada!<CR>')
-- vim.keymap.set({ 'n' }, '<C-b>', '<cmd>rshada<cr><Plug>(Marks-toggle)')
vim.cmd [[

nnoremap <C-b> <Plug>BookmarkToggle:echo""<cr>
nnoremap mm <Plug>BookmarkToggle:echo""<cr>
nnoremap <silent> <C-n> <Plug>BookmarkNext:echo""<cr>
nnoremap <silent> <tab><tab> <Plug>BookmarkNext:echo ""<cr>
nnoremap <C-S-n> <Plug>BookmarkPrev:echo""<cr>
nnoremap <S-tab><S-tab> <Plug>BookmarkPrev:echo""<cr>
autocmd VimEnter * delmarks 0-9

" nnoremap <leader>= :let original_cursor = getpos(".")<CR>:%normal =<CR>:call setpos('.', original_cursor)<CR>
"autocmd FileType &filetype != 'lua' autocmd BufWritePre <buffer> lua vim.lsp.buf.format()

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


nnoremap <leader>z :x<CR>
nnoremap <leader>q :q!<CR>

nnoremap <silent> <leader>w :silent w<CR>:echo ""<CR>

set noswapfile
set nobackup
set nomodeline

nnoremap <silent> <c-p> :KittyNavigateRight<cr>
nnoremap <silent> <c-h> :KittyNavigateLeft<cr>
" as removed trim from osc52, to yank line go to first non-whitespace char
nmap <silent> Y ^vg_<leader>y:echo "yank line"<CR>:sleep 700m<CR>:echo ""<CR>
" nmap <silent> Y 0vg_<leader>y:echo "yank line"<CR>:sleep 700m<CR>:echo ""<CR>


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

nmap <silent> ++ gcc
vmap <silent> ++ gc
nmap <silent> +p gcip

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
exe "hi! PMenu guifg=Normal guibg=NONE"



"exe "hi! MatchParen guifg=lightblue guibg=darkblue"

" pmenu up and down arrow support
if &wildoptions =~ "pum"
    cnoremap <expr> <up> pumvisible() ? "<C-p>" : "\\<up>"
    cnoremap <expr> <down> pumvisible() ? "<C-n>" : "\\<down>"
endif

" temporary solution for not showing ~@k when scrolling
set noshowcmd
let g:lsp_diagnostics_float_delay = 5000


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

set lazyredraw
let g:loaded_matchparen=0
let g:vimtex_matchparen_enabled =0
let g:matchparen_timeout = 2
let g:matchparen_insert_timeout = 2

" do something (cut or delete) then press dot to replace down or up
nnoremap c* /\<<C-R>=expand('<cword>')<CR>\>\C<CR>``cgn
nnoremap c# /\<<C-R>=expand('<cword>')<CR>\>\C<CR>``cgN
nnoremap d* /\<<C-r>=expand('<cword>')<CR>\>\C<CR>``dgn
nnoremap d# ?\<<C-r>=expand('<cword>')<CR>\>\C<CR>``dgN


nnoremap <leader>gd <cmd> lua vim.lsp.buf.definition()<cr>

"nmap <silent> <leader>l :set nohlsearch<CR>*:set hlsearch<CR>
nmap <silent> <leader>l :set nohlsearch<CR>*:let @/ = ''<CR>:set hlsearch<CR>


"exe "hi! Search         gui=NONE   guifg=#303030   guibg=#ad7b57"
"exe "hi! IncSearch      gui=BOLD   guifg=#303030   guibg=#cd8b60"
exe "hi! IncSearch guibg=#a9b1d6 guifg=#444444 gui=NONE"
exe "hi! Search guibg=#444444 guifg=#cccccc gui=NONE"
"exe "hi! Search guibg=#b16286 guifg=#ababa2 gui=NONE"
set autochdir


nnoremap <silent> <leader>gg :LazyGitCurrentFile<CR>
nnoremap <silent> <leader>m :MarkdownPreview<CR>
"let g:lazygit_floating_window_winblend = 0 " transparency of floating window
"let g:lazygit_floating_window_scaling_factor = 0.9 " scaling factor for floating window
"let g:lazygit_floating_window_corner_chars = ['╭', '╮', '╰', '╯'] " customize lazygit popup window corner characters
"let g:lazygit_floating_window_use_plenary = 0 " use plenary.nvim to manage floating window if available
"let g:lazygit_use_neovim_remote = 1 " fallback to 0 if neovim-remote is not installed


nmap <silent> <leader>x :silent exec "! chmod +x % "<CR>:echo "made it executable"<CR>:sleep 700m<CR>:echo ""<CR>
" nmap <silent> <leader>x :!chmod +x % echo "yank line"<CR>:sleep 700m<CR>:echo ""<CR>

set formatoptions=qrn1          " automatic formating.
set formatoptions-=o            " don't start new lines w/ comment leader on
""-- set clipboard=unnamedplus
" "--- cw need to be "_cw to avoid cw yank text
set iskeyword+=-


nnoremap cd ciw
" cut (c) or delete (d) then press dot to replace down(*) or up(#) and 'n' to skip
nnoremap c* /\<<C-R>=expand('<cword>')<CR>\>\C<CR>``cgn
nnoremap c# /\<<C-R>=expand('<cword>')<CR>\>\C<CR>``cgN
nnoremap d* /\<<C-r>=expand('<cword>')<CR>\>\C<CR>``dgn
nnoremap d# ?\<<C-r>=expand('<cword>')<CR>\>\C<CR>``dgN

let g:VM_highlight_matches = 'hi Search guifg=#ffffff'


" -- but when deleting marks -- temporary solution"
""-- nnoremap dm<space> :delm!<CR>:wshada!<CR>

""-- nnoremap km :execute 'delm '.nr2char(getchar())<cr>:wshada!<CR>

nnoremap <leader>d :<C-u>call DelmFunction(input("Enter mark letter: ",""))<CR>
" nnoremap <C-b> :<Plug>(Marks-toggle)<CR>



""-- endfunction
 function! DelmFunction(letter)
   execute "delm ".a:letter
"  execute "wshada!"
 endfunction


nnoremap <A-Up> {
nnoremap <A-Down> }


"autocmd FileType qf nnoremap <buffer><silent> q :cclose<cr>

" function! ToggleQuickFix()
"     if empty(filter(getwininfo(), 'v:val.quickfix'))
"         copen
"     else
"         cclose
"     endif
" endfunction
" nnoremap <silent> Q :call ToggleQuickFix()<cr>
autocmd FileType qf nnoremap <buffer><silent> q :quit<cr>


augroup qf
    autocmd!
    autocmd FileType qf set nobuflisted
augroup END

"noremap('n', '<Leader>l', ':cclose|lclose<CR>')

nnoremap <leader>1 :set invspell<CR>
nnoremap <leader>3 ]s
nnoremap <leader>4 [s
" f3
]]

vim.keymap.set('n', '<leader>s', ':Telescope vim_bookmarks current_file<CR>', { silent = true })
-- vim.keymap.set('n', '<leader>s', ':MarksListBuf<CR>', { silent = true })
-- local mark_list = vim.fn.getmarklist(1)
-- for i in mark_list:iter() do
--     print(i)
-- end
-- print(mark_list)

-- vim.api.nvim_set_keymap('n', '<leader>qc', ':cclose<CR>', {})
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
      fg = '#6f6b79',
    },
    buffer_selected = {
      bold = true,
      italic = true,
      fg = '#dddddd',
    },
  },
}

vim.lsp.handlers['textDocument/publishDiagnostics'] = vim.lsp.with(vim.lsp.diagnostic.on_publish_diagnostics, {
  underline = false,
  virtual_text = false,
  signs = true,
  update_in_insert = true,
  focusable = false,
  --- error before gutter sign
  severity_sort = true,
})

require('nvim-web-devicons').set_icon {
  txt = {
    icon = '',
    color = '#777777',
    cterm_color = '65',
    name = 'Txt',
  },
  md = {
    icon = '',
    color = '#777777',
    cterm_color = '65',
    name = 'markdown',
  },
}

-- local signs = { Error = "E", Warn = "W", Hint = "H", Info = "I" }
-- local signs = { Error = " ", Warn = " ", Hint = " ", Info = " " }
local signs = { Error = '', Warn = '', Hint = '', Info = '' }
for type, icon in pairs(signs) do
  local hl = 'DiagnosticSign' .. type
  vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
end

vim.lsp.handlers['textDocument/hover'] = vim.lsp.with(vim.lsp.handlers.hover, { focusable = false })

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

if vim.fn.has 'mac' == 1 then
  vim.cmd [[
:au FocusLost   * :set nocursorline
:au FocusLost   * :set nocursorcolumn
:au FocusGained * :set cursorline
:au FocusGained * :set cursorcolumn
]]
end

vim.api.nvim_create_autocmd({ 'BufWinEnter' }, {
  callback = function()
    if vim.fn.has 'mac' == 0 then
      vim.cmd 'IlluminatePauseBuf'
      vim.cmd [[
               set nocursorline
               set nocursorcolumn
            ]]
    end
  end,
})

local nvim_web_devicons = require 'nvim-web-devicons'

local current_icons = nvim_web_devicons.get_icons()
local new_icons = {}

-- put gray because txt file color icon does not change
for key, icon in pairs(current_icons) do
  icon.color = '#6f6b79'
  icon.cterm_color = 198
  new_icons[key] = icon
end

nvim_web_devicons.set_icon(new_icons)

-- vim.keymap.set({ "n", "x" }, "p", "<Plug>(YankyPutAfter)")
-- vim.keymap.set({ "n", "x" }, "P", "<Plug>(YankyPutBefore)")
-- vim.keymap.set({ "n", "x" }, "gp", "<Plug>(YankyGPutAfter)")
-- vim.keymap.set({ "n", "x" }, "gP", "<Plug>(YankyGPutBefore)")

-- "n", "<leader>p", ':set paste<cr>o<esc>"*]p:set nopaste<cr>'
-- vim.keymap.set("n", "<Leader>p", ':set paste<cr>o<esc>"*]p:set nopaste<cr>')
vim.keymap.set('n', '<Leader>p', '"+p')
vim.keymap.set('n', '<Leader>P', '"+]p')
-- vim.keymap.set("n", "<leader>]", 'm]')
-- vim.keymap.set("n", "<leader>[", 'm[')

-- vim.api.nvim_set_keymap('n', '<C-e>', ':cclose<CR>', { noremap = true, silent = true })

-- vim.api.nvim_set_keymap('n', '<leader>b',
--     '<cmd>lua require"telescope.builtin".marks({bufnr= vim.api.nvim_get_current_buf()})<CR>',
--     { noremap = true })

vim.api.nvim_set_keymap(
  'n',
  '<leader>v',
  '<cmd>lua require"telescope.builtin".lsp_definitions({jump_type="vsplit"})<CR>',
  { noremap = true, silent = true }
)

vim.api.nvim_set_keymap('n', '<leader>gr', '<cmd> Telescope lsp_references<CR>', { noremap = true })
vim.api.nvim_set_keymap('n', '<leader>gd', '<cmd> Telescope lsp_definitions<CR>', { noremap = true })
vim.api.nvim_set_keymap('n', '<leader>2', '<cmd> Telescope spell_suggest<CR>', { noremap = true })

-- function quit_buffer()
-- vim.cmd('q')
-- end

-- vim.api.nvim_buf_set_keymap(0, 'n', 'q', ':lua quit_buffer()<CR>', { noremap = true, silent = true })
-- if vim.bo.filetype == 'qf' then
-- vim.api.nvim_set_keymap("n", "q", ":q<CR>", { noremap = true, silent = true })
-- end
-- if vim.o.filetype == 'python' then
vim.api.nvim_set_keymap(
  'n',
  '<leader>fm',
  '<cmd> Telescope lsp_document_symbols  symbols={"function","method"}<CR>',
  { noremap = true }
)

-- local lsp_fallback = setmetatable({
--   html = 'always',
--   -- yaml = 'always',
--   lua = false,
-- }, {
--   -- default true
--   __index = function()
--     return true
--   end,
-- })
--
require('conform').setup {
  notify_on_error = false,
  formatters_by_ft = {
    lua = { 'stylua' },
    -- Conform will run multiple formatters sequentially
    python = { 'autoflake', 'isort', 'black' },
    bash = { 'shfmt', 'shellcheck' },
    zsh = { 'shfmt', 'shellcheck' },
    sh = { 'shfmt', 'shellcheck' },
    yaml = { 'yamlfmt' },
    json = { 'jq' },
    ['_'] = { 'trim_whitespace' },
    -- python = { "black" },
    -- python = { "isort", "black" },
    -- Use a sub-list to run only the first available formatter
    -- javascript = { { "prettierd", "prettier" } },
  },
  format_after_save = {
    lsp_fallback = true,
    timeout_ms = 500,
  },
  -- format_on_save = function(buf)
  --   return {
  --     lsp_fallback = lsp_fallback[vim.bo[buf].filetype],
  --   }
  -- end,
}
--
vim.api.nvim_create_autocmd('BufWritePre', {
  pattern = '*',
  callback = function(args)
    require('conform').format { bufnr = args.buf }
  end,
})

-- else
-- vim.api.nvim_set_keymap('n', '<leader>fm',
-- '<cmd> Telescope lsp_document_symbols theme=dropdown symbols={"interface","class","constructor","method"}<CR>',
-- { noremap = true })
-- end

-- vim.api.nvim_set_keymap("n", "<C-t>", function()
--     require("telescope.builtin").quickfix()
--     vim.cmd(":cclose")
-- end, { desc = "Open Quickfix (Telescope)" })

-- vim.keymap.set("n", "<Leader>p", ':set paste<CR>"+]p:set nopaste<cr>')

-- vim.keymap.set("x", "<leader>p", [["_dP]])
-- vim.keymap.set('n', '<leader>p', '"*]p')

-- vim.keymap.set('n', '<Leader>v', 'i<C-r><C-o>+<ESC>l=`[`]$', { desc = 'Paste block and indent' })
-- -- Indenting
-- vim.opt.expandtab = true
-- vim.opt.shiftwidth = 2
-- vim.opt.smartindent = true
-- vim.opt.tabstop = 2
-- vim.opt.softtabstop = 2
--
-- vim.opt.fillchars = { eob = " " }
-- vim.opt.ignorecase = true
-- vim.opt.smartcase = true
-- vim.opt.mouse = "a"

-- vim.cmd("highlight! link CmpPmenu         Pmenu")
-- vim.cmd("highlight! link CmpPmenuBorder   Pmenu")
-- vim.cmd("highlight! CmpPmenu         guibg=#282828")
-- vim.cmd("highlight! CmpPmenuBorder   guifg=#615750")

--
--
-- local format_on_save = require("format-on-save")
-- local formatters = require("format-on-save.formatters")
--
-- format_on_save.setup({
--     exclude_path_patterns = {
--         "/node_modules/",
--         ".local/share/nvim/lazy",
--     },
--     formatter_by_ft = {
--         css = formatters.lsp,
--         html = formatters.lsp,
--         java = formatters.lsp,
--         javascript = formatters.lsp,
--         json = formatters.lsp,
--         lua = formatters.lsp,
--         markdown = formatters.prettierd,
--         -- python = formatters.lsp,
--         python = formatters.black,
--         rust = formatters.lsp,
--         sh = formatters.shfmt,
--         terraform = formatters.lsp,
--         typescript = formatters.prettierd,
--         typescriptreact = formatters.prettierd,
--         yaml = formatters.lsp,
--     },
-- })
