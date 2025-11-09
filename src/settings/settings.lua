local pedalsSettings = require("src.settings.tabs.pedalsSettings")
local pitLaneSettings = require("src.settings.tabs.pitLaneSettings")
local sessionlapsSettings = require("src.settings.tabs.sessionLapsSettings")
local language = require("lang.language")
local config = require("common.config")

local settings = {}

local languages = {
  ["en"] = "English",
  ["pt-br"] = "Português - Brasil"
}

local settingsStorage = ac.storage{
    optionlanguage = "en",
    selectedSpeed = 1,
    transparancy = 0.85,
    windowsColor = rgbm.from0255(18, 21, 29, 0.85),
    
}

Optionlanguage  = language.getCurrentLanguage()
SelectedSpeed = settingsStorage.selectedSpeed
WindowsColor = settingsStorage.windowsColor
SettingsActive = false

WindowSettingsSize = vec2(450, 450)


local tabPin = false
function settings.updateSettings()
  SIM = ac.getSim()
  CAR = ac.getCar(SIM.focusedCar)
  MY_CAR = ac.getCar(0)
end
  
local function geral()
  if(tabPin) then
    tabPin = false
  end
  
  local initPos = 50
  ui.setCursor(vec2(15, initPos))
  ui.header(language.get("LANGUAGE"))
  
  initPos = initPos + 20
  ui.setCursor(vec2(20, initPos))
  ui.combo('##resolution', languages[Optionlanguage], function ()
    if ui.selectable(languages["en"]) then
      Optionlanguage = "en"
    end

    if ui.selectable(languages["pt-br"]) then
      Optionlanguage = "pt-br"
    end
  end)

  initPos = initPos + 30
  ui.setCursor(vec2(20, initPos))
  if ui.button(language.get("APPLY")) then
    tabPin = true
    language.setlanguage(Optionlanguage)
  end

  initPos = initPos + 35
  ui.drawRectFilled(vec2(5, initPos), vec2(WindowSettingsSize.x - 5, initPos), rgbm.from0255(119, 118, 124, 0.3), 1)
  
  initPos = initPos + 10
  ui.setCursor(vec2(15, initPos))
  ui.header(language.get("SPEED"))
  
  initPos = initPos + 20
  ui.setCursor(vec2(20, initPos))
  SelectedSpeed = ui.combo("##Speed", SelectedSpeed , {"Km/h", "Mph"})
  settingsStorage.selectedSpeed = SelectedSpeed

  initPos = initPos + 35
  ui.drawRectFilled(vec2(5, initPos), vec2(WindowSettingsSize.x - 5, initPos), rgbm.from0255(119, 118, 124, 0.3), 1)

  initPos = initPos + 20
  ui.setCursor(vec2(15, initPos))
  ui.header(language.get("SELECT_COLOR"))
  local color = settingsStorage.windowsColor
  ui.pushItemWidth(150)
  
  initPos = initPos + 20
  ui.setCursor(vec2(20, initPos))
  ui.colorPicker(language.get('COLOR'), color, ui.ColorPickerFlags.PickerHueBar + ui.ColorPickerFlags.NoInputs, 10, 20)

  initPos = initPos + 130
  ui.setCursor(vec2(20, initPos))
  settingsStorage.transparancy = ui.slider(language.get('TRANSPARENCY'), settingsStorage.transparancy, 0, 1, string.format("%.0f", settingsStorage.transparancy * 100));

  settingsStorage.windowsColor = rgbm(color.r, color.g, color.b, settingsStorage.transparancy)
  ui.popItemWidth()

  initPos = initPos + 30
  ui.setCursor(vec2(20, initPos))
  if ui.button(language.get("RESET_COLOR")) then
    settingsStorage.windowsColor = rgbm.from0255(18, 21, 29, 0.85)
    settingsStorage.transparancy = 0.85
  end
end

function settings.windowOpenSettings()
  SettingsActive = true
end

function settings.windowCloseSettings()
  SettingsActive = false
end

function settings.windowMain()
  ui.drawRectFilled(vec2(0, 0), WindowSettingsSize, rgbm.from0255(18, 21, 29, 0.85), 0)
  ui.tabBar('##ID',function ()
    ui.tabItem(language.get("GENERAL"), tabPin and ui.TabItemFlags.SetSelected, geral)
    ui.tabItem(language.get("PEDALS"), pedalsSettings.pedalsSettings)
    ui.tabItem(language.get("PIT_LANE"), pitLaneSettings.pitlaneSettings)
    ui.tabItem(language.get("SESSION_LAPS"), sessionlapsSettings.sessionlapsSettings)
  end)
end

return settings