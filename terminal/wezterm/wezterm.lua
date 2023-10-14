local wezterm = require 'wezterm'
local io = require 'io'
local os = require 'os'
local act = wezterm.action
local config = {}

if wezterm.config_builder then
    config = wezterm.config_builder()
end

-- hide new tab button
config.show_new_tab_button_in_tab_bar = false
-- config.tab_bar_appearance = "Fancy"

--  hide close tab button
config.use_fancy_tab_bar = false

local SOLID_LEFT_ARROW = ' '
local SOLID_RIGHT_ARROW = ' '
wezterm.on(
    'format-tab-title',
    function(tab, tabs, panes, config, hover, max_width)
        local edge_background = '#2C323B'
        local background = '#242a33'
        local foreground = '#808080'

        if tab.is_active then
            background = '#242a33'
            foreground = '#5485c0'
        else
            background = '#333941'
            foreground = '#777777'
        end

        local edge_foreground = background

        -- ensure that the titles fit in the available space,
        -- and that we have room for the edges.
        local title = wezterm.truncate_right(tab.active_pane.title, max_width + 2)
        local zoomed = '  '
        local zz
        if tab.active_pane.is_zoomed then
            zoomed = ' ■'
        end

        return {
            { Attribute = { Italic = false } },
            { Attribute = { Underline = "None" } },
            -- { Attribute = { Underline = "Dotted" } },
            { Background = { Color = edge_background } },
            { Foreground = { Color = edge_foreground } },
            { Attribute = { Underline = "None" } },
            { Text = SOLID_LEFT_ARROW },
            { Foreground = { Color = edge_foreground } },
            { Background = { Color = edge_background } },
            { Text = '███' },
            { Attribute = { Underline = "None" } },
            { Background = { Color = background } },
            { Foreground = { Color = foreground } },
            { Attribute = { Underline = "None" } },
            { Text = title },
            { Text = zoomed },
            { Attribute = { Underline = "None" } },
            { Foreground = { Color = edge_foreground } },
            { Background = { Color = edge_background } },
            { Text = '█' },
            { Background = { Color = edge_background } },
            { Foreground = { Color = edge_foreground } },
            { Text = SOLID_RIGHT_ARROW },
        }
    end)


config.tab_max_width = 20

-- function tab_title(tab_info)
--     local title = tab_info.tab_title
--     -- if the tab title is explicitly set, take that
--     if title and #title > 0 then
--         return title
--     end
--     -- Otherwise, use the title from the active pane
--     -- in that tab
--     return tab_info.active_pane.title
-- end
--
-- wezterm.on(
--     'format-tab-title',
--     function(tab, tabs, panes, config, hover, max_width)
--         local title = tab_title(tab)
--         if tab.is_active then
--             return {
--                 { Background = { Color = 'blue' } },
--                 { Text = ' ' .. title .. ' ' },
--             }
--         end
--         return title
--     end
-- )

config.color_scheme = 'SpaceGray Eighties'
config.colors = {
    foreground = '#a9b1d6',
    background = '#2C323B',
    selection_fg = '#cccccc',
    selection_bg = '#4466aa',
    split = "#444444",
    -- split = "#4E96E2"

    tab_bar = {
        background = "#2C323B",
        active_tab = {
            bg_color = "#2C323B",
            fg_color = "#C8C093",
            -- underline = "Single",
        },
        inactive_tab = {
            bg_color = "#2C323B",
            fg_color = "#727169",
            italic = false,
        },
        -- inactive_tab_hover = {
        --     bg_color = "#2A2A37",
        --     fg_color = "#DCD7BA",
        -- },
        -- new_tab = {
        --     bg_color = "#ff0000",
        --     fg_color = "#727169",
        -- },
        -- new_tab_hover = {
        --     bg_color = "#2A2A37",
        --     fg_color = "#DCD7BA",
        -- },
    },
}


-- wezterm.on(
--     'format-tab-title',
--     function(tab, tabs, panes, config, hover, max_width)
--         local title = #tab.tab_title > 0 and tab.tab_title or tab.active_pane.title
--
--         return {
--             { Text = title },
--         }
--     end
-- )

-- wezterm.on(
--     'format-tab-title',
--     function(tab, tabs, panes, config, hover, max_width)
--         local zoomed = ''
--         if tab.active_pane.is_zoomed then
--             zoomed = ' [Z]'
--         end
--
--         if tab.is_active then
--             return {
--                 { Attribute = { Intensity = "Bold" } },
--                 { Text = ' ' .. tab.tab_index + 1 .. ' ' .. tab.active_pane.title .. zoomed .. ' ' },
--             }
--         end
--         return ' ' .. tab.tab_index + 1 .. ' ' .. tab.active_pane.title .. zoomed .. ' '
--     end
-- )

-- wezterm.on("format-tab-title", function(tab)
--     local tab_index = tab.tab_index + 1
--     local tab_title = tab.active_pane.title
--     local user_title = tab.active_pane.user_vars.panetitle
--
--     if user_title ~= nil and #user_title > 0 then
--         tab_title = user_title
--     end
--
--     return {
--         { Text = "    " .. tab_title .. "    " },
--         -- { Text = " " .. tab_index .. ": " .. tab_title .. "" },
--     }
-- end)

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
config.font_size = 13

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

-- animation_fps = 60,
--    max_fps = 60,
--    front_end = 'WebGpu',
--    webgpu_power_preference = 'HighPerformance',



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
    { key = 'q', mods = 'CMD', action = wezterm.action.QuitApplication },
}

config.disable_default_key_bindings = true

config.audible_bell = 'Disabled'


------------------- tab bar -----------------------------
-- config.tab_bar_style = {
--     window_hide = wezterm.format({
--         { Background = { Color = "#ff161D" } },
--         { Foreground = { Color = "#727169" } },
--         { Text = " _ " },
--     }),
--     window_hide_hover = wezterm.format({
--         { Background = { Color = "#2A2A37" } },
--         { Foreground = { Color = "#DCD7BA" } },
--         { Text = " _ " },
--     }),
--     window_maximize = wezterm.format({
--         { Background = { Color = "#16161D" } },
--         { Foreground = { Color = "#727169" } },
--         { Text = " [] " },
--     }),
--     window_maximize_hover = wezterm.format({
--         { Background = { Color = "#2A2A37" } },
--         { Foreground = { Color = "#DCD7BA" } },
--         { Text = " [] " },
--     }),
--     window_close = wezterm.format({
--         { Background = { Color = "#16161D" } },
--         { Foreground = { Color = "#727169" } },
--         { Text = " X " },
--     }),
--     window_close_hover = wezterm.format({
--         { Background = { Color = "#2A2A37" } },
--         { Foreground = { Color = "#DCD7BA" } },
--         { Text = " X " },
--     }),
-- }

-- config.window_frame = {
--     font = config.font,
--     font_size = config.font_size,
--     inactive_titlebar_bg = "#ff161D",
--     active_titlebar_bg = "#ff0000",
--     inactive_titlebar_fg = "#727169",
--     active_titlebar_fg = "#aaffaa",
--     inactive_titlebar_border_bottom = "#54546D",
--     active_titlebar_border_bottom = "#54546D",
--     button_fg = "#727169",
--     button_bg = "#16161D",
--     button_hover_fg = "#DCD7BA",
--     button_hover_bg = "#2A2A37",
--
--     border_left_width = "0.25cell",
--     border_right_width = "0.25cell",
--     border_bottom_height = "0.1cell",
--     border_top_height = "0.1cell",
--     border_left_color = "#16161D",
--     border_right_color = "#16161D",
--     border_bottom_color = "#1616ff",
--     border_top_color = "#16161D",
-- }
------------------- tab bar -----------------------------


return config
-- ----------------------------------------------------------------------------
--  may be useful
-- ----------------------------------------------------------------------------

-- config.window_decorations = "NONE | MACOS_FORCE_DISABLE_SHADOW | RESIZE"
