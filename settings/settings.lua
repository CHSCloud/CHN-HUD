local languages = {
  ["en"] = { name = "English", code = "en" },
  ["pt-br"] = { name = "Português - Brasil", code = "pt-br" }
}

local settings = ac.storage{
    hudScale = 1,
    wheelActive = true,
    ABSActive = true,
    acceleratorActive = true,
    brakeActive = true,
    clutchActive = true,
    optionLanguage = languages.en.code,
    selectedSpeed = 1
}

HudScale = settings.hudScale
WheelActive = settings.wheelActive
ABSActive = settings.ABSActive
AcceleratorActive = settings.acceleratorActive
BrakeActive = settings.brakeActive
ClutchActive = settings.clutchActive
OptionLanguage  = Language.getCurrentLanguage()
SelectedSpeed = settings.selectedSpeed

SIM = ac.getSim()
CAR = ac.getCar(SIM.focusedCar)

function script.saveSettings()
    settings.hudScale = HudScale
    settings.wheelActive = WheelActive
    settings.ABSActive = ABSActive
    settings.selectedSpeed = SelectedSpeed
    settings.optionLanguage = OptionLanguage
    AcceleratorActive = settings.acceleratorActive
    BrakeActive = settings.brakeActive
    ClutchActive = settings.clutchActive
end

-- Escolher Idioma:
local function setLanguage()
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
  

-- Checkbox
local function elements()
    ui.setCursor(vec2(20, 55))
    if ui.checkbox(Language.get("WHEEL"), WheelActive) then
        WheelActive = not WheelActive
    end

    ui.setCursor(vec2(20, 80))
    if ui.checkbox(Language.get("ABS"), ABSActive) then
        ABSActive = not ABSActive
    end

    ui.setCursor(vec2(20, 110))
    ui.header(Language.get("PEDALS"))

    ui.setCursor(vec2(20, 125))
    if ui.checkbox(Language.get("ACCELERATOR"), AcceleratorActive) then
        AcceleratorActive = not AcceleratorActive
    end

    ui.setCursor(vec2(20, 150))
    if ui.checkbox(Language.get("BRAKE"), BrakeActive) then
        BrakeActive = not BrakeActive
    end

    ui.setCursor(vec2(20, 175))
    if ui.checkbox(Language.get("CLUTCH"), ClutchActive) then
        ClutchActive = not ClutchActive
    end

    -- Alert ABS
    if CAR.absModes == 0 then
        ui.setCursor(vec2(70, 75))
        ui.dwriteTextAligned(Language.get("ALERT_ABS"), 10, ui.Alignment.Center, ui.Alignment.Center, vec2(150, 35), false, rgbm(255, 0, 0, 1))  
    end
end
--
  
local function geral()
    ui.setCursor(vec2(10, 50))
    ui.header(Language.get("SIZE"))
    ui.setCursor(vec2(10, 70))
    HudScale = ui.slider("##Size", HudScale, 0.8  , 3, string.format("%.2f", HudScale));
    
    ui.setCursor(vec2(10, 100))
    ui.header(Language.get("SPEED"))
    ui.setCursor(vec2(10, 120))
    SelectedSpeed = ui.combo("##Speed", SelectedSpeed , {"Km/h", "Mph"})
end
  
  -- TabBar
function script.windowSettings()
    ui.drawRectFilled(vec2(0, 0), vec2(272, 200), rgbm(0, 0, 0, 0.70), 0)
    ui.tabBar('##ID', function ()
    ui.tabItem(Language.get("GENERAL"), geral)
    ui.tabItem(Language.get("ELEMENTS"), elements)
    ui.tabItem(Language.get("LANGUAGE"), setLanguage)
    end)
end