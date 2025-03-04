local wezterm = require("wezterm")
local io = require("io")
local os = require("os")
local act = wezterm.action
local config = {}

local function lighten_color(hex, percent)
  local function hex_to_rgb(hex)
    hex = hex:gsub("#", "")
    return tonumber("0x" .. hex:sub(1, 2)), tonumber("0x" .. hex:sub(3, 4)), tonumber("0x" .. hex:sub(5, 6))
  end

  local function rgb_to_hex(r, g, b)
    return string.format("#%02X%02X%02X", r, g, b)
  end

  local r, g, b = hex_to_rgb(hex)

  r = math.min(255, math.floor(r + (255 - r) * percent))
  g = math.min(255, math.floor(g + (255 - g) * percent))
  b = math.min(255, math.floor(b + (255 - b) * percent))

  return rgb_to_hex(r, g, b)
end

local mybackground = "#202235"
-- local tabbg2 = lighten_color("#292c4c", 0.10)

-- https://wezfurlong.org/wezterm/config/default-keys.html

if wezterm.config_builder then
  config = wezterm.config_builder()
end

config.show_new_tab_button_in_tab_bar = false
-- config.tab_bar_appearance = "Fancy"

--  hide close tab button
config.use_fancy_tab_bar = false

local SOLID_LEFT_ARROW = " ██"
local SOLID_RIGHT_ARROW = "██ "

function tab_title(tab_info)
  local title = tab_info.tab_title
  -- if the tab title is explicitly set, take that
  if title and #title > 0 then
    return title
  end
  -- Otherwise, use the title from the active pane
  -- in that tab
  return tab_info.active_pane.title
end

wezterm.on("format-tab-title", function(tab, tabs, panes, config, hover, max_width)
  local edge_background = mybackground
  local background = "#2a2a3a"
  local foreground = "#dfbf8e"

  if tab.is_active then
    -- background = "#7f849c"
    background = "#404275"
  end

  local edge_foreground = background

  local title = ""
  if tab.active_pane.is_zoomed then
    title = "■"
    if tab.is_active then
      foreground = "#FFA500"
      -- foreground = "#8addff"
    end
  else
    title = "▪"
  end

  return {
    { Background = { Color = edge_background } },
    { Foreground = { Color = edge_foreground } },
    { Text = " " .. SOLID_LEFT_ARROW },
    { Background = { Color = background } },
    { Foreground = { Color = foreground } },
    { Text = title },
    { Background = { Color = edge_background } },
    { Foreground = { Color = edge_foreground } },
    { Text = SOLID_RIGHT_ARROW },
  }
end)

config.tab_max_width = 20

-- config.color_scheme = "SpaceGray Eighties"
-- config.color_scheme = "Rosé Pine (Gogh)"
config.color_scheme = "Catppuccin Macchiato"
-- config.color_scheme = "Everforest Dark (Gogh)"
-- config.color_scheme = "nord"
-- config.color_scheme = "Tokyo Night"
config.colors = {
  -- foreground = "#a9b1d6",
  --background = "#303446", -- base cat frappe
  -- background = "#24273a", -- base cat macchiato
  --  background = "#2C323B",
  selection_fg = "#cccccc",
  selection_bg = "#4466aa",
  split = "#444444",
  -- split = "#5485c0",
  -- split = "#4E96E2"

  quick_select_label_bg = { Color = "#4466aa" },
  quick_select_label_fg = { Color = "#ffffff" },
  quick_select_match_bg = { Color = "#2C323B" },
  quick_select_match_fg = { Color = "#888888" },

  tab_bar = {
    background = mybackground,
    active_tab = {
      bg_color = "#2C323B",
      fg_color = "#C8C093",
    },
    inactive_tab = {
      bg_color = "#2C323B",
      fg_color = "#727169",
      italic = false,
    },
  },

  compose_cursor = "orange",
  -- show cursor only on focused pane,
  -- make border (which is shown in inactive pane), transparent
  cursor_border = "#2C323B",
}
-- not convinced it is a good idea
-- config.pane_focus_follows_mouse = true

config.inactive_pane_hsb = {
  -- saturation = 0.9, -- default
  -- brightness = 0.8, -- default
  saturation = 0.8,
  brightness = 0.6,
}

config.foreground_text_hsb = {
  hue = 1.0,
  saturation = 1.0,
  brightness = 0.9,
}

-- window_background_image_hsb = {
--   brightness = 0.01,
--   hue = 1.0,
--   saturation = 0.2,
-- }

-- config.foreground_text_hsb = {
--   hue = 1.0,
--   saturation = 0.8,
--   brightness = 0.9,
-- }
-- config.active_pane_hsb = {
--   -- saturation = 0.9, -- default
--   -- brightness = 0.8, -- default
--   saturation = 0.4,
--   brightness = 0.6,
-- }

config.window_padding = {
  left = "0.2cell",
  right = "0.2cell",
  top = "0.2cell",
  bottom = "0.2cell",
}

-- config.window_decorations = "NONE | RESIZE"
config.window_decorations = "NONE | MACOS_FORCE_DISABLE_SHADOW | RESIZE"
config.adjust_window_size_when_changing_font_size = false
config.font_size = 16
config.default_cursor_style = "SteadyBlock"

config.cursor_thickness = "3.0"
-- issue when pressing keys (sticky + delay)
config.use_ime = false

config.font = wezterm.font_with_fallback({
  -- { family = "Menlo", weight = 500 },
  { family = "SF Mono", weight = 600 },
  -- { family = "JetBrains Mono", weight = 700 },
  -- { family = "Fira Mono", weight = 600 },
  -- { family = "Monaco", weight = "Regular" }, --- best font ever
  -- { family = "Monaco", weight = 800 }, --- best font ever
  -- { family = "Monaco", weight = 800 }, --- best font ever
  { family = "Zapf Dingbats", weight = 700 }, --- arrow prompt
  { family = "Monaco Nerd Font", weight = 400 },
  { family = "Symbols Nerd Font Mono", weight = "Regular" },
  -- 'Noto Color Emoji',
})

-- make bold fonts less bold
config.font_rules = {
  {
    intensity = "Bold",
    italic = false,
    font = wezterm.font({
      family = "SF Mono",
      weight = 600,
    }),
  },
}

config.bold_brightens_ansi_colors = "No"
config.warn_about_missing_glyphs = true
config.line_height = 0.95
-- config.cell_width = 1.10
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

wezterm.on("multipaneclean", function(window, pane)
  current_tab = pane:tab()
  panes = current_tab:panes()
  for _, p in pairs(panes) do
    if p:get_title() == "zsh" then
      p:send_text("\f")
    end
  end
end)

wezterm.on("multipowerpaneclean", function(window, pane)
  current_tab = pane:tab()
  panes = current_tab:panes()
  for _, p in pairs(panes) do
    if p:get_title() == "zsh" then
      p:send_text("cd > /dev/null\n\f")
    end
  end
end)

local function is_vim(pane)
  -- local prog = pane:get_user_vars()["WEZTERM_PROG"]
  local prog = pane:get_title()
  local process = pane:get_foreground_process_name()
  -- print("is_vim process=" .. process)
  return prog:match("^nvim") or prog:match("^lima") or prog:match("^tmux") or prog:match("^ssh")
end

local function is_shell(pane)
  -- local prog = pane:get_user_vars()["WEZTERM_PROG"]
  local prog = pane:get_title()
  local process = pane:get_foreground_process_name()
  -- print("is_vim process=" .. process)
  return prog:match("^zsh")
end

-- local function is_vim(pane)
--     -- this is set by the plugin, and unset on ExitPre in Neovim
--     return pane:get_user_vars().IS_NVIM == 'true'
-- end

myscrollup = wezterm.action_callback(function(window, pane)
  -- if is_shell(pane) then
  -- window:perform_action(act.SendKey({ key = "u", mods = "CTRL" }), pane)
  -- window:perform_action(act.ScrollByPage(-1), pane)
  -- else
  window:perform_action({
    SendKey = { key = "PageUp" },
  }, pane)
  -- end
  -- else
  --    window:perform_action(act.ScrollByPage(-1), pane)
  --  end
end)

myscrolldown = wezterm.action_callback(function(window, pane)
  -- if is_shell(pane) then
  -- window:perform_action(act.ScrollByPage(1), pane)
  -- else
  window:perform_action({
    SendKey = { key = "PageDown" },
  }, pane)
  -- end
end)

mypaste = wezterm.action_callback(function(window, pane)
  -- if is_vim(pane) then
  --   window:perform_action(act.SendKey({ key = "Escape" }), pane)
  --   pane:perform_action(act.PasteFrom("Clipboard"), pane)
  --   pane:send_text(" p")
  -- else
  window:perform_action(act.PasteFrom("Clipboard"), pane)
  -- end
end)

mypasteindent = wezterm.action_callback(function(window, pane)
  if is_vim(pane) then
    window:perform_action(act.SendKey({ key = "Escape" }), pane)
    -- pane:perform_action(act.PasteFrom 'Clipboard', pane)
    pane:send_text(" P")
  else
    window:perform_action(act.PasteFrom("Clipboard"), pane)
  end
end)

mycopy = wezterm.action_callback(function(window, pane)
  if is_vim(pane) then
    -- window:perform_action(act.SendKey({ key = "Escape" }), pane)
    -- pane:perform_action(act.PasteFrom 'Clipboard', pane)
    pane:send_text(" y")
  else
    window:perform_action(act.CopyTo("Clipboard"), pane)
  end
end)

local function isViProcess(pane)
  return pane:get_title():find("n?vim") ~= nil
end

local function conditionalActivatePane(window, pane, pane_direction, vim_direction)
  if isViProcess(pane) then
    window:perform_action(
      -- This should match the keybinds set in Neovim
      act.SendKey({ key = vim_direction, mods = "ALT|CTRL" }),
      pane
    )
  else
    window:perform_action(act.ActivatePaneDirection(pane_direction), pane)
  end
end

wezterm.on("ActivatePaneDirection-right", function(window, pane)
  conditionalActivatePane(window, pane, "Right", "l")
end)
wezterm.on("ActivatePaneDirection-left", function(window, pane)
  conditionalActivatePane(window, pane, "Left", "h")
end)

wezterm.on("ActivatePaneDirection-up", function(window, pane)
  conditionalActivatePane(window, pane, "Up", "k")
end)

wezterm.on("ActivatePaneDirection-down", function(window, pane)
  conditionalActivatePane(window, pane, "Down", "j")
end)

--config.leader = { key = 'CTRL', mods = 'SHIFT' }
config.keys = {
  { key = "PageUp", action = myscrollup },
  { key = "PageDown", action = myscrolldown },
  -- { key = 'UpArrow',    mods = 'CTRL',                      action = act.ScrollByPage(-1) },
  -- { key = 'PageUp',     action = act.ScrollByPage(-1) },
  { key = "PageUp", mods = "SHIFT", action = act.ScrollByPage(-1) },
  -- { key = 'PageUp',     action = act.ScrollByPage(-1) },
  { key = "UpArrow", mods = "CTRL|SHIFT", action = act.ScrollByPage(-1) },
  { key = "PageDown", mods = "SHIFT", action = act.ScrollByPage(1) },
  { key = "DownArrow", mods = "CTRL|SHIFT", action = act.ScrollByPage(1) },
  --Menus
  -- { key = 'F1',         action = act.ActivateCommandPalette },
  -- { key = "F2", action = act.ShowLauncher },
  -- { key = "F3", action = act.PaneSelect },
  --    { key = 'F12',        action = wezterm.action.ShowDebugOverlay },
  --    { key = 'UpArrow',    mods = 'SHIFT',                     action = act.ScrollToPrompt(-1) },
  --    { key = 'DownArrow',  mods = 'SHIFT',                     action = act.ScrollToPrompt(1) },
  --Copy Paste operation
  { key = "v", mods = "CMD", action = mypaste },
  { key = "i", mods = "CMD", action = mypasteindent },
  { key = "c", mods = "CMD", action = mycopy },
  { key = "k", mods = "CMD", action = act.PasteFrom("Clipboard") },
  -- { key = 'v',          mods = 'CMD',                       action = act.PasteFrom 'Clipboard' },
  --    { key = 'v',          mods = 'CTRL',                      action = act.PasteFrom 'PrimarySelection' },
  --Pane navigation
  -- { key = "LeftArrow", mods = "CMD", action = act.ActivatePaneDirection("Left") },
  -- { key = "j", mods = "CMD", action = act.ActivatePaneDirection("Left") },
  -- { key = "RightArrow", mods = "CMD", action = act.ActivatePaneDirection("Right") },
  -- { key = "l", mods = "CMD", action = act.ActivatePaneDirection("Right") },
  -- { key = "UpArrow", mods = "CMD", action = act.ActivatePaneDirection("Up") },
  -- { key = "i", mods = "CMD", action = act.ActivatePaneDirection("Up") },
  -- { key = "DownArrow", mods = "CMD", action = act.ActivatePaneDirection("Down") },
  -- { key = "k", mods = "CMD", action = act.ActivatePaneDirection("Down") },

  { key = "RightArrow", mods = "CMD", action = act.EmitEvent("ActivatePaneDirection-right") },
  { key = "l", mods = "CMD", action = act.EmitEvent("ActivatePaneDirection-right") },
  { key = "LeftArrow", mods = "CMD", action = act.EmitEvent("ActivatePaneDirection-left") },
  { key = "j", mods = "CMD", action = act.EmitEvent("ActivatePaneDirection-left") },
  { key = "UpArrow", mods = "CMD", action = act.EmitEvent("ActivatePaneDirection-up") },
  { key = "i", mods = "CMD", action = act.EmitEvent("ActivatePaneDirection-up") },
  { key = "DownArrow", mods = "CMD", action = act.EmitEvent("ActivatePaneDirection-down") },
  { key = "k", mods = "CMD", action = act.EmitEvent("ActivatePaneDirection-down") },
  --Pane spliting
  {
    key = "d",
    mods = "CMD",
    action = wezterm.action.SplitHorizontal({ domain = "CurrentPaneDomain" }),
  },
  {
    key = "d",
    mods = "CMD|SHIFT",
    action = wezterm.action.SplitVertical({ domain = "CurrentPaneDomain" }),
  },
  { key = "w", mods = "CMD", action = wezterm.action.CloseCurrentPane({ confirm = false }) },
  --Pane resize
  { key = "LeftArrow", mods = "CMD|ALT", action = act.AdjustPaneSize({ "Left", 3 }) },
  { key = "j", mods = "CMD|ALT", action = act.AdjustPaneSize({ "Left", 3 }) },
  { key = "RightArrow", mods = "CMD|ALT", action = act.AdjustPaneSize({ "Right", 3 }) },
  { key = "l", mods = "CMD|ALT", action = act.AdjustPaneSize({ "Right", 3 }) },
  { key = "UpArrow", mods = "CMD|ALT", action = act.AdjustPaneSize({ "Up", 3 }) },
  { key = "i", mods = "CMD|ALT", action = act.AdjustPaneSize({ "Up", 3 }) },
  { key = "DownArrow", mods = "CMD|ALT", action = act.AdjustPaneSize({ "Down", 3 }) },
  { key = "k", mods = "CMD|ALT", action = act.AdjustPaneSize({ "Down", 3 }) },
  -- Pane zoom
  { key = "z", mods = "CMD", action = wezterm.action.TogglePaneZoomState },
  --Tab navigation
  { key = "LeftArrow", mods = "CMD|SHIFT", action = act.ActivateTabRelative(-1) },
  { key = "j", mods = "CMD|SHIFT", action = act.ActivateTabRelative(-1) },
  { key = "RightArrow", mods = "CMD|SHIFT", action = act.ActivateTabRelative(1) },
  { key = "l", mods = "CMD|SHIFT", action = act.ActivateTabRelative(1) },
  --    { key = '\\',         mods = 'ALT',       action = act.ShowTabNavigator },
  --Tab spawning
  { key = "t", mods = "CMD", action = act.SpawnTab("DefaultDomain") },
  { key = "=", mods = "CMD", action = wezterm.action.IncreaseFontSize },
  { key = "-", mods = "CMD", action = wezterm.action.DecreaseFontSize },
  -- toggle comment
  { key = "/", mods = "CMD", action = act.SendString("++") },
  { key = "p", mods = "CMD", action = act.SendString("+p") },
  -- zsh autocomplete
  -- { key = "Enter", mods = "CMD|SHIFT", action = act.SendString("\x1bxxy") },
  { key = "Enter", mods = "CMD", action = act.SendString("\x1bxxx") },
  { key = "LeftArrow", mods = "ALT", action = act.SendString("\x1b[1;5D") },
  { key = "j", mods = "ALT", action = act.SendString("\x1b[1;5D") },
  { key = "n", mods = "ALT|CMD|SHIFT|CTRL", action = act.SendString("\x1b[1;5D") },
  -- { key = "j", mods = "ALT", action = act.SendString("\x1b[1;5D") },
  { key = "RightArrow", mods = "ALT", action = act.SendString("\x1b[1;5C") },
  { key = "l", mods = "ALT", action = act.SendString("\x1b[1;5C") },
  { key = "m", mods = "ALT|CMD|SHIFT|CTRL", action = act.SendString("\x1b[1;5C") },
  -- { key = "l", mods = "ALT", action = act.SendString("\x1b[1;5C") },
  {
    key = "l",
    mods = "CTRL|SHIFT|ALT",
    action = act.EmitEvent("multipaneclean"),
  },
  {
    key = "p",
    mods = "CTRL|SHIFT",
    action = act.EmitEvent("multipowerpaneclean"),
  },
  { key = "q", mods = "CMD", action = wezterm.action.QuitApplication },
  {
    key = "s",
    mods = "CMD",
    action = act.PaneSelect({
      mode = "SwapWithActive",
    }),
  },
  {
    key = "o",
    mods = "CMD",
    action = wezterm.action.QuickSelectArgs({
      label = "open url",
      patterns = { "https?://\\S+" },
      action = wezterm.action_callback(function(window, pane)
        local url = window:get_selection_text_for_pane(pane)
        --- remove trailing '>' character, especially for urls in markdown
        url = url:gsub(">", "")
        wezterm.open_with(url)
      end),
    }),
  },
  { key = "x", mods = "CMD", action = wezterm.action.ActivateCopyMode },
  ---- tmux ---------------------------------------
  {
    key = "UpArrow",
    mods = "LEADER",
    action = act.Multiple({
      act.SendKey({ key = "f", mods = "CTRL" }),
      act.SendKey({ key = "UpArrow" }),
    }),
  },
  {
    key = "i",
    mods = "LEADER",
    action = act.Multiple({
      act.SendKey({ key = "f", mods = "CTRL" }),
      act.SendKey({ key = "UpArrow" }),
    }),
  },
  {
    key = "DownArrow",
    mods = "LEADER",
    action = act.Multiple({
      act.SendKey({ key = "f", mods = "CTRL" }),
      act.SendKey({ key = "DownArrow" }),
    }),
  },
  {
    key = "k",
    mods = "LEADER",
    action = act.Multiple({
      act.SendKey({ key = "f", mods = "CTRL" }),
      act.SendKey({ key = "DownArrow" }),
    }),
  },
  {
    key = "LeftArrow",
    mods = "LEADER",
    action = act.Multiple({
      act.SendKey({ key = "f", mods = "CTRL" }),
      act.SendKey({ key = "LeftArrow" }),
    }),
  },
  {
    key = "j",
    mods = "LEADER",
    action = act.Multiple({
      act.SendKey({ key = "f", mods = "CTRL" }),
      act.SendKey({ key = "LeftArrow" }),
    }),
  },

  {
    key = "RightArrow",
    mods = "LEADER",
    action = act.Multiple({
      act.SendKey({ key = "f", mods = "CTRL" }),
      act.SendKey({ key = "RightArrow" }),
    }),
  },
  {
    key = "l",
    mods = "LEADER",
    action = act.Multiple({
      act.SendKey({ key = "f", mods = "CTRL" }),
      act.SendKey({ key = "RightArrow" }),
    }),
  },

  {
    key = "z",
    mods = "LEADER",
    action = act.Multiple({
      act.SendKey({ key = "f", mods = "CTRL" }),
      act.SendKey({ key = "z" }),
    }),
  },
  {
    key = "d",
    mods = "LEADER",
    action = act.Multiple({
      act.SendKey({ key = "v", mods = "CTRL|ALT" }),
    }),
  },
  {
    key = "D",
    mods = "LEADER",
    action = act.Multiple({
      act.SendKey({ key = "h", mods = "CTRL|ALT" }),
    }),
  },
  {
    key = "a",
    mods = "LEADER|CMD",
    action = act.Multiple({
      act.SendKey({ key = "w", mods = "CTRL|ALT" }),
    }),
  },
  --- tmux resize pane (use mouse to resize)
  -- {
  --     key = "UpArrow",
  --     mods = "LEADER|ALT",
  --     action = act.Multiple({
  --         act.SendKey({ key = "f", mods = "CTRL" }),
  --         act.SendKey({ key = "UpArrow", mods = "ALT" })
  --     })
  -- },
  -- {
  --     key = "DownArrow",
  --     mods = "LEADER|ALT",
  --     action = act.Multiple({
  --         act.SendKey({ key = "f", mods = "CTRL" }),
  --         act.SendKey({ key = "DownArrow", mods = "ALT" })
  --     })
  -- },
  -- {
  --     key = "LeftArrow",
  --     mods = "LEADER|ALT",
  --     action = act.Multiple({
  --         act.SendKey({ key = "f", mods = "CTRL" }),
  --         act.SendKey({ key = "LeftArrow", mods = "ALT" })
  --     })
  -- },
  -- {
  --     key = "RightArrow",
  --     mods = "LEADER|ALT",
  --     action = act.Multiple({
  --         act.SendKey({ key = "f", mods = "CTRL" }),
  --         act.SendKey({ key = "RightArrow", mods = "ALT" })
  --     })
  -- },
  {
    key = "t",
    mods = "LEADER",
    action = act.Multiple({
      act.SendKey({ key = "n", mods = "CTRL|ALT" }),
    }),
  },
  {
    key = "LeftArrow",
    mods = "LEADER|SHIFT|CMD",
    action = act.Multiple({
      act.SendKey({ key = "LeftArrow", mods = "CTRL|ALT|SHIFT" }),
    }),
  },
  {
    key = "RightArrow",
    mods = "LEADER|SHIFT|CMD",
    action = act.Multiple({
      act.SendKey({ key = "RightArrow", mods = "CTRL|ALT|SHIFT" }),
    }),
  },
  {
    key = "m",
    mods = "LEADER",
    action = act.Multiple({
      act.SendKey({ key = "f", mods = "CTRL" }),
      act.SendKey({ key = "m", mods = "CTRL" }),
    }),
  },

  -- { key = "w", mods = "CTRL|SHIFT|CMD|ALT", action = act.SendKey({ key = "w", mods = "CTRL" }) },
  --------------------------------------------------
}

config.leader = { key = "a", mods = "CMD", timeout_milliseconds = 1000 }

config.disable_default_key_bindings = true

config.audible_bell = "Disabled"

config.key_tables = {
  copy_mode = {
    -- { key = "UpArrow",   mods = "CTRL",  action = wezterm.action { CopyMode = "PageUp" } },
    -- { key = "DownArrow", mods = "CTRL",  action = wezterm.action { CopyMode = "PageDown" } },
    { key = "Escape", mods = "NONE", action = wezterm.action({ CopyMode = "Close" }) },
    -- Enter search mode to edit the pattern.
    { key = "/", mods = "NONE", action = wezterm.action({ Search = { CaseInSensitiveString = "" } }) },
    -- navigate any search mode results
    { key = "n", mods = "NONE", action = wezterm.action({ CopyMode = "NextMatch" }) },
    { key = "N", mods = "SHIFT", action = wezterm.action({ CopyMode = "PriorMatch" }) },
    { key = "q", mods = "NONE", action = wezterm.action({ CopyMode = "Close" }) },
    { key = "Escape", mods = "NONE", action = wezterm.action({ CopyMode = "Close" }) },
  },
  search_mode = {
    { key = "Escape", mods = "NONE", action = wezterm.action({ CopyMode = "Close" }) },
    { key = "Enter", mods = "NONE", action = "ActivateCopyMode" },
    -- Go back to copy mode when pressing enter, so that we can use unmodified keys like "n"
    -- to navigate search results without conflicting with typing into the search area.
    -- { key = "Enter",  mods = "NONE", action = "ActivateCopyMode" },
  },
}

wezterm.on("update-right-status", function(window, pane)
  local leader = ""
  if window:leader_is_active() then
    leader = "LEADER"
  end
  window:set_right_status(leader)

  window:set_right_status(wezterm.format({
    { Attribute = { Underline = "None" } },
    { Attribute = { Italic = true } },
    { Foreground = { Color = "#ffffff" } },
    { Background = { Color = "#4466aa" } },
    { Text = leader },
  }))
end)

config.max_fps = 120
-- config.front_end = "WebGpu"
-- config.front_end = "OpenGL"
-- config.webgpu_power_preference = "HighPerformance"

config.scrollback_lines = 10000

return config
-- ----------------------------------------------------------------------------
--  may be useful ... work in progress
-- ----------------------------------------------------------------------------

-- config.window_decorations = "NONE | MACOS_FORCE_DISABLE_SHADOW | RESIZE"
--
-- https://wezfurlong.org/wezterm/config/lua/wezterm/nerdfonts.html
-- test font: wezterm ls-fonts --text "❯    "
--            fc-list ':charset=f659'
--            fc-list ':charset=f529'
-- config.font = wezterm.font("Monaco", { weight = 900 })

-- https://en.wikipedia.org/wiki/Zapf_Dingbats

-- fc-list | grep "<fontname>"

-- config.max_fps = 144
-- config.animation_fps = 144
-- config.front_end = "WebGpu"
-- config.front_end = "OpenGL"
-- config.webgpu_power_preference = "HighPerformance"
--
-- config.animation_fps = 144
-- config.max_fps = 144
-- config.front_end = 'WebGpu'
-- config.front_end = 'OpenGL'
-- config.webgpu_power_preference = 'HighPerformance'

-- config.enable_kitty_keyboard = false
-- config.scrollback_lines = 9999
-- config.hide_tab_bar_if_only_one_tab = true
-- config.tab_bar_at_bottom = true
--
