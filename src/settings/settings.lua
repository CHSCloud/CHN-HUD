local pedalsSettings = require("src.settings.tabs.pedalsSettings")
local pitLaneSettings = require("src.settings.tabs.pitLaneSettings")
local sessionLapsSettings = require("src.settings.tabs.sessionLapsSettings")
local startingLightsSettings = require("src.settings.tabs.startingLightsSettings")
local sessionFlagsSettings = require("src.settings.tabs.sessionFlagsSettings")
local mapSettings = require("src.settings.tabs.mapSettings")

local language = require("lang.language")
local config = require("common.config")

local settings = {}

local languages = {
  ["en"] = "English",
  ["pt-br"] = "Português - Brasil"
}

local defaultValues = {
    optionLanguage = "en",
    selectedSpeed = "Km/h",
    transparancy = 0.85,
    windowsColor = rgbm.from0255(18, 21, 29, 0.85)
}

settings.store = ac.storage(defaultValues)

COLOR = {
  RED = rgbm.from0255(255, 0, 0, 1),
  RED_DARK = rgbm.from0255(200, 0, 0, 1),
  GREEN = rgbm.from0255(90, 212, 51, 1),
  BLUE = rgbm.from0255(0, 89, 208, 1),
  BLUE_SKY = rgbm.from0255(0, 191, 255, 1),
  YELLOW = rgbm.from0255(255, 255, 0, 1),
  YELLOW_DARK = rgbm.from0255(255, 203, 0, 1),
  WHITE = rgbm.from0255(255, 255, 255, 1),
  BLACK = rgbm.from0255(0, 0, 0, 1),
  GRAY = rgbm.from0255(119, 118, 124, 0.3),
  GRAY_BG = rgbm.from0255(55, 55, 63, 0.85)
}

local tabPin = false
SettingsActive = false
WindowsColor = settings.store.windowsColor
SelectedSpeed = settings.store.selectedSpeed
WindowSettingsSize = vec2(720, 460)
SIM = ac.getSim()
CAR = ac.getCar(SIM.focusedCar)
MY_CAR = ac.getCar(0)

if settings.store.optionLanguage ~= language.getCurrentLanguage() then
  language.setlanguage(settings.store.optionLanguage)
end

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
  
  -- Lógica de linguagem usando store direto
  ui.setNextItemWidth(150)
  ui.combo('##resolution', languages[settings.store.optionLanguage], function ()
    if ui.selectable(languages["en"]) then
      tabPin = true
      settings.store.optionLanguage = "en"
      language.setlanguage(settings.store.optionLanguage)
    end

    if ui.selectable(languages["pt-br"]) then
      tabPin = true
      settings.store.optionLanguage = "pt-br"
      language.setlanguage(settings.store.optionLanguage)
    end
  end)

  initPos = initPos + 35
  ui.drawRectFilled(vec2(5, initPos), vec2(WindowSettingsSize.x - 5, initPos), COLOR.GRAY, 1)
  
  initPos = initPos + 10
  ui.setCursor(vec2(15, initPos))
  ui.header(language.get("SPEED"))
  
  initPos = initPos + 20
  ui.setCursor(vec2(20, initPos))
  
  -- Lógica de velocidade usando store direto
  ui.setNextItemWidth(150)
  ui.combo("##Speed", settings.store.selectedSpeed ,
    function ()
      if ui.selectable("Km/h") then
        settings.store.selectedSpeed = "Km/h"
      end

      if ui.selectable("Mph") then
        settings.store.selectedSpeed = "Mph"
    end
    SelectedSpeed = settings.store.selectedSpeed
  end)
  
  initPos = initPos + 35
  ui.drawRectFilled(vec2(5, initPos), vec2(WindowSettingsSize.x - 5, initPos), COLOR.GRAY, 1)

  initPos = initPos + 20
  ui.setCursor(vec2(300, initPos + 20))
  
  -- Checkbox Pin All Apps
  if ui.checkbox(language.get("PIN_ALL_APPS"), config.store.pinAllApps) then
    config.store.pinAllApps = not config.store.pinAllApps
    config.pinAllApps(config.store.pinAllApps)
  end
  
  -- Seção de Cores
  ui.setCursor(vec2(15, initPos))
  ui.header(language.get("SELECT_COLOR"))
  
  ui.pushItemWidth(150)
  
  initPos = initPos + 20
  ui.setCursor(vec2(20, initPos))
  
  ui.colorPicker(language.get('COLOR'), settings.store.windowsColor, ui.ColorPickerFlags.PickerHueBar + ui.ColorPickerFlags.NoInputs)

  initPos = initPos + 130
  ui.setCursor(vec2(20, initPos))
  
  -- Slider de Transparência
  local newAlpha = ui.slider(language.get('TRANSPARENCY'), settings.store.transparancy, 0, 1, string.format("%.0f", settings.store.transparancy * 100));
  if ui.itemEdited() then
      settings.store.transparancy = newAlpha
  end

  -- Atualiza a cor final combinando RGB do picker + Alpha do slider
  settings.store.windowsColor = rgbm(settings.store.windowsColor.r, settings.store.windowsColor.g, settings.store.windowsColor.b, settings.store.transparancy)
  
  ui.popItemWidth()

  initPos = initPos + 30
  ui.setCursor(vec2(20, initPos))
  
  -- Reset Color
  if ui.button(language.get("RESET_COLOR")) then
    settings.store.windowsColor = rgbm.from0255(18, 21, 29, 0.85)
    settings.store.transparancy = 0.85
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
    ui.tabItem(language.get("PIT_LANE"), pitLaneSettings.pitLaneSettings)
    ui.tabItem(language.get("SESSION_LAPS"), sessionLapsSettings.sessionLapsSettings)
    ui.tabItem(language.get("STARTING_LIGHTS"), startingLightsSettings.startingLightsSettings)
    ui.tabItem("Session Flags", sessionFlagsSettings.sessionFlagsSettings)
    ui.tabItem("Map", mapSettings.mapSettings)
  end)

  config.resize(WindowSettingsSize, "Settings CHN")
end

return settings