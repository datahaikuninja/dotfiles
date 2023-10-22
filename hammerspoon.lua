function hotkey(appName)
  local app = hs.application.get(appName)

  if app == nill then
    hs.application.launchOrFocus(appName)
  elseif app:isFrontmost() then
    app:hide()
  else
    hs.application.launchOrFocus(appName)
  end
end

--1password hotkey
hs.hotkey.bind({"cmd", "ctrl"}, "t", function()
  local appName = "1Password"
  hotkey(appName)
end)

--Google Chrome hotkey  
hs.hotkey.bind({"cmd", "ctrl"}, "c", function()
  local appName = "Google Chrome"
  hotkey(appName)
end)

--Slack hotkey  
hs.hotkey.bind({"cmd", "ctrl"}, "s", function()
  local appName = "Slack"
  hotkey(appName)
end)

--WezTerm hotkey  
hs.hotkey.bind({"cmd", "ctrl"}, "w", function()
  local appName = "WezTerm"
  hotkey(appName)
end)

--VSCode hotkey
hs.hotkey.bind({"cmd", "ctrl"}, "v", function()
  local appName = "Visual Studio Code"
  hotkey(appName)
end)
