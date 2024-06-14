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
--- color setup ----------------------------------------------------------------
--------------------------------------------------------------------------------
local function lighten_color(hex, percent)
  local function hex_to_rgb(hex)
    hex = hex:gsub('#', '')
    return tonumber('0x' .. hex:sub(1, 2)), tonumber('0x' .. hex:sub(3, 4)), tonumber('0x' .. hex:sub(5, 6))
  end

  local function rgb_to_hex(r, g, b)
    return string.format('#%02X%02X%02X', r, g, b)
  end

  local r, g, b = hex_to_rgb(hex)

  r = math.min(255, math.floor(r + (255 - r) * percent))
  g = math.min(255, math.floor(g + (255 - g) * percent))
  b = math.min(255, math.floor(b + (255 - b) * percent))

  return rgb_to_hex(r, g, b)
end

local colorbg = '#24273a' -- "Catppuccin Macchiato"
-- local colorbg = '#2C323B' -- original gray
local colorbg1 = lighten_color(colorbg, 0.04)
local colorbg2 = lighten_color(colorbg, 0.09)
--------------------------------------------------------------------------------
--- plugins --------------------------------------------------------------------
--------------------------------------------------------------------------------
require('lazy').setup {
  {
    'catppuccin/nvim',
    name = 'catppuccin',
    priority = 1000,
    config = function(_, opts)
      require('catppuccin').setup {
        transparent_background = true,
        no_italic = true,
        no_bold = true,
      }
      vim.cmd [[colorscheme catppuccin-mocha]]
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

      local custom_theme = require 'lualine.themes.catppuccin-macchiato'
      custom_theme.normal.a.gui = ''
      custom_theme.insert.a.gui = ''
      custom_theme.replace.a.gui = ''
      custom_theme.visual.a.gui = ''
      custom_theme.command.a.gui = ''

      require('lualine').setup {
        options = {
          theme = custom_theme,
          component_separators = { left = ' ', right = ' ' },
          section_separators = { left = '', right = '' },
          globalstatus = true,
        },
        sections = {
          lualine_b = {
            file_path,
            {
              'filename',
              symbols = { modified = '[+]', readonly = ' ' },
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
              symbols = {
                error = ' ',
                warn = ' ',
                info = ' ',
                hint = '󰌶 ',
              },
              colored = true,
              update_in_insert = false,
              always_visible = false,
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
        max_length = 0,
        silent = true,
        trim = false,
      }
    end,
  },
  -- lsp -----------------------------------------------------------------------------
  {
    'williamboman/mason.nvim',
    dependencies = {
      'WhoIsSethDaniel/mason-tool-installer.nvim',
    },

    config = function()
      require('mason').setup {
        max_concurrent_installers = 10,
      }
      require('mason-tool-installer').setup {
        ensure_installed = {
          'autoflake',
          'black',
          'isort',
          'shfmt',
          'stylua',
        },
      }
    end,
  },
  {
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
    branch = 'v3.x',
    dependencies = {
      'neovim/nvim-lspconfig',
      'hrsh7th/nvim-cmp',
      'hrsh7th/cmp-nvim-lsp',
      'L3MON4D3/LuaSnip',
    },
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
        '<leader>fr',
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
  -- highlight current word --------------------------------------------------
  {
    'RRethy/vim-illuminate',
    -- event = "BufReadPost",
    event = { 'BufReadPost', 'BufWinEnter' },
    opts = { delay = 500 },
    config = function(_, opts)
      require('illuminate').configure(opts)
    end,
  },
  -- auto pair brackets ------------------------------------------------------
  {
    'windwp/nvim-autopairs',
    event = 'InsertEnter',
    opts = {},
  },
  -- buffer names on top of screen --------------------------------------------
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
            bold = false,
            italic = true,
            fg = '#6f6b79',
          },
          buffer_selected = {
            bold = false,
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
  -- wezterm navigator ----------------------------------------------------------------
  {
    'numToStr/Navigator.nvim',
    keys = {
      { '<C-M-h>', '<CMD>NavigatorLeft<CR>', mode = { 'n', 't' } },
      { '<C-M-l>', '<CMD>NavigatorRight<CR>', mode = { 'n', 't' } },
      { '<C-M-k>', '<CMD>NavigatorUp<CR>', mode = { 'n', 't' } },
      { '<C-M-j>', '<CMD>NavigatorDown<CR>', mode = { 'n', 't' } },
    },
    config = function()
      local ok, wezterm = pcall(function()
        return require('Navigator.mux.wezterm'):new()
      end)
      require('Navigator').setup { mux = ok and wezterm or 'auto' }
    end,
  },
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
      formatters_by_ft = {
        lua = { 'stylua' },
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
      vim.o.formatexpr = "v:lua.require'conform'.formatexpr()"
    end,
    config = function(_, opts)
      require('conform').setup(opts)
      notify_on_error = false
    end,
  },
  {
    'MattesGroeger/vim-bookmarks',
    init = function()
      -- vim.g.bookmark_sign = ''
      vim.g.bookmark_sign = '➜'
    end,
  },
  {
    'tom-anders/telescope-vim-bookmarks.nvim',
  },

  {

    'rmagatti/auto-session',
    config = function()
      require('auto-session').setup {
        log_level = 'error',
        auto_session_enable_last_session = true,
        auto_session_root_dir = vim.fn.stdpath 'data' .. '/sessions/',
        auto_session_suppress_dirs = { '~/', '~/Downloads', '/' },
        auto_session_enabled = true,
        auto_save_enabled = true,
        auto_restore_enabled = false,
        session_lens = {
          -- If load_on_setup is set to false, one needs to eventually call `require("auto-session").setup_session_lens()` if they want to use session-lens.
          buftypes_to_ignore = {}, -- list of buffer types what should not be deleted from current session
          load_on_setup = true,
          theme_conf = { border = true },
          previewer = false,
        },
      }
      local keymap = vim.keymap

      keymap.set('n', '<leader>wr', '<cmd>SessionRestore<CR>', { desc = 'Restore session for cwd' })
      keymap.set('n', '<leader>ws', '<cmd>SessionSave<CR>', { desc = 'Save session for auto session root dir' })
    end,
  },
  {
    'rmagatti/goto-preview',
    config = function()
      require('goto-preview').setup {
        width = 120, -- Width of the floating window
        height = 25, -- Height of the floating window
        border = { '↖', '─', '┐', '│', '┘', '─', '└', '│' }, -- Border characters of the floating window
        default_mappings = false,
        debug = false, -- Print debug information
        opacity = nil, -- 0-100 opacity level of the floating window where 100 is fully transparent.
        resizing_mappings = false, -- Binds arrow keys to resizing the floating window.
        post_open_hook = nil, -- A function taking two arguments, a buffer and a window to be ran as a hook.
        references = { -- Configure the telescope UI for slowing the references cycling window.
          telescope = require('telescope.themes').get_dropdown { hide_preview = false },
        },
        -- These two configs can also be passed down to the goto-preview definition and implementation calls for one off "peak" functionality.
        focus_on_open = true, -- Focus the floating window when opening it.
        dismiss_on_move = false, -- Dismiss the floating window when moving the cursor.
        force_close = true, -- passed into vim.api.nvim_win_close's second argument. See :h nvim_win_close
        bufhidden = 'wipe', -- the bufhidden option to set on the floating window. See :h bufhidden
        stack_floating_preview_windows = true, -- Whether to nest floating windows
        preview_window_title = { enable = true, position = 'left' }, -- Whether
      }
    end,
  },
  {
    'kylechui/nvim-surround',
    version = '*', -- Use for stability; omit to use `main` branch for the latest features
    event = 'VeryLazy',
    config = function()
      require('nvim-surround').setup {
        -- Configuration here, or leave empty to use defaults
      }
    end,
  },
  {
    'smjonas/inc-rename.nvim',
    config = function()
      require('inc_rename').setup()
    end,
  },
  {
    'goolord/alpha-nvim',
    event = 'VimEnter', -- load plugin after all configuration is set
    dependencies = {
      'nvim-tree/nvim-web-devicons',
    },
    config = function()
      local alpha = require 'alpha'
      local dashboard = require 'alpha.themes.dashboard'

      dashboard.section.header.val = {
        '     ',
        '     ',
        '     ',
        '     ',
        '       ┏┓ ╻   ╻ ╻   ╻   ┏┳┓',
        '       ┃┃┏┛   ┃┏┛   ┃   ┃┃┃',
        '       ┃┗┛    ┗┛    ╹   ╹ ╹',
        '   ',
      }

      _Gopts = {
        position = 'center',
        hl = 'Type',
        -- wrap = "overflow";
      }

      -- Set menu
      dashboard.section.buttons.val = {
        dashboard.button('j', '󰈚   Restore Session', ':SessionRestore<cr>'),
        dashboard.button('e', '   New file', ':ene <BAR> startinsert <CR>'),
        dashboard.button('f', '   Find file', ':cd $HOME/dotfiles | Telescope find_files<CR>'),
        dashboard.button('g', '󰱼   Find word', ':Telescope live_grep<CR>'),
        dashboard.button('r', '   Recent', ':Telescope oldfiles<CR>'),
        dashboard.button('s', '   Settings', ':e $MYVIMRC <CR>'),
        dashboard.button('q', '✗   Quit NVIM', ':qa<CR>'),
      }

      -- local function footer()
      --   return 'Welcome to neovim'
      -- end
      -- dashboard.section.footer.val = footer()

      dashboard.opts.opts.noautocmd = true
      alpha.setup(dashboard.opts)

      require('alpha').setup(dashboard.opts)

      -- vim.api.nvim_create_autocmd("User", {
      -- 	pattern = "LazyVimStarted",
      -- 	callback = function()
      -- 		local stats = require("lazy").stats()
      -- 		local count = (math.floor(stats.startuptime * 100) / 100)
      -- 		dashboard.section.footer.val = {
      -- 			"󱐌 " .. stats.count .. " plugins loaded in " .. count .. " ms",
      -- 			" ",
      -- 			"      Mohammed Babiker Babai",
      -- 		}
      -- 		pcall(vim.cmd.AlphaRedraw)
      -- 	end,
      -- })
    end,
  },
  {
    'stevearc/dressing.nvim',
    opts = {},
  },
  -- {
  --
  --   'jedrzejboczar/possession.nvim',
  --
  --   config = function()
  --     require('possession').setup {}
  --   end
  -- },
  -- {
  --   'gennaro-tedesco/nvim-possession',
  --   dependencies = {
  --     'ibhagwan/fzf-lua',
  --   },
  --
  --   config = function()
  --     require('nvim-possession').setup {
  --       save_hook = function()
  --         -- Get visible buffers
  --         local visible_buffers = {}
  --         for _, win in ipairs(vim.api.nvim_list_wins()) do
  --           visible_buffers[vim.api.nvim_win_get_buf(win)] = true
  --         end
  --
  --         local buflist = vim.api.nvim_list_bufs()
  --         for _, bufnr in ipairs(buflist) do
  --           if visible_buffers[bufnr] == nil then -- Delete buffer if not visible
  --             vim.cmd('bd ' .. bufnr)
  --           end
  --         end
  --       end,
  --       autoload = true,
  --       autoswitch = {
  --         enable = true, -- default false
  --       },
  --       sessions = {
  --         sessions_icon = ' ',
  --       },
  --       fzf_winopts = {
  --         -- any valid fzf-lua winopts options, for instance
  --         width = 0.5,
  --         preview = {
  --           vertical = 'right:30%',
  --         },
  --       },
  --     }
  --   end,
  --   init = function()
  --     local possession = require 'nvim-possession'
  --     vim.keymap.set('n', '\\s', function()
  --       possession.list()
  --     end)
  --     vim.keymap.set('n', '\\n', function()
  --       possession.new()
  --     end)
  --     vim.keymap.set('n', '\\u', function()
  --       possession.update()
  --     end)
  --     vim.keymap.set('n', '\\d', function()
  --       possession.delete()
  --     end)
  --   end,
  -- },
  --
}

-------------------------------------------------------------------------------
-- more plugin related config
-------------------------------------------------------------------------------
require('telescope').load_extension 'file_browser'

local lsp_zero = require 'lsp-zero'

lsp_zero.on_attach(function(client, bufnr)
  -- see :help lsp-zero-keybindings
  -- to learn the available actions
  lsp_zero.default_keymaps { buffer = bufnr }
end)

-- to learn how to use mason.nvim
-- read this: https://github.com/VonHeikemen/lsp-zero.nvim/blob/v3.x/doc/md/guide/integrate-with-mason-nvim.md
require('mason').setup {}
require('mason-lspconfig').setup {
  ensure_installed = {
    'tsserver',
    'bashls',
    'cssls',
    'lua_ls',
    'html',
    'jsonls',
    'pyright',
    'yamlls',
    'bicep',
  },
  handlers = {
    function(server_name)
      require('lspconfig')[server_name].setup {}
    end,
  },
}

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

vim.keymap.set('n', '<C-s>', require('auto-session.session-lens').search_session, {
  noremap = true,
})

-------------------------------------------------------------------------------
--- settings ------------------------------------------------------------------
-------------------------------------------------------------------------------
vim.opt.termguicolors = true -- Enable 24-bit RGB colors
vim.opt.updatetime = 200

-- vim.opt.clipboard = 'unnamedplus' -- Copy/paste to system clipboard -- PLEASE NO!
vim.opt.swapfile = false
vim.opt.ignorecase = true
vim.opt.smartcase = true

vim.opt.expandtab = true
vim.opt.shiftwidth = 4
vim.opt.tabstop = 4
vim.opt.autoindent = true
vim.opt.wrap = true
vim.opt.smartindent = true

vim.opt.cursorline = true
vim.opt.cursorcolumn = true
vim.opt.showmode = false

vim.o.backup = false
vim.o.modeline = false

vim.o.number = false
vim.o.scrolloff = 8

vim.o.list = true
vim.o.listchars = 'tab:▸\\ ,trail:¬,nbsp:.,extends:❯,precedes:❮'
vim.o.signcolumn = 'no'

vim.o.autochdir = true

--vim.o.iskeyword = vim.o.iskeyword .. '-'

-- Set automatic formatting options
vim.o.formatoptions = 'qrn1'

-- Disable starting new lines with comment leader
vim.o.formatoptions = vim.o.formatoptions:gsub('o', '')

vim.o.sessionoptions = 'blank,buffers,curdir,folds,help,tabpages,winsize,winpos,terminal,localoptions'

-------------------------------------------------------------------------------
--- shortcuts -----------------------------------------------------------------
-------------------------------------------------------------------------------
-- source: https://sbulav.github.io/vim/neovim-opening-urls/
if vim.fn.has 'mac' == 1 then
  vim.keymap.set('', 'gu', '<Cmd>call jobstart(["open", expand("<cfile>")], {"detach": v:true})<CR>', {})
elseif vim.fn.has 'unix' == 1 then
  vim.keymap.set('', 'gu', '<Cmd>call jobstart(["xdg-open", expand("<cfile>")], {"detach": v:true})<CR>', {})
end

vim.api.nvim_set_keymap('n', '<C-p>', 'gwap', { noremap = true, silent = true })

vim.api.nvim_set_keymap('n', '<leader>z', ':x<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>q', ':q!<CR>', { noremap = true, silent = true })

-- clear research highlight
vim.api.nvim_set_keymap(
  'n',
  '<leader>/',
  ':set nohlsearch<CR>:echo ""<CR>:let @/ = ""<CR>:set hlsearch<CR>',
  { silent = true }
)

vim.keymap.set('n', '<leader>y', require('osc52').copy_operator, { expr = true }) -- required for yank line
vim.keymap.set('x', '<c-y>', require('osc52').copy_visual)
vim.keymap.set('x', '<leader>y', require('osc52').copy_visual) --- not working???

vim.api.nvim_set_keymap('n', 'U', '<C-R>', { noremap = true, silent = true })

vim.api.nvim_set_keymap('n', '<space>fw', ':Telescope file_browser<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<space>fb', ':Telescope buffers<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>gd', '<cmd> Telescope lsp_definitions<CR>', { noremap = true })

vim.api.nvim_set_keymap('n', 'Y', '^vg_<leader>y:echo "yank line"<CR>:sleep 700m<CR>:echo ""<CR>', { silent = true })

vim.api.nvim_set_keymap('n', 'W', 'viw', { silent = true })

vim.api.nvim_set_keymap('n', '<leader>1', ':set invspell<CR>', { silent = true })
vim.api.nvim_set_keymap('n', '<leader>2', '<cmd> Telescope spell_suggest<CR>', { noremap = true })
vim.api.nvim_set_keymap('n', '<leader>3', ']s', { silent = true })
vim.api.nvim_set_keymap('n', '<leader>4', '[s', { silent = true })

vim.api.nvim_set_keymap('n', '<leader>r', '<cmd> Telescope lsp_references<CR>', { noremap = true })
vim.api.nvim_set_keymap('n', '<leader>gd', '<cmd> Telescope lsp_definitions<CR>', { noremap = true })

vim.keymap.set('n', 'gp', "<cmd>lua require('goto-preview').goto_preview_definition()<CR>", { noremap = true })
vim.keymap.set('n', 'gr', "<cmd>lua require('goto-preview').goto_preview_references()<CR>", { noremap = true })

vim.api.nvim_set_keymap(
  'n',
  '<leader>fm',
  '<cmd> Telescope lsp_document_symbols  symbols={"function","method"}<CR>',
  { noremap = true }
)

vim.keymap.set(
  'n',
  '<leader>v',
  ':botright vsplit | lua vim.lsp.buf.definition()<CR>',
  { noremap = true, silent = true }
)

vim.keymap.set('n', '<leader>rn', function()
  return ':IncRename ' .. vim.fn.expand '<cword>'
end, { expr = true })

vim.api.nvim_set_keymap('n', '<leader>fg', ':Telescope live_grep<CR>', { silent = true })
vim.api.nvim_set_keymap('n', '<leader>fc', ':Telescope find_files cwd=%:h<CR>', { silent = true })

vim.api.nvim_set_keymap('n', '<Leader>rn', ':lua vim.lsp.buf.rename()<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>gd', '<cmd>lua vim.lsp.buf.definition()<CR>', { noremap = true, silent = true })

vim.api.nvim_set_keymap('n', '<leader>gg', ':LazyGitCurrentFile<CR>', { silent = true })
vim.api.nvim_set_keymap('n', '<leader>m', ':MarkdownPreview<CR>', { silent = true })

vim.api.nvim_set_keymap('n', 'cd', 'ciw', { silent = true })

vim.api.nvim_set_keymap('n', '<A-i>', '{', { silent = true })
vim.api.nvim_set_keymap('n', '<A-Up>', '{', { silent = true })
vim.api.nvim_set_keymap('n', '<A-k>', '}', { silent = true })
vim.api.nvim_set_keymap('n', '<A-Down>', '}', { silent = true })

vim.api.nvim_set_keymap(
  'n',
  '<leader>x',
  ':silent exec "!chmod +x %" <CR>:echo "made it executable"<CR>:sleep 700m<CR>:echo ""<CR>',
  { silent = true }
)

-------------------------------------------------------------------------------
--- colors --------------------------------------------------------------------
-------------------------------------------------------------------------------
vim.api.nvim_set_hl(0, 'CursorLineNr', { fg = '#AAAAAA', bg = 'None', bold = false })
vim.api.nvim_set_hl(0, 'SignColumn', { fg = '#AAAAAA', bg = 'None', bold = false })
vim.api.nvim_set_hl(0, 'LineNr', { fg = '#47525C', bg = 'None', bold = false })

vim.api.nvim_set_hl(0, 'EndOfBuffer', { fg = colorbg, bg = 'None' })
vim.api.nvim_set_hl(0, 'CursorLine', { bg = colorbg1 })
vim.api.nvim_set_hl(0, 'CursorColumn', { bg = colorbg1 })

vim.api.nvim_set_hl(0, 'CurrentWordTwins', { bg = '#3A4149' })
vim.api.nvim_set_hl(0, 'CurrentWord', { bg = '#3A4139' })

vim.api.nvim_create_autocmd('InsertEnter', {
  pattern = '*',
  callback = function()
    vim.api.nvim_set_hl(0, 'CursorLine', { bg = colorbg2 })
    vim.api.nvim_set_hl(0, 'CursorColumn', { bg = colorbg2 })
  end,
})

vim.api.nvim_create_autocmd('InsertLeave', {
  pattern = '*',
  callback = function()
    vim.api.nvim_set_hl(0, 'CursorLine', { bg = colorbg1 })
    vim.api.nvim_set_hl(0, 'CursorColumn', { bg = colorbg1 })
  end,
})

-------------------------------------------------------------------------------
--- autocmds --------------------------------------------------------------------
-------------------------------------------------------------------------------

-- open file in the same position closed
vim.api.nvim_command 'autocmd BufWinLeave * silent! mkview'
vim.api.nvim_command 'autocmd BufWinEnter * silent! loadview'

-------------------------------------------------------------------------------
--- plugins -------------------------------------------------------------------
-------------------------------------------------------------------------------
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
      bold = false,
      italic = true,
      fg = '#6f6b79',
    },
    buffer_selected = {
      bold = false,
      italic = true,
      fg = '#dddddd',
    },
  },
}

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

-- https://github.com/nvim-telescope/telescope.nvim/issues/1048
local opts_ff = {
  attach_mappings = function(prompt_bufnr, map)
    local actions = require 'telescope.actions'
    actions.select_default:replace(function(prompt_bufnr)
      local actions = require 'telescope.actions'
      local state = require 'telescope.actions.state'
      local picker = state.get_current_picker(prompt_bufnr)
      local multi = picker:get_multi_selection()
      local single = picker:get_selection()
      local str = ''
      if #multi > 0 then
        for i, j in pairs(multi) do
          str = str .. 'edit ' .. j[1] .. ' | '
        end
      end
      str = str .. 'edit ' .. single[1]
      -- To avoid populating qf or doing ":edit! file", close the prompt first
      actions.close(prompt_bufnr)
      vim.api.nvim_command(str)
    end)
    return true
  end,
}
-- And then to call find_files with a mapping or whatever:
vim.keymap.set('n', '<leader>ff', function()
  return require('telescope.builtin').find_files(opts_ff)
end, s)

-- put gray because txt file color icon does not change
local nvim_web_devicons = require 'nvim-web-devicons'
local current_icons = nvim_web_devicons.get_icons()
local new_icons = {}
for key, icon in pairs(current_icons) do
  icon.color = '#6f6b79'
  icon.cterm_color = 198
  new_icons[key] = icon
end
nvim_web_devicons.set_icon(new_icons)

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
}
vim.api.nvim_create_autocmd('BufWritePre', {
  pattern = '*',
  callback = function(args)
    require('conform').format { bufnr = args.buf }
  end,
})

-------------------------------------------------------------------------------
--- misc ----------------------------------------------------------------------
-------------------------------------------------------------------------------

-- set signs for diagnostics
-- local signs = { Error = "E", Warn = "W", Hint = "H", Info = "I" }
-- local signs = { Error = " ", Warn = " ", Hint = " ", Info = " " }
local signs = { Error = '', Warn = '', Hint = '', Info = '' }
for type, icon in pairs(signs) do
  local hl = 'DiagnosticSign' .. type
  vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
end

vim.cmd [[
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
]]

if vim.fn.has 'persistent_undo' == 1 then
  vim.o.undodir = vim.fn.expand '~/.undodir'
  vim.o.undofile = true
  if vim.fn.isdirectory(vim.o.undodir) == 0 then
    vim.fn.mkdir(vim.o.undodir, 'p')
  end
  vim.o.undolevels = 99999
  vim.o.undoreload = 10000
end

-- have line and sign for all filetypes except text
vim.cmd [[
autocmd BufRead * if !empty(&filetype) && &filetype != 'text' | set number | set signcolumn=yes  |endif
]]

vim.cmd [[autocmd FileType markdown set tw=80 wrap]]

function ToggleCurline()
  if vim.o.cursorline == true and vim.o.cursorcolumn == true then
    vim.o.cursorline = false
    vim.o.cursorcolumn = false
  else
    vim.o.cursorline = true
    vim.o.cursorcolumn = true
  end
end

vim.api.nvim_set_keymap('n', '<leader>tc', ':lua ToggleCurline()<CR>', { silent = true })

vim.cmd [[
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

nnoremap <silent> <c-9> :call JumpWithinFile("\<c-i>", "\<c-o>")<cr>
nnoremap <silent> <c-8> :call JumpWithinFile("\<c-o>", "\<c-i>")<cr>
]]

vim.cmd [[
nnoremap <C-b> <Plug>BookmarkToggle:echo""<cr>
nnoremap <leader><leader> <Plug>BookmarkToggle:echo""<cr>
nnoremap <silent> <C-n> <Plug>BookmarkNext:echo""<cr>
nnoremap <silent> <tab><tab> <Plug>BookmarkNext:echo ""<cr>
nnoremap <C-S-n> <Plug>BookmarkPrev:echo""<cr>
nnoremap <S-tab><S-tab> <Plug>BookmarkPrev:echo""<cr>
autocmd VimEnter * delmarks 0-9
]]

vim.cmd [[
function! StripTrailingWhitespaces()
  if !&binary && &filetype != 'diff'
    let l:save = winsaveview()
    keeppatterns %s/\s\+$//e
    call winrestview(l:save)
  endif
endfun
nnoremap <silent> <leader>w :call StripTrailingWhitespaces()<cr>:silent w<cr>:echo ""<CR>
]]

vim.cmd [[
autocmd FileType qf nnoremap <buffer><silent> q :quit<cr>

augroup qf
    autocmd!
    autocmd FileType qf set nobuflisted
augroup END
]]

vim.cmd [[
    function! StripTrailingWhitespaces()
  if !&binary && &filetype != 'diff'
    let l:save = winsaveview()
    keeppatterns %s/\s\+$//e
    call winrestview(l:save)
  endif
endfun
nnoremap <silent> <leader>w :call StripTrailingWhitespaces()<cr>:silent w<cr>:echo ""<CR>
]]

vim.cmd [[
" do something (cut or delete) then press dot to replace down or up
" cut (c) or delete (d) then press dot to replace down(*) or up(#) and 'n' to skip
nnoremap c* /\<<C-R>=expand('<cword>')<CR>\>\C<CR>``cgn
nnoremap c# /\<<C-R>=expand('<cword>')<CR>\>\C<CR>``cgN
nnoremap d* /\<<C-r>=expand('<cword>')<CR>\>\C<CR>``dgn
nnoremap d# ?\<<C-r>=expand('<cword>')<CR>\>\C<CR>``dgN
]]

-- vim.cmd [[autocmd CursorHold * lua vim.diagnostic.open_float(0, {scope="line", focus=false,close_events = {"CursorMoved", "CursorMovedI", "BufHidden", "InsertCharPre", "WinLeave","InsertEnter"}})]]

if vim.fn.has 'mac' == 1 then
  vim.cmd [[
:au FocusLost   * :set nocursorline
:au FocusLost   * :set nocursorcolumn
:au WinLeave   * :set nocursorcolumn
:au WinLeave   * :set nocursorline
:au WinEnter   * :set cursorline
:au WinEnter   * :set cursorcolumn
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

vim.cmd [[
function! ModifyInsideBrackets(commandType) abort
    let curr_line=getline('.')
    let cursor_pos=col('.')

    let brackets = ["[", "]", "(", ")", "{", "}", "\"", "'", "<", ">"]
    let str_till_cursor_pos=strpart(curr_line,0,cursor_pos)
    let reversed_str=join(reverse(split(str_till_cursor_pos, '.\zs')), '')

    for char in split(reversed_str, '\zs')
        let value_found_at = index(brackets, char)

        if(value_found_at >= 0)
            if(a:commandType ==? 'change')
              execute "normal! ci".char

              :normal! l
              :startinsert
            elseif(a:commandType==?'delete')
              execute "normal! ci".char
            elseif(a:commandType==? 'select')
              execute "normal! vi".char
            elseif(a:commandType==? 'yank')
              execute "normal! yi".char
            endif

            break
        endif
    endfor
endfunction

" https://github.com/hrai/vim-files/blob/0cbc90229c0de0be296f3453396120f216a2870b/config.lua#L348
" command! ModifyInsideBrackets call ModifyInsideBrackets()
nmap <silent> dib :call ModifyInsideBrackets("delete")<CR>
nmap <silent> cib :call ModifyInsideBrackets("change")<CR>
nmap <silent> cb :call ModifyInsideBrackets("change")<CR>
nmap <silent> vib :call ModifyInsideBrackets("select")<CR>
nmap <silent> yib :call ModifyInsideBrackets("yank")<CR>
]]

vim.cmd [[
nmap <silent> ++ gcc
vmap <silent> ++ gc
nmap <silent> +p gcip
]]

vim.cmd [[
let g:vim_current_word#highlight_delay = 300
]]

vim.cmd [[
nnoremap <silent> <S-q> :bw<cr>
" nnoremap <silent> <S-q> :bp<cr>:bd #<cr>
nnoremap <silent> <leader>bq :bp<cr>:bd #<cr>
nnoremap <silent> <leader>k :bp<cr>:bd #<cr>
nnoremap <silent> <S-Right> :bnext<CR>
nnoremap <silent> <S-Left>  :bprevious<CR>
nnoremap <silent> <c-s-l> :bnext<CR>
nnoremap <silent> <c-s-j>  :bprevious<CR>
nnoremap <silent> <s-h>  :bprevious<CR>
nnoremap <silent> <s-l>  :bnext<CR>
nnoremap <silent> <a-.>  :bnext<CR>
nnoremap <silent> <a-,>  :bnext<CR>
]]

vim.cmd [[
" pmenu up and down arrow support
if &wildoptions =~ "pum"
    cnoremap <expr> <up> pumvisible() ? "<C-p>" : "\\<up>"
    cnoremap <expr> <down> pumvisible() ? "<C-n>" : "\\<down>"
endif
]]

-- vim.cmd [[
-- " temporary solution for not showing ~@k when scrolling
-- set noshowcmd
-- let g:lsp_diagnostics_float_delay = 5000
-- ]]

vim.cmd [[
let g:VM_highlight_matches = 'hi Search guifg=#ffffff'
]]

vim.cmd [[
set lazyredraw
let g:loaded_matchparen=0
let g:vimtex_matchparen_enabled =0
let g:matchparen_timeout = 2
let g:matchparen_insert_timeout = 2
]]

vim.cmd [[
nnoremap <C-M-i> <c-i>
nnoremap <C-M-o> <c-o>
]]

vim.lsp.handlers['textDocument/publishDiagnostics'] = vim.lsp.with(vim.lsp.diagnostic.on_publish_diagnostics, {
  underline = false,
  virtual_text = false,
  signs = true,
  update_in_insert = true,
  focusable = false,
  --- error before gutter sign
  severity_sort = true,
})

vim.lsp.handlers['textDocument/hover'] = vim.lsp.with(vim.lsp.handlers.hover, { focusable = false })

----------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------
-- STUFF TESTING------------------------------------------------------------------------
----------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------
---
vim.diagnostic.config {
  virtual_text = false,
  signs = true,
  update_in_insert = true,
  underline = false,
  severity_sort = true,
  float = {
    border = 'rounded',
    source = 'always',
    header = '',
    prefix = '- ',
  },
}
--
vim.api.nvim_set_keymap('n', '<C-S-a>', '<C-a>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<C-S-x>', '<C-x>', { noremap = true, silent = true })

vim.api.nvim_set_keymap('n', '<C-a>', '^', { noremap = true, silent = true })
vim.api.nvim_set_keymap('v', '<C-a>', '^', { noremap = true, silent = true })
vim.api.nvim_set_keymap('o', '<C-a>', '^', { noremap = true, silent = true })

vim.api.nvim_set_keymap('i', '<C-a>', '<C-o>0', { noremap = true, silent = true })
vim.api.nvim_set_keymap('i', '<C-e>', '<C-o>$', { noremap = true, silent = true })

vim.api.nvim_set_keymap('n', '<C-e>', '$', { noremap = true, silent = true })
vim.api.nvim_set_keymap('v', '<C-e>', '$', { noremap = true, silent = true })
vim.api.nvim_set_keymap('o', '<C-e>', '$', { noremap = true, silent = true })

vim.cmd [[
nnoremap <c-d>    <cmd>lua vim.diagnostic.open_float()<CR>
nnoremap <leader>d    <cmd>lua vim.diagnostic.open_float()<CR>
]]

-- float for diagnosticis and pmenu keep transparent background
-- vim.cmd('hi! link FloatBorder Normal')
-- vim.cmd 'hi! link NormalFloat Normal'
-- vim.cmd 'hi! WildMenu guifg=#226622'
-- vim.cmd 'hi! PMenu guifg=Normal guibg=NONE'

-- vim.cmd 'hi! IncSearch guibg=#a9b1d6 guifg=#444444 gui=NONE'
-- vim.cmd 'hi! Search guibg=#444444 guifg=#cccccc gui=NONE'
-- vim.cmd 'hi! Visual guibg=#444449 gui=none'

-- vim.cmd [[
-- function! SetLSPHighlights()
--     highlight LspDiagnosticsUnderlineError guifg=#aa4917 gui=none
--     highlight LspDiagnosticsUnderlineWarning guifg=#EBA217 gui=undercurl
--     highlight LspDiagnosticsUnderlineInformation guifg=#17D6EB, gui=undercurl
--     highlight LspDiagnosticsUnderlineHint guifg=#17EB7A gui=undercurl
-- endfunction
--
-- autocmd ColorScheme * call SetLSPHighlights()
-- ]]
