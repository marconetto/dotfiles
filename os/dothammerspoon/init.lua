hs.ipc.cliInstall()
hs.window.animationDuration = 0

function set_alert_color()

  local screen = hs.screen.mainScreen()
  current_image =  screen:desktopImageURL()

  print (current_image)
  if string.match(current_image, "rgb") and string.match(current_image, "png") then
    v1, v2, v3 = current_image:match("rgb_(%d+)_(%d+)_(%d+).png")
    hs.alert.defaultStyle.fillColor={red=v1/755,green=v2/755, blue=v3/755, alpha=0.05}
  else
    hs.alert.defaultStyle.fillColor={red=0.1,green=0.1, blue=0.3, alpha=0.05}
  end
end

hs.alert.defaultStyle.radius = 04
hs.alert.defaultStyle.strokeWidth=0.0
hs.alert.defaultStyle.strokeColor={red=0.1,green=0.1, blue=0.3, alpha=0.15}
hs.alert.defaultStyle.fadeOutDuration=0.70
hs.alert.defaultStyle.atScreenEdge=1
hs.alert.defaultStyle.textSize=14
hs.alert.defaultStyle.textFont="MonacoB"

local frameMaxCache = {}

set_alert_color()

WINDOW_BORDER=24
INBETWEEN_BORDER=5
ENABLE_WINMOVES=0
hs.window.animationDuration = 0

uber_last_clean_timer = nil
DIR_SIMPLE_ALERT="/Library/Application\\ Support/Übersicht/widgets/simplealert.widget/"
USE_UBER_ALERT=true

uber_pomodoro_last_clean_timer = nil
DIR_POMODORO_ALERT="/Library/Application\\ Support/Übersicht/widgets/pomodoro.widget/"
USE_UBER_POMODORO_ALERT=true

-------------------------------------------------------------------------------
-- ubersicht alert
-------------------------------------------------------------------------------
function cleanuberalert()
    return function()

        message = ""
        messagefile=os.getenv("HOME")..DIR_SIMPLE_ALERT.."/message.txt"
        command="echo \""..message.."\" > "..messagefile
        hs.execute(command,false)

        command="tell application \"Übersicht\" to refresh widget id \"simplealert-widget-simplealert-coffee\""
        hs.osascript.applescript(command)

        if uber_last_clean_timer ~= nil then
            uber_last_clean_timer = nil
        end
    end
end

function uberalert(message, duration)

    messagefile=os.getenv("HOME")..DIR_SIMPLE_ALERT.."/message.txt"
    command="echo \""..message.."\" > "..messagefile
    hs.execute(command,false)

    command="tell application \"Übersicht\" to refresh widget id \"simplealert-widget-simplealert-coffee\""
    hs.osascript.applescript(command)

    if uber_last_clean_timer ~= nil then
        uber_last_clean_timer:stop()
    end
    timer = hs.timer.doAfter(duration, cleanuberalert())
    uber_last_clean_timer = timer

end

function show_alert(message, duration)

    print("show_alert")
    if USE_UBER_ALERT then
        print(message)
        uberalert(message, duration)
    else

      hs.alert.closeAll(0.0)
      hs.alert.show(message, {}, duration)
    end

end
-------------------------------------------------------------------------------
-- reload configuration file automatically
-------------------------------------------------------------------------------
function reloadConfig(files)
    doReload = false
    for _,file in pairs(files) do
        if file:sub(-4) == ".lua" then
            doReload = true
        end
    end
    if doReload then
        hs.reload()
    end
end

myWatcher = hs.pathwatcher.new(os.getenv("HOME") .. "/.hammerspoon/", reloadConfig):start()
show_alert("config reloaded", 1)


local hyperkeys = {"ctrl", "alt", "cmd", "shift"}
local threekeys = {"ctrl", "alt", "cmd"}

hs.hotkey.bind({"cmd", "alt", "ctrl"}, "r", function()
  hs.reload()
end)


hs.hotkey.bind(hyperkeys, "a", function()
      hs.alert.closeAll(0.0)
      hs.alert.show(
         "Test Hyper!",
         {
            textFont= "Comic Sans MS",
            textSize=70,
            fadeOutDuration=1
         }
      )
end)

-------------------------------------------------------------------------------
-- lock screen shortcut
-------------------------------------------------------------------------------
hs.hotkey.bind(threekeys, 'm', function()
  hs.eventtap.keyStroke({'ctrl','cmd'}, 'q')
end)

function toggle_window_maximized()
   local win = hs.window.focusedWindow()
   if frameCache[win:id()] then
      win:setFrame(frameCache[win:id()])
      frameCache[win:id()] = nil
   else
      frameCache[win:id()] = win:frame()
      win:maximize()
   end
end

-------------------------------------------------------------------------------
-- make window full screen with border
-------------------------------------------------------------------------------
function borderFullScreen()
  return function()

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
        border = WINDOW_BORDER
        f.x = border
        f.y = border + 00
        f.w = w-border*2
        f.h = h-border*2 - 00

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

hs.hotkey.bind({'cmd'}, 'm', borderFullScreen())

-------------------------------------------------------------------------------
-- volume control and play functions
-------------------------------------------------------------------------------
function toggleMute()
  return function()
    local current = hs.audiodevice.defaultOutputDevice():outputMuted()
    hs.alert.closeAll(0.0)
    if current == false then
      hs.audiodevice.defaultOutputDevice():setMuted(true)
      show_alert("muted", 3.0)
    else
      hs.audiodevice.defaultOutputDevice():setMuted(false)
      show_alert("unmuted", 3.0)
    end
  end
end

function changeVolume(diff)
  return function()
    local current = hs.audiodevice.defaultOutputDevice():volume()
    local new = math.min(100, math.max(0, math.floor(current + diff)))

    new = math.floor(new/10+0.5) * 10
    -- if new > 0 then
      -- hs.audiodevice.defaultOutputDevice():setMuted(false)
    -- end
    -- hs.alert.closeAll(0.0)
    -- hs.timer.usleep(90000)
    hs.audiodevice.defaultOutputDevice():setVolume(new)
    message = "vol "..new
    -- hs.alert.show(message, {}, 2)
    show_alert(message, 1)
  end
end

function togglePlay()
  return function()
    local playing = hs.spotify.isPlaying()
    hs.alert.closeAll(0.0)
    if playing == false then
      hs.spotify.play()
      show_alert("play", 3)
    else
      hs.spotify.pause()
      show_alert("pause", 3)
    end
  end
end

function myPrevious()
  return function()
    local playing = hs.spotify.isPlaying()
    hs.alert.closeAll(0.0)
    if playing == true then
      hs.spotify.previous()
      show_alert("previous", 3)
    end
  end
end

function myNext()
  return function()
    local playing = hs.spotify.isPlaying()
    hs.alert.closeAll(0.0)
    if playing == true then
      hs.spotify.next()
      show_alert("next", 3)
    end
  end
end

local inc_volume = 10

hs.hotkey.bind(hyperkeys, 'i', changeVolume(-inc_volume),
     nil, changeVolume(-inc_volume))

hs.hotkey.bind(hyperkeys, 'o', changeVolume(inc_volume),
    nil, changeVolume(inc_volume))

hs.hotkey.bind(hyperkeys, 'u', toggleMute())

hs.hotkey.bind(threekeys, 'q', togglePlay())
hs.hotkey.bind(threekeys, 'w', myPrevious())
hs.hotkey.bind(threekeys, 'e', myNext())

-------------------------------------------------------------------------------
-- hyper+numbers mapped to function keys
-------------------------------------------------------------------------------
fkeys = {}
for i=0,9 do
   fkey = string.format("f%d",i)
   index = string.format("%d",i)
   fkeys[index] = fkey
end

for key, val in pairs(fkeys) do
   print ("Configuring " .. val .. "  "  .. key)
   hs.hotkey.bind(hyperkeys, key, function()
      hs.eventtap.keyStroke({}, val)
   end)
   -- hs.eventtap.keyStroke(hyperkeys, key)
   -- end)
end

-------------------------------------------------------------------------------
-- color and background functions
-------------------------------------------------------------------------------
function cycleColour()
  return function()
    funcCycleColour()
  end
end

function DeleteCurrentColour()
  return function()
    funcDeleteCurrentColour()
  end
end

function GetFiles(mask)
    local files = {}
    local tmpfile = '/tmp/stmp.txt'
    os.execute('ls -1 '..mask..' > '..tmpfile)
    local f = io.open(tmpfile)
    if not f then return files end
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
    current_image =  screen:desktopImageURL()
    print("call cycle colour")

    backdir = (os.getenv("HOME")).. "/misc/simplebackgrounds/"
    print ("Background Dir = ".. backdir)
    files = GetFiles(backdir)
    maxfiles = 0
    for key, val in pairs(files) do
      maxfiles = maxfiles + 1
      print (key, val)
    end

    index = 0
    newbackground = nil
    for i=1, maxfiles do
        if string.match(current_image, files[i]) then
            index = i
            break
        end
    end

    print (index)
    print (maxfiles)
    if index == 0 or index == maxfiles then
        print (index)
        print (maxfiles)
        newbackground = files[1]
    else
        newbackground = files[index + 1]
    end

    print ("New Background File = ".. newbackground)
    msg = "bg> "..newbackground.."=(" ..index.."/"..maxfiles..")"
    show_alert(msg,3)

    command = "tell application \"System Events\" to tell every desktop to set picture to \"" ..backdir..newbackground.."\""
    -- command = "tell application \"Finder\" to set desktop picture to POSIX file \"" ..backdir..newbackground.."\""
    print (command)
    hs.osascript.applescript(command)
    set_alert_color()

end

function funcDeleteCurrentColour()

    local screen = hs.screen.mainScreen()
    current_image =  screen:desktopImageURL()

    backdir = (os.getenv("HOME")).. "/misc/simplebackgrounds/"

    current_image = string.gsub(current_image, "file://", "")
    command = "rm "..current_image.." "..backdir
    print (command)
    hs.execute(command,true)

    funcCycleColour()
    hs.alert.closeAll(0.0)
    hs.alert.show("background deleted", {}, 2.0)
end

hs.hotkey.bind(threekeys, '0', cycleColour())
-------------------------------------------------------------------------------
-- change window of the same application... for now powerpoint
-------------------------------------------------------------------------------
function cmdLeft()
  return function()

      win = hs.window.focusedWindow()
      app = win:application()
      if app:name() == "Microsoft PowerPoint" then
          a = hs.eventtap.event.newKeyEvent({ "cmd" ,'shift'}, "`", true):post()
          -- hs.eventtap.keyStroke({'cmd','shift'},'`')
          -- else
          -- hs.eventtap.keyStroke({'cmd'},'left')
      end
  end
end

hs.hotkey.bind(hyperkeys, ';', cmdLeft(), nil, cmdLeft())

-------------------------------------------------------------------------------
-- refresh ubersicht battery menubar item
-------------------------------------------------------------------------------
function battery_changed()

    command="tell application \"Übersicht\" to refresh widget id \"battery_pro-widget-index-coffee\""
    hs.osascript.applescript(command)

    command="tell application \"Übersicht\" to refresh widget id \"batterysimple-widget-batterysimple-coffee\""
    hs.osascript.applescript(command)
    function_fixkeyboard()
    print("battery changed")
    charged = hs.battery.isCharged()
    percentage = hs.battery.percentage()
    charging = hs.battery.isCharging()
    print("IS CHARGED: "..tostring(charged).."percentage:"..percentage)
    print("IS CHARGING: "..tostring(charging))

    if charged then
        print("battery is charged")
        battery_set_off()
    elseif not charged and charging then
        print("battery is NOT charged and is charging")
        battery_set_on()
    elseif not charged and (percentage > 98 or percentage < 15) then

        print("battery is NOT charged and NOT between 98--15")
        battery_set_on()
    else
        print("battery is NOT charged and between 98--15")
        battery_set_off()

    end
end

battery_watcher = hs.battery.watcher.new(battery_changed)
battery_watcher:start()

function battery_set_off()

    command="tell application \"Übersicht\" to set hidden of widget id \"batterysimple-widget-batterysimple-coffee\" to true"
    hs.osascript.applescript(command)
    print("SET battery OFF")

end

function battery_set_on()

    command="tell application \"Übersicht\" to set hidden of widget id \"batterysimple-widget-batterysimple-coffee\" to false"
    hs.osascript.applescript(command)
    print("SET battery ON")
end

function toggle_battery_func()

    command="tell application \"Übersicht\" to get hidden of widget id \"batterysimple-widget-batterysimple-coffee\""
    error, battery_on, output =  hs.osascript.applescript(command)
    print(battery_on)

    if battery_on then
        battery_set_on()
    else
        battery_set_off()
    end

end

 function toggle_battery()
  return function()
      toggle_battery_func()
  end
end

hs.hotkey.bind(threekeys, '1', toggle_battery(), nil,nil)

-------------------------------------------------------------------------------
-- toggle network menubar
-------------------------------------------------------------------------------
function toggle_network_func()


    command="tell application \"Übersicht\" to get hidden of widget id \"net-widget-net-coffee\""
    error, network_on, output =  hs.osascript.applescript(command)
    print(network_on)

    if network_on then
        command="tell application \"Übersicht\" to set hidden of widget id \"net-widget-net-coffee\" to false"
    else
        command="tell application \"Übersicht\" to set hidden of widget id \"net-widget-net-coffee\" to true"
    end
    hs.osascript.applescript(command)
end

 function toggle_network()
  return function()
      toggle_network_func()
  end
end

hs.hotkey.bind(threekeys, '3', toggle_network(), nil,nil)

-------------------------------------------------------------------------------
-- toggle appworkspace menubar
-------------------------------------------------------------------------------
function toggle_space_func()

    command="tell application \"Übersicht\" to get hidden of widget id \"appspace-widget-appspace-coffee\""
    error, space_on, output =  hs.osascript.applescript(command)
    print(space_on)

    if space_on then
        command="tell application \"Übersicht\" to set hidden of widget id \"appspace-widget-appspace-coffee\" to false"
    else
        command="tell application \"Übersicht\" to set hidden of widget id \"appspace-widget-appspace-coffee\" to true"
    end

    hs.osascript.applescript(command)
end

 function toggle_space()
  return function()
      toggle_space_func()
  end
end

hs.hotkey.bind(threekeys, '2', toggle_space(), nil,nil)

-------------------------------------------------------------------------------
-- change keyboard layout
-------------------------------------------------------------------------------
function cycleKeyboardLayout()
  return function()

    eng_layout = "ABC"
    -- br_layout = "U.S. International - PC"
    br_layout = "U.S. International – PC"
    -- print(hs.keycodes.layouts())
      -- hs.keycodes.setLayout("U.S.")
    current_layout =  hs.keycodes.currentLayout()
    -- print(current_layout)
    if current_layout == eng_layout then
        hs.keycodes.setLayout(br_layout)
        msg = "----- BR -----"
    else
        hs.keycodes.setLayout(eng_layout)
        msg = "----- ENG -----"
    end
    command="tell application \"Übersicht\" to refresh widget id \"kbswitcher-widget-line-jsx\""
    print(command)
    hs.osascript.applescript(command)
  end
end

hs.hotkey.bind({'ctrl','cmd'}, 'space', cycleKeyboardLayout())

-------------------------------------------------------------------------------
-- change window to monitor (toggle)
-------------------------------------------------------------------------------
function nextMonitor()
  return function()

      -- Get the focused window, its window frame dimensions, its screen frame dimensions,
      -- and the next screen's frame dimensions.
      local focusedWindow = hs.window.focusedWindow()
      local focusedScreenFrame = focusedWindow:screen():frame()
      local nextScreenFrame = focusedWindow:screen():next():frame()
      local windowFrame = focusedWindow:frame()

      -- Calculate the coordinates of the window frame in the next screen and retain aspect ratio
      windowFrame.x = ((((windowFrame.x - focusedScreenFrame.x) / focusedScreenFrame.w) * nextScreenFrame.w) + nextScreenFrame.x)
      windowFrame.y = ((((windowFrame.y - focusedScreenFrame.y) / focusedScreenFrame.h) * nextScreenFrame.h) + nextScreenFrame.y)
      windowFrame.h = ((windowFrame.h / focusedScreenFrame.h) * nextScreenFrame.h)
      windowFrame.w = ((windowFrame.w / focusedScreenFrame.w) * nextScreenFrame.w)

      -- Set the focused window's new frame dimensions
      focusedWindow:setFrame(windowFrame)

      show_alert("next monitor", 3)
   end
end

hs.hotkey.bind(threekeys, '9', nextMonitor(), nil,nil)

-------------------------------------------------------------------------------
-- fix key repeat speed
-- now it fixes when battery status change and machine wakes up
-------------------------------------------------------------------------------
function function_fixkeyboard()
      command = (os.getenv("HOME")).. "/dotfiles/os/dry/dry 0.0166666666667"
      output, status, termType, rc = hs.execute(command,false)
      if rc == 1 then
          show_alert("keyboard: fixed", 3)
     end
end
function fixkeyboard()
  return function()

      function_fixkeyboard()
    end
end

hs.hotkey.bind(threekeys, '8', fixkeyboard(), nil,nil)
hs.timer.doEvery(60, fixkeyboard())

-------------------------------------------------------------------------------
-- show help... difficult to remember all key shortcuts
-------------------------------------------------------------------------------
function showhelp()
  return function()

      show_alert("6=help 7=net 8=keyfix 9=monitor 0=cyclewall", 7)
  end
end

hs.hotkey.bind(threekeys, '6', showhelp(), nil,nil)

-------------------------------------------------------------------------------
-------------------------------------------------------------------------------
function justwokeup(eventType)
    if (eventType == hs.caffeinate.watcher.systemDidWake) then
        print("just woke up")
        function_fixkeyboard()
    elseif (eventType == hs.caffeinate.watcher.screensDidUnlock ) then
        print("just unlocked")
        function_fixkeyboard()
    end

end
caffeinateWatcher = hs.caffeinate.watcher.new(justwokeup)
caffeinateWatcher:start()

-------------------------------------------------------------------------------
--
-------------------------------------------------------------------------------

 local _all_wins_filter = hs.window.filter.new():setDefaultFilter()
_all_wins_filter:subscribe(hs.window.filter.windowCreated, function(window, appName)
    win_title = window:title()
    print('Window created ... maximising: ' .. win_title)
    print('Window created ... DONE: ' .. win_title)

    if win_title == "Teams" then
       hs.timer.usleep(2000000)
       focusedanother = window:focusWindowWest(false)
       print("Refocused other window "..tostring(focusedanother))
   end
end)


-------------------------------------------------------------------------------
-- block / unblock menubar
-- menubar_allowed can be enabled/disabled via shortcut
-- if it is disabled, by moving mouse and holding control pressed
-- we can enable menubar as well
-------------------------------------------------------------------------------
menubar_allowed = false
function togglemenubarblocker_func()

    if menubar_allowed then
        menubar_allowed = false
    else
        menubar_allowed = true
    end
    msg = "menubar: "..tostring(menubar_allowed)
    show_alert(msg, 3)

end
function togglemenubarblocker()
  return function()
      togglemenubarblocker_func()
  end
end

ev = hs.eventtap.new({hs.eventtap.event.types.mouseMoved, hs.eventtap.event.types.flagsChanged}, function(e)
    unlock_access = false

    if e:location().y < 5 then
        mods = e:getFlags()

        if mods['ctrl'] then
            unlock_access = true
        end

        if menubar_allowed == true or unlock_access == true then
            return false
        end
        return true
    else
        return false

    end
 end):start()

-------------------------------------------------------------------------------
-- show network info
-------------------------------------------------------------------------------
function shownetinfo_func()

      command = "/Sy*/L*/Priv*/Apple8*/V*/C*/R*/airport -I | sed -e 's/^  *SSID: //p' -e d | tr -d '\n'"
      ssid, status, termType, rc = hs.execute(command,false)
      -- hs.alert.show(output, {}, 1)


      net_info = ssid
      show_alert(net_info, 2)
      command="tell application \"Übersicht\" to refresh widget id \"net-widget-net-coffee\""
      hs.osascript.applescript(command)
end

function shownetinfo()
  return function()

   shownetinfo_func()
  end
end

hs.hotkey.bind(threekeys, '7', shownetinfo(), nil,nil)

-------------------------------------------------------------------------------
-- yabai functions
-------------------------------------------------------------------------------
function yabaitoggle_func()

    command="/bin/sh "..os.getenv("HOME").."/.hammerspoon/handle_yabai.sh toggle"

    output, status, termType, rc = hs.execute(command,false)

    msg = "yabai going up"
    if string.find(output,"on") then
        command = "/usr/local/bin/brew services stop yabai"
        msg = "yabai going down"
    else
        command = "/usr/local/bin/brew services start yabai"
    end

    output, status, termType, rc = hs.execute(command,false)
    show_alert(msg, 5)
end

 function yabaitoggle()
  return function()
      yabaitoggle_func()
  end
end

function yabairestart_func()

    command="/bin/sh "..os.getenv("HOME").."/.hammerspoon/handle_yabai.sh restart"

    print(command)
    output, status, termType, rc = hs.execute(command,false)

    msg = "yabai restarting..."
    show_alert(msg, 5)
end

 function yabairestart()
  return function()
      yabairestart_func()
  end
end

-------------------------------------------------------------------------------
--
-------------------------------------------------------------------------------
-- function showmousespeed_func()

    -- speed = hs.mouse.trackingSpeed()
    -- msg = "mouse speed..."..speed
    -- show_alert(msg, 5)
-- end

 -- function showmousespeed()
  -- return function()
      -- showmousespeed_func()
  -- end
-- end
-- hs.hotkey.bind(threekeys, '4', showmousespeed(), nil,nil)

-- function setmousespeed_func()

    -- speed = hs.mouse.trackingSpeed(2.0)
    -- msg = "set mouse speed..."..speed
    -- show_alert(msg, 5)
-- end

 -- function setmousespeed()
  -- return function()
      -- setmousespeed_func()
  -- end
-- end
-- hs.hotkey.bind(threekeys, '5', setmousespeed(), nil,nil)

--
wifiwatcher = hs.wifi.watcher.new(shownetinfo())
wifiwatcher:start()



------------------------------------------------------------------------------
------------------------------------------------------------------------------
------------------------------------------------------------------------------
function cleandesktop()
  return function()

      command = "rm $HOME/Desktop/* -rf"
      hs.execute(command,false)
      msg = "cleaned desktop..."
      show_alert(msg, 2)
  end
end

hs.hotkey.bind(threekeys, '5', cleandesktop(), nil,nil)
------------------------------------------------------------------------------
------------------------------------------------------------------------------
------------------------------------------------------------------------------

-- Focus the last used window.
local function focusLastFocused()
    local wf = hs.window.filter
    local lastFocused = wf.defaultCurrentSpace:getWindows(wf.sortByFocusedLast)
    if #lastFocused > 0 then lastFocused[1]:focus() end
end

function file_exists(file)
  local f = io.open(file, "rb")
  if f then f:close() end
  return f ~= nil
end

function lines_from(file)
  if not file_exists(file) then return {} end
  lines = {}
  for line in io.lines(file) do
    lines[#lines + 1] = line
  end
  return lines
end

local choices2 = {}

WIFI_SCRIPT=os.getenv("HOME").."/.hammerspoon/changewifi.sh"

table.insert(choices2,
    {text="yabai_t",
        subText="yabai toggle",
        command="yabai_t"
    })

table.insert(choices2,
    {text="yabai_r",
        subText="yabai restart",
        command="yabai_r"
    })

table.insert(choices2,
    {text="menubar",
        subText="menubar toggle",
        command="menubar"
    })

table.insert(choices2,
    {text="delwall",
        subText="del wall paper",
        command="delwall"
    })

-- Create the chooser.
-- On selection, copy the emoji and type it into the focused application.

chooser2 = hs.chooser.new(function(choice)

    if not choice then focusLastFocused(); return end

    print(choice["text"])
    selection = choice["text"]

    -- if text contains * nothing should be done
    -- hs.pasteboard.setContents(choice["chars"])
    focusLastFocused()
    print(choices2)

    local command
    if string.find(selection, "yabai_t") then
        yabaitoggle_func()
    elseif string.find(selection, "yabai_r") then
        yabairestart_func()
    elseif string.find(selection, "menubar") then
        togglemenubarblocker_func()
    elseif string.find(selection, "delwall") then
        funcDeleteCurrentColour()
    end

end)

chooser2:searchSubText(true)
chooser2:choices(choices2)
chooser2:rows(6)
chooser2:bgDark(true)
chooser2:width(20)
-- local mainRes = mainScreen:fullFrame()

local mainRes = hs.screen.mainScreen():fullFrame()
print(mainRes.w)
local chooser_width=mainRes.w*chooser2:width()/100
print(chooser_width)
local geo = hs.geometry.rect((mainRes.w-chooser_width)/2,mainRes.h/2)

hs.hotkey.bind(threekeys, 'v', function() chooser2:show(geo) end)

-----------------------------------------------------------------------------
-- pomodoro
-----------------------------------------------------------------------------
function cleanuberpomdoro()
    return function()

        message = ""
        messagefile=os.getenv("HOME")..DIR_POMODORO_ALERT.."/message.txt"
        command="echo \""..message.."\" > "..messagefile
        output, status, termType, rc = hs.execute(command,false)

        command="tell application \"Übersicht\" to refresh widget id \"pomodoro-widget-pomodoro-coffee\""
        hs.osascript.applescript(command)

        if uber_pomodoro_last_clean_timer ~= nil then
            uber_pomodoro_last_clean_timer = nil
        end

    end
end
function uberpomodoro_func(duration)

    print("start pomodoro")

    messagefile=os.getenv("HOME")..DIR_POMODORO_ALERT.."/message.txt"
    command="echo `date +%s` "..duration.." > "..messagefile
    -- command="echo \""..message.."\" > "..messagefile
    output, status, termType, rc = hs.execute(command,false)

    print(command)
    command="tell application \"Übersicht\" to refresh widget id \"pomodoro-widget-pomodoro-coffee\""
    hs.osascript.applescript(command)
    print(command)

    duration=(duration+2)*60

    if uber_pomodoro_last_clean_timer ~= nil then
        uber_pomodoro_last_clean_timer:stop()
    end
    timer = hs.timer.doAfter(duration, cleanuberpomdoro())
    uber_pomodoro_last_clean_timer = timer

end

 function uberpomodoro(duration)
  return function()
      uberpomodoro_func(duration)
  end
end
hs.hotkey.bind(threekeys, 's', uberpomodoro(30), nil,nil)
hs.hotkey.bind(threekeys, 'x', cleanuberpomdoro(), nil,nil)
