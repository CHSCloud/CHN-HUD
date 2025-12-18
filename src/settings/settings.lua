local pedalsSettings = require("src.settings.tabs.pedalsSettings")
local pitLaneSettings = require("src.settings.tabs.pitLaneSettings")
local sessionLapsSettings = require("src.settings.tabs.sessionLapsSettings")
local startingLightsSettings = require("src.settings.tabs.startingLightsSettings")
local sessionFlagsSettings = require("src.settings.tabs.sessionFlagsSettings")
local mapSettings = require("src.settings.tabs.mapSettings")

local toggleButton = require("src.ui.toggleButton")
local button = require("src.ui.button")
local slider = require("src.ui.slider")

local language = require("lang.language")
local config = require("common.config")
local droplist = require("src.ui.droplist")

local settings = {}

local defaultValues = {
    optionLanguage = 1,
    selectedSpeed = 1,
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
WindowSettingsSize = vec2(780, 480)

if settings.store.optionLanguage ~= language.getCurrentLanguage() then
  language.setlanguage(settings.store.optionLanguage)
end
  
local function geral()
  if(tabPin) then
    tabPin = false
  end
  
  local initPos = 80
  settings.store.optionLanguage = droplist.main("##Language", language.get("LANGUAGE"), vec2(15, initPos), 160, settings.store.optionLanguage, language.languages)
  if settings.store.optionLanguage ~= language.getCurrentLanguage() then
    tabPin = true
    language.setlanguage(settings.store.optionLanguage)
  end

  initPos = initPos + 35
  ui.drawRectFilled(vec2(5, initPos), vec2(WindowSettingsSize.x - 5, initPos), COLOR.GRAY, 1)
  
  initPos = initPos + 30
  settings.store.selectedSpeed = droplist.main("##Speed", language.get("SPEED"), vec2(20, initPos), 150, settings.store.selectedSpeed, {"Km/h", "Mph"})
  SelectedSpeed = settings.store.selectedSpeed
  
  initPos = initPos + 35
  ui.drawRectFilled(vec2(5, initPos), vec2(WindowSettingsSize.x - 5, initPos), COLOR.GRAY, 1)

  initPos = initPos + 20
  ui.setCursor(vec2(300, initPos + 20))
  
  -- Checkbox Pin All Apps
  if toggleButton.main("pin", vec2(300, initPos), config.store.pinAllApps, language.get("PIN_ALL_APPS")) then
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

  initPos = initPos + 150
  
  -- Slider de Transparência
  settings.store.transparancy = slider.main(language.get("TRANSPARENCY"), string.format("%.0f", settings.store.transparancy * 100) .. "%",vec2(20, initPos + 10), 200, settings.store.transparancy, 0, 1)

  -- Atualiza a cor final combinando RGB do picker + Alpha do slider
  settings.store.windowsColor = rgbm(settings.store.windowsColor.r, settings.store.windowsColor.g, settings.store.windowsColor.b, settings.store.transparancy)

  initPos = initPos + 40

  if button.main(vec2(20, initPos), language.get("RESET_COLOR")) then
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
  ui.pushDWriteFont("fonts/Montserrat-Bold.ttf")
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