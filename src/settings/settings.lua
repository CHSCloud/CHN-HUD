local pedalsSettings = require("src.settings.tabs.pedalsSettings")
local pitLaneSettings = require("src.settings.tabs.pitLaneSettings")
local sessionlapsSettings = require("src.settings.tabs.sessionLapsSettings")

local settings = {}

local languages = {
  ["en"] = "English",
  ["pt-br"] = "Português - Brasil"
}

local settingsStorage = ac.storage{
    optionlanguage = "en",
    selectedSpeed = 1
}

Optionlanguage  = language.getCurrentlanguage()
SelectedSpeed = settingsStorage.selectedSpeed

SIM = ac.getSim()
CAR = ac.getCar(SIM.focusedCar)
local applyLanguageNextFrame = false
  
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
    applyLanguageNextFrame = true
  end

  ui.setCursor(vec2(10, 140))
  ui.header(language.get("SPEED"))
  ui.setCursor(vec2(10, 160))
  SelectedSpeed = ui.combo("##Speed", SelectedSpeed , {"Km/h", "Mph"})
  settingsStorage.selectedSpeed = SelectedSpeed
end
  
function settings.windowMain()
  -- Aplicando tradução antes da renderização da janela:
  if applyLanguageNextFrame then
      language.setlanguage(Optionlanguage)
      language.loadTranslations()
      applyLanguageNextFrame = false
  end

  ui.drawRectFilled(vec2(0, 0), vec2(500, 500), rgbm(0, 0, 0, 0.70), 0)
  ui.tabBar('##ID',function ()
    ui.tabItem(language.get("GENERAL"), geral)
    ui.tabItem(language.get("PEDALS"), pedalsSettings.pedalsSettings)
    ui.tabItem(language.get("PIT_LANE"), pitLaneSettings.pitlaneSettings)
    ui.tabItem(language.get("SESSION_LAPS"), sessionlapsSettings.sessionlapsSettings)
  end)
end

return settings