local pedalsSettings = require("src.settings.tabs.pedalsSettings")
local pitLaneSettings = require("src.settings.tabs.pitLaneSettings")
local sessionlapsSettings = require("src.settings.tabs.sessionLapsSettings")
local language = require("lang.language")

local settings = {}

local languages = {
  ["en"] = "English",
  ["pt-br"] = "Português - Brasil"
}

local settingsStorage = ac.storage{
    optionlanguage = "en",
    selectedSpeed = 1,
    transparancy = 0.85,
    windowsColor = rgbm.from0255(18, 21, 29, 0.85)
}

Optionlanguage  = language.getCurrentLanguage()
SelectedSpeed = settingsStorage.selectedSpeed
WindowsColor = settingsStorage.windowsColor

WindowSettingsSize = vec2(450, 420)
function update()
  SIM = ac.getSim()
  CAR = ac.getCar(SIM.focusedCar)
  MY_CAR = ac.getCar(0)
end
  
local function geral()
  ui.setCursor(vec2(10, 50))
  ui.header(language.get("LANGUAGE"))
  ui.setCursor(vec2(10, 70))
  
  ui.combo('##resolution', languages[Optionlanguage], function ()
    if ui.selectable(languages["en"]) then
      Optionlanguage = "en"
    end

    if ui.selectable(languages["pt-br"]) then
      Optionlanguage = "pt-br"
    end
  end)

  ui.setCursor(vec2(10,100))
  if ui.button(language.get("APPLY")) then
    language.setlanguage(Optionlanguage)
  end

  ui.drawRectFilled(vec2(5, 130), vec2(WindowSettingsSize.x - 5, 130), rgbm.from0255(119, 118, 124, 0.3), 1)
  
  ui.setCursor(vec2(10, 140))
  ui.header(language.get("SPEED"))
  ui.setCursor(vec2(10, 160))
  SelectedSpeed = ui.combo("##Speed", SelectedSpeed , {"Km/h", "Mph"})
  settingsStorage.selectedSpeed = SelectedSpeed

  ui.drawRectFilled(vec2(5, 190), vec2(WindowSettingsSize.x - 5, 190), rgbm.from0255(119, 118, 124, 0.3), 1)

  ui.setCursor(vec2(10, 200))
  ui.header(language.get("SELECT_COLOR"))
  local color = settingsStorage.windowsColor
  ui.pushItemWidth(150)
  ui.setCursor(vec2(10, 220))
  ui.colorPicker(language.get('COLOR'), color, ui.ColorPickerFlags.PickerHueBar + ui.ColorPickerFlags.NoInputs, 10, 20)

  ui.setCursor(vec2(10, 350))
  settingsStorage.transparancy = ui.slider(language.get('TRANSPARENCY'), settingsStorage.transparancy, 0, 1, string.format("%.2f", settingsStorage.transparancy));

  settingsStorage.windowsColor = rgbm(color.r, color.g, color.b, settingsStorage.transparancy)
  ui.popItemWidth()

  ui.setCursor(vec2(10, 380))
  if ui.button(language.get("RESET_COLOR")) then
    settingsStorage.windowsColor = rgbm.from0255(18, 21, 29, 0.85)
    settingsStorage.transparancy = 0.85
  end
end

function settings.windowMain()
  ui.drawRectFilled(vec2(0, 0), WindowSettingsSize, rgbm.from0255(18, 21, 29, 0.85), 0)
  ui.tabBar('##ID',function ()
    ui.tabItem(language.get("GENERAL"), geral)
    ui.tabItem(language.get("PEDALS"), pedalsSettings.pedalsSettings)
    ui.tabItem(language.get("PIT_LANE"), pitLaneSettings.pitlaneSettings)
    ui.tabItem(language.get("SESSION_LAPS"), sessionlapsSettings.sessionlapsSettings)
  end)

 ----------------------------- PIN--------------------------------------
  local pinnedpedals = ac.accessAppWindow("IMGUI_LUA_CHN HUD_pedal"):pinned()
  local pinnedpitLane = ac.accessAppWindow("IMGUI_LUA_CHN HUD_pitLane"):pinned()
  local pinnedSesionLaps = ac.accessAppWindow("IMGUI_LUA_CHN HUD_sessionLaps"):pinned()
  ui.setCursor(vec2(220, 200))
  if ui.checkbox("Edit Clip", pinnedpedals, pinnedSesionLaps, pinnedpitLane) then
      ac.accessAppWindow("IMGUI_LUA_CHN HUD_pedal"):setPinned(not pinnedpedals)
      ac.accessAppWindow("IMGUI_LUA_CHN HUD_sessionLaps"):setPinned(not pinnedSesionLaps)
      ac.accessAppWindow("IMGUI_LUA_CHN HUD_pitLane"):setPinned(not pinnedpitLane)
  end
  ------------------------------------------------------------------------
end

return settings