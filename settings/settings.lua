local settings = ac.storage{
    hudScale = 1,
    wheelActive = true,
    ABSActive = true,
    optionLanguage = "English",
    selectedSpeed = 1
}

HudScale = settings.hudScale
WheelActive = settings.wheelActive
ABSActive = settings.ABSActive
OptionLanguage  = settings.optionLanguage
SelectedSpeed = settings.selectedSpeed

local SIM = ac.getSim()
local CAR = ac.getCar(SIM.focusedCar)

-- Escolher Idioma:
local function setLanguage()
    ui.header(Language.get("LANGUAGE"))
    ui.combo('##resolution', OptionLanguage, function ()
      if ui.selectable("English") then
        OptionLanguage = "English"
        Language.setLanguage("en")
      end
  
      if ui.selectable("Português - Brasil") then
        OptionLanguage = "Português - Brasil"
        Language.setLanguage("pt-br")
      end
    end)
    ui.setCursor(vec2(20,100))
    if ui.button(Language.get("APPLY")) then
      Language.loadTranslations()
    end
end
  

-- Checkbox
local function elements()
    ui.setCursor(vec2(20, 55))
    if ui.checkbox(Language.get("wheelActive"), WheelActive) then
        WheelActive = not WheelActive
    end

    ui.setCursor(vec2(20, 80))
    if ui.checkbox(Language.get("ABS"), settings.ABS) then
        settings.ABS = not settings.ABS
    end
    -- Alert ABS
    if CAR.absModes == 0 then
        ui.setCursor(vec2(70, 75))
        ui.dwriteTextAligned(Language.get("ALERT_ABS"), 10, ui.Alignment.Center, ui.Alignment.Center, vec2(150, 35), false, rgbm(255, 0, 0, 1))  
    end
end
--
  
local function geral()
    HudScale = ui.slider(Language.get("SIZE"), HudScale, 1, 3, string.format("%.2f", HudScale));
    
    ui.header(Language.get("SPEED"))
    SelectedSpeed = ui.combo("##Speed", SelectedSpeed , {"Km/h", "Mph"})
end
  
  -- TabBar
function script.Ioverlay_Settings()
    ui.tabBar('##ID', function ()
    ui.tabItem(Language.get("GENERAL"), geral)
    ui.tabItem(Language.get("ELEMENTS"), elements)
    ui.tabItem(Language.get("LANGUAGE"), setLanguage)
    end)
end