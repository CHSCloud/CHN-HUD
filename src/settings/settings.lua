local pedalsSettings = require("src.settings.pedalsSettings")
local pitLaneSettings = require("src.settings.pitLaneSettings")
local sessionlapsSettings = require("src.settings.sessionLapsSettings")

local settings = {}

local languages = {
  ["en"] = { name = "English", code = "en" },
  ["pt-br"] = { name = "Português - Brasil", code = "pt-br" }
}

local settingsStorage = ac.storage{
    optionlanguage = languages.en.code,
    selectedSpeed = 1
}

Optionlanguage  = language.getCurrentlanguage()
SelectedSpeed = settingsStorage.selectedSpeed

SIM = ac.getSim()
CAR = ac.getCar(SIM.focusedCar)
local applyLanguageNextFrame = false
  
local function geral()

  if applyLanguageNextFrame then
      language.setlanguage(Optionlanguage)
      language.loadTranslations()
      applyLanguageNextFrame = false
  end
  
  ui.setCursor(vec2(10, 50))
  ui.header(language.get("LANGUAGE"))
  ui.setCursor(vec2(10, 70))
  
  ui.combo('##resolution', languages[Optionlanguage].name, function ()
    if ui.selectable(languages["en"].name) then
      Optionlanguage = languages["en"].code
    end

    if ui.selectable(languages["pt-br"].name) then
      Optionlanguage = languages["pt-br"].code
    end
  end)

  ui.setCursor(vec2(10,100))
  if ui.button(language.get("APPLY")) then
    language.setlanguage(Optionlanguage)
    language.loadTranslations()
    applyLanguageNextFrame = true
  end

  ui.setCursor(vec2(10, 140))
  ui.header(language.get("SPEED"))
  ui.setCursor(vec2(10, 160))
  SelectedSpeed = ui.combo("##Speed", SelectedSpeed , {"Km/h", "Mph"})
  settingsStorage.selectedSpeed = SelectedSpeed
end
  
function settings.windowMain()
  ui.drawRectFilled(vec2(0, 0), vec2(500, 500), rgbm(0, 0, 0, 0.70), 0)
  ui.tabBar('##ID',function ()
    ui.tabItem(language.get("GENERAL"), geral)
    ui.tabItem(language.get("PEDALS"), pedalsSettings.pedalsSettings)
    ui.tabItem(language.get("PIT_LANE"), pitLaneSettings.pitlaneSettings)
    ui.tabItem(language.get("SESSION_LAPS"), sessionlapsSettings.sessionlapsSettings)
  end)
end

return settings