if not hs.ipc.cliStatus() then
  hs.ipc.cliInstall()
end
hs.ipc.cliInstall()

-------------------------------------------------------------------------------
hs.alert.defaultStyle.radius = 5
hs.alert.defaultStyle.strokeWidth = 1.0
hs.alert.defaultStyle.strokeColor = { red = 1.0, green = 0.5, blue = 0.2, alpha = 0.99 }
hs.alert.defaultStyle.fadeOutDuration = 0.70
hs.alert.defaultStyle.atScreenEdge = 0
hs.alert.defaultStyle.textSize = 12
hs.alert.defaultStyle.textFont = "Monaco"

local hyperkeys = { "ctrl", "alt", "cmd", "shift" }
local threekeys = { "ctrl", "alt", "cmd" }

-------------------------------------------------------------------------------

-------------------------------------------------------------------------------
hs.alert.show("Config hammerspoon", 3)

function reloadConfig(files)
  local doReload = false
  for _, file in pairs(files) do
    if file:sub(-4) == ".lua" then
      doReload = true
    end
  end
  if doReload then
    print("Config reloaded")
    configFileWatcher = nil
    hs.reload()
  end
end
configFileWatcher = hs.pathwatcher.new(os.getenv("HOME") .. "/.hammerspoon/", reloadConfig)
configFileWatcher:start()
-------------------------------------------------------------------------------

-------------------------------------------------------------------------------
function show_alert(message, duration)
  print("show_alert")
  hs.alert.closeAll(0.0)
  hs.alert.show(message, {}, duration)
end
-------------------------------------------------------------------------------

-------------------------------------------------------------------------------
-- color and background functions
-------------------------------------------------------------------------------
function cycleColour()
  return function()
    funcCycleColour()
  end
end

function GetFiles(mask)
  local files = {}
  local tmpfile = "/tmp/stmp.txt"
  os.execute("ls -1 " .. mask .. " > " .. tmpfile)
  local f = io.open(tmpfile)
  if not f then
    return files
  end
  local k = 1
  for line in f:lines() do
    files[k] = line
    k = k + 1
  end
  f:close()
  return files
end

-- strings cannot have dash in their names
function funcCycleColour()
  local screen = hs.screen.mainScreen()
  current_image = screen:desktopImageURL()
  print("call cycle colour")

  backdir = (os.getenv("HOME")) .. "/sys/simplebackgrounds/"
  print("Background Dir = " .. backdir)
  files = GetFiles(backdir)
  maxfiles = 0
  for key, val in pairs(files) do
    maxfiles = maxfiles + 1
    print(key, val)
  end

  index = 0
  newbackground = nil
  for i = 1, maxfiles do
    if string.match(current_image, files[i]) then
      index = i
      break
    end
  end

  print(index)
  print(maxfiles)
  if index == 0 or index == maxfiles then
    print(index)
    print(maxfiles)
    newbackground = files[1]
  else
    newbackground = files[index + 1]
  end

  print("New Background File = " .. newbackground)
  msg = "bg: " .. newbackground .. "(" .. index .. "/" .. maxfiles .. ")"
  show_alert(msg, 3)

  command = 'tell application "System Events" to tell every desktop to set picture to "'
    .. backdir
    .. newbackground
    .. '"'
  -- command = "tell application \"Finder\" to set desktop picture to POSIX file \"" ..backdir..newbackground.."\""
  print(command)
  hs.osascript.applescript(command)
end

hs.hotkey.bind(threekeys, "0", cycleColour())
-------------------------------------------------------------------------------
-------------------------------------------------------------------------------
-------------------------------------------------------------------------------

-------------------------------------------------------------------------------
-- Outlook see calendar and email
-------------------------------------------------------------------------------
function seeCalendar()
  print("----")
  local app = hs.application.find("Microsoft Outlook")
  app:selectMenuItem({ "View", "Go To", "Calendar" })
end

hs.hotkey.bind({ "ctrl" }, "2", seeCalendar)

function seeMail()
  local app = hs.application.find("Microsoft Outlook")
  app:selectMenuItem({ "View", "Go To", "Mail" })
end

hs.hotkey.bind({ "ctrl" }, "1", seeMail)
-------------------------------------------------------------------------------
-------------------------------------------------------------------------------
-------------------------------------------------------------------------------

-------------------------------------------------------------------------------
-- change keyboard layout
-------------------------------------------------------------------------------
function cycleKeyboardLayout()
  return function()
    eng_layout = "ABC"
    br_layout = "U.S. International – PC"
    current_layout = hs.keycodes.currentLayout()
    -- print(current_layout)
    if current_layout == eng_layout then
      hs.keycodes.setLayout(br_layout)
      msg = "----- BR -----"
    else
      hs.keycodes.setLayout(eng_layout)
      msg = "----- ENG -----"
    end
    show_alert(msg, 2)
  end
end

hs.hotkey.bind({ "ctrl", "cmd" }, "space", cycleKeyboardLayout())
-------------------------------------------------------------------------------
-------------------------------------------------------------------------------
-------------------------------------------------------------------------------

-------------------------------------------------------------------------------
-- make menubar accessible only when using command key + mouse
-------------------------------------------------------------------------------
menubar_allowed = false

-- ev2 = hs.eventtap
--   .new({ hs.eventtap.event.types.leftMouseDown, hs.eventtap.event.types.flagsChanged }, function(e)
--     mods = e:getFlags()
--     if e:getType() == hs.eventtap.event.types.leftMouseDown then
--       print("first")
--     end
--     print(button)
--
--     print(mods)
--     if mods["cmd"] then
--       print("hey")
--     end
--     return false
--   end)
--   :start()
--
ev = hs.eventtap
  .new({ hs.eventtap.event.types.mouseMoved, hs.eventtap.event.types.flagsChanged }, function(e)
    unlock_access = false

    if e:location().y < 5 then
      mods = e:getFlags()

      if mods["cmd"] then
        unlock_access = true
      end

      if menubar_allowed == true or unlock_access == true then
        return false
      end
      return true
    else
      return false
    end
  end)
  :start()

local _all_wins_filter = hs.window.filter.new():setDefaultFilter()
_all_wins_filter:subscribe(hs.window.filter.windowCreated, function(window, appName)
  win_title = window:title()
  print("Window created ... maximising: " .. win_title)
  print("Window created ... DONE: " .. win_title)

  local f = window:frame()
  print("Window created ... f.y: " .. f.y)
  if f.y < 28 then
    f.y = 28
    window:setFrame(f)
  end
  if f.x < 16 then
    f.x = 16
    window:setFrame(f)
  end

  local screen = window:screen()
  local h = screen:currentMode().h
  max_h = h - 28 - 16 - 00
  if f.h > max_h then
    f.h = max_h
    window:setFrame(f)
  end

  w = screen:currentMode().w
  max_w = w - 16 * 2
  if f.w > max_w then
    f.w = max_w
    window:setFrame(f)
  end

  -- if win_title == "Teams" then
  --   hs.timer.usleep(2000000)
  --   focusedanother = window:focusWindowWest(false)
  --   print("Refocused other window " .. tostring(focusedanother))
  -- end
end)

local frameMaxCache = {}
-------------------------------------------------------------------------------
-- make window full screen with border
-------------------------------------------------------------------------------
function borderFullScreen()
  return function()
    print("borderFullScreen")
    if hs.window.focusedWindow() then
      local win = hs.window.frontmostWindow()
      if frameMaxCache[win:id()] then
        win:setFrame(frameMaxCache[win:id()])
        frameMaxCache[win:id()] = nil
      else
        local id = win:id()
        local screen = win:screen()
        frameMaxCache[win:id()] = win:frame()

        h = screen:currentMode().h
        w = screen:currentMode().w
        local f = win:frame()
        -- border = WINDOW_BORDER
        -- f.x = border
        -- f.y = border + 00
        -- f.w = w - border * 2
        -- f.h = h - border * 2 - 00

        -- TODO: fix hardcoded values

        f.x = 16
        f.y = 28 + 00
        f.w = w - 16 * 2
        f.h = h - 28 - 16 - 00
        -- border = 30
        -- f.x = border
        -- f.y = border + border
        -- f.w = w-border*2
        -- f.h = h-border*2 - border
        win:setFrame(f)
      end
    end
  end
end

hs.hotkey.bind({ "cmd" }, "m", borderFullScreen())

-------------------------------------------------------------------------------
-- make window full screen with border
-------------------------------------------------------------------------------
function allBorderFullScreen()
  return function()
    print("all borderFullScreen")
    local allWindows = hs.window.allWindows() -- Get all windows
    for _, win in ipairs(allWindows) do
      if win:isStandard() then -- Skip non-standard windows (like hidden or minimized ones)
        local id = win:id()
        -- if frameMaxCache[id] then
        -- win:setFrame(frameMaxCache[id]) -- Restore original frame
        -- frameMaxCache[id] = nil
        -- else
        local screen = win:screen()
        frameMaxCache[id] = win:frame() -- Cache the original frame

        -- Get screen dimensions
        local h = screen:currentMode().h
        local w = screen:currentMode().w

        -- Set the new frame with desired dimensions
        local f = win:frame()
        f.x = 16
        f.y = 28 + 00
        f.w = w - 16 * 2
        f.h = h - 28 - 16 - 00

        win:setFrame(f)
        -- end
      end
    end
  end
end

hs.hotkey.bind({ "cmd", "shift" }, "m", allBorderFullScreen())

-------------------------------------------------------------------------------
---
-------------------------------------------------------------------------------
-------------------------------------------------------------------------------
function allBorderHalfLeft()
  return function()
    local win = hs.window.focusedWindow() -- Get the currently focused window
    if not win then
      print("No focused window")
      return
    end

    print("allBorderHalfLeft")
    local id = win:id()
    -- Cache the original frame for potential restoration
    frameMaxCache[id] = win:frame()

    -- Get screen dimensions
    local screen = win:screen()
    local h = screen:currentMode().h
    local w = screen:currentMode().w

    -- Set the new frame to occupy the left half of the screen
    local f = win:frame()
    f.x = 16 -- Offset from the left edge
    f.y = 28 + 00 -- Offset from the top edge
    f.w = (w / 2) - 16 -- Half the screen width, minus padding
    f.h = h - 28 - 16 - 00 -- Adjust height to fit within the screen bounds

    win:setFrame(f)
  end
end
hs.hotkey.bind({ "cmd", "shift", "ctrl", "alt" }, "[", allBorderHalfLeft())

function allBorderHalfRight()
  return function()
    local win = hs.window.focusedWindow() -- Get the currently focused window
    if not win then
      print("No focused window")
      return
    end
    local id = win:id()
    -- Cache the original frame for potential restoration
    frameMaxCache[id] = win:frame()

    -- Get screen dimensions
    local screen = win:screen()
    local h = screen:currentMode().h
    local w = screen:currentMode().w

    -- Set the new frame to occupy the right half of the screen
    local f = win:frame()
    f.x = (w / 2) + 16 -- Start from the middle of the screen, add left padding
    f.y = 28 + 00 -- Offset from the top edge
    f.w = (w / 2) - 16 * 2 -- Half the screen width, minus padding
    f.h = h - 28 - 16 - 00 -- Adjust height to fit within the screen bounds

    win:setFrame(f)
  end
end

hs.hotkey.bind({ "cmd", "shift", "ctrl", "alt" }, "]", allBorderHalfRight())

-- windowFilter = hs.window.filter.new():setOverrideFilter({ allowTitles = 1 })
--
-- windowFilter:subscribe(hs.window.filter.windowCreated, function(win)
--   print("Window created")
--   if win then
--     local f = win:frame()
--     print("Window created ... f.y: " .. f.y)
--     if f.y < 30 then
--       f.y = 30
--       win:setFrame(f)
--     end
--   end
-- end)
--
--
local function enforceWindowPosition()
  local win = hs.window.focusedWindow()
  if win then
    local f = win:frame()
    if f.y < 28 then
      f.y = 28
      win:setFrame(f)
    end
    if f.x < 16 then
      f.x = 16
      win:setFrame(f)
    end
    if f.x + f.w > hs.screen.mainScreen():frame().w - 16 then
      f.x = hs.screen.mainScreen():frame().w - f.w - 16
      win:setFrame(f)
    end
    if f.y + f.h > hs.screen.mainScreen():frame().h - 16 then
      f.y = hs.screen.mainScreen():frame().h - f.h - 16
      win:setFrame(f)
    end
  end
end

-- Monitor window movement and enforce the position
moveWatcher = hs.eventtap.new({ hs.eventtap.event.types.leftMouseUp }, function(event)
  hs.timer.doAfter(0.1, enforceWindowPosition) -- Slight delay to let the window move
  return false -- Allow the event to pass through
end)

moveWatcher:start()
