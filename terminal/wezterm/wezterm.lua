local wezterm = require("wezterm")
local io = require("io")
local os = require("os")
local act = wezterm.action
local config = {}

-- https://wezfurlong.org/wezterm/config/default-keys.html

if wezterm.config_builder then
  config = wezterm.config_builder()
end

config.show_new_tab_button_in_tab_bar = false
-- config.tab_bar_appearance = "Fancy"

--  hide close tab button
config.use_fancy_tab_bar = false

local SOLID_LEFT_ARROW = " "
local SOLID_RIGHT_ARROW = " "
wezterm.on("format-tab-title", function(tab, tabs, panes, config, hover, max_width)
  local edge_background = "#2C323B"
  local background = "#242a33"
  local foreground = "#808080"

  if tab.is_active then
    background = "#242a33"
    foreground = "#5485c0"
  else
    background = "#333941"
    foreground = "#777777"
  end

  local edge_foreground = background

  -- ensure that the titles fit in the available space,
  -- and that we have room for the edges.
  local title = wezterm.truncate_right(tab.active_pane.title, max_width + 2)
  local zoomed = "  "
  local zz
  if tab.active_pane.is_zoomed then
    zoomed = " ■"
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
    -- { Text = "█" },
    { Attribute = { Underline = "None" } },
    { Background = { Color = background } },
    { Foreground = { Color = foreground } },
    { Attribute = { Underline = "None" } },
    { Text = zoomed },
    { Text = " " },
    { Text = title },
    { Attribute = { Underline = "None" } },
    { Foreground = { Color = edge_foreground } },
    { Background = { Color = edge_background } },
    { Text = "███" },
    { Background = { Color = edge_background } },
    { Foreground = { Color = edge_foreground } },
    { Text = SOLID_RIGHT_ARROW },
  }
end)

config.tab_max_width = 20

config.color_scheme = "SpaceGray Eighties"
config.colors = {
  foreground = "#a9b1d6",
  background = "#2C323B",
  selection_fg = "#cccccc",
  selection_bg = "#4466aa",
  split = "#444444",
  -- split = "#4E96E2"

  quick_select_label_bg = { Color = "#4466aa" },
  quick_select_label_fg = { Color = "#ffffff" },
  quick_select_match_bg = { Color = "#2C323B" },
  quick_select_match_fg = { Color = "#888888" },

  tab_bar = {
    background = "#2C323B",
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

config.inactive_pane_hsb = {
  -- saturation = 0.9, -- default
  -- brightness = 0.8, -- default
  saturation = 0.7,
  brightness = 0.6,
}

config.window_padding = {
  left = "0.2cell",
  right = "0.2cell",
  top = "0.2cell",
  bottom = "0.2cell",
}

config.window_decorations = "NONE | RESIZE"
-- config.window_decorations = "NONE | MACOS_FORCE_DISABLE_SHADOW | RESIZE"
config.adjust_window_size_when_changing_font_size = false
config.bold_brightens_ansi_colors = "No"
config.line_height = 0.90
config.font_size = 16
config.default_cursor_style = "SteadyBlock"

config.cursor_thickness = "3.0"
-- issue when pressing keys (sticky + delay)
config.use_ime = false

config.font = wezterm.font_with_fallback({
  -- { family = 'Menlo',                  weight = 'Bold' },
  -- { family = 'Fira Code',              weight = 400 },
  { family = "Monaco", weight = "Bold" }, --- best font ever
  { family = "Zapf Dingbats", weight = "Bold" }, --- arrow prompt
  { family = "Monaco Nerd Font", weight = "Bold" },
  { family = "Symbols Nerd Font Mono", weight = "Regular" },
  -- 'Noto Color Emoji',
})

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
  -- get_foreground_process_name On Linux, macOS and Windows,
  -- the process can be queried to determine this path. Other operating systems
  -- (notably, FreeBSD and other unix systems) are not currently supported
  return pane:get_foreground_process_name():find("n?vim") ~= nil
  -- return pane:get_title():find("n?vim") ~= nil
end

local function conditionalActivatePane(window, pane, pane_direction, vim_direction)
  if isViProcess(pane) then
    window:perform_action(
      -- This should match the keybinds set in Neovim
      act.SendKey({ key = vim_direction, mods = "ALT" }),
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
  { key = "LeftArrow", mods = "CMD", action = act.EmitEvent("ActivatePaneDirection-left") },
  { key = "RightArrow", mods = "CMD", action = act.EmitEvent("ActivatePaneDirection-right") },
  { key = "UpArrow", mods = "CMD", action = act.EmitEvent("ActivatePaneDirection-up") },
  { key = "DownArrow", mods = "CMD", action = act.EmitEvent("ActivatePaneDirection-down") },
  -- { key = "LeftArrow", mods = "CMD", action = act.ActivatePaneDirection("Left") },
  -- { key = "RightArrow", mods = "CMD", action = act.ActivatePaneDirection("Right") },
  -- { key = "UpArrow", mods = "CMD", action = act.ActivatePaneDirection("Up") },
  -- { key = "DownArrow", mods = "CMD", action = act.ActivatePaneDirection("Down") },
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
  { key = "LeftArrow", mods = "CMD|ALT", action = act.AdjustPaneSize({ "Left", 1 }) },
  { key = "RightArrow", mods = "CMD|ALT", action = act.AdjustPaneSize({ "Right", 1 }) },
  { key = "UpArrow", mods = "CMD|ALT", action = act.AdjustPaneSize({ "Up", 1 }) },
  { key = "DownArrow", mods = "CMD|ALT", action = act.AdjustPaneSize({ "Down", 1 }) },
  -- Pane zoom
  { key = "z", mods = "CMD", action = wezterm.action.TogglePaneZoomState },
  --Tab navigation
  { key = "LeftArrow", mods = "CMD|SHIFT", action = act.ActivateTabRelative(-1) },
  { key = "RightArrow", mods = "CMD|SHIFT", action = act.ActivateTabRelative(1) },
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
  { key = "RightArrow", mods = "ALT", action = act.SendString("\x1b[1;5C") },
  {
    key = "l",
    mods = "CTRL|SHIFT",
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
    key = "l",
    mods = "CMD",
    action = wezterm.action.QuickSelectArgs({
      label = "open url",
      patterns = { "https?://\\S+" },
      action = wezterm.action_callback(function(window, pane)
        local url = window:get_selection_text_for_pane(pane)
        wezterm.open_with(url)
      end),
    }),
  },
  { key = "x", mods = "CMD", action = wezterm.action.ActivateCopyMode },
  ---- tmux ---------------------------------------
  {
    key = "UpArrow",
    mods = "LEADER|CMD",
    action = act.Multiple({
      act.SendKey({ key = "f", mods = "CTRL" }),
      act.SendKey({ key = "UpArrow" }),
    }),
  },
  {
    key = "DownArrow",
    mods = "LEADER|CMD",
    action = act.Multiple({
      act.SendKey({ key = "f", mods = "CTRL" }),
      act.SendKey({ key = "DownArrow" }),
    }),
  },
  {
    key = "LeftArrow",
    mods = "LEADER|CMD",
    action = act.Multiple({
      act.SendKey({ key = "f", mods = "CTRL" }),
      act.SendKey({ key = "LeftArrow" }),
    }),
  },
  {
    key = "RightArrow",
    mods = "LEADER|CMD",
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

config.max_fps = 240
config.front_end = "WebGpu"
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
