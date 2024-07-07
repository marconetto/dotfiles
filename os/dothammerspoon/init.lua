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

  backdir = (os.getenv("HOME")) .. "/misc/simplebackgrounds/"
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
  local app = hs.application.find("Microsoft Outlook")
  app:selectMenuItem({ "View", "Go To", "Calendar" })
end

hs.hotkey.bind({ "alt" }, "2", seeCalendar)

function seeMail()
  local app = hs.application.find("Microsoft Outlook")
  app:selectMenuItem({ "View", "Go To", "Mail" })
end

hs.hotkey.bind({ "alt" }, "1", seeMail)
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
-------------------------------------------------------------------------------
-------------------------------------------------------------------------------
-------------------------------------------------------------------------------
