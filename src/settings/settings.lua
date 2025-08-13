local pedalsSettings = require("src.settings.pedalsSettings")

local settings = {}

local languages = {
  ["en"] = { name = "English", code = "en" },
  ["pt-br"] = { name = "Português - Brasil", code = "pt-br" }
}

local settingsStorage = ac.storage{
    optionLanguage = languages.en.code,
    selectedSpeed = 1
}

OptionLanguage  = Language.getCurrentLanguage()
SelectedSpeed = settingsStorage.selectedSpeed

SIM = ac.getSim()
CAR = ac.getCar(SIM.focusedCar)
  
local function geral()
    ui.setCursor(vec2(10, 100))
    ui.header(Language.get("SPEED"))
    ui.setCursor(vec2(10, 120))
    SelectedSpeed = ui.combo("##Speed", SelectedSpeed , {"Km/h", "Mph"})
    settingsStorage.selectedSpeed = SelectedSpeed

    ui.setCursor(vec2(10, 50))
    ui.header(Language.get("LANGUAGE"))
    ui.setCursor(vec2(10, 70))
    
    ui.combo('##resolution', languages[OptionLanguage].name, function ()
      if ui.selectable(languages["en"].name) then
        OptionLanguage = languages["en"].code
      end
  
      if ui.selectable(languages["pt-br"].name) then
        OptionLanguage = languages["pt-br"].code
      end
    end)

    ui.setCursor(vec2(10,100))
    if ui.button(Language.get("APPLY")) then
      Language.setLanguage(OptionLanguage)
      Language.loadTranslations()
    end
end
  
function settings.windowMain()
    ui.drawRectFilled(vec2(0, 0), vec2(500, 500), rgbm(0, 0, 0, 0.70), 0)
    ui.tabBar('##ID',function ()
        ui.tabItem(Language.get("GENERAL"), geral)
        ui.tabItem(Language.get("PEDALS"), pedalsSettings.pedalsSettings)
    end)
end

return settings