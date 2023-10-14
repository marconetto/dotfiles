local wezterm = require 'wezterm'
local io = require 'io'
local os = require 'os'
local act = wezterm.action
local config = {}

if wezterm.config_builder then
    config = wezterm.config_builder()
end

config.color_scheme = 'SpaceGray Eighties'
config.colors = {
    foreground = '#a9b1d6',
    background = '#2C323B',
    selection_fg = '#cccccc',
    selection_bg = '#4466aa',
    split = "#555555",
    -- split = "#4E96E2"
}

config.window_padding = {
    left = '0.2cell',
    right = '0.2cell',
    top = '0.2cell',
    bottom = '0.2cell',
}

config.window_decorations = "NONE | RESIZE"
config.adjust_window_size_when_changing_font_size = false
config.bold_brightens_ansi_colors = "No"
config.line_height = 1.00
config.font_size = 12

-- https://wezfurlong.org/wezterm/config/lua/wezterm/nerdfonts.html
-- test font: wezterm ls-fonts --text "❯    "
--            fc-list ':charset=f659'
--            fc-list ':charset=f529'
-- config.font = wezterm.font("Monaco", { weight = 900 })

-- https://en.wikipedia.org/wiki/Zapf_Dingbats

-- fc-list | grep "<fontname>"

config.max_fps = 144
config.animation_fps = 144
config.front_end = "WebGpu"
config.webgpu_power_preference = "HighPerformance"
-- config.enable_kitty_keyboard = false
-- config.scrollback_lines = 9999
-- config.hide_tab_bar_if_only_one_tab = true
-- config.tab_bar_at_bottom = true
--

-- show cursor only on focused pane
config.cursor_thickness = "-1.0"

config.font = wezterm.font_with_fallback {
    -- { family = 'Menlo',                  weight = 'Bold' },
    -- { family = 'Fira Code',              weight = 400 },
    { family = 'Monaco',                 weight = 'Bold' }, --- best font ever
    { family = 'Monaco',                 weight = 'Bold' }, --- best font ever
    { family = 'Zapf Dingbats',          weight = 'Bold' }, --- arrow prompt
    { family = 'Monaco Nerd Font',       weight = 'Bold' },
    { family = 'Symbols Nerd Font Mono', weight = 'Regular' },
    -- 'Noto Color Emoji',
}

config.warn_about_missing_glyphs = true
config.cell_width = 1.10
-- config.command_palette_font_size = 16.0
-- config.command_palette_font_size = 24.0 or 16.0
config.anti_alias_custom_block_glyphs = true
-- config.freetype_load_flags = "FORCE_AUTOHINT" --- bad
config.freetype_load_flags = "NO_HINTING" -- good
-- config.command_palette_font_size = hidpi and 24.0 or 16.0
config.command_palette_font_size = 24.0 or 16.0

config.force_reverse_video_cursor = true

-- config.animation_fps = 250
-- config.front_end = "Software"
--

-- config.animation_fps = 1
-- config.cursor_blink_ease_in = 'Constant'
-- config.cursor_blink_ease_out = 'Constant'



wezterm.on('multipaneclean', function(window, pane)
    current_tab = pane:tab()
    panes = current_tab:panes()
    for _, p in pairs(panes) do
        if p:get_title() == "zsh" then
            p:send_text("\f")
        end
    end
end)

wezterm.on('multipowerpaneclean', function(window, pane)
    current_tab = pane:tab()
    panes = current_tab:panes()
    for _, p in pairs(panes) do
        if p:get_title() == "zsh" then
            p:send_text("cd > /dev/null\n\f")
        end
    end
end)

--config.leader = { key = 'CTRL', mods = 'SHIFT' }
config.keys = {
    --Menus
    { key = 'F1',         action = act.ActivateCommandPalette },
    { key = 'F2',         action = act.ShowLauncher },
    { key = 'F3',         action = act.PaneSelect },
    --    { key = 'F12',        action = wezterm.action.ShowDebugOverlay },
    --    { key = 'UpArrow',    mods = 'SHIFT',                     action = act.ScrollToPrompt(-1) },
    --    { key = 'DownArrow',  mods = 'SHIFT',                     action = act.ScrollToPrompt(1) },
    --Copy Paste operation
    { key = 'v',          mods = 'CMD',                       action = act.PasteFrom 'Clipboard' },
    --    { key = 'v',          mods = 'CTRL',                      action = act.PasteFrom 'PrimarySelection' },
    --Pane navigation
    { key = 'LeftArrow',  mods = 'CMD',                       action = act.ActivatePaneDirection 'Left', },
    { key = 'RightArrow', mods = 'CMD',                       action = act.ActivatePaneDirection 'Right', },
    { key = 'UpArrow',    mods = 'CMD',                       action = act.ActivatePaneDirection 'Up', },
    { key = 'DownArrow',  mods = 'CMD',                       action = act.ActivatePaneDirection 'Down', },
    --Pane spliting
    {
        key = 'd',
        mods = 'CMD',
        action = wezterm.action.SplitHorizontal { domain =
        'CurrentPaneDomain' },
    },
    {
        key = 'd',
        mods = 'CMD|SHIFT',
        action = wezterm.action.SplitVertical { domain =
        'CurrentPaneDomain' },
    },
    { key = "w",          mods = "CMD",       action = wezterm.action.CloseCurrentPane { confirm = false } },
    --Pane resize
    { key = 'LeftArrow',  mods = 'CMD|ALT',   action = act.AdjustPaneSize { 'Left', 1 }, },
    { key = 'RightArrow', mods = 'CMD|ALT',   action = act.AdjustPaneSize { 'Right', 1 }, },
    { key = 'UpArrow',    mods = 'CMD|ALT',   action = act.AdjustPaneSize { 'Up', 1 } },
    { key = 'DownArrow',  mods = 'CMD|ALT',   action = act.AdjustPaneSize { 'Down', 1 }, },
    -- Pane zoom
    { key = 'z',          mods = 'CMD',       action = wezterm.action.TogglePaneZoomState, },
    --Tab navigation
    { key = 'LeftArrow',  mods = 'CMD|SHIFT', action = act.ActivateTabRelative(-1) },
    { key = 'RightArrow', mods = 'CMD|SHIFT', action = act.ActivateTabRelative(1) },
    --    { key = '\\',         mods = 'ALT',       action = act.ShowTabNavigator },
    --Tab spawning
    { key = 't',          mods = 'CMD',       action = act.SpawnTab 'DefaultDomain' },
    { key = '=',          mods = 'CMD',       action = wezterm.action.IncreaseFontSize },
    { key = '-',          mods = 'CMD',       action = wezterm.action.DecreaseFontSize },
    -- toggle comment
    { key = '/',          mods = 'CMD',       action = act.SendString '++' },
    -- zsh autocomplete
    { key = 'Enter',      mods = 'CMD|SHIFT', action = act.SendString '\x1bxxy' },
    { key = 'Enter',      mods = 'CMD',       action = act.SendString '\x1bxxx' },
    { key = 'LeftArrow',  mods = 'ALT',       action = act.SendString '\x1b[1;5D' },
    { key = 'RightArrow', mods = 'ALT',       action = act.SendString '\x1b[1;5C' },
    {
        key = 'l',
        mods = 'CTRL|SHIFT',
        action = act.EmitEvent 'multipaneclean',
    },
    {
        key = 'p',
        mods = 'CTRL|SHIFT',
        action = act.EmitEvent 'multipowerpaneclean',
    },
}

config.disable_default_key_bindings = true

config.audible_bell = 'Disabled'

return config
-- ----------------------------------------------------------------------------
--  may be useful
-- ----------------------------------------------------------------------------

-- config.window_decorations = "NONE | MACOS_FORCE_DISABLE_SHADOW | RESIZE"
